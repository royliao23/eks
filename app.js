const express = require('express');
const app = express();
const port = 3000; // You can use any port you prefer

app.get('/hello', (req, res) => {
  res.send('Hello!');
});

app.get('/path', (req, res) => {
  res.send('Hello from /path!');
});

app.get('/', (req, res) => {
    res.send('Hello world ecs?!');
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});