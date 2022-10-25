USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
	COUNT(*) AS Num_rows
FROM
	director_mapping; 

SELECT 
	COUNT(*) AS Num_rows
FROM 
	genre;

SELECT
	COUNT(*) AS Num_rows
FROM  
	movie;

SELECT 
	COUNT(*) AS Num_rows 
FROM  
	names;

SELECT 
	COUNT(*) AS Num_rows 
FROM
	ratings;

SELECT 
	COUNT(*) AS Num_rows 
FROM
	role_mapping;

/* Summarising the number of rows for each table - 
1. director_mapping - 3867 Rows
2. genre - 14662 Rows
3. movie - 7997 Rows
4. names - 25735 Rows
5. ratings - 7997 Rows
6. role_mapping - 15615 Rows
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
	Sum(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_count_id,
	Sum(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_count_title,
	Sum(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_count_year,
	Sum(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS null_count_date_published,
	Sum(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS null_count_duration,
	Sum(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_count_country,
	Sum(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS null_count_worlwide_gross_income,
	Sum(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS null_count_languages,
	Sum(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS null_count_production_company
FROM
	movie; 
/* The Following columns in the 'movie' table have null Values - 
1. country - 20 NULL values
2. worlwide_gross_income - 3724 NULL values
3. languages - 194 NULL values
4. production_company - 528 NULL values
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- PART 1 
SELECT
	year AS Year,
    COUNT(*) AS number_of_movies
FROM 
	movie
GROUP BY 
	year
ORDER BY 
	year;
/* Number of movies in each year are - 

2017 - 3052 movies
2018 - 2944 movies
2019 - 2001 movies
*/

-- PART 2

SELECT
	MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM 
	movie
GROUP BY 
	MONTH(date_published)
ORDER BY 
	MONTH(date_published);
