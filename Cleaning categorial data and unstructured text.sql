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
 
 
 -- Remove house numbers, extra punctuation and any spaces from the beginnng of street values
 
SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;
 
 
