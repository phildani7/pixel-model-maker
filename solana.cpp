#include "solana.h"

#include <QDir>
#include <QFile>
#include <QStandardPaths>
#include <QTextStream>
#include <QVector>

#include "libs/ed25519/src/ed25519.h"

inline static constexpr const uint8_t base58map[] = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
    'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
    'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

Solana::Solana(QObject * /*parent*/) : m_public_key("") { readWallet(); }

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
