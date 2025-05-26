-- Active: 1747757623462@@127.0.0.1@5432@conservation_db

CREATE TABLE rangers (
    rangers_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(100) NOT NULL
);

INSERT INTO
    rangers (name, region)
VALUES ('Sohel Rana', 'Sundarbans'),
    (
        'Abir hasan',
        'Chittagong Hill Tracts'
    ),
    (
        'Mehedi Hasan',
        'Sylhet Forest Region'
    ),
    (
        'Nasima Begum',
        'Barind Tract'
    ),
    (
        'Rafiq Ahmed',
        'Haor Area, Kishoreganj'
    );

SELECT * FROM rangers;

CREATE TYPE conservation_status_enum AS ENUM('Endangered', 'Vulnerable', 'Historic');

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE,
    conservation_status conservation_status_enum NOT NULL
);

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Bengal Fox',
        'Vulpes bengalensis',
        '1830-01-01',
        'Vulnerable'
    );

SELECT * FROM species;

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers (rangers_id),
    species_id INT REFERENCES species (species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(120) NOT NULL,
    notes TEXT
)
INSERT INTO
    sightings (
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

SELECT * FROM sightings;

-- 1. Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- 2. Count unique species ever sighted.
SELECT count(*) AS count_species_sighted
FROM (
        SELECT species_id
        FROM sightings
        GROUP BY
            species_id
    ) AS unique_species

-- 3. Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location ILIKE '%pass%'

-- 4.List each ranger's name and their total number of sightings.
SELECT r.name, COUNT(s.sighting_id) AS total_sightings
FROM sightings s
    JOIN rangers r ON s.ranger_id = r.rangers_id
GROUP BY
    r.name;

-- 5.List species that have never been sighted.
SELECT common_name
FROM species
WHERE
    species_id NOT IN (
        SELECT species_id
        FROM sightings
    );

-- 6. Show the most recent 2 sightings.
SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings s
    JOIN species sp ON s.species_id = sp.species_id
    JOIN rangers r ON s.ranger_id = r.rangers_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- 7.Update all species discovered before year 1800 to have status 'Historic'.
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01';

-- 8.Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) BETWEEN 12 AND 16  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- 9.Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE
    rangers_id NOT IN (
        SELECT DISTINCT
            ranger_id
        FROM sightings
    );