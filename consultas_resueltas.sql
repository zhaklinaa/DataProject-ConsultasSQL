-- 1. Crea el esquema de la BBDD. ESQUEMA CREADO 


--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.

SELECT  f.title AS Nombre
FROM  film f 
WHERE  f.rating = 'R';


--3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.

SELECT a.first_name AS Nombre, a.actor_id 
FROM actor a 
WHERE a.actor_id BETWEEN 30 AND 40;

--4. Obtén las películas cuyo idioma coincide con el idioma original.

SELECT f.title AS titulo
FROM film f
WHERE f.language_id = f.original_language_id;

--5. Ordena las películas por duración de forma ascendente.

SELECT f.title, f.length 
FROM film f 
ORDER BY f.length;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.

SELECT a.first_name, a.last_name 
FROM actor a 
WHERE a.last_name ILIKE 'Allen';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.

SELECT f.rating clasificacion, count (f.rating ) AS recuento 
FROM film f 
GROUP BY f.rating;

--8. Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una duración mayor a 3 horas en la tabla film.

SELECT f.title AS titulo
FROM film f 
WHERE f.rating = 'PG-13' OR f.length > 180;

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT 
    VARIANCE(replacement_cost) AS varianza,
    STDDEV(replacement_cost) AS desviacion_estandar,
    MAX(replacement_cost) - MIN(replacement_cost) AS rango_variabilidad
FROM film;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

(SELECT title, length AS duracion
 FROM film 
 ORDER BY length ASC
 LIMIT 1)
UNION
(SELECT title, length AS duracion
 FROM film 
 ORDER BY length DESC
 LIMIT 1);

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.



--12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC 17ʼ ni ‘Gʼ en cuanto a su clasificación.

SELECT f.title, f.rating 
FROM film f 
WHERE f.rating NOT IN ('NC-17', 'G');


--13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT f.rating AS clasificacion, round(AVG(f.length),2) promedio_duracion
FROM film f 
GROUP BY f.rating;

--14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT f.title
FROM film f 
WHERE f.length > 180;

--15. ¿Cuánto dinero ha generado en total la empresa? 

SELECT sum(p.amount ) AS dinero_total 
FROM payment p;

--16. Muestra los 10 clientes con mayor valor de id.

SELECT c.first_name, c.last_name, c.customer_id 
FROM customer c
ORDER BY c.customer_id DESC
LIMIT 10;


--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.

WITH pelicula AS (
	SELECT f.film_id AS film_id
	FROM film f
	WHERE UPPER(f.title) = 'EGG IGBY' 
),

actores AS (
	SELECT fa.actor_id AS actor_id 
	FROM film_actor fa
	WHERE fa.film_id IN (SELECT film_id FROM pelicula)
)

SELECT a.first_name AS nombre, a.last_name AS apellido 
FROM actor a
WHERE a.actor_id IN (SELECT actor_id FROM actores)


--18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT title 
FROM film;

--19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.


SELECT f.title AS título, f.length AS duración, c.name AS categoría
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;


--20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name AS categoría, avg(f.length ) AS promedio_duración
FROM category c
INNER JOIN film_category fc ON fc.category_id = c.category_id 
INNER JOIN film f ON fc.film_id = f.film_id 
GROUP BY c.name
HAVING  avg(f.length ) > 110;


--21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(rental_duration) AS promedio_dias_alquiler
FROM film;


--22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT concat(a.first_name,' ',a.last_name ) AS nombre_apellido
FROM actor a ;


--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT DATE(r.rental_date) AS dia, COUNT(r.rental_id) AS cantidad_alquileres
FROM rental r
GROUP BY DATE(r.rental_date)
ORDER BY cantidad_alquileres DESC;


--24. Encuentra las películas con una duración superior al promedio.

SELECT f.title AS Titulo, f.length duracion
FROM film f 
WHERE f.length > (SELECT AVG(fa.length ) FROM film fa);


--25. Averigua el número de alquileres registrados por mes.

SELECT COUNT(r.rental_id ) AS num_alquileres , EXTRACT (MONTH FROM r.rental_date ) AS mes 
FROM rental r
GROUP BY mes
ORDER BY mes;


--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT ROUND(AVG(p.amount),2) promedio, ROUND(STDDEV(p.amount),2) AS desviacion_estandar, ROUND(VARIANCE(p.amount),2) varianza
FROM payment p;


--27. ¿Qué películas se alquilan por encima del precio medio?

WITH precio_medio AS (
    SELECT AVG(f.rental_rate ) AS precio_medio
    FROM film f
),

peliculas_alquiladas AS (
    SELECT film_id FROM inventory
)

SELECT title, rental_rate
FROM film
WHERE film_id IN (SELECT film_id FROM peliculas_alquiladas) 
  AND rental_rate > (SELECT precio_medio FROM precio_medio);



--28. Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT fa.actor_id, COUNT(fa.film_id) AS total_peliculas
FROM film_actor fa
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) > 40
ORDER BY total_peliculas DESC;


--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT f.title AS pelicula, COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY cantidad_disponible DESC;

--30. Obtener los actores y el número de películas en las que ha actuado.

SELECT a.first_name AS nombre, a.last_name AS apellido, COUNT(fa.film_id) AS numero_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY numero_peliculas DESC;

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT f.title AS pelicula, a.first_name AS nombre_actor, a.last_name AS apellido_actor
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title;

--32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

