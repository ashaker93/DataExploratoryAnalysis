 
 /* Data Exploration by aggregating data using functions like TRUNC, Percentile
 ,Correlation, Generate series, Temp Tables and others*/
 -- -- --
 -- Summarize numeric columns
 -- Select min, avg, max, and stddev of fortune500 profits
SELECT min(profits),
       avg(profits),
       max(profits),
       stddev(profits)
  FROM fortune500;
 
 -- repeat previous step, but summarize profits by sector
 -- Select sector and summary measures of fortune500 profits
SELECT sector,
       min(profits),
       avg(profits),
       max(profits),
       stddev(profits)
  FROM fortune500
 -- GROUP BY sector
GROUP BY sector
 -- Order by the average profits
 ORDER BY AVG;
 
 /*
 what is the standard deviation across tags in the maximum number of Stack Overflow questions per day? What about the mean, min, and max of the maximums as well?
 */
 -- Compute standard deviation of maximum values
SELECT stddev(maxval),
       -- min
       min(maxval),
       -- max
       max(maxval),
       -- avg
       avg(maxval)
  -- Subquery to compute max of question_count by tag
  FROM (SELECT max(question_count) AS maxval
          FROM stackoverflow
         -- Compute max by...
         GROUP BY tag) AS max_results;
		 
------------
-- Distribution of Values

/* Using Trunc to examine the distributions of attributes of the
Fortune 500 companies
*/
-- truncate employees to the 100,000s (5 zeros)
SELECT TRUNC(employees, -5) AS employee_bin,
       -- Count number of companies with each truncated value
       COUNT(name)
  FROM fortune500
 GROUP BY employee_bin
 ORDER BY employee_bin ;
 
 -- Repeat the last step for companies with < 100,000 employees (most common).
 -- Truncate employees to 10,000 place
SELECT TRUNC(employees, -4) AS employee_bin,
       -- Count number of companies with each truncated value
       COUNT(name)
  FROM fortune500
 WHERE employees < 100000
 GROUP BY employee_bin
 ORDER BY employee_bin;
 ----------
 
 -- Generate Series
 
/*
Summarize the distribution of the number of questions with the tag
"dropbox" on Stack Overflow per day by binning the data.
*/
WITH bins AS (
      SELECT generate_series(2200, 3050, 50) AS lower,
             generate_series(2250, 3100, 50) AS upper),
     -- Subset stackoverflow to just tag dropbox
     dropbox AS (
      SELECT question_count 
        FROM stackoverflow
       WHERE tag='dropbox') 
-- Select columns for result
SELECT lower, upper, count(question_count) 
  FROM bins  -- Created above
       -- Join to dropbox (created above), 
       -- keeping all rows from the bins table in the join
       LEFT JOIN dropbox
       -- Compare question_count to lower and upper
         ON question_count >= lower 
        AND question_count < upper
 -- Group by lower and upper to count values in each bin
 GROUP BY lower, upper
 -- Order by lower to put bins in order
 ORDER BY lower;
 ---------
 
 -- Correlation Function
/* What's the relationship between a company's revenue and its other
financial attributes?
 */
-- Correlation between revenues and profit
SELECT corr(revenues,profits) AS rev_profits,
	   -- Correlation between revenues and assets
       corr(revenues,assets) AS rev_assets,
       -- Correlation between revenues and equity
       corr(revenues,equity) AS rev_equity 
  FROM fortune500
  
-- Calculate Mean with AVG() and Median with percentile_disc()

SELECT sector,
       -- Select the mean of assets with the avg function
       AVG(assets) AS mean,
       -- Select the median with percentile_disc()
       percentile_disc(0.5) WITHIN GROUP (ORDER BY assets) AS median
  FROM fortune500
 -- Computing statistics for each what?
 GROUP BY sector
 -- Order results by a value of interest
 ORDER BY mean;
/* The mean and median can differ significantly for skewed
distributions that have a few extreme values.
*/
-------------------
-- Using Temp Table and percentile function
/* Finding the Fortune 500 companies that have profits in the top 20%
for their sector (compared to other Fortune 500 companies)
*/

DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;

SELECT title, fortune500.sector, 
       fortune500.profits, profits/pct80 AS ratio
  FROM fortune500 
       LEFT JOIN profit80
       ON fortune500.sector=profit80.sector
 WHERE profits > pct80;
----------

-- How many questions had each tag on the first date for which data for each tag ?
-- how many questions had the tag on the last day?
-- computing the difference between these two values

DROP TABLE IF EXISTS startdates;

CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;
 
SELECT startdates.tag, 
       mindate, 
       -- Select question count on the min and max days
	   so_min.question_count AS min_date_question_count,
       so_max.question_count AS max_date_question_count,
       -- Compute the change in question_count (max- min)
       so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow
       INNER JOIN stackoverflow AS so_min
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again
       INNER JOIN stackoverflow AS so_max
          ON startdates.tag = so_max.tag
         AND so_max.date = '2018-09-25';
 
 
 
 
 
  