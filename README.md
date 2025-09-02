# Netflix Movies and TV Shows Database

## Overview
This project presents a comprehensive analytical study of Netflix's content library using SQL-based data analysis techniques. The primary objective is to extract actionable business insights from Netflix's movies and TV shows dataset to support strategic decision-making and content optimization initiatives.

## Project Objectives
The analysis addresses critical business questions to understand Netflix's content landscape, including:
**1-Content Distribution Analysis:** Examining the composition of movies versus TV shows in Netflix's catalog.
**2-Geographic Content Mapping:**Identifying content production patterns across different countries.
**3-Temporal Trend Analysis:**Understanding content release patterns and historical growth trends.
**4-Genre and Category Performance:**Analyzing popular content categories and their market performance.
**5-Content Maturity Profiling:**Evaluating content ratings and target audience demographics.
**6-Quality Assessment Metrics:**Investigating content duration, cast diversity, and production characteristics.
## Business Intelligence Framework
**Key Performance Indicators (KPIs)**
*Content volume by type and release year
*Geographic distribution of content production
*Genre popularity and market penetration
*Content rating distribution and audience targeting
*Production timeline and release frequency metrics
##Analytical Techniques Employed
*Complex SQL queries with subquery operations
*Aggregate functions for statistical analysis
*Window functions for ranking and trend analysis
*Subqueries and Common Table Expressions (CTEs) for complex data transformations
*Date/time analysis for temporal pattern recognition

## 📋 Data Source
The data was sourced from publicly available Netflix content databases and has been cleaned, normalized, and structured for analytical purposes.

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/balrampanday/data-netflix)

##🙏 Acknowledgments
Netflix for the original content data
Kaggle and other open data communities
Contributors and supporters of this project
##🛠️ Tools and Technologies
**Database: PostgreSQL**

##📊 There are 36 of Business Problems and their Solutions

## Schema
```sql
	DROP TABLE IF EXISTS netflix;
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
```
# Business Problems and Solutions

## Q.1-Count of titles by type & year
 **Business:** “How fast are we adding Movies vs TV Shows YoY?”
 
```sql
	SELECT 
			release_year,
			type,
			COUNT(*) AS title
	FROM netflix
	GROUP BY 1,2
	ORDER BY 1 DESC,2;
```

## Q.2- Top-10 countries with most titles
 **Business:** “Which markets are we strongest in?”
 
```sql
	SELECT UNNEST(STRING_TO_ARRAY(TRIM(country), ',')) AS single_country,
			title,
			COUNT(*)                                    AS titles
	FROM   netflix
	WHERE  country IS NOT NULL
	GROUP  BY single_country,title
	ORDER  BY titles DESC
	LIMIT 10;
```

## Q.3- Titles added in last 30 days
 **Business:** “What’s fresh on the platform?”
 
```sql

	SELECT title,
			type,
			date_added
	FROM   netflix
	WHERE  TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '30 days';
```

## Q.4- All movies released between 2015-2020 with rating > 8
 **Business:** “Identify evergreen catalog for licensing negotiations.”

```sql
	SELECT title, release_year, rating
	FROM   netflix
	WHERE  type = 'Movie'
	  AND  release_year BETWEEN 2015 AND 2020
	  AND  rating IN ('TV-MA','R','PG-13');
```
	  
## Q.5- Count the Number of Movies vs TV Shows
	**Business:** "Determine the distribution of content types on Netflix."
	
```sql
		 SELECT
				type,
				 COUNT(*)
		FROM netflix
		GROUP BY 1;
```

## Author

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated
**Your Name** Balram Pandey
**Email** [balram.cpt@gmail.com]

##Conclusion
This comprehensive SQL-based analysis of Netflix's content library demonstrates the power of data analytics in extracting meaningful business insights from large datasets. The project showcases advanced analytical capabilities while providing actionable intelligence for strategic content management and business development initiatives.