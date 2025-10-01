SELECT
  cuisine,
  COUNT(*) AS num_restaurants
FROM restaurants
GROUP BY cuisine
ORDER BY num_restaurants DESC, cuisine ASC;