SELECT a.first_name AS nombre, a.last_name AS apellido, f.title AS pelicula
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
ORDER BY apellido, nombre;

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f.film_id, f.title AS pelicula, r.rental_id, r.rental_date
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.title, r.rental_date DESC;


--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT c.first_name AS nombre, c.last_name apellido, sum(p.amount) total_gastado
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id 
GROUP BY c.first_name, c.last_name 
ORDER BY total_gastado DESC 
LIMIT 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT a.first_name AS Nombre, a.last_name AS Apellido
FROM actor a
WHERE a.first_name ILIKE 'Johnny';

--36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.

SELECT first_name AS Nombre, last_name AS Apellido
FROM actor;

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT MIN(actor_id) AS id, 'más bajo' AS tipo FROM actor
UNION ALL
SELECT MAX(actor_id) AS id, 'más alto' AS tipo FROM actor;

--38. Cuenta cuántos actores hay en la tabla “actorˮ.

SELECT count(a.actor_id) AS num_actores
FROM actor a;

--39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
ORDER BY a.last_name DESC;


-40. Selecciona las primeras 5 películas de la tabla “filmˮ.

SELECT title
FROM film 
LIMIT 5;


--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

SELECT first_name AS nombre, COUNT(*) AS cantidad_repetidos
FROM actor
GROUP BY first_name
ORDER BY cantidad_repetidos DESC
LIMIT 1;


--42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT r.rental_date, c.first_name AS nombre_cliente, c.last_name AS apellido_cliente
FROM rental r
INNER JOIN customer c ON r.customer_id = c.customer_id;


--43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT c.first_name AS nombre, c.last_name AS apellido, r.rental_id, r.rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY c.last_name, c.first_name;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

SELECT f.film_id, f.title AS pelicula, c.category_id, c.name AS categoria
FROM film f
CROSS JOIN category c
ORDER BY f.title, c.name;

--No, no aporta valor. Al emparejar cada película con todas las categorías existentes por igual, la consulta genera combinaciones falsas. 
--Además, infla el resultado multiplicando el número de filas de forma masiva e innecesaria, 
--perdiendo por completo la relación real que existe en la base de datos a través de la tabla film_category.



--45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT DISTINCT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film_category fc ON fa.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';


--46. Encuentra todos los actores que no han participado en películas.

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT DISTINCT fa.actor_id 
    FROM film_actor fa
)
ORDER BY a.last_name, a.first_name;


--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT a.first_name AS nombre, a.last_name AS apellido, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC;



--48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas AS
SELECT a.actor_id, a.first_name AS nombre, a.last_name AS apellido, COUNT(fa.film_id) AS total_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

SELECT * FROM actor_num_peliculas
ORDER BY total_peliculas DESC;



--49. Calcula el número total de alquileres realizados por cada cliente.


SELECT c.first_name AS nombre, c.last_name AS apellido, COUNT(*) AS total_alquileres
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;


--50. Calcula la duración total de las películas en la categoría 'Action'.

SELECT c.name AS categoria, SUM(f.length) AS duracion_total_minutos
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
GROUP BY c.category_id, c.name;


--51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.

CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS total_alquileres
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;


SELECT * FROM cliente_rentas_temporal
WHERE total_alquileres > 30
ORDER BY total_alquileres DESC;

--52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title AS pelicula, COUNT(r.rental_id) AS total_alquileres
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

SELECT * FROM peliculas_alquiladas
ORDER BY total_alquileres DESC;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

SELECT f.title AS pelicula
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY' 
  AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title ASC;


--54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film_category fc ON fa.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name ASC, a.first_name ASC;


--55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN inventory i ON fa.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    -- Subconsulta: Encuentra la primera fecha de alquiler de 'Spartacus Cheaper'
    SELECT MIN(r2.rental_date)
    FROM rental r2
    INNER JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    INNER JOIN film f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name ASC, a.first_name ASC;



--56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.

SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT DISTINCT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc ON fa.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
);

--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT f.title AS pelicula
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE EXTRACT (DAY FROM(r.return_date - r.rental_date)) > 8
ORDER BY f.title;

--58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.

SELECT title AS título
FROM film f 
INNER JOIN film_category fc ON f.film_id = fc.film_id 
INNER JOIN category c ON fc.category_id = c.category_id 
WHERE c."name"  = 'Animation';

--59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.

WITH duracion_pelicula AS (
    SELECT f.length AS duracion
    FROM film f
    WHERE UPPER(f.title) = 'DANCING FEVER'
) 

SELECT f.title 
FROM film f 
WHERE f.length IN (SELECT duracion FROM duracion_pelicula )
ORDER BY f.title  ASC;

--60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

SELECT c.customer_id, c.first_name AS nombre, c.last_name AS apellido, COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name ASC;


--61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN inventory i ON fc.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.category_id, c.name
ORDER BY total_alquileres DESC;


--62. Encuentra el número de películas por categoría estrenadas en 2006.

SELECT c."name" categoría, count(film.film_id) AS total_películas 
FROM film 
INNER JOIN film_category ON film.film_id  = film_category.film_id 
INNER JOIN category c ON film_category.category_id = c.category_id  
WHERE film.release_year = 2006
GROUP BY c."name" ;

--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT s.staff_id, s.first_name AS nombre_trabajador, s.last_name AS apellido_trabajador, st.store_id AS tienda_id
FROM staff s
CROSS JOIN store st
ORDER BY s.staff_id, st.store_id;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS total_peliculas_alquiladas
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_peliculas_alquiladas DESC;
