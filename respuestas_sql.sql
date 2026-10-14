--MUY FÁCIL

-- 1- Devuelve todas las películas
SELECT * FROM MOVIES

-- 2- Devuelve todos los géneros existentes
SELECT * FROM GENRES

-- 3- Devuelve la lista de todos los estudios de grabación que estén activos
SELECT * FROM STUDIOS WHERE STUDIO_ACTIVE = 1

-- 4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma
SELECT * FROM USERS 
ORDER BY USER_JOIN_DATE DESC LIMIT 20

-- 38- Devuelve una lista de los 10 usuarios con más tiempo de antigüedad en la plataforma
SELECT * FROM USERS 
ORDER BY USER_JOIN_DATE ASC LIMIT 20

-- 39- Devuelve una lista con los nombres de los actores fallecidos.
SELECT * FROM ACTORS 
WHERE ACTOR_DEAD_DATE IS NOT NULL 

-- 40- Devuelve una lista con todos los nombres de los directores que estén vivos.
SELECT * FROM DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL

-- 41- Devuelve el nombre y precio de todas las suscripciones disponibles en la plataforma
SELECT s.PLAN_NAME, s.PLAN_PRICE  
FROM SUBSCRIPTIONS s

-- 42- Devuelve la cantidad total de películas registradas en la base de datos.
SELECT COUNT(MOVIE_ID ) 
FROM MOVIES

-- 43- Devuelve las 10 películas más largas registradas en la base de datos.
SELECT * 
FROM MOVIES
ORDER BY MOVIE_DURATION DESC
LIMIT 10

-- FÁCIL

-- 5- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor
SELECT m.MOVIE_DURATION, COUNT(m.MOVIE_ID) AS "NUM_MOVIES" 
FROM MOVIES m 
GROUP BY m.MOVIE_DURATION 
ORDER BY "NUM_MOVIES" DESC 
LIMIT 20
 
-- 6- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT *
FROM MOVIES m 
WHERE m.MOVIE_RELEASE_DATE >= '2000-01-01'
	AND m.MOVIE_NAME LIKE 'A%'
	
SELECT * 
FROM MOVIES m 
WHERE m.MOVIE_RELEASE_DATE >= DATE '2000-01-01' 
	AND UPPER(m.MOVIE_NAME) LIKE 'A%'

-- 7- Devuelve los actores nacidos un mes de Junio
SELECT a.ACTOR_NAME, a.ACTOR_BIRTH_DATE 
FROM ACTORS a 
WHERE MONTH(a.ACTOR_BIRTH_DATE) = 6

-- 8- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos
SELECT * FROM ACTORS a
WHERE EXTRACT(MONTH FROM a.ACTOR_BIRTH_DATE) <> 6 AND a.ACTOR_DEAD_DATE IS NULL

-- 9- Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT d.DIRECTOR_NAME, DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE, TODAY()) AS EDAD
FROM DIRECTORS d 
WHERE DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE, TODAY()) <= 50
	AND d.DIRECTOR_DEAD_DATE IS NULL

-- 10- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT ACTOR_NAME, DATEDIFF(YEAR, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE) AS "AGE" 
FROM ACTORS 
WHERE DATEDIFF(YEAR, ACTOR_BIRTH_DATE, ACTOR_DEAD_DATE) < 50 
	AND ACTOR_DEAD_DATE IS NOT NULL

-- 11- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT d.DIRECTOR_NAME
FROM DIRECTORS d 
WHERE DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE , TODAY()) <= 40
	AND d.DIRECTOR_DEAD_DATE IS NULL

-- 12- Indica la edad media de los directores vivos
SELECT AVG(DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE  , TODAY())) AS EDAD_MEDIA
FROM DIRECTORS d 
WHERE d.DIRECTOR_DEAD_DATE IS NULL

-- 13- Indica la edad media de los actores que han fallecido
SELECT AVG(DATEDIFF(YEAR, a.ACTOR_BIRTH_DATE , a.ACTOR_DEAD_DATE)) AS Age 
FROM ACTORS a 
WHERE a.ACTOR_DEAD_DATE  IS NOT NULL;

-- 44- Devuelve la cantidad de películas accedidas por cada mes del año 2016
SELECT COUNT(uma.ACCESS_ID) AS TOTAL_ACCESS, MONTH(uma.ACCESS_DATE) AS "MONTH" 
FROM USER_MOVIE_ACCESS uma 
WHERE YEAR(uma.ACCESS_DATE) = 2016 
GROUP BY MONTH 
ORDER BY MONTH

