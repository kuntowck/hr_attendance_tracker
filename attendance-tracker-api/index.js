const express = require("express")
const bodyParser = require("body-parser")
const cors = require("cors")
const pool = require("./database")

const app = express()
const PORT = 5144

app.use(cors())
app.use(bodyParser.json())

app.get("/api/attendance", async (req, res) => {
  try {
    const { employeeId } = req.query

    if (!employeeId) {
      return res.status(400).json({ error: "Employee ID is required" })
    }

    result = await pool.query(
      `SELECT * FROM attendances WHERE employee_id = $1 ORDER BY id DESC`,
      [employeeId]
    )

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Attendance logs is not found" })
    }

    res.status(200).json(result.rows)
  } catch (error) {
    console.error(error.message)

    res.status(500).json({ error: "Server error, please try again later" })
  }
})

app.post("/api/attendance/checkin", async (req, res) => {
  try {
    const { employee_id, date, check_in, status } = req.body

    if (!employee_id || !date || !check_in || !status) {
      return res.status(400).json({ error: "Missing required fields" })
    }

    const result = await pool.query(
      `INSERT INTO attendances (employee_id, date, check_in, status) VALUES ($1, $2, $3, $4) RETURNING *`,
      [employee_id, date, check_in, status]
    )

    res.status(201).json(result.rows[0])
  } catch (error) {
    console.error(error.message)

    res.status(500).json({ error: "Server error, please try again later" })
  }
})

app.put("/api/attendance/checkout/:id", async (req, res) => {
  try {
    const { id } = req.params
    const { employee_id, date, check_in, check_out, status, duration } =
      req.body

    if (!id) {
      return res.status(400).json({ error: "Attendance ID is required" })
    }

    if (!check_out || !status || !duration) {
      return res.status(400).json({ error: "Missing required fields" })
    }

    const result = await pool.query(
      `UPDATE attendances SET employee_id=$1, date=$2, check_in=$3, check_out=$4, status=$5, duration=$6 WHERE id=$7 RETURNING *`,
      [employee_id, date, check_in, check_out, status, duration, id]
    )

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Attendance log is not found" })
    }

    res.status(200).json(result.rows[0])
  } catch (error) {
    console.error(error.message)

    res.status(500).json({ error: "Server error, please try again later" })
  }
})

app.delete("/api/attendance/:id", async (req, res) => {
  try {
    const { id } = req.params
    const result = await pool.query(
      `DELETE FROM attendances WHERE id = $1 RETURNING *`,
      [id]
    )

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Attendance log is not found." })
    }

    res.json({ message: "Attendance log deleted succesfully" })
  } catch (error) {
    console.error(error.message)

    res.status(500).json({ error: "Server error, please try again later" })
  }
})

// Start server
app.listen(PORT, () =>
  console.log(`HR Attendance Tracker API running at http://localhost:${PORT}`)
)
