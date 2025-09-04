const { Pool } = require("pg")

const pool = new Pool({
  user: "postgres", // username PostgreSQL
  host: "localhost",
  database: "ht_attendance_tracker", // nama database
  password: "980213", // password PostgreSQL
  port: 5432,
})

module.exports = pool
