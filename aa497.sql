#F28DM CW2



#username = aa497



#question 1

SELECT count(*) FROM imdb_actors WHERE sex = 'F';

#question 2

SELECT title FROM imdb_movies WHERE year=(SELECT min(year) FROM imdb_movies);

#question 3

SELECT count(number) FROM (SELECT count(directorid) AS number FROM imdb_movies2directors GROUP BY movieid HAVING count(directorid)>5) AS number_of_movies;

#question 4

SELECT title FROM (SELECT movie_id AS id_of_movie, max(director_count) FROM 
(SELECT movieid AS movie_id, count(directorid) AS director_count FROM imdb_movies2directors GROUP BY movieid ORDER BY count(directorid) desc) 
AS max_director_count) AS movie_table, imdb_movies AS the_movies WHERE the_movies.movieid=movie_table.id_of_movie;

#question 5

SELECT sum(time1) FROM imdb_runningtimes JOIN imdb_movies2directors ON imdb_runningtimes.movieid = imdb_movies2directors.movieid WHERE genre = "Sci-Fi";

#question 6

SELECT count(movie_id) FROM (SELECT movieid AS movie_id FROM imdb_movies2actors AS movies_actors, imdb_actors AS the_actors WHERE  
movies_actors.actorid=the_actors.actorid AND the_actors.name LIKE "%McGregor%Ewan%" AND movieid IN (SELECT movieid FROM imdb_movies2actors 
AS movies_actors_table, imdb_actors AS the_actors_table WHERE movies_actors_table.actorid=the_actors_table.actorid AND 
the_actors_table.name LIKE "%Carlyle%Robert%") ) AS number_of_movies;

#question 7

SELECT count(distinct actor1) FROM (SELECT A.actorid AS actor1, B.actorid AS actor2, A.movieid AS a_movieid, B.movieid 
AS b_movieid FROM imdb_movies2actors A, imdb_movies2actors B WHERE A.actorid<>B.actorid AND A.movieid=B.movieid 
GROUP BY A.actorid, B.actorid HAVING count(*)>=10) AS count_movies;

#question 8

SELECT case 
WHEN year>= 1960 AND year <= 1969 THEN "1960-1969" 
WHEN year >= 1970 AND year <= 1979 THEN "1970-1979" 
WHEN year >= 1980 AND year <= 1989 THEN "1980-1989" 
WHEN year >= 1990 AND year <= 1999 THEN "1990-1999" 
WHEN year >= 2000 AND year <= 2010 THEN "2000-2010" 
ELSE NULL end AS decade_movie,
count(*) FROM imdb_movies GROUP BY decade_movie HAVING decade_movie IS not NULL;

#question 9

SELECT count(*) FROM (SELECT count(case WHEN sex = 'M' THEN 1 end) AS male_count, 
count(case WHEN sex = 'F' THEN 1 end) AS female_count, 
count(imdb_movies2actors.movieid) AS movie_count FROM imdb_actors,imdb_movies2actors WHERE 
imdb_actors.actorid=imdb_movies2actors.actorid GROUP BY movieid HAVING female_count>male_count) AS count_female_male;

#question 10

SELECT genre_rank_max FROM (SELECT genre_rank AS genre_rank_max, max(average_rank) FROM (SELECT genre AS genre_rank, avg(rank) 
AS average_rank FROM imdb_movies2directors,imdb_ratings WHERE imdb_movies2directors.movieid=imdb_ratings.movieid AND imdb_ratings.votes>=1000 
GROUP BY genre ORDER BY avg(rank) desc) AS max_avg_rank,imdb_movies2directors) AS max_genre_avg_rank;

#question 11

SELECT name FROM imdb_actors WHERE actorid = (SELECT distinct actorid FROM imdb_movies2actors JOIN imdb_movies2directors ON 
imdb_movies2actors.movieid=imdb_movies2directors.movieid GROUP BY actorid HAVING count(distinct genre)>=10);

#question 12

SELECT count(*) FROM (SELECT count(movies_actors.movieid) AS count_movies_actors, actors.name AS actors, directors.name AS directors, writers.name AS writers 
FROM imdb_movies2actors AS movies_actors, imdb_movies2directors AS movies_directors, imdb_movies2writers AS movies_writers, 
imdb_actors AS actors, imdb_writers AS writers,imdb_directors AS directors 
WHERE movies_actors.movieid = movies_directors.movieid AND movies_directors.movieid = movies_writers.movieid AND 
movies_writers.movieid = movies_actors.movieid AND movies_actors.actorid = actors.actorid AND 
movies_directors.directorid = directors.directorid AND movies_writers.writerid = writers.writerid 
GROUP BY(movies_actors.movieid) HAVING (actors like directors) AND (directors like writers)) AS count_movies;

#question 13

SELECT high_year AS highest_year FROM (SELECT floor_year AS high_year, max(avg_rank) AS max_avg_rank FROM (SELECT (floor(year/10)*10) AS floor_year,  
count(imdb_movies.movieid) AS movie_count, avg(rank) AS avg_rank FROM imdb_movies, imdb_ratings WHERE imdb_movies.movieid = imdb_ratings.movieid GROUP BY  
floor(year/10) ORDER BY avg_rank desc) AS max_table) AS max_table_year;

#question 14

SELECT count(distinct movieid) FROM imdb_movies2directors WHERE genre IS null;

#question 15

SELECT count(*) FROM (SELECT count(movies_directors.movieid) AS count_movies_actors, actors.name AS actors, directors.name AS directors, writers.name AS writers  
FROM imdb_movies2actors AS movies_actors, imdb_movies2directors AS movies_directors, imdb_movies2writers AS movies_writers, 
imdb_actors AS actors, imdb_writers AS writers, imdb_directors AS directors 
WHERE movies_actors.movieid = movies_directors.movieid AND movies_directors.movieid = movies_writers.movieid AND 
movies_writers.movieid = movies_actors.movieid AND movies_actors.actorid = actors.actorid AND 
movies_directors.directorid = directors.directorid AND movies_writers.writerid = writers.writerid 
GROUP BY(movies_actors.movieid) HAVING (actors NOT LIKE directors) AND (directors LIKE writers) AND (actors NOT LIKE writers)) AS count_movies;