-- MEDIA

--14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT m.MOVIE_NAME, s.STUDIO_NAME  
FROM MOVIES m 
JOIN STUDIOS s ON m.STUDIO_ID = m.STUDIO_ID 

-- 15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015
SELECT USER_NAME
FROM (
SELECT u.USER_NAME, uma.ACCESS_DATE 
FROM USERS u 
JOIN USER_MOVIE_ACCESS uma ON u.USER_ID = uma.USER_ID 
WHERE uma.ACCESS_DATE  >= '2010-01-01'
 	AND uma.ACCESS_DATE < '2015-01-01'
) 
GROUP BY USER_NAME

-- MEJOR
SELECT DISTINCT(s.USER_NAME) 
FROM USER_MOVIE_ACCESS uma 
INNER JOIN USERS s ON s.USER_ID = uma.USER_ID
WHERE ACCESS_DATE >= DATE '2010-01-01'
	AND ACCESS_DATE <= DATE '2015-01-01'

-- 16- Devuelve cuantas películas hay de cada país
SELECT n.NATIONALITY_NAME , COUNT(*) AS "Cantidad Peliculas"
FROM MOVIES m 
JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID 
GROUP BY n.NATIONALITY_NAME 

-- 17- Devuelve todas las películas que hay de género documental
SELECT m.MOVIE_NAME 
FROM MOVIES m 
JOIN GENRES g  ON m.GENRE_ID  = g.GENRE_ID 
WHERE g.GENRE_NAME = 'Documentary'

-- 18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT m.MOVIE_NAME, d.DIRECTOR_NAME
FROM MOVIES m
JOIN DIRECTORS d
ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE d.DIRECTOR_BIRTH_DATE >= '1980-01-01'
AND d.DIRECTOR_DEAD_DATE IS NULL

-- 19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores
SELECT USER_TOWN, USER_NAME, DIRECTOR_NAME
FROM USERS u
JOIN DIRECTORS d ON u.USER_TOWN = d.DIRECTOR_BIRTH_PLACE 

-- 20- Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT m.MOVIE_NAME, YEAR(m.MOVIE_RELEASE_DATE) AS AÑO 
FROM MOVIES m
INNER JOIN STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID
WHERE s.STUDIO_ACTIVE = 0 
ORDER BY YEAR(m.MOVIE_RELEASE_DATE) DESC

-- 21- Devuelve una lista de las últimas 10 películas a las que se ha accedido
SELECT m.MOVIE_NAME, uma.ACCESS_DATE
FROM MOVIES m
JOIN USER_MOVIE_ACCESS uma ON m.MOVIE_ID = uma.MOVIE_ID
ORDER BY uma.ACCESS_DATE DESC
LIMIT 10

-- 22- Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT d.DIRECTOR_NAME, COUNT(m.MOVIE_ID) AS "movie amount" FROM DIRECTORS d
INNER JOIN MOVIES m ON
d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE DATEDIFF(YEAR, d.DIRECTOR_BIRTH_DATE, m.MOVIE_RELEASE_DATE )<41
GROUP BY d.DIRECTOR_NAME

-- 23- Indica cuál es la media de duración de las películas de cada director
SELECT d.DIRECTOR_NAME, AVG(m.MOVIE_DURATION ) AS DURACION_MEDIA_PELICULA
FROM MOVIES m 
JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID 
GROUP BY d.DIRECTOR_NAME

-- 24- Indica cuál es la el nombre y la duración mínima de las películas a las que se ha accedido en los últimos 2 años por los miembros del plataforma (La “fecha de ejecución” de esta consulta es el 25-01-2019)
SELECT m.MOVIE_NAME, m.MOVIE_DURATION 
FROM MOVIES m 
INNER JOIN USER_MOVIE_ACCESS u ON m.MOVIE_ID = u.MOVIE_ID 
WHERE DATEADD(YEAR, -2, DATE '2019-01-25') <= u.ACCESS_DATE 
ORDER BY MOVIE_DURATION 
LIMIT 1

