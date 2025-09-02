# Netflix Movies and TV Shows Database

![GitHub](https://img.shields.io/badge/SQL-PostgreSQL-blue) ![GitHub](https://img.shields.io/badge/Status-Active-brightgreen) ![GitHub](https://img.shields.io/badge/Data-Netflix%20Content-red)

## Overview

This project presents a comprehensive analytical study of Netflix's content library using SQL-based data analysis techniques. The primary objective is to extract actionable business insights from Netflix's movies and TV shows dataset to support strategic decision-making and content optimization initiatives.

## Project Objectives

The analysis addresses critical business questions to understand Netflix's content landscape, including:

- **Content Distribution Analysis:** Examining the composition of movies versus TV shows in Netflix's catalog
- **Geographic Content Mapping:** Identifying content production patterns across different countries
- **Temporal Trend Analysis:** Understanding content release patterns and historical growth trends
- **Genre and Category Performance:** Analyzing popular content categories and their market performance
- **Content Maturity Profiling:** Evaluating content ratings and target audience demographics
- **Quality Assessment Metrics:** Investigating content duration, cast diversity, and production characteristics

## Business Intelligence Framework

### Key Performance Indicators (KPIs)
- Content volume by type and release year
- Geographic distribution of content production
- Genre popularity and market penetration
- Content rating distribution and audience targeting
- Production timeline and release frequency metrics

### Analytical Techniques Employed
- Complex SQL queries with subquery operations
- Aggregate functions for statistical analysis
- Window functions for ranking and trend analysis
- Subqueries and Common Table Expressions (CTEs) for complex data transformations
- Date/time analysis for temporal pattern recognition

## 📊 Database Schema

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
```

## 🚀 Getting Started

### Prerequisites
- PostgreSQL (version 12 or higher recommended)
- Basic SQL knowledge

### Installation

1. Clone this repository:
```bash
git clone https://github.com/balrampandey/netflix-sql-database.git
cd netflix-sql-database
```

2. Create a PostgreSQL database:
```sql
CREATE DATABASE netflix_db;
```

3. Import the SQL file:
```bash
psql netflix_db < netflix_database.sql
```

Or use pgAdmin to import the SQL file directly.

## 📋 Data Source

The data for this project is sourced from the Kaggle dataset:
- **Dataset Link:** [Netflix Movies and TV Shows](https://www.kaggle.com/datasets/balrampanday/data-netflix)

## 📊 Business Problems and Solutions

### Q.1 Count of titles by type & year
**Business Question:** "How fast are we adding Movies vs TV Shows YoY?"

```sql
SELECT 
    release_year,
    type,
    COUNT(*) AS title_count
FROM netflix
GROUP BY 1,2
ORDER BY 1 DESC,2;
```

### Q.2 Top-10 countries with most titles
**Business Question:** "Which markets are we strongest in?"

```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(TRIM(country), ',')) AS single_country,
    COUNT(*) AS titles_count
FROM netflix
WHERE country IS NOT NULL
GROUP BY single_country
ORDER BY titles_count DESC
LIMIT 10;
```

### Q.3 Titles added in last 30 days
**Business Question:** "What's fresh on the platform?"

```sql
SELECT 
    title,
    type,
    date_added
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '30 days';
```

### Q.4 All movies released between 2015-2020 with rating > 8
**Business Question:** "Identify evergreen catalog for licensing negotiations."

```sql
SELECT 
    title, 
    release_year, 
    rating
FROM netflix
WHERE type = 'Movie'
    AND release_year BETWEEN 2015 AND 2020
    AND rating IN ('TV-MA','R','PG-13');
```

### Q.5 Count the Number of Movies vs TV Shows
**Business Question:** "Determine the distribution of content types on Netflix."

```sql
SELECT
    type,
    COUNT(*) AS count
FROM netflix
GROUP BY 1;
```

*(Note: The complete project includes 36 business problems and solutions)*

## 🛠️ Tools and Technologies

- **Database:** PostgreSQL





## 🙏 Acknowledgments

- Netflix for the original content data
- Kaggle and other open data communities
- Contributors and supporters of this project

## Author

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

**Your Name:** Balram Pandey  
**Email:** [balram.cpt@gmail.com](mailto:balram.cpt@gmail.com)  
**Quick Access:**[linktr.ee/balrampandey]

---

## Conclusion

This comprehensive SQL-based analysis of Netflix's content library demonstrates the power of data analytics in extracting meaningful business insights from large datasets. The project showcases advanced analytical capabilities while providing actionable intelligence for strategic content management and business development initiatives.

⭐️ Feel free to star this repository if you found it helpful!

