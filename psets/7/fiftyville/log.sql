-- Keep a log of any SQL queries you execute as you solve the mystery.
-- First, I decided to query the crime_scene_reports table, to find the description of the crime, using the date and place i was provide:
SELECT
    *
FROM
    crime_scene_reports
WHERE
    street = 'Humphrey Street'
    AND DAY = 28
    AND MONTH = 7
    AND YEAR = 2023;

-- This gave me two crimes, so I decided to filter a little more, and add the one who had cs50 duck on the description:
SELECT
    *
FROM
    crime_scene_reports
WHERE
    street = 'Humphrey Street'
    AND DAY = 28
    AND MONTH = 7
    AND YEAR = 2023
    AND description LIKE '%cs50 duck%';

-- Now I know that the crime id is 295 and that there were 3 witnesses and that they mention the bakery:
SELECT
    *
FROM
    interviews
WHERE
    transcript LIKE '%bakery%'
    AND DAY = 28
    AND MONTH = 7
    AND YEAR = 2023;

-- This way, I now have the info of the 3 witnesses. Key takeaways:
-- 1. Within 10 minutes of the theft, the thief was saw get into a car in the bakery parking lot. Look at camera footages for cars who left the parking lot in that time frame.
-- 2. A witness recognized him, but don't know the name. Earlier that morning, the witness saw him at the ATM on Leggett Street withdrawing some money.
-- 3. When the thief was leaving the bakery, he called someone and talked for less than a minute. In the call, they said they were planning to take the earliest flight out of Fiftyville the next day. He also asked the other person to purchase the flight ticket.
-- Next steps: In the crime report description, it says that the duck was stolen at 10:15am, so I would now look on the bakery_security_logs in the next ten minutes frame:
SELECT
    *
FROM
    bakery_security_logs
WHERE
    DAY = 28
    AND MONTH = 7
    AND YEAR = 2023
    AND HOUR = 10
    AND MINUTE BETWEEN 15 AND 25;

-- I now have this cars as suspects:
-- +-----+------+-------+-----+------+--------+----------+---------------+
-- | id  | year | month | day | hour | minute | activity | license_plate |
-- +-----+------+-------+-----+------+--------+----------+---------------+
-- | 260 | 2023 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
-- | 261 | 2023 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
-- | 262 | 2023 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
-- | 263 | 2023 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
-- | 264 | 2023 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
-- | 265 | 2023 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
-- | 266 | 2023 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
-- | 267 | 2023 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
-- +-----+------+-------+-----+------+--------+----------+---------------+
-- Let's continue with the data from suspect 2. Let's look for withdraws on the atm at legget street that morning:
SELECT
    *
FROM
    atm_transactions
WHERE
    DAY = 28
    AND MONTH = 7
    AND YEAR = 2023
    AND transaction_type = 'withdraw'
    AND atm_location = 'Leggett Street';

-- We get this results:
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- | 246 | 28500762       | 2023 | 7     | 28  | Leggett Street | withdraw         | 48     |
-- | 264 | 28296815       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 266 | 76054385       | 2023 | 7     | 28  | Leggett Street | withdraw         | 60     |
-- | 267 | 49610011       | 2023 | 7     | 28  | Leggett Street | withdraw         | 50     |
-- | 269 | 16153065       | 2023 | 7     | 28  | Leggett Street | withdraw         | 80     |
-- | 288 | 25506511       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
-- | 313 | 81061156       | 2023 | 7     | 28  | Leggett Street | withdraw         | 30     |
-- | 336 | 26013199       | 2023 | 7     | 28  | Leggett Street | withdraw         | 35     |
-- +-----+----------------+------+-------+-----+----------------+------------------+--------+
-- Let's finish with witness 3, and then we will try to match all the conections:
SELECT
    *
FROM
    phone_calls
WHERE
    DAY = 28
    AND MONTH = 7
    AND YEAR = 2023
    AND duration < 60;