-- 25- Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título
SELECT d.DIRECTOR_NAME, COUNT(*) AS "NUMERO_PELICULAS"
FROM MOVIES m 
JOIN DIRECTORS d ON m.DIRECTOR_ID  = D.DIRECTOR_ID 
WHERE m.MOVIE_RELEASE_DATE >= '1960-01-01'
	AND m.MOVIE_RELEASE_DATE < '1990-01-01'
	AND UPPER(m.MOVIE_NAME) LIKE '%THE%'
GROUP BY d.DIRECTOR_NAME

-- 45- Devuelve los nombres de los usuarios que han accedido a más de 5 películas
SELECT u.USER_NAME, COUNT(USER_ID) AS "Number of movie accesses" FROM USERS u
INNER JOIN USER_MOVIE_ACCESS uma ON
u.USER_ID =uma.USER_ID
GROUP BY u.USER_NAME
HAVING COUNT(USER_ID)>5

-- 46- Devuelve la cantidad de películas en las que ha participado cada actor.
SELECT a.ACTOR_NAME, COUNT(ma.MOVIE_ID) AS "movie amount" 
FROM ACTORS a 
INNER JOIN MOVIES_ACTORS ma ON a.ACTOR_ID = ma.ACTOR_ID 
GROUP BY a.ACTOR_NAME

-- 47- Devuelve el número de películas accedidas por tipo de suscripción
SELECT s.plan_name, count(uma.movie_id) AS "movie amount" 
FROM USER_MOVIE_ACCESS uma
INNER JOIN USERS u ON
u.user_id=uma.USER_ID
INNER JOIN subscriptions s ON
uma.ACCESS_TYPE = s.SUBSCRIPTION_ID
GROUP BY s.plan_name

			--CON PELICULAS REPETIDAS

			SELECT s.PLAN_NAME, COUNT(m.MOVIE_ID) 

			FROM MOVIES m 

			JOIN USER_MOVIE_ACCESS uma ON m.MOVIE_ID = uma.MOVIE_ID 

			JOIN SUBSCRIPTIONS s ON s.SUBSCRIPTION_ID = uma.ACCESS_TYPE 

			GROUP BY s.PLAN_NAME 

			--SIN PELICULAS REPETIDAS

			SELECT s.PLAN_NAME, COUNT(DISTINCT m.MOVIE_ID) 

			FROM MOVIES m 

			JOIN USER_MOVIE_ACCESS uma ON m.MOVIE_ID = uma.MOVIE_ID 

			JOIN SUBSCRIPTIONS s ON s.SUBSCRIPTION_ID = uma.ACCESS_TYPE 

			GROUP BY s.PLAN_NAME 			
 

-- 48- Devuelve el número de películas accedidas por cada usuario		
SELECT U.USER_NAME, COUNT(UMA.MOVIE_ID) AS TOTAL_ACCESS 
FROM USERS U 
JOIN USER_MOVIE_ACCESS UMA ON U.USER_ID = UMA.USER_ID 
GROUP BY U.USER_NAME
 
			
-- 49- Devuelve los nombres de los usuarios que solo han accedido a una película
SELECT u.USER_NAME, count(uma.movie_id) AS "Number of movie accesses" FROM USERS u
INNER JOIN USER_MOVIE_ACCESS uma   ON
u.user_id=uma.USER_ID
GROUP BY u.user_name
HAVING count(uma.movie_id)=1

-- DIFÍCIL

-- 26- Lista nombre, nacionalidad y director de todas las películas
SELECT m.MOVIE_NAME, d.DIRECTOR_NAME , n.NATIONALITY_NAME 
FROM MOVIES m 
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID 
INNER JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID 

-- 27- Muestra las películas con los actores que han participado en cada una de ellas
SELECT m.MOVIE_NAME AS MOVIE, GROUP_CONCAT(a.ACTOR_NAME SEPARATOR ', ') AS ACTORS
		FROM MOVIES m
		JOIN MOVIES_ACTORS ma ON m.MOVIE_ID = ma.MOVIE_ID
		JOIN ACTORS a ON ma.ACTOR_ID = a.ACTOR_ID
		GROUP BY m.MOVIE_NAME ORDER BY m.MOVIE_NAME

-- 28- Indica cual es el nombre del director del que más películas se ha accedido
SELECT d.DIRECTOR_NAME, COUNT(uma.ACCESS_ID ) AS ACCESOS
FROM USER_MOVIE_ACCESS uma 
INNER JOIN MOVIES m ON uma.MOVIE_ID = m.MOVIE_ID 
INNER JOIN	DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID 
GROUP BY d.DIRECTOR_ID  
ORDER BY ACCESOS DESC
LIMIT 1

