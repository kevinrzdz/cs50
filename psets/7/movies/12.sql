SELECT
    m.title
FROM
    movies m
    JOIN stars s ON m.id = s.movie_id
    JOIN people p ON s.person_id = p.id
    join stars s2 on m.id = s2.movie_id
    join people p2 on s2.person_id = p2.id
WHERE
    p.name like 'Bradley Cooper' and p2.name like 'Jennifer Lawrence';
