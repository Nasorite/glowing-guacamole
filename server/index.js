const express = require('express');
const pool = require('./db');
const app = express();
const bodyParser = require('body-parser');
cors = require('cors')

app.use(cors());
app.use(express.json({limit: '10mb'}));

app.get("/getPersons", async(req,res) => {
    try {
        const result = await pool.query('SELECT * FROM persons')

        res.json(result.rows)
    } catch (error) {
        console.log(error);
    }
})

app.post("/addPersons", async (req,res) => {
    try {
        console.log("hello")
        const {personname, age, gender, occupation, height, weight} = req.body;

        const result = await pool.query(`SELECT MAX(id) FROM persons`);
        const maxKey = result.rows[0].max;

        const key = maxKey ? maxKey + 1 : 1;

        const response = await pool.query('INSERT INTO persons (id,name, age, gender, occupation, height, weight) VALUES ($1,$2,$3,$4,$5,$6,$7)',
        [key, personname, age, gender, occupation, height, weight]);

        res.status(200).json("done");
    } catch (error) {
        console.log(error)
    }
})

app.listen(5000, () => {
    console.log("Sever is running")
})