const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// in-memory store (simples e suficiente para a entrega)
let movies = [];
let reviews = {};
let nextId = 1;

app.get('/', (req, res) => res.send('🎬 MovieFlix API funcionando!'));

// cadastrar filme
app.post('/movies', (req, res) => {
  const { title, year, genre } = req.body;
  const id = nextId++;
  const movie = { id, title, year, genre };
  movies.push(movie);
  reviews[id] = [];
  res.status(201).json(movie);
});

// listar filmes
app.get('/movies', (req, res) => res.json(movies));

// adicionar avaliação
app.post('/movies/:id/reviews', (req, res) => {
  const id = Number(req.params.id);
  const movie = movies.find(m => m.id === id);
  if (!movie) return res.status(404).json({ error: 'Filme não encontrado' });

  const { rating, comment, user_id } = req.body;
  reviews[id].push({
    rating: Number(rating),
    comment: comment || '',
    user_id: user_id || null,
    timestamp: new Date().toISOString()
  });
  res.status(201).json({ message: 'Avaliação registrada' });
});

// listar avaliações
app.get('/movies/:id/reviews', (req, res) => {
  const id = Number(req.params.id);
  if (!reviews[id]) return res.status(404).json({ error: 'Filme não encontrado' });
  res.json(reviews[id]);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor rodando na porta ${PORT}`));
