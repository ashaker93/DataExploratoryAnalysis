-- Cleaning Categorial data and unstructured text
/*
Database used:
Evanston311 dataset: This is data on help requests submitted to the city of Evanston, IL. 
*/

-- How many distinct values of zip appear in at least 100 rows?
SELECT DISTINCT zip,COUNT(*)
  FROM evanston311
 GROUP BY zip
HAVING COUNT(*) >=100; 

-- How many distinct values of source appear in at least 100 rows?
SELECT DISTINCT source, COUNT(*)
  FROM evanston311
GROUP BY source
Having COUNT(*) >= 100

-- Select the five most common values of street and the count of each.
SELECT street, COUNT(*)
  FROM evanston311
 GROUP BY street
 ORDER BY COUNT(*) DESC
 LIMIT 5;
 
 -- Using TRIM()
 -- Remove house numbers, extra punctuation and any spaces from the beginnng of street values
SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;
 
 -- Using LIKE and ILIKE
 -- Count rows where the description includes 'trash' or 'garbage' but the category does not
SELECT COUNT(*)
  FROM evanston311 
 -- description contains trash or garbage (any case)
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
 -- category does not contain Trash or Garbage
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%';
   
-- Find the most common categories for rows with a description about trash that don't have a trash-related category.
SELECT category, COUNT(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 GROUP BY category
 --- order by most frequent values
 ORDER BY COUNT(*) DESC
 LIMIT 10;
 
 
-- Using Concatenate Function
-- Concatenate house_num and street and trim spaces
SELECT TRIM(CONCAT(house_num,' ', street)) AS address
  FROM evanston311;
  
-- Using split_part 
-- Extract just the first word of each street value to find the most common streets regardless of the suffix
SELECT split_part(street,' ',1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;
 
-- Using CASE, LEFT and CONCAT
-- Shorten Long strings
-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN LEFT(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;

 