-- +-----+----------------+----------------+------+-------+-----+----------+
-- | id  |     caller     |    receiver    | year | month | day | duration |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | 221 | (130) 555-0289 | (996) 555-8899 | 2023 | 7     | 28  | 51       |
-- | 224 | (499) 555-9472 | (892) 555-8872 | 2023 | 7     | 28  | 36       |
-- | 233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7     | 28  | 45       |
-- | 251 | (499) 555-9472 | (717) 555-1342 | 2023 | 7     | 28  | 50       |
-- | 254 | (286) 555-6063 | (676) 555-6554 | 2023 | 7     | 28  | 43       |
-- | 255 | (770) 555-1861 | (725) 555-3243 | 2023 | 7     | 28  | 49       |
-- | 261 | (031) 555-6622 | (910) 555-3251 | 2023 | 7     | 28  | 38       |
-- | 279 | (826) 555-1652 | (066) 555-9701 | 2023 | 7     | 28  | 55       |
-- | 281 | (338) 555-6650 | (704) 555-2131 | 2023 | 7     | 28  | 54       |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- We now have all the calls during that day, that were shorter than a minute. Let's try to recap now:
-- I think we can now retieve data from all tables and try to find a match:
SELECT
    *
FROM
    people
WHERE
    license_plate IN (
        '5P2BI95',
        '94KL13X',
        '6P58WS2',
        '4328GD8',
        'G412CB7',
        'L93JTIZ',
        '322W7JE',
        '0NTHK55'
    );

-- +--------+---------+----------------+-----------------+---------------+
-- |   id   |  name   |  phone_number  | passport_number | license_plate |
-- +--------+---------+----------------+-----------------+---------------+
-- | 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       |
-- | 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       |
-- | 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
-- | 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       |
-- | 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
-- | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
-- +--------+---------+----------------+-----------------+---------------+
-- This are the suspects based on the bakery_security_logs data. Let's try now with the atm info:
SELECT
    *
FROM
    people p
    JOIN bank_accounts b ON p.id = b.person_id
WHERE
    account_number IN (
        28500762,
        28296815,
        76054385,
        49610011,
        16153065,
        25506511,
        81061156,
        26013199
    );

-- +--------+---------+----------------+-----------------+---------------+----------------+-----------+---------------+
-- |   id   |  name   |  phone_number  | passport_number | license_plate | account_number | person_id | creation_year |
-- +--------+---------+----------------+-----------------+---------------+----------------+-----------+---------------+
-- | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       | 686048    | 2010          |
-- | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       | 514354    | 2012          |
-- | 458378 | Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       | 16153065       | 458378    | 2012          |
-- | 395717 | Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       | 28296815       | 395717    | 2014          |
-- | 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       | 396669    | 2014          |
-- | 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       | 467400    | 2014          |
-- | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | 76054385       | 449774    | 2015          |
-- | 438727 | Benista | (338) 555-6650 | 9586786673      | 8X428L0       | 81061156       | 438727    | 2018          |
-- +--------+---------+----------------+-----------------+---------------+----------------+-----------+---------------+
-- We now have some suspects based on the atm info. Finally, with the phone call:
SELECT
    *
FROM
    people
WHERE
    phone_number IN (
        '(130) 555-0289',
        '(499) 555-9472',
        '(367) 555-5533',
        '(499) 555-9472',
        '(286) 555-6063',
        '(770) 555-1861',
        '(031) 555-6622',
        '(826) 555-1652',
        '(338) 555-6650'
    );

-- +--------+---------+----------------+-----------------+---------------+
-- |   id   |  name   |  phone_number  | passport_number | license_plate |
-- +--------+---------+----------------+-----------------+---------------+
-- | 395717 | Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       |
-- | 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       |
-- | 438727 | Benista | (338) 555-6650 | 9586786673      | 8X428L0       |
-- | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
-- | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
-- | 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
-- | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
-- | 907148 | Carina  | (031) 555-6622 | 9628244268      | Q12B3Z3       |
-- +--------+---------+----------------+-----------------+---------------+
-- I think we can now combine all this data on a single query and reduce the number of suspects:
WITH
    first_query AS (
        SELECT
            *
        FROM
            people
        WHERE
            license_plate IN (
                '5P2BI95',
                '94KL13X',
                '6P58WS2',
                '4328GD8',
                'G412CB7',
                'L93JTIZ',
                '322W7JE',
                '0NTHK55'
            )
    ),
    second_query AS (
        SELECT
            p.*
        FROM
            people p
            JOIN bank_accounts b ON p.id = b.person_id
        WHERE
            b.account_number IN (
                28500762,
                28296815,
                76054385,
                49610011,
                16153065,
                25506511,
                81061156,
                26013199
            )
    ),
    third_query AS (
        SELECT
            *
        FROM
            people
        WHERE
            phone_number IN (
                '(130) 555-0289',
                '(499) 555-9472',
                '(367) 555-5533',
                '(499) 555-9472',
                '(286) 555-6063',
                '(770) 555-1861',
                '(031) 555-6622',
                '(826) 555-1652',
                '(338) 555-6650'
            )
    )
