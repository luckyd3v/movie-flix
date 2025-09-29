CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE IF NOT EXISTS dw.movies (
  imdb_id TEXT PRIMARY KEY,
  title TEXT,
  year TEXT,
  genre TEXT,
  country TEXT
);

CREATE TABLE IF NOT EXISTS dw.users (
  user_id INT PRIMARY KEY,
  name TEXT,
  age INT,
  country TEXT
);

CREATE TABLE IF NOT EXISTS dw.ratings (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES dw.users(user_id),
  imdb_id TEXT REFERENCES dw.movies(imdb_id),
  rating INT,
  timestamp TIMESTAMP
);
