// src/app.js
const express = require('express');
const app = express();
const { exec } = require('child_process');

// --- VULNERABILIDAD 1: Secreto Hardcodeado (Para Gitleaks) ---
// Simulación de una API Key de pasarela de pago (común en Fintech)
const STRIPE_SECRET_KEY = "sk_live_1234567890abcdef12345678"; 

app.use(express.json());

app.get('/', (req, res) => {
    res.send('Cashea Node.js Secure Demo');
});

// --- VULNERABILIDAD 2: Command Injection / RCE (Para SAST - njsscan/Semgrep) ---
// Un endpoint que permite al usuario hacer "ping", pero inseguro.
// Si el usuario envía: "8.8.8.8; rm -rf /", borra el servidor.
app.get('/ping-service', (req, res) => {
    const ip = req.query.ip;
    
    // PELIGRO: Pasamos input de usuario directo a un comando de sistema
    exec(`ping -c 1 ${ip}`, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).send(`Error: ${error.message}`);
        }
        res.send(`Resultado: ${stdout}`);
    });
});

// --- VULNERABILIDAD 3: Eval Injection (Para SAST) ---
app.post('/calculate-tax', (req, res) => {
    const userFormula = req.body.formula;
    // PELIGRO: eval() ejecuta código arbitrario
    const result = eval(userFormula); 
    res.send({ tax: result });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
