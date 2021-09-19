#ifndef SOLANA_H
#define SOLANA_H

#include <QtCore>

class Solana : public QObject {
  Q_OBJECT
  Q_DISABLE_COPY(Solana)
  Q_PROPERTY(QString publicKey READ publicKey WRITE setPublicKey NOTIFY
                 publicKeyChanged)

 public:
  Solana(QObject *parent = 0);
  ~Solana();

  Q_INVOKABLE QString newKeypair();
  Q_INVOKABLE QString upload(const QImage &image, const QJsonObject &data,
                             const QJsonObject &options = QJsonObject());
  Q_INVOKABLE QString verify(const QJsonObject &options = QJsonObject());
  Q_INVOKABLE QString create(const QJsonObject &options = QJsonObject());
  Q_INVOKABLE QString update(const QJsonObject &options = QJsonObject());
  Q_INVOKABLE QString mint(const QJsonObject &options = QJsonObject());
  Q_INVOKABLE QString sign(const QJsonObject &options = QJsonObject());

  QString publicKey();

 public slots:
  void setPublicKey(const QString &publicKey);
  void uploadFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus);
  void verifyFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus);
  void createFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus);
  void updateFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus);
  void mintFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus);
  void signFinishedSlot(int exitCode, QProcess::ExitStatus exitStatus);

 private:
  QString m_public_key;
  uint8_t seed[32], public_key[32];
  QProcess *metaplex;
  QString encodeBase58(uint8_t data[], size_t date_size);
  void readWallet();
  void writeWallet();
  inline static QString walletFilename();
  void setMetaplexProgramName();
  QJsonObject buildMetaplexJsonFile(const QJsonObject &options);

 signals:
  void publicKeyChanged();
  void error(QString error);
  void uploadFinished(QString data, int exitCode,
                      QProcess::ExitStatus exitStatus);
  void verifyFinished(QString data, int exitCode,
                      QProcess::ExitStatus exitStatus);
  void createFinished(QString data, int exitCode,
                      QProcess::ExitStatus exitStatus);
  void updateFinished(QString data, int exitCode,
                      QProcess::ExitStatus exitStatus);
  void mintFinished(QString data, int exitCode,
                    QProcess::ExitStatus exitStatus);
  void signFinished(QString data, int exitCode,
                    QProcess::ExitStatus exitStatus);
};
#endif  // SOLANA_H
