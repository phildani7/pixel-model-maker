#include "solana.h"

#include <QDir>
#include <QFile>
#include <QImage>
#include <QProcess>
#include <QStandardPaths>
#include <QTextStream>
#include <QVector>

#include "gltfexport.h"
#include "libs/ed25519/src/ed25519.h"

inline static constexpr const uint8_t base58map[] = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
    'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
    'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

Solana::Solana(QObject * /*parent*/) : m_public_key(""), metaplex(nullptr) {
  readWallet();
}

Solana::~Solana() {}

QString Solana::encodeBase58(uint8_t data[], size_t data_size) {
  QVector<uint8_t> digits((data_size * 138 / 100) + 1, 0);
  size_t digitslen = 1;
  for (size_t i = 0; i < data_size; i++) {
    uint32_t carry = static_cast<uint32_t>(data[i]);
    for (size_t j = 0; j < digitslen; j++) {
      carry = carry + static_cast<uint32_t>(digits[j] << 8);
      digits[j] = static_cast<uint8_t>(carry % 58);
      carry /= 58;
    }
    for (; carry; carry /= 58)
      digits[digitslen++] = static_cast<uint8_t>(carry % 58);
  }
  QString result;
  for (size_t i = 0; i < (data_size - 1) && !data[i]; i++)
    result.push_back(QChar(base58map[0]));
  for (size_t i = 0; i < digitslen; i++)
    result.push_back(QChar(base58map[digits[digitslen - 1 - i]]));
  return result;
}

QString Solana::newKeypair() {
  uint8_t secret_key[64] = {0};
  if (ed25519_create_seed(seed)) {
    emit error("error while generating seed");
    return "";
  }

  ed25519_create_keypair(public_key, secret_key, seed);
  m_public_key = encodeBase58(public_key, 32);
  writeWallet();
  emit publicKeyChanged();

  return m_public_key;
}

QString Solana::walletFilename() {
  QDir appLocalData = QDir(
      QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));
  if (!appLocalData.exists()) {
    appLocalData.mkpath(appLocalData.path());
  }
  return appLocalData.filePath("wallet.json");
}

void Solana::readWallet() {
  QFile walletFile(Solana::walletFilename());
  qDebug() << "read wallet from" << walletFile.fileName();
  if (!walletFile.exists()) {
    qDebug() << "wallet file does not exist";
    return;
  }
  if (!walletFile.open(QIODevice::ReadOnly)) {
    qDebug() << "can't open wallet for reading";
    return;
  }

  QJsonDocument walletDoc = QJsonDocument::fromJson(walletFile.readAll());
  walletFile.close();
  if (!walletDoc.isArray()) {
    qDebug() << "invalid wallet data format";
    return;
  }
  QJsonArray keypair = walletDoc.array();
  if (keypair.size() != 64) {
    qDebug() << "invalid keypair size";
    return;
  }

  for (int i = 0; i < 32; ++i) {
    seed[i] = (uint8_t)keypair[i].toInt();
  }

  for (int i = 32; i < 64; ++i) {
    public_key[i - 32] = (uint8_t)keypair[i].toInt();
  }

  m_public_key = encodeBase58(public_key, 32);
  qDebug() << m_public_key;
  emit publicKeyChanged();
}

void Solana::writeWallet() {
  // What to save as a wallet:
  //   https://blog.mozilla.org/warner/2011/11/29/ed25519-keys/
  QFile walletFile(Solana::walletFilename());
  qDebug() << "write wallet to" << walletFile.fileName();
  if (walletFile.exists()) {
    qDebug() << "wallet file already exists";
    return;
  }
  QJsonArray keypair;
  for (int i = 0; i < 32; ++i) {
    keypair.append(seed[i]);
  }

  for (int i = 0; i < 32; ++i) {
    keypair.append(public_key[i]);
  }

  QJsonDocument walletDoc(keypair);
  if (!walletFile.open(QIODevice::ReadWrite)) {
    qDebug() << "can't open wallet for writing";
    return;
  }
  walletFile.write(walletDoc.toJson(QJsonDocument::Compact));
  walletFile.close();
}

QString Solana::publicKey() { return m_public_key; }

void Solana::setPublicKey(const QString &publicKey) {
  m_public_key = publicKey;
}

void Solana::setMetaplexProgramName() {
  if (metaplex == nullptr) {
    return;
  }
  QString programName = "metaplex";
  if (QSysInfo::productType().startsWith("win")) {
    programName += ".exe";
  }
  metaplex->setProgram(QCoreApplication::applicationDirPath() +
                       QDir::separator() + programName);
}

