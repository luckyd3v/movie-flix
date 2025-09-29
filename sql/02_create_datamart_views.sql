SET search_path = dw;

CREATE OR REPLACE VIEW dm_top10_by_avg AS
SELECT m.imdb_id, m.title, m.genre,
       AVG(r.rating)::numeric(10,2) AS avg_rating,
       COUNT(r.*) AS ratings_count
FROM movies m
JOIN ratings r ON r.imdb_id = m.imdb_id
GROUP BY m.imdb_id, m.title, m.genre
HAVING COUNT(r.*) >= 1
ORDER BY avg_rating DESC, ratings_count DESC
LIMIT 10;

CREATE OR REPLACE VIEW dm_avg_rating_by_age_group AS
SELECT age_group, AVG(r.rating)::numeric(10,2) AS avg_rating, COUNT(*) AS ratings_count
FROM (
  SELECT r.*, CASE
    WHEN u.age < 18 THEN '<18'
    WHEN u.age BETWEEN 18 AND 25 THEN '18-25'
    WHEN u.age BETWEEN 26 AND 35 THEN '26-35'
    WHEN u.age BETWEEN 36 AND 50 THEN '36-50'
    ELSE '50+' END AS age_group
  FROM ratings r
  JOIN users u ON u.user_id = r.user_id
) sub
GROUP BY age_group
ORDER BY avg_rating DESC;

CREATE OR REPLACE VIEW dm_ratings_by_country AS
SELECT u.country, COUNT(r.*) AS ratings_count
FROM ratings r
JOIN users u ON u.user_id = r.user_id
GROUP BY u.country
ORDER BY ratings_count DESC;
