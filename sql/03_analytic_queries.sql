-- 1) Quais os 5 filmes mais populares? (por número de avaliações)
SELECT m.imdb_id, m.title, COUNT(r.*) AS ratings_count
FROM dw.movies m
JOIN dw.ratings r ON r.imdb_id = m.imdb_id
GROUP BY m.imdb_id, m.title
ORDER BY ratings_count DESC
LIMIT 5;

-- 2) Qual gênero tem a melhor avaliação média?
SELECT genre_first, AVG(avg_rating)::numeric(10,2) as genre_avg
FROM (
  SELECT m.imdb_id, split_part(m.genre, ',',1) AS genre_first, AVG(r.rating) AS avg_rating
  FROM dw.movies m
  JOIN dw.ratings r ON r.imdb_id = m.imdb_id
  GROUP BY m.imdb_id, split_part(m.genre, ',',1)
) t
GROUP BY genre_first
ORDER BY genre_avg DESC
LIMIT 5;

-- 3) Qual país assiste mais filmes? (mais avaliações por país)
SELECT u.country, COUNT(*) AS ratings_count
FROM dw.ratings r
JOIN dw.users u ON u.user_id = r.user_id
GROUP BY u.country
ORDER BY ratings_count DESC
LIMIT 10;
