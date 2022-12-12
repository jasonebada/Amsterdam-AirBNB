/* 

AirBNB Amsterdam Listing Data Exploration in SQL Queries

Skills Used: Aggregate Functions, Subqueries, Common Table Expressions, Temp Tables, Converting Data Types, Joins, Creating Views

*/

-- Taking a look at the tables

SELECT *
FROM AirBNB.dbo.Listings
ORDER BY 1

SELECT *
FROM AirBNB.dbo.Reviews
ORDER BY 1

 ----------------------------------------------------------------------------------------------------

 -- TOP 5 Dutch Cities ordered by Listing Count

SELECT TOP 5 host_city, COUNT(host_city) AS 'Total Listings'
FROM AirBNB.dbo.Listings
WHERE host_country = 'Netherlands'
GROUP BY host_city
ORDER BY 2 DESC

 ----------------------------------------------------------------------------------------------------

 -- Using a CTE to find cheap listings for 2 or less people

SELECT AVG(price) AS AveragePrice
FROM AirBNB.dbo.Listings



WITH CheapListings AS
(
SELECT id, property_type, room_type, accommodates, bedrooms, beds, price
FROM AirBNB.dbo.Listings
WHERE price < (
SELECT AVG(price)
FROM AirBNB.dbo.Listings)
)
SELECT *
FROM CheapListings
WHERE accommodates <= 2
ORDER BY 4 DESC, 7 DESC


 ----------------------------------------------------------------------------------------------------

 -- Creating a temp_table out of Reviews table

SELECT *
FROM Airbnb.dbo.Reviews

CREATE TABLE #temp_scores (
id float,
host_id float,
review_scores_rating float,
review_scores_accuracy float,
review_scores_cleanliness float,
review_scores_checkin float,
review_scores_communication float,
review_scores_location float,
review_scores_value float,
)

INSERT INTO #temp_scores
SELECT id, host_id, review_scores_rating, review_scores_accuracy, review_scores_cleanliness, review_scores_checkin, 
	review_scores_communication, review_scores_location, review_scores_value
FROM AirBNB.dbo.Reviews


SELECT id, host_id, CAST( (review_scores_rating + review_scores_accuracy + review_scores_cleanliness + review_scores_checkin + 
	review_scores_communication + review_scores_location + review_scores_value) / 7 AS DECIMAL(5,2)) AS FinalScore
FROM #temp_scores

ALTER TABLE #temp_scores
ADD FinalScore float

UPDATE #temp_scores
SET FinalScore = CAST( (review_scores_rating + review_scores_accuracy + review_scores_checkin + review_scores_communication +
review_scores_location + review_scores_value) / 6 AS DECIMAL(5,2))

SELECT * FROM #temp_scores

 ----------------------------------------------------------------------------------------------------

 -- Average FinalScore of Superhosts vs Non-Superhosts

SELECT AVG(FinalScore) AS 'Superhost FinalScore', host_is_superhost
FROM #temp_scores T
JOIN AirBNB.dbo.Listings L
ON T.id = L.id AND T.host_id = L.host_id
GROUP BY host_is_superhost

 ----------------------------------------------------------------------------------------------------

 -- Creating View  of Host Percentage per Country Around the World for later visualizations

CREATE VIEW [Host Country Percentage] AS
SELECT host_country, CAST( COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS HostPercentage
FROM AirBNB.dbo.Listings
GROUP BY host_country

SELECT *
FROM [Host Country Percentage]
ORDER BY 2 DESC