-- 29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT s.STUDIO_NAME, SUM (a.AWARD_WIN ) AS "AWARDS_WIN" 
FROM MOVIES m 
INNER JOIN AWARDS a ON m.MOVIE_ID = a.MOVIE_ID 
INNER JOIN STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID 
GROUP BY s.STUDIO_ID; 

-- 30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)
SELECT ac.ACTOR_NAME, SUM(a.AWARD_ALMOST_WIN) AS "AWARDS_ALMOST_WIN" 
FROM MOVIES m 
INNER JOIN AWARDS a ON m.MOVIE_ID = a.MOVIE_ID 
INNER JOIN MOVIES_ACTORS ma ON m.MOVIE_ID = ma.MOVIE_ID 
INNER JOIN ACTORS ac ON ac.ACTOR_ID = ma.ACTOR_ID 
GROUP BY ac.ACTOR_ID
--más optima que la anterior pq usa una tabla menos
SELECT a.ACTOR_NAME, SUM(aw.AWARD_ALMOST_WIN) AS "CASI, PERO NO" FROM MOVIES_ACTORS m
INNER JOIN AWARDS aw ON m.MOVIE_ID = aw.MOVIE_ID
INNER JOIN ACTORS a ON m.ACTOR_ID = a.ACTOR_ID
GROUP BY a.ACTOR_NAME
ORDER BY "CASI, PERO NO" DESC

-- 31- Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT COUNT(DISTINCT ma.ACTOR_ID) AS NUM_ACTORES,
COUNT(DISTINCT m.DIRECTOR_ID) AS NUM_DIRECTORES
FROM STUDIOS s
INNER JOIN MOVIES m ON s.STUDIO_ID = m.STUDIO_ID
INNER JOIN MOVIES_ACTORS ma ON m.MOVIE_ID = ma.MOVIE_ID
WHERE s.STUDIO_ACTIVE  = FALSE

-- 32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
SELECT DISTINCT u.USER_NAME, u.USER_TOWN, u.USER_PHONE 
FROM USERS u 
INNER JOIN USER_MOVIE_ACCESS uma ON u.USER_ID = uma.USER_ID 
WHERE uma.MOVIE_ID IN (
	SELECT a.MOVIE_ID 
	FROM AWARDS a 
	WHERE a.AWARD_NOMINATION > 150 AND a.AWARD_WIN < 50
);

-- 33- Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película en el 88)
SELECT d.DIRECTOR_NAME, d.DIRECTOR_DEAD_DATE, MAX(m.MOVIE_RELEASE_DATE) AS MOVIE_RELEASE_DATE
FROM MOVIES m
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID 
WHERE m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE 
GROUP BY d.DIRECTOR_ID 

SELECT d.DIRECTOR_NAME, d.DIRECTOR_DEAD_DATE, MAX(m.MOVIE_RELEASE_DATE) AS MOVIE_RELEASE_DATE 
FROM MOVIES m 
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID 
WHERE m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE 
GROUP BY d.DIRECTOR_ID;

-- 34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)
UPDATE DIRECTORS d 
SET DIRECTOR_DEAD_DATE = (
SELECT MAX(DATEADD(YEAR, 1, m.MOVIE_RELEASE_DATE)) 
FROM MOVIES m 
WHERE m.DIRECTOR_ID = d.DIRECTOR_ID 
AND m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE) 
WHERE EXISTS (SELECT 1 FROM MOVIES m WHERE m.DIRECTOR_ID = d.DIRECTOR_ID AND m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE);

-- BERSERK

-- 35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
WITH GENRE_COUNTS AS 
(
SELECT d.DIRECTOR_ID, d.DIRECTOR_NAME, g.GENRE_ID, g.GENRE_NAME, COUNT(MOVIE_ID) AS NUM_MOVIES
FROM MOVIES m 
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID 
INNER JOIN GENRES g ON m.GENRE_ID = g.GENRE_ID
GROUP BY d.DIRECTOR_ID, g.GENRE_ID
),
 
MAX_GENRES AS (
SELECT DIRECTOR_ID, MAX(NUM_MOVIES) AS MAX_MOVIES FROM GENRE_COUNTS
GROUP BY DIRECTOR_ID 
)
 
