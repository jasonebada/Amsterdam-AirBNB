/* 

Cleaning Data in SQL Queries

*/



SELECT *
FROM AirBNB.dbo.Listings
ORDER BY 1



----------------------------------------------------------------------------------------------------

-- Change 't' and 'f' to 'True' and 'False' in "has_availability" field	

SELECT DISTINCT has_availability, COUNT(has_availability)
FROM AirBNB.dbo.Listings
GROUP BY has_availability



SELECT has_availability,
CASE
	WHEN has_availability = 't' THEN 'True'
	ELSE 'False'
END AS has_availability_updated
FROM AirBNB.dbo.Listings



UPDATE AirBNB.dbo.Listings
SET has_availability = CASE WHEN has_availability = 't' THEN 'True'
	ELSE 'False'
END





----------------------------------------------------------------------------------------------------

-- Standardizing Date Format

SELECT host_since, CONVERT(Date, host_since) host_since_converted
FROM AirBNB.dbo.Listings



ALTER TABLE AirBNB.dbo.Listings
Add host_since_converted Date



UPDATE AirBNB.dbo.Listings
SET host_since_converted = CONVERT(Date, host_since)





----------------------------------------------------------------------------------------------------

-- Breaking out host_location into Individual Columns (host_city, host_country)

SELECT host_location
FROM AirBNB.dbo.Listings



SELECT PARSENAME(REPLACE(host_location, ',', '.'), 2) AS host_city
FROM AirBNB.dbo.Listings



ALTER TABLE AirBNB.dbo.Listings
Add host_city Nvarchar(255);



UPDATE AirBNB.dbo.Listings
SET host_city = PARSENAME(REPLACE(host_location, ',', '.'), 2)



-- Locations in the US appear as 2-letter state abbreviations, so I change them to 'United States' instead

SELECT CASE 
	WHEN LEN(LTRIM (SUBSTRING(host_location, CHARINDEX(',', host_location) + 1, LEN(host_location)))) > 2 
		THEN LTRIM (SUBSTRING(host_location, CHARINDEX(',', host_location) + 1, LEN(host_location)))
	ELSE 'United States'
END AS host_country
FROM AirBNB.dbo.Listings



ALTER TABLE AirBNB.dbo.Listings
Add host_country Nvarchar(255);



UPDATE AirBNB.dbo.Listings
SET host_country = CASE 
	WHEN LEN(LTRIM (SUBSTRING(host_location, CHARINDEX(',', host_location) + 1, LEN(host_location)))) > 2 
		THEN LTRIM (SUBSTRING(host_location, CHARINDEX(',', host_location) + 1, LEN(host_location)))
	ELSE 'United States'
END






----------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM AirBNB.dbo.Listings



ALTER TABLE AirBNB.dbo.Listings
DROP COLUMN host_location, host_since




