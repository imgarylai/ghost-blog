module.exports = {
  mysqlDatabaseUrl:
    process.env.MYSQL_DATABASE_URL ||
    process.env.JAWSDB_URL ||
    process.env.CLEARDB_DATABASE_URL ||
    process.env.JAWSDB_MARIA_URL,
  mailService:
    process.env.MAIL_SERVICE ||
    "Mailgun",
  host:
    process.env.SMTP_HOST ||
    process.env.SMTP_SERVER ||
    process.env.MAILGUN_SMTP_SERVER,
  port:
    process.env.SMTP_PORT ||
    process.env.MAILGUN_SMTP_PORT ||
    "465",
  smtpLogin:
    process.env.SMTP_LOGIN ||
    process.env.MAILGUN_SMTP_LOGIN,
  smtpPassword:
    process.env.SMTP_PASSWORD ||
    process.env.MAILGUN_SMTP_PASSWORD
};
