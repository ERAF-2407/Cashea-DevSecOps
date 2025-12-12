const express = require('express');
const { exec } = require('child_process');
const app = express();

app.use(express.json());

// --- OWASP A01:2021 - Broken Access Control ---
// VULNERABILIDAD: Clave hardcodeada (Gitleaks la detectará)
const ADMIN_API_KEY = "sk_live_1234567890abcdef12345678"; 

// --- OWASP A03:2021 - Injection ---
// VULNERABILIDAD: Command Injection (Njsscan la detectará)
app.get('/system-health', (req, res) => {
    const target = req.query.target;
    // PELIGRO: El usuario puede enviar "google.com; cat /etc/passwd"
    exec(`ping -c 1 ${target}`, (err, stdout) => { 
        if (err) return res.status(500).send(err.message);
        res.send(stdout);
    });
});

// --- OWASP A05:2021 - Security Misconfiguration ---
// VULNERABILIDAD: Exponer stack trace detallado en producción
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send(err.stack); // ¡Nunca hagas esto en prod!
});

app.get('/', (req, res) => res.send('Cashea Secure Node Demo'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));