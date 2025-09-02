-- Netflix Project
DROP TABLE netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(10),
    type         VARCHAR(15),
    title        VARCHAR(300),
    director     VARCHAR(600),
    casts        VARCHAR(1100),
    country      VARCHAR(600),
    date_added   VARCHAR(60),
    release_year INT,
    rating       VARCHAR(20),
    duration     VARCHAR(20),
    listed_in    VARCHAR(300),
    description  VARCHAR(600)
);
SELECT * FROM netflix;
*************************************
--Business Problems and Solutions
**********************

-- Q.1-Count of titles by type & year
-- Business: “How fast are we adding Movies vs TV Shows YoY?”

SELECT 
		release_year,
		type,
		COUNT(*) AS title
FROM netflix
GROUP BY 1,2
ORDER BY 1 DESC,2;

-- Q.2- Top-10 countries with most titles
-- Business: “Which markets are we strongest in?”

SELECT UNNEST(STRING_TO_ARRAY(TRIM(country), ',')) AS single_country,
		title,
		COUNT(*)                                    AS titles
FROM   netflix
WHERE  country IS NOT NULL
GROUP  BY single_country,title
ORDER  BY titles DESC
LIMIT 10;

-- Q.3- Titles added in last 30 days
-- Business: “What’s fresh on the platform?”

SELECT title,
		type,
		date_added
FROM   netflix
WHERE  TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '30 days';

-- Q.4- All movies released between 2015-2020 with rating > 8
-- Business: “Identify evergreen catalog for licensing negotiations.”

SELECT title, release_year, rating
FROM   netflix
WHERE  type = 'Movie'
  AND  release_year BETWEEN 2015 AND 2020
  AND  rating IN ('TV-MA','R','PG-13');
  
 -- Q.5- Count the Number of Movies vs TV Shows
 -- Business: "Determine the distribution of content types on Netflix."
 SELECT
 		type,
		 COUNT(*)
FROM netflix
GROUP BY 1;

-- Q.6- Find the Most Common Rating for Movies and TV Shows
-- Business : "Identify the most frequently occurring rating for each type of content."
SELECT
	type,
	rating,
	ranking
FROM
(
SELECT 
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) AS ranking
FROM netflix
GROUP BY 1,2
) as t1
WHERE ranking = 1;

-- Q.7- List All Movies name Released in a Specific Year (e.g., 2021)
-- Business : "Retrieve all movies name released in a specific year."
SELECT 
	*
FROM netflix
WHERE release_year = '2021'
				AND type = 'Movie'

-- Q.8-Find the Top 5 Countries with the Most Content on Netflix
-- Business: Identify the top 5 countries with the highest number of content items.

SELECT 
		UNNEST(STRING_TO_ARRAY(country,',')) AS country,
		COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9- Identify the longest movies;
-- Business: Find the movie with the longest duration.

SELECT * 
FROM netflix
	WHERE type = 'Movie'
	AND
	duration = (SELECT max(duration) FROM netflix);
-- Q.10-  Find the content that added in last 5 years
-- Business : Retrieve content added to Netflix in the last 5 years.

SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- Q.11-  Find all the MOvies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- Q.12-  List the all TV Shows with more than 5 Seasons

SELECT 
	* 
FROM netflix
WHERE type = 'TV Show'
	AND 
	SPLIT_PART(duration,' ',1)::numeric > 5;

-- Q.13-  Count the number of content items in each genre
SELECT
	UNNEST(STRING_TO_ARRAY(listed_in,	',')) AS Genre,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

-- Q.14-  Find each year and average numbers of content release in India on netflix. Return top 5 year with
-- highest average content release;

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS Years,
	COUNT(*) AS yearly_content,
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country='India') * 100,2) AS avg_content
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 3 DESC;

-- Q.15-  Lists all the movies that are documentaries

SELECT * 
FROM netflix
WHERE listed_in ILIKE '%documentaries%';

-- Q.16- Find all the content without director

SELECT *
FROM netflix
WHERE director IS NULL;

-- Q.16- Find how many movies actor 'Salman Khan' appeared in last 11 years;

SELECT *
FROM netflix
WHERE casts ILIKE '%Salman%Khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 11;

-- Q.17- Find the top 10 actors who have appeared in the highest number of movies produced in India;

SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) as actor,
	COUNT(*) as total_movie
FROM netflix
WHERE country ILIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Q.18- Categorieze the content based on the presence of the keyword 'Kill' and 'violence' in the 
-- description field. Label the content containing these keywords as 'Bad' and all other content 
-- as 'Good'. COUNT how many item fall into each category.

WITH new_category
AS
(
SELECT *,
	CASE
		WHEN 
			description ILIKE '%kill%' OR 
			description ILIKE '%violence%'
		THEN 'Bad Content'
		ELSE 'Good Content'
		END category
FROM netflix
)
SELECT
		category,
		COUNT(*) AS total_content
FROM new_category
GROUP BY 1;


-- Q-19-Average movie duration (minutes)
-- Business: “Benchmark our catalog length vs competitors.”

SELECT 
	type,
	ROUND(AVG(SPLIT_PART(duration,' ',1)::INT),2) AS avg_duration
FROM netflix
WHERE type = 'Movie'
GROUP BY 1
ORDER BY 2 DESC;

-- Q.20.Top-5 genres by title count
-- Business: “Which genres should we double-down on?”

