SELECT DISTINCT
    p.name
FROM
    people p
    JOIN stars s ON p.id = s.person_id
    JOIN stars s2 ON s.movie_id = s2.movie_id
    JOIN people p2 ON s2.person_id = p2.id
WHERE
    p2.name LIKE 'Kevin Bacon'
    AND p2.birth = 1958
    AND p.name != 'Kevin Bacon';