/* Number of movies in each month are - 
01. January   - 804 movies
02. February  - 640 movies
03. March     - 824 movies
04. April     - 680 movies
05. May       - 625 movies
06. June      - 580 movies
07. July      - 493 movies
08. August    - 678 movies
09. September - 809 movies
10. October   - 801 movies
11. November  - 625 movies
12. December  - 438 movies
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(*) AS Number_of_movies_in_USA_or_India
FROM 
	movie
WHERE country LIKE '%USA%' OR country LIKE '%India%';
-- Answer = 3900 movies were produced in the USA or India in 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT
	DISTINCT genre AS Unique_list_of_genres
FROM 
	genre;

/* The unique list of genres are - 
01. Drama
02. Fantasy
03. Thriller
04. Comedy
05. Horror
06. Family
07. Romance
08. Adventure
09. Action
10. Sci-Fi
11. Crime
12. Mystery
13. Others
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT
	g.genre AS Genre_with_highest_num_of_movies,
    COUNT(m.id) AS Count_of_movies
FROM 
	genre g 
    INNER JOIN movie m 
		ON m.id=g.movie_id
GROUP BY
	g.genre
ORDER BY
	COUNT(m.id) DESC
LIMIT 1;

-- Answer = Drama genre had the most number of movies produced i.e., 4285 movies

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


WITH number_of_genres AS(
	SELECT
		title AS Movie_Title,
		COUNT(genre) AS num_of_genres
	FROM 
		movie m
		INNER JOIN genre g ON m.id=g.movie_id
	GROUP BY 
		title
)
SELECT 
	COUNT(Movie_Title) AS movie_count
FROM 
	number_of_genres
WHERE
	num_of_genres=1;
-- Answer = 3245 movies belong to only one genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	genre,
    ROUND(AVG(duration),2) AS avg_duration
FROM 
	movie m
	INNER JOIN genre g ON m.id=g.movie_id
GROUP BY
	genre
ORDER BY
	AVG(duration) DESC;

-- Action movies have the longest average duration of 112.88 minutes followed by Romance(109.53 minutes).
-- Horror movies have the shortest average duration of 92.72 minutes

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH genre_ranks AS(
	SELECT
		genre,
		COUNT(id) AS movie_count,
		ROW_NUMBER() OVER (ORDER BY COUNT(id) DESC) AS genre_rank
	FROM 
		movie m
		INNER JOIN genre g ON m.id=g.movie_id
	GROUP BY
		genre)
SELECT
	genre,
	movie_count,
    genre_rank
FROM
	genre_ranks
WHERE
	genre='thriller';
    
-- Answer = Rank 3

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
	ROUND(MIN(avg_rating)) AS min_avg_rating,
    ROUND(MAX(avg_rating)) AS max_avg_rating,
    ROUND(MIN(total_votes)) AS min_total_votes,
    ROUND(MAX(total_votes)) AS max_total_votes,
    ROUND(MIN(median_rating)) AS min_median_rating,
    ROUND(MAX(median_rating)) AS max_median_rating
FROM ratings;

-- Answer as per output of query    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_rating_rank AS( 
	SELECT
		title,
		avg_rating,
		RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
	FROM
		movie m
		INNER JOIN ratings r ON m.id=r.movie_id)
	SELECT 
		title,
		avg_rating,
		movie_rank
	FROM 
		movie_rating_rank
	WHERE	
		movie_rank<=10;

-- Answer as per output of query

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
		median_rating,
		COUNT(movie_id) AS movie_count
	FROM
		ratings
	GROUP BY 
		median_rating
	ORDER BY
		COUNT(movie_id) DESC;
-- Answer as per output of query

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	production_company,
    COUNT(id) AS movie_count,
    DENSE_RANK() OVER(ORDER BY COUNT(id)DESC) AS prod_company_rank
FROM
	movie m
    INNER JOIN ratings r ON m.id=r.movie_id
WHERE 
	avg_rating>8 and production_company IS NOT NULL
GROUP BY
	production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	genre,
    COUNT(g.movie_id) AS movie_count
FROM
	movie m
    INNER JOIN genre g ON g.movie_id=m.id
    INNER JOIN ratings r ON r.movie_id=m.id
WHERE
	MONTH(date_published) = 3
    AND year = 2017
    AND total_votes>1000
    AND country LIKE '%USA%'
GROUP BY
	genre
ORDER BY
	COUNT(g.movie_id) DESC;

-- Answer as per output of query
-- Drama movies tops this list with 24 movies 

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	title,
    avg_rating,
    genre
FROM
	movie m
    INNER JOIN genre g ON g.movie_id=m.id
    INNER JOIN ratings r ON r.movie_id=m.id
WHERE 
	title REGEXP '^The'
	AND avg_rating>8
ORDER BY
	genre,
    title;

-- Answer as per output of query

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	median_rating, 
    Count(*) AS movie_count
FROM   
	movie m
    INNER JOIN ratings r ON r.movie_id = m.id
WHERE  
	median_rating = 8
    AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY 
	median_rating;

-- Answer = 361 Movies

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

/*The  question is a little ambiguous. 
The solution can be based on language or country. 
I have approached this question based on the country column*/

SELECT 
	country AS Country,
    SUM(total_votes) AS Total_votes
FROM 
	movie m
    INNER JOIN ratings r ON m.id=r.movie_id
WHERE
	country in ('germany', 'Italy')
GROUP BY country;

-- Answer = Yes, German movies get more votes than Italian movies.

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