SELECT TRIM(genre) AS genres,
       COUNT(*)    AS titles
FROM   netflix,
       UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
GROUP  BY genre
ORDER  BY titles DESC
LIMIT 5;

-- Q.21-Titles missing director information
-- Business: “Data quality audit.”

SELECT 
	COUNT(*) AS missing_director
FROM netflix
WHERE director IS NULL OR director = ' ';

-- Q.22-Distribution of content by rating
-- Business: “Age-appropriate mix for parental controls.”

SELECT rating,
       COUNT(*) AS titles
FROM   netflix
GROUP  BY rating
ORDER  BY titles DESC;

-- Q.23-Indian TV Shows added after 2020
-- Business: “Regional commissioning pipeline check.”

SELECT 	title,
		type,
		date_added
FROM   netflix
WHERE  country ILIKE '%India%'
  AND  type = 'TV Show'
  AND  release_year > 2020;

-- Q.24-Longest movie
-- Business: “Edge-case sanity check.”

SELECT title,
       SPLIT_PART(duration, ' ', 1)::INT AS minutes
FROM   netflix
WHERE  type = 'Movie' AND duration IS NOT NULL
ORDER  BY minutes DESC
LIMIT 1;

-- Q.25-Year-over-Year growth % in titles
-- Business: “Board-level KPI.”

WITH yearly
AS 
(
  SELECT 
  		release_year,
	  	COUNT(*) AS titles
  FROM  netflix
  GROUP  BY release_year
)
SELECT release_year,
       titles,
       ROUND(100.0 * (titles - LAG(titles) OVER (ORDER BY release_year)) /
             LAG(titles) OVER (ORDER BY release_year), 2) AS pct_growth
FROM   yearly
ORDER  BY release_year;

-- Q.26-Titles containing “Love” in description
-- Business: “Marketing campaign for Valentine’s week.”

SELECT title
FROM netflix
WHERE description ILIKE '%love%';

-- Q.27- Number of unique directors
-- Business: “Talent diversity metric.”

SELECT COUNT(DISTINCT TRIM(director)) AS Unique_Director
FROM netflix
WHERE director IS NOT NULL;

-- Q.28-TV Shows with more than 3 seasons
-- Business: “Identify binge-worthy assets.”

SELECT title,
       SPLIT_PART(duration, ' ', 1)::INT AS seasons
FROM   netflix
WHERE  type = 'TV Show'
  AND  SPLIT_PART(duration, ' ', 2) ILIKE '%season%'
  AND  SPLIT_PART(duration, ' ', 1)::INT > 3;

-- Q.29- Top-10 busiest actors
-- Business: “Star power analysis.”

SELECT
	TRIM(actor) AS Actors,
	COUNT(*) AS titles
FROM netflix,
	UNNEST(STRING_TO_ARRAY(casts,',')) AS actor
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- Q.30-. Titles added in 2023 but released before 2000
-- Business: “Legacy content acquisition review.”

SELECT title, release_year, date_added
FROM   netflix
WHERE  release_year < 2000
  AND  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) = 2023;

-- Q.31.Percentage split of Movies vs TV Shows
-- Business: “Platform identity metric.”

SELECT type,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM   netflix
GROUP  BY 1;

-- Q-32. Documentaries under 60 minutes
-- Business: “Snackable content for mobile.”
SELECT * FROM netflix;

SELECT title,
       SPLIT_PART(duration, ' ', 1)::INT AS minutes
FROM   netflix
WHERE  type = 'Movie'
  AND  listed_in ILIKE '%Documentaries%'
  AND  SPLIT_PART(duration, ' ', 2) = 'min'
  AND  SPLIT_PART(duration, ' ', 1)::INT <= 60;

-- Q.33. Titles with “Christmas” keyword released in December
-- Business: “Seasonal programming.”
SELECT title, release_year
FROM   netflix
WHERE  description ILIKE '%christmas%'
  AND  EXTRACT(MONTH FROM TO_DATE(date_added, 'Month DD, YYYY')) = 12;

-- Q-34.Directors who are also actors in the same title
-- Business: “Multi-hyphenate talent identification.”

SELECT DISTINCT n.title,
                TRIM(d.director) AS person
FROM   netflix n,
       UNNEST(STRING_TO_ARRAY(n.director, ',')) AS d(director),
       UNNEST(STRING_TO_ARRAY(n.casts, ','))     AS c(actor)
WHERE  TRIM(d.director) = TRIM(c.actor);

-- Q.35.Most frequent collaboration (director-actor pair)
-- Business: “Find golden duos for green-light decisions.”

SELECT TRIM(d.director) AS director,
       TRIM(c.actor)    AS actor,
       COUNT(*)         AS collaborations
FROM   netflix,
       UNNEST(STRING_TO_ARRAY(director, ',')) AS d(director),
       UNNEST(STRING_TO_ARRAY(casts, ','))    AS c(actor)
GROUP  BY 1, 2
HAVING COUNT(*) > 2
ORDER  BY 3 DESC
LIMIT 5;

-- Q.36. Top-20 titles with highest keyword frequency in description
-- Business: “SEO & recommendation tagging.”

SELECT title,
       ARRAY_LENGTH(STRING_TO_ARRAY(description, ' '), 1) AS word_count
FROM   netflix
ORDER  BY word_count DESC
LIMIT 20;

-- End of the Report-- 

