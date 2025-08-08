-- Create the Airbnb database schema 
CREATE DATABASE Airbnb;

-- Create the Hosts Table 
CREATE TABLE IF NOT EXISTS hosts (
	host_id INT PRIMARY KEY,
    host_name VARCHAR(255),
    calculated_host_listings_count INT NOT NULL
);

-- Create the Neighbourhoods Table 
CREATE TABLE IF NOT EXISTS neighbourhoods (
    neighbourhood_id INT PRIMARY KEY,
    neighbourhood VARCHAR(100) NOT NULL,
    neighbourhood_group VARCHAR(100) NOT NULL
);

-- Create the Listings Table 
CREATE TABLE IF NOT EXISTS listings (
	listing_id INT PRIMARY KEY,
    listing_name VARCHAR(255),
    host_id INT,
    neighbourhood_id INT,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    minimum_nights INT NOT NULL,
    number_of_reviews INT NOT NULL,
    last_review DATE,
    reviews_per_month FLOAT,
    availability_365 INT NOT NULL,
    FOREIGN KEY (host_id) REFERENCES hosts(host_id) ON DELETE CASCADE,
    FOREIGN KEY (neighbourhood_id) REFERENCES neighbourhoods(neighbourhood_id) ON DELETE CASCADE
);


-- NOTE: The normalized Airbnb dataset tables were imported into MySQL using the Table Data Import Wizard for smooth and structured data loading.


-- > Data Analysis Begins Here < -- 

-- Descriptive Analytics & Inventory Reporting

-- 1. Generate a report detailing the distribution of listings across all neighborhoods within the 
-- 'Brooklyn' borough, including the specific neighborhood and the count of listings in each.

SELECT 
	nb.neighbourhood_group,
    nb.neighbourhood,
    COUNT(*) AS listings 
FROM 
	listings lis
JOIN 
	neighbourhoods nb
	ON lis.neighbourhood_id = nb.neighbourhood_id
WHERE 
	neighbourhood_group = 'Brooklyn'
GROUP BY 
	neighbourhood
ORDER BY 
	listings DESC; 

-- 2. Provide a summary count of listings categorized by room_type to understand 
-- the composition of our inventory (e.g., 'Entire home/apt', 'Private room').

SELECT 
	room_type,
	COUNT(*) AS listings
 FROM 
	listings
GROUP BY
	room_type;
    
-- 3. Identify all listings with a nightly price between $150 and $250. The output should include 
-- the listing ID, name, neighborhood, and exact price to help analyze our mid-tier market segment.

SELECT 
	lis.listing_id, 
    lis.listing_name,
    nb.neighbourhood,
    lis.price
FROM 
	listings lis
JOIN 
	neighbourhoods nb
	ON lis.neighbourhood_id = nb.neighbourhood_id
WHERE 
	lis.price BETWEEN 150 AND 250
ORDER BY
	lis.price;
    
-- 4. Compile a list of all hosts who manage only a single property.
-- This can be used for targeted communications or support initiatives.

SELECT 
	*
FROM 
	`hosts` hs
JOIN 
	listings lis
    ON hs.host_id = lis.host_id
WHERE 
	calculated_host_listings_count = 1;
    
-- 5. Generate a report of all listings that have received a review since June 1, 2019. 
-- Include the listing name, host name, and the date of the last review.

SELECT 
	lis.listing_name,
    hs.host_name,
    last_review
FROM 
	`hosts` hs
JOIN 
	listings lis
    ON hs.host_id = lis.host_id
WHERE 
	last_review >= '2019-06-1';
    
-- Performance & Market Analysis 

-- 6. Calculate the average annual availability (availability_365) for listings in 
-- 'Queens' versus 'Manhattan' to serve as a proxy for relative occupancy rates.

SELECT
	nb.neighbourhood_group, 
	AVG(availability_365) AS Avg_Availability 
FROM
	listings lis
JOIN
	neighbourhoods nb
	ON lis.neighbourhood_id = nb.neighbourhood_id
WHERE
	nb.neighbourhood_group IN ('Queens', 'Manhattan')
GROUP BY
	neighbourhood_group;
    
-- 7. Identify the top 5 hosts based on the cumulative number of reviews received across all their properties.
-- This will help us recognize and potentially partner with our most successful hosts.

SELECT 
	h.host_name,
	(SELECT SUM(l.number_of_reviews) 
	FROM listings l
	WHERE  l.host_id = h.host_id) AS Total_Reviews
FROM
	`hosts` h
ORDER BY
	Total_Reviews DESC
LIMIT 5;

-- 8. Quantify the number of listings that have a number_of_reviews of zero. This is a key 
-- metric for identifying underperforming or new inventory that may require intervention.

SELECT
    COUNT(*) AS Listings_with_zero_reviews  
FROM
	listings
WHERE 
	number_of_reviews = 0;

-- 9. Determine which neighborhood has the highest concentration of 'Entire home/apt' listings to understand geographic market specialization.

SELECT 
	n.neighbourhood_group,
    n.neighbourhood,
    COUNT(*) AS Entire_Homes
FROM 
	neighbourhoods n
JOIN 
	listings l
    ON n.neighbourhood_id = l.neighbourhood_id
WHERE
	room_type = 'Entire home/apt'
GROUP BY
	n.neighbourhood_group,
    n.neighbourhood
