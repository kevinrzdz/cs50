SELECT
    title,
    rating
FROM
    movies m
    JOIN ratings r ON r.movie_id = m.id
WHERE
    YEAR = 2010
ORDER BY
    rating desc,
    title;
