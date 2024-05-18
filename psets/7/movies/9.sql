SELECT DISTINCT
    p.name
FROM
    people p
    JOIN stars s ON p.id = s.person_id
    JOIN movies m ON s.movie_id = m.id
WHERE
    YEAR = 2004
ORDER BY
    p.birth;
