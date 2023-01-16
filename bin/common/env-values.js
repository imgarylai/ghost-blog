module.exports = {
  mysqlDatabaseUrl:
    process.env.MYSQL_DATABASE_URL ||
    process.env.JAWSDB_URL ||
    process.env.CLEARDB_DATABASE_URL ||
    process.env.JAWSDB_MARIA_URL,
  mail: {
    service: process.env.MAIL_SERVICE ||
      "Mailgun",
    host: process.env.SMTP_HOST ||
      process.env.MAILGUN_SMTP_SERVER ||
      "smtp.mailgun.org",
    port: process.env.SMTP_PORT ||
      process.env.MAILGUN_SMTP_PORT ||
      "465",
    user: process.env.SMTP_LOGIN ||
      process.env.MAILGUN_SMTP_LOGIN,
    pass: process.env.SMTP_PASSWORD ||
      process.env.MAILGUN_SMTP_PASSWORD,
  }
};