ORDER BY
	Entire_Homes DESC
LIMIT 1;
    
-- 10. Calculate the average listing price for each neighbourhood_group. The results should be ordered 
-- from highest to lowest average price to reveal pricing disparities across boroughs.

SELECT 
	n.neighbourhood_group,
    AVG(l.price) AS Avg_listing_price
FROM 
	neighbourhoods n
JOIN 
	listings l
    ON n.neighbourhood_id = l.neighbourhood_id
GROUP BY
	n.neighbourhood_group
ORDER BY
	Avg_listing_price DESC;
    
-- 11. Isolate listings priced above the average for their respective neighborhoods. This helps in 
-- identifying properties that command a premium and understanding the factors that allow them to do so.

SELECT
	l.listing_id,
    n.neighbourhood,
    l.price 
FROM 
	listings l
JOIN 
	neighbourhoods n
    ON l.neighbourhood_id = n.neighbourhood_id
WHERE l.price > (
	SELECT AVG(l2.price)
    FROM listings l2
    WHERE l2.neighbourhood_id = l.neighbourhood_id
);

-- 12. Identify all listings where the reviews_per_month metric exceeds the average for their specific room_type.
-- This can help pinpoint properties with high guest satisfaction and turnover.

WITH PerformanceMetrics AS (
  SELECT
    listing_id,
    listing_name,
    host_id,
    neighbourhood_id,
    room_type,
    reviews_per_month,
    -- Calculate the average reviews_per_month for each room_type partition
    AVG(reviews_per_month) OVER (PARTITION BY room_type) AS avg_reviews_for_room_type,
    -- Rank listings within each room_type based on reviews_per_month
    RANK() OVER (PARTITION BY room_type ORDER BY reviews_per_month DESC) AS ranking
  FROM
    listings
  WHERE
    reviews_per_month IS NOT NULL
)
SELECT
  pm.listing_name,
  h.host_name,
  n.neighbourhood,
  pm.room_type,
  pm.reviews_per_month,
  pm.avg_reviews_for_room_type,
  pm.ranking
FROM
  PerformanceMetrics pm
JOIN
  hosts h ON pm.host_id = h.host_id
JOIN
  neighbourhoods n ON pm.neighbourhood_id = n.neighbourhood_id
WHERE
  pm.reviews_per_month > pm.avg_reviews_for_room_type
ORDER BY
  pm.room_type,
  pm.ranking;
  
-- Advanced & Strategic Insights

-- 13. Compare the average annual availability (availability_365) for two cohorts: listings with over 100 reviews and those with fewer than 10.
-- This analysis can provide insights into the operational differences between high-volume and low-volume properties.

SELECT
	CASE
		WHEN number_of_reviews > 100 THEN 'High-Volume (Over 100 reviews)'
        WHEN number_of_reviews < 10 THEN 'Low-Volume (Fewer than 10 reviews)'
	END AS review_cohort,
    AVG(availability_365) AS Avg_annual_availability,
    MAX(availability_365) AS Max_annual_availability,
    MIN(availability_365) AS Min_annual_availability,
    -- Arithmetic to calculate the availability range
    MAX(availability_365) - MIN(availability_365) AS availability_range
FROM 
	listings
WHERE 
	number_of_reviews > 100 OR number_of_reviews < 10
GROUP BY
	review_cohort;

-- 14. For each neighbourhood_group, create a ranked list of neighborhoods based on their average listing price.
--  This hierarchical analysis provides a granular view of the most and least expensive micro-markets.

WITH NeighborhoodAveragePrice AS (
  SELECT
    n.neighbourhood_group,
    n.neighbourhood,
    AVG(l.price) AS Avg_price
  FROM
    listings l
  JOIN
    neighbourhoods n ON l.neighbourhood_id = n.neighbourhood_id
  GROUP BY
    n.neighbourhood_group,
    n.neighbourhood
)
SELECT
  neighbourhood_group,
  neighbourhood,
  avg_price,
  RANK() OVER (PARTITION BY neighbourhood_group ORDER BY Avg_price DESC) AS price_rank
FROM
  NeighborhoodAveragePrice
ORDER BY
  neighbourhood_group,
  price_rank;
  
-- 15. Define and identify a segment of "Power Hosts" based on a composite set of criteria: managing at least 5 distinct listings,
-- maintaining an average of over 15 reviews per listing, and having an average annual availability of more than 180 days.

WITH HostPerformanceMetrics AS (
  SELECT
    host_id,
    COUNT(listing_id) AS Total_listings,
    AVG(number_of_reviews) AS Avg_reviews_per_listing,
    AVG(availability_365) AS Avg_annual_availability
  FROM
    listings
  GROUP BY
    host_id
)
SELECT
  h.host_name,
  hpm.total_listings,
  hpm.avg_reviews_per_listing,
  hpm.avg_annual_availability,
  ROW_NUMBER() OVER (ORDER BY hpm.Total_listings DESC, hpm.Avg_reviews_per_listing DESC) AS Power_host_rank
FROM
  HostPerformanceMetrics hpm
JOIN
  hosts h ON hpm.host_id = h.host_id
WHERE
  hpm.total_listings >= 5
  AND hpm.Avg_reviews_per_listing > 15
  AND hpm.Avg_annual_availability > 180
ORDER BY
  Power_host_rank;