QJsonObject Solana::buildMetaplexJsonFile(const QJsonObject &options) {
  QJsonObject metaplexJsonConfig = QJsonObject{
      {"name", options.value("name")},
      {"symbol", options.value("symbol")},
      {"description", options.value("description")},
      {"seller_fee_basis_points", 0},
      {"image", "0.png"},
      {"animation_url", ""},
      {"external_url", ""},
      {"attributes", options.value("attributes").toArray()},
      {"collection", options.value("collection")},
      {"properties",
       QJsonObject{
           {"category", "vr"},
           {"files",
            QJsonArray{
                QJsonObject{{"uri", "0.png"}, {"type", "image/png"}},
                QJsonObject{{"uri", "0.gltf"}, {"type", "model/gltf+json"}}}},
           {"creators", options.value("creators")
                            .toArray(QJsonArray{QJsonObject{
                                {"address", publicKey()}, {"share", 100}}})}}}};
  return metaplexJsonConfig;
}

QString Solana::upload(const QImage &image, const QJsonObject &data,
                       const QJsonObject &options) {
  QDir workDir(
      QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));

  QDir assetDir(workDir.filePath(options.value("assets").toString("assets")));
  if (!assetDir.exists()) {
    assetDir.mkpath(assetDir.path());
  }

  GLTFExport exporter;
  QJsonObject gltfJson = exporter.model(data).toObject();
  QFile gltfFile(assetDir.filePath("0.gltf"));
  if (!gltfFile.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
    return "";
  }
  gltfFile.write(QJsonDocument(gltfJson).toJson(QJsonDocument::Compact));
  gltfFile.close();
  int size = std::min(image.width(), image.height());
  QRect cropRect((image.width() - size) / 2, (image.height() - size) / 2, size,
                 size);
  if (!image.copy(cropRect).save(assetDir.filePath("0.png"))) {
    return "";
  }

  QFile jsonFile(assetDir.filePath("0.json"));
  if (!jsonFile.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
    return "";
  }
  jsonFile.write(QJsonDocument(buildMetaplexJsonFile(options)).toJson());
  jsonFile.close();

  if (metaplex != nullptr) {
    return "";
  }
  metaplex = new QProcess;
  metaplex->setWorkingDirectory(workDir.path());
  setMetaplexProgramName();
  metaplex->setArguments(QStringList()
                         << "upload"
                         << "-e" << options.value("network").toString("devnet")
                         << "-k"
                         << "wallet.json"
                         << "-c" << options.value("cachename").toString("temp")
                         << options.value("assets").toString("assets"));
  metaplex->start();
  if (!metaplex->waitForStarted()) {
    return "";
  }
  qDebug() << "metaplex started (" << metaplex->processId() << ")";
  connect(metaplex, &QProcess::finished, this, &Solana::uploadFinishedSlot);
  return "";
}

void Solana::uploadFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus) {
  if (metaplex == nullptr) {
    return;
  }

  QString error = QString::fromUtf8(metaplex->readAllStandardError());
  QString output = QString::fromUtf8(metaplex->readAllStandardOutput());
  qDebug() << exitCode << error << output;
  delete metaplex;
  metaplex = nullptr;
  emit uploadFinished(output, exitCode, exitStatus);
}

QString Solana::verify(const QJsonObject &options) {
  QDir workDir(
      QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));

  if (metaplex != nullptr) {
    return "";
  }
  metaplex = new QProcess;
  metaplex->setWorkingDirectory(workDir.path());
  setMetaplexProgramName();

  metaplex->setArguments(
      QStringList() << "verify"
                    << "-e" << options.value("network").toString("devnet")
                    << "-k"
                    << "wallet.json"
                    << "-c" << options.value("cachename").toString("temp"));
  metaplex->start();
  if (!metaplex->waitForStarted()) {
    return "";
  }
  qDebug() << "metaplex started (" << metaplex->processId() << ")"
           << metaplex->program() << metaplex->arguments();
  connect(metaplex, &QProcess::finished, this, &Solana::verifyFinishedSlot);
  return "";
}

void Solana::verifyFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus) {
  if (metaplex == nullptr) {
    return;
  }

  QString error = QString::fromUtf8(metaplex->readAllStandardError());
  QString output = QString::fromUtf8(metaplex->readAllStandardOutput());
  qDebug() << exitCode << error << output;
  delete metaplex;
  metaplex = nullptr;
  emit verifyFinished(output, exitCode, exitStatus);
}

