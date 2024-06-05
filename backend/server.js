const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// MySQL connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'ayza2380mkdir',
    database: 'gestcomprod'
});

db.connect(err => {
    if (err) {
        throw err;
    }
    console.log('MySQL connected...');
});

// Create client
app.post('/api/clients', (req, res) => {
    const { code_client, nom_client, adresse, codepostal, ville, telephone, email, matricule_fiscal } = req.body;
    const sql = 'INSERT INTO client (code_client, nom_client, adresse, codepostal, ville, telephone, email, matricule_fiscal) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
    db.query(sql, [code_client, nom_client, adresse, codepostal, ville, telephone, email, matricule_fiscal], (err, result) => {
        if (err) return res.status(500).send(err);
        res.status(201).send(result);
    });
});

// Read all clients
app.get('/api/clients', (req, res) => {
    const sql = 'SELECT * FROM client';
    db.query(sql, (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).send(results);
    });
});

// Read a single client by code_client
app.get('/api/clients/:code_client', (req, res) => {
    const code_client = req.params.code_client;
    const sql = 'SELECT * FROM client WHERE code_client = ?';
    db.query(sql, [code_client], (err, result) => {
        if (err) return res.status(500).send(err);
        if (result.length === 0) return res.status(404).send({ message: 'Client not found' });
        res.status(200).send(result[0]);
    });
});

// Update client
app.put('/api/clients/:code_client', (req, res) => {
    const code_client = req.params.code_client;
    const { nom_client, adresse, codepostal, ville, telephone, email, matricule_fiscal } = req.body;
    const sql = 'UPDATE client SET nom_client = ?, adresse = ?, codepostal = ?, ville = ?, telephone = ?, email = ?, matricule_fiscal = ? WHERE code_client = ?';
    db.query(sql, [nom_client, adresse, codepostal, ville, telephone, email, matricule_fiscal, code_client], (err, result) => {
        if (err) return res.status(500).send(err);
        if (result.affectedRows === 0) return res.status(404).send({ message: 'Client not found' });
        res.status(200).send(result);
    });
});

// Delete client
app.delete('/api/clients/:code_client', (req, res) => {
    const code_client = req.params.code_client;
    const sql = 'DELETE FROM client WHERE code_client = ?';
    db.query(sql, [code_client], (err, result) => {
        if (err) return res.status(500).send(err);
        if (result.affectedRows === 0) return res.status(404).send({ message: 'Client not found' });
        res.status(200).send(result);
    });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