-- All columns except name have null values

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS(
	SELECT 
		genre,
		COUNT(g.movie_id) AS movie_count,
		ROW_NUMBER() OVER (ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
	FROM
		genre g
		INNER JOIN ratings r USING(movie_id)
	WHERE
		avg_rating>8
	GROUP BY 
		genre
	LIMIT 3)

SELECT 
    name,
    COUNT(d.movie_id) AS Movie
FROM
	director_mapping d
    INNER JOIN genre g USING(movie_id)
    INNER JOIN top_3_genres USING(genre)
    INNER JOIN names n ON d.name_id=n.id
    INNER JOIN ratings r USING(movie_id)
WHERE 
	avg_rating>8
GROUP BY
	 name
ORDER BY 
	COUNT(d.movie_id) DESC
LIMIT 3;
    
-- Top 3 Directors are James Mangold, Anthony Russo, Soubin Shahir
    

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	name AS actor_name,
    COUNT(r.movie_id) AS movie_count
FROM 
	role_mapping r
    INNER JOIN names n ON n.id=r.name_id
    INNER JOIN ratings USING(movie_id)
WHERE 
	median_rating>=8
GROUP BY 
	name
ORDER BY
	    COUNT(r.movie_id) DESC
LIMIT 2;

-- Answer = Top 2 actors are Mammootty and Mohanlal

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	production_company,
    SUM(total_votes) AS vote_count,
    ROW_NUMBER() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM
	movie m
    INNER JOIN ratings r ON m.id=r.movie_id
GROUP BY
	production_company
LIMIT 3;

/* Top 3 Production houses are 
1. Marvel Studios
2. Twentieth Century Fox
3. Warner Bros. */

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actor_summary AS(
	SELECT
		name AS actor_name,
		total_votes,
		total_votes*avg_rating AS sum_rating,
		a.movie_id AS movie_id
	FROM
		role_mapping a
		INNER JOIN ratings r USING(movie_id)
		INNER JOIN names n ON n.id=a.name_id
        INNER JOIN movie m ON r.movie_id=m.id
	WHERE
		category='actor'
        AND country='india')
SELECT 
	actor_name,
    SUM(total_votes) AS total_votes,
    COUNT(movie_id) AS movie_count,
    ROUND(SUM(sum_rating)/SUM(total_votes),2) AS actor_avg_rating,
    ROW_NUMBER() OVER (ORDER BY ROUND(SUM(sum_rating)/SUM(total_votes)) DESC, SUM(total_votes) DESC) AS actor_rank
FROM 
	actor_summary
GROUP BY 
	actor_name
HAVING
	COUNT(movie_id)>=5;

-- Top actor is Vijay Sethupathi with an average rating of 8.42, followed by Fahadh Faasil and  Yogi Babu

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary AS(
	SELECT
		name AS actress_name,
		total_votes,
		total_votes*avg_rating AS sum_rating,
		a.movie_id AS movie_id
	FROM
		role_mapping a
		INNER JOIN ratings r USING(movie_id)
		INNER JOIN names n ON n.id=a.name_id
        INNER JOIN movie m ON r.movie_id=m.id
	WHERE
		category='actress'
        AND country='india'
        AND languages LIKE '%hindi%')
SELECT 
	actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(movie_id) AS movie_count,
    ROUND(SUM(sum_rating)/SUM(total_votes),2) AS actor_avg_rating,
    ROW_NUMBER() OVER (ORDER BY ROUND(SUM(sum_rating)/SUM(total_votes),2) DESC, SUM(total_votes) DESC) AS actor_rank
FROM 
	actress_summary
GROUP BY
	actress_name
HAVING
	COUNT(movie_id)>=3;

/* Top 5 Actress are - 
1. Taapsee Pannu
2. Kriti Sanon
3. Divya Dutta
4. Shraddha Kapoor
5. Kriti Kharbanda
*/ 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Rating classification for each movie
SELECT
	title AS movie_title,
    avg_rating,
    (CASE
		WHEN avg_rating>8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies' END) AS rating_classification
FROM 
	movie m
    INNER JOIN genre g ON m.id=g.movie_id
    INNER JOIN ratings r ON m.id=r.movie_id
WHERE
	genre = 'thriller';

-- Answer as per output of query
    
-- Number of movies under each rating classification
WITH rating_classification AS (
	SELECT
		title AS movie_title,
		avg_rating,
		(CASE
			WHEN avg_rating>8 THEN 'Superhit movies'
			WHEN avg_rating BETWEEN 7 AND 8 THEN 'hit movies'
			WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
			ELSE 'Flop movies' END) AS rating_classification
	FROM 
		movie m
		INNER JOIN genre g ON m.id=g.movie_id
		INNER JOIN ratings r ON m.id=r.movie_id
	WHERE
		genre = 'thriller')
SELECT 
	rating_classification,
    COUNT(movie_title) AS movie_count
FROM 
	rating_classification
GROUP BY
	rating_classification
ORDER BY 
	COUNT(movie_title) DESC;
-- Answer as per output of query

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comedy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
	genre,
    ROUND(AVG(duration),2) AS avg_duration,
	SUM(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS 4 PRECEDING) AS moving_avg_duration
    -- Here I am taking an arbitrary number 4 for moving average
FROM
	genre g
    INNER JOIN movie m ON m.id=g.movie_id
GROUP BY 
	genre;

-- Round is good to have and not a must have; Same thing applies to sorting

-- Answer as per output of query

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
   
   WITH 
	top_3_genres AS(
		SELECT 
			genre,
			COUNT(g.movie_id) AS movie_count,
			ROW_NUMBER() OVER (ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
		FROM
			genre g
			INNER JOIN ratings r USING(movie_id)
		WHERE
			avg_rating>8
		GROUP BY 
			genre
		LIMIT 3),
	income_summary AS(
		SELECT
			genre,
            YEAR(date_published) AS year,
            title AS movie_name,
            worlwide_gross_income AS worldwide_gross_income,
            -- I have not converted the currencies into a common currency and have assigned ranks based on absolute value of worlwide_gross_income 
            DENSE_RANK() OVER (
								PARTITION BY
									YEAR(date_published)
								ORDER BY
									CAST(RIGHT(worlwide_gross_income, POSITION(' ' IN REVERSE(worlwide_gross_income))) AS DECIMAL(20)) DESC) AS movie_rank
		FROM 
			movie m
            INNER JOIN genre g ON m.id=g.movie_id
		WHERE
			genre IN (SELECT genre FROM top_3_genres))
SELECT 
	*
FROM
	income_summary
WHERE
	movie_rank<=5
GROUP BY
	movie_name;

-- Answer as per output of query


-- Top 3 Genres based on most number of movies

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	production_company,
    COUNT(*) AS movie_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM
	movie m
    INNER JOIN ratings r ON m.id=r.movie_id
WHERE
	median_rating>=8
    AND languages LIKE '%,%'
    AND production_company IS NOT NULL
GROUP BY
	production_company
LIMIT 2;

-- Top 2 production houses are Star Cinema and Twentieth Century Fox


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary_drama AS(
		SELECT
			name AS actress_name,
            SUM(total_votes) AS total_votes,
            COUNT(id) AS movie_count,
            SUM(avg_rating*total_votes)/SUM(total_votes) AS actress_avg_rating
		FROM
			ratings r
			INNER JOIN role_mapping rol USING(movie_id)
			INNER JOIN names n ON n.id=rol.name_id
			INNER JOIN genre g ON g.movie_id=rol.movie_id
		WHERE
			genre='drama'
            AND category='actress'
            AND avg_rating>8
		GROUP BY
			name)
	SELECT
		*,
        RANK() OVER (ORDER BY movie_count DESC) AS actress_rank
	FROM
		actress_summary_drama
	LIMIT 3;
    
-- Top 3 Actress are Parvathy Thiruvothu, Susan Brown, Amanda Lawrence
        

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH 
	top_9_directors AS (
		SELECT
			name_id,
			ROW_NUMBER() OVER(ORDER BY COUNT(movie_id) DESC)AS dir_rank
		FROM
			director_mapping
		GROUP BY 
			name_id
		LIMIT 9),
	dir_summary AS(
		SELECT
			name_id AS director_id,
			name AS director_name,
			m.id AS movie_id,
			date_published,
			LEAD(date_published, 1) OVER (PARTITION BY name ORDER BY name, date_published) AS next_movie_date_published,
            DATEDIFF(LEAD(date_published, 1) OVER (PARTITION BY name ORDER BY name, date_published), date_published) AS inter_movie_days,
			avg_rating,
			total_votes,
			duration
		FROM 
			movie m
            INNER JOIN director_mapping d ON m.id=d.movie_id
            INNER JOIN names n ON n.id=d.name_id
            INNER JOIN ratings r USING(movie_id)
		WHERE
			name_id IN (SELECT name_id FROM top_9_directors))
SELECT 
	director_id,
	director_name,
	COUNT(movie_id) AS number_of_movies,
	ROUND(AVG(inter_movie_days),2) AS avg_inter_movie_days,
	SUM(avg_rating*total_votes)/SUM(total_votes) AS avg_rating,
	SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration
FROM 
	dir_summary
GROUP BY
	director_id;
