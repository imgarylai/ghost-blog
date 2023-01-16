module.exports = {
  mysqlDatabaseUrl:
    process.env.MYSQL_DATABASE_URL ||
    process.env.JAWSDB_URL ||
    process.env.CLEARDB_DATABASE_URL ||
    process.env.JAWSDB_MARIA_URL,
  mail: {
    service: process.env.SMTP_MAIL_SERVICE ||
      "Mailgun",
    smtpLogin: process.env.SMTP_LOGIN ||
      process.env.MAILGUN_SMTP_LOGIN,
    smtpPass: process.env.SMTP_PASSWORD ||
      process.env.MAILGUN_SMTP_PASSWORD
  }
};
