#ifndef SOLANA_H
#define SOLANA_H

#include <QtCore>

class Solana : public QObject {
  Q_OBJECT
  Q_DISABLE_COPY(Solana)
  Q_PROPERTY(QString publicKey READ publicKey WRITE setPublicKey NOTIFY
                 publicKeyChanged)

 public:
  Solana(QObject* parent = 0);
  ~Solana();

  Q_INVOKABLE QString newKeypair();

  QString publicKey();

 public slots:
  void setPublicKey(const QString& publicKey);

 private:
  QString m_public_key;
  uint8_t seed[32], public_key[32], private_key[64];
  QString encodeBase58(uint8_t data[], size_t date_size);
  void readWallet();
  void writeWallet();
  inline static QString walletFilename();

 signals:
  void publicKeyChanged();
  void error(QString error);
};
#endif  // SOLANA_H
