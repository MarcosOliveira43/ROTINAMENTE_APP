require("dotenv").config();
const mysql = require("mysql2");

const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 3306,
});

connection.query("SELECT 1", (err, results) => {
  if (err) {
    console.error("❌ Erro de conexão com MySQL:", err);
  } else {
    console.log("✅ Conexão com MySQL bem-sucedida!");
  }
  connection.end();
});