SELECT gc.DIRECTOR_NAME, GROUP_CONCAT(GENRE_NAME SEPARATOR ', ') AS FAVORITE_GENRE FROM GENRE_COUNTS gc 
INNER JOIN MAX_GENRES mg ON gc.DIRECTOR_ID = mg.DIRECTOR_ID AND gc.NUM_MOVIES = mg.MAX_MOVIES
GROUP BY gc.DIRECTOR_NAME;

-- 36- Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas
WITH NATIONALITY_COUNTS AS 
(
	SELECT s.STUDIO_ID, s.STUDIO_NAME, n.NATIONALITY_ID , n.NATIONALITY_NAME, COUNT(n.NATIONALITY_ID ) AS NUM_NACIONALITIES
	FROM MOVIES m 
	INNER JOIN STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID 
	INNER JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID 
	GROUP BY s.STUDIO_ID, n.NATIONALITY_ID 
),
MAX_NACIONALITIES AS (
	SELECT STUDIO_ID, MAX(NUM_NACIONALITIES) AS MAX_NACIONALITIES 
	FROM NATIONALITY_COUNTS
	GROUP BY STUDIO_ID
)
 
SELECT STUDIO_NAME, GROUP_CONCAT(NATIONALITY_NAME SEPARATOR ', ') AS FAVORITE_NACIONALITY
FROM NATIONALITY_COUNTS nc
INNER JOIN MAX_NACIONALITIES mn  ON nc.STUDIO_ID = mn.STUDIO_ID AND nc.NUM_NACIONALITIES = mn.MAX_NACIONALITIES
GROUP BY nc.STUDIO_NAME;
 
-- 37- Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad
WITH PHONE_DIGIT AS
  (SELECT USER_NAME,
          USER_ID,
          SUBSTR(USER_PHONE, LENGTH(USER_PHONE), 1) AS LAST_NUMBER
   FROM USERS),
     USER_NAT AS
  (SELECT N.NATIONALITY_ID,
          M.USER_NAME,
          M.USER_ID
   FROM NATIONALITIES N
   INNER JOIN PHONE_DIGIT M ON N.NATIONALITY_ID = M.LAST_NUMBER),
     MOVIE_ACCESS AS
  (SELECT UN.NATIONALITY_ID,
          UN.USER_NAME,
          UMA.USER_ID,
          UMA.MOVIE_ID,
          UMA.ACCESS_DATE
   FROM USER_NAT UN
   INNER JOIN USER_MOVIE_ACCESS UMA ON UN.USER_ID = UMA.USER_ID),
     MIN_ACCESS AS
  (SELECT USER_ID,
          MIN(ACCESS_DATE) AS ACCESS_DATE
   FROM MOVIE_ACCESS
   GROUP BY USER_ID)
SELECT MOA.USER_NAME,
       M.MOVIE_NAME
FROM MOVIE_ACCESS MOA
INNER JOIN MIN_ACCESS MIA ON MOA.ACCESS_DATE = MIA.ACCESS_DATE
AND MOA.USER_ID = MIA.USER_ID
INNER JOIN MOVIES M ON MOA.MOVIE_ID = M.MOVIE_ID


-- 55- Indica cuáles son los estudios que han producido más películas en cada década y cuantas han realizado.
WITH MOVIE_DECADE AS
  (SELECT S.STUDIO_NAME,
          (YEAR(M.MOVIE_RELEASE_DATE) / 10) * 10 AS DECADE,
          COUNT(*) AS TOTAL_MOVIES
   FROM MOVIES M
   JOIN STUDIOS S ON M.STUDIO_ID = S.STUDIO_ID
   GROUP BY S.STUDIO_NAME,
            DECADE),
     MAX_DECADE AS
  (SELECT DECADE,
          MAX(TOTAL_MOVIES) AS MAX_MOVIES
   FROM MOVIE_DECADE
   GROUP BY DECADE)
SELECT MD.STUDIO_NAME,
       MD.DECADE,
       MD.TOTAL_MOVIES
FROM MOVIE_DECADE MD
JOIN MAX_DECADE MMD ON MD.DECADE = MMD.DECADE
AND MD.TOTAL_MOVIES = MMD.MAX_MOVIES
ORDER BY MD.DECADE;
