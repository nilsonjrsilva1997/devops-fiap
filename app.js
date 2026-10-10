const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Servir arquivos estáticos (HTML, CSS, JS)
app.use(express.static(path.join(__dirname, 'public')));

// Middleware para JSON
app.use(express.json());

// Endpoint único - retorna dados para o frontend
app.get('/api/mensagem', (req, res) => {
  res.json({
    mensagem: 'Olá do Backend!',
    timestamp: new Date().toISOString(),
    status: 'conectado'
  });
});

// Rota raiz
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
  console.log(`Acesse: http://localhost:${PORT}`);
});
