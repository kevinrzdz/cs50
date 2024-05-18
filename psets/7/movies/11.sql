SELECT
    title
FROM
    movies m
    JOIN stars s ON m.id = s.movie_id
    JOIN people p ON s.person_id = p.id
    JOIN ratings r ON s.movie_id = r.movie_id
WHERE
    p.name = 'Chadwick Boseman'
ORDER BY
    rating desc
LIMIT
    5;