QString Solana::create(const QJsonObject &options) {
  QDir workDir(
      QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));

  if (metaplex != nullptr) {
    return "";
  }
  metaplex = new QProcess;
  metaplex->setWorkingDirectory(workDir.path());
  setMetaplexProgramName();
  metaplex->setArguments(QStringList()
                         << "create_candy_machine"
                         << "-e" << options.value("network").toString("devnet")
                         << "-k"
                         << "wallet.json"
                         << "-c" << options.value("cachename").toString("temp")
                         << "-p" << options.value("price").toString("1"));
  metaplex->start();
  if (!metaplex->waitForStarted()) {
    return "";
  }
  qDebug() << "metaplex started (" << metaplex->processId() << ")"
           << metaplex->program() << metaplex->arguments();
  connect(metaplex, &QProcess::finished, this, &Solana::createFinishedSlot);
  return "";
}

void Solana::createFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus) {
  if (metaplex == nullptr) {
    return;
  }

  QString error = QString::fromUtf8(metaplex->readAllStandardError());
  QString output = QString::fromUtf8(metaplex->readAllStandardOutput());
  qDebug() << exitCode << error << output;
  delete metaplex;
  metaplex = nullptr;
  emit createFinished(output, exitCode, exitStatus);
}

QString Solana::update(const QJsonObject &options) {
  QDir workDir(
      QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));

  if (metaplex != nullptr) {
    return "";
  }
  metaplex = new QProcess;
  metaplex->setWorkingDirectory(workDir.path());
  setMetaplexProgramName();
  metaplex->setArguments(QStringList()
                         << "update_candy_machine"
                         << "-e" << options.value("network").toString("devnet")
                         << "-k"
                         << "wallet.json"
                         << "-c" << options.value("cachename").toString("temp")
                         << "-d"
                         << options.value("date").toString(
                                "01 Jan 2021 00:00:00 GMT"));
  metaplex->start();
  if (!metaplex->waitForStarted()) {
    return "";
  }
  qDebug() << "metaplex started (" << metaplex->processId() << ")"
           << metaplex->program() << metaplex->arguments();
  connect(metaplex, &QProcess::finished, this, &Solana::updateFinishedSlot);
  return "";
}

void Solana::updateFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus) {
  if (metaplex == nullptr) {
    return;
  }

  QString error = QString::fromUtf8(metaplex->readAllStandardError());
  QString output = QString::fromUtf8(metaplex->readAllStandardOutput());
  qDebug() << exitCode << error << output;
  delete metaplex;
  metaplex = nullptr;
  emit updateFinished(output, exitCode, exitStatus);
}

QString Solana::mint(const QJsonObject &options) {
  QDir workDir(
      QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));

  if (metaplex != nullptr) {
    return "";
  }
  metaplex = new QProcess;
  metaplex->setWorkingDirectory(workDir.path());
  setMetaplexProgramName();
  metaplex->setArguments(
      QStringList() << "mint_one_token"
                    << "-e" << options.value("network").toString("devnet")
                    << "-k"
                    << "wallet.json"
                    << "-c" << options.value("cachename").toString("temp"));
  metaplex->start();
  if (!metaplex->waitForStarted()) {
    return "";
  }
  qDebug() << "metaplex started (" << metaplex->processId() << ")"
           << metaplex->program() << metaplex->arguments();
  connect(metaplex, &QProcess::finished, this, &Solana::mintFinishedSlot);
  return "";
}

void Solana::mintFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus) {
  if (metaplex == nullptr) {
    return;
  }

  QString error = QString::fromUtf8(metaplex->readAllStandardError());
  QString output = QString::fromUtf8(metaplex->readAllStandardOutput());
  qDebug() << exitCode << error << output;
  delete metaplex;
  metaplex = nullptr;
  emit mintFinished(output, exitCode, exitStatus);
}

QString Solana::sign(const QJsonObject &options) {
  QDir workDir(
      QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));

  if (metaplex != nullptr) {
    return "";
  }
  metaplex = new QProcess;
  metaplex->setWorkingDirectory(workDir.path());
  setMetaplexProgramName();
  metaplex->setArguments(
      QStringList() << "sign_candy_machine_metadata"
                    << "-e" << options.value("network").toString("devnet")
                    << "-k"
                    << "wallet.json"
                    << "-c" << options.value("cachename").toString("temp"));
  metaplex->start();
  if (!metaplex->waitForStarted()) {
    return "";
  }
  qDebug() << "metaplex started (" << metaplex->processId() << ")"
           << metaplex->program() << metaplex->arguments();
  connect(metaplex, &QProcess::finished, this, &Solana::signFinishedSlot);
  return "";
}

void Solana::signFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus) {
  if (metaplex == nullptr) {
    return;
  }

  QString error = QString::fromUtf8(metaplex->readAllStandardError());
  QString output = QString::fromUtf8(metaplex->readAllStandardOutput());
  qDebug() << exitCode << error << output;
  delete metaplex;
  metaplex = nullptr;
  emit mintFinished(output, exitCode, exitStatus);
}