SELECT
    f.*
FROM
    first_query f
    JOIN second_query s ON f.id = s.id
    JOIN third_query t ON f.id = t.id;

-- This reduces the number of suspects to just two:
-- +--------+-------+----------------+-----------------+---------------+
-- |   id   | name  |  phone_number  | passport_number | license_plate |
-- +--------+-------+----------------+-----------------+---------------+
-- | 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       |
-- | 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       |
-- +--------+-------+----------------+-----------------+---------------+
-- I think we can now use the call to try to find the accomplice:
SELECT
    *
FROM
    phone_calls
WHERE
    caller IN ('(367) 555-5533', '(770) 555-1861')
    AND DAY = 28
    AND MONTH = 7
    AND YEAR = 2023
    AND duration < 60;

-- +-----+----------------+----------------+------+-------+-----+----------+
-- | id  |     caller     |    receiver    | year | month | day | duration |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- | 233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7     | 28  | 45       |
-- | 255 | (770) 555-1861 | (725) 555-3243 | 2023 | 7     | 28  | 49       |
-- +-----+----------------+----------------+------+-------+-----+----------+
-- We also have just two possible accomplice too. Let's look at their names:
SELECT
    *
FROM
    people
WHERE
    phone_number IN ('(375) 555-8161', '(725) 555-3243');

-- +--------+--------+----------------+-----------------+---------------+
-- |   id   |  name  |  phone_number  | passport_number | license_plate |
-- +--------+--------+----------------+-----------------+---------------+
-- | 847116 | Philip | (725) 555-3243 | 3391710505      | GW362R6       |
-- | 864400 | Robin  | (375) 555-8161 | NULL            | 4V16VO0       |
-- +--------+--------+----------------+-----------------+---------------+
-- Let's look at flights:
SELECT
    f.id AS flight_id,
    origin.city AS origin_city,
    dest.city AS destination_city
FROM
    flights f
    JOIN airports origin ON f.origin_airport_id = origin.id
    JOIN airports dest ON f.destination_airport_id = dest.id
WHERE
    origin.city = 'Fiftyville'
    AND f.day = 29
    AND f.month = 7
    AND f.year = 2023
ORDER BY
    f.hour
LIMIT
    1;

-- +-----------+-------------+------------------+
-- | flight_id | origin_city | destination_city |
-- +-----------+-------------+------------------+
-- | 36        | Fiftyville  | New York City    |
-- +-----------+-------------+------------------+
-- We have now solved the second mystery, we now know that the city the thief escaped to was New York City!
-- Let's found who was on that flight, I think that one of them has to be Philip, so let's found the thief:
SELECT
    *
FROM
    passengers p
    JOIN flights f ON p.flight_id = f.id
    JOIN airports a ON f.destination_airport_id = a.id
WHERE
    a.id = 4
    AND f.day = 29
    AND f.month = 7
    AND f.year = 2023
    AND HOUR = 8
    AND p.passport_number IN (5773159633, 5773159633);

-- +-----------+-----------------+------+----+-------------------+------------------------+------+-------+-----+------+--------+----+--------------+-------------------+---------------+
-- | flight_id | passport_number | seat | id | origin_airport_id | destination_airport_id | year | month | day | hour | minute | id | abbreviation |     full_name     |     city      |
-- +-----------+-----------------+------+----+-------------------+------------------------+------+-------+-----+------+--------+----+--------------+-------------------+---------------+
-- | 36        | 5773159633      | 4A   | 36 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | 4  | LGA          | LaGuardia Airport | New York City |
-- +-----------+-----------------+------+----+-------------------+------------------------+------+-------+-----+------+--------+----+--------------+-------------------+---------------+
-- That's it, we now know the thief too, the person with passport number: 5773159633, who is Bruce.
-- Finally, let's found the accomplice, we now it has to be one of Philip or Robin, we don't have Robin passport, so let's try with Philip:
SELECT
    *
FROM
    passengers p
    JOIN flights f ON p.flight_id = f.id
    JOIN airports a ON f.destination_airport_id = a.id
WHERE
    a.id = 4
    AND f.day = 29
    AND f.month = 7
    AND f.year = 2023
    AND f.hour = 8
    AND p.passport_number = 3391710505;

-- This query didn't return any data, so I think the accomplice must be Robin.
