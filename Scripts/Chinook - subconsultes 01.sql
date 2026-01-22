-- 1

SELECT COUNT(t.TrackId)AS canciones
FROM Track t 
WHERE t.UnitPrice = (SELECT MAX(t2.UnitPrice)
FROM Track t2)

-- 2

SELECT t.Name 
FROM Track t 
WHERE t.UnitPrice = (SELECT MAX(t2.UnitPrice)
FROM Track t2)
order by Name desc
limit 5

-- 3

SELECT t.Name, (Milliseconds / 60000.0) AS Minutes
FROM Track t
WHERE Milliseconds > (
    SELECT AVG(Milliseconds) * 3
    FROM Track t2)
ORDER BY Name ASC, Milliseconds ASC;

-- Para resolver este ejercicio, 
-- necesitamos comparar la duración de cada canción con el promedio global multiplicado por tres.
-- Como la duración en la tabla Track suele estar en milisegundos,
-- para mostrar los minutos debemos realizar una pequeña operación aritmética ($ms / 1000 / 60$).
-- Detalles clave de la consulta:
-- Conversión a minutos: Dividimos Milliseconds entre $60,000$ (que es $1000 \times 60$).
-- Usamos 60000.0 (con decimal) para asegurarnos de que el resultado no sea un número entero redondeado,
-- sino que incluya decimales si el motor de SQL es estricto con los tipos de datos.
-- Subconsulta de promedio: La parte (SELECT AVG(Milliseconds) * 3 FROM Track) calcula primero la media de toda la tabla y la triplica,
-- sirviendo como valor de corte para el WHERE.Ordenación doble: Tal como pide el enunciado,
-- primero ordenamos por Name y añadimos Milliseconds (o Minutes) como segundo criterio para desempatar nombres idénticos.

-- 4

SELECT Name, SEC_TO_TIME(Milliseconds / 1000)AS Minutes
FROM Track
WHERE Milliseconds > (SELECT Milliseconds
    				  FROM Track
    				  WHERE Name = 'Take the Celestra')
ORDER BY Name;

-- Explicació dels punts clau:
-- SEC_TO_TIME(Milliseconds / 1000): 
-- Aquesta funció de MySQL espera un valor en segons. 
-- Com que la columna original està en mil·lisegons, la dividim per 1000 per obtenir el format HH:MM:SS que demana l'enunciat.
-- Subconsulta: (SELECT Milliseconds FROM Track WHERE Name = 'Take the Celestra') obté el valor exacte de temps que ens servirà de filtre.
-- Filtre WHERE: Comparem la durada de cada cançó (Milliseconds) per veure si és major que el resultat de la subconsulta.
-- ORDER BY Name: Ordena els resultats alfabèticament pel nom de la cançó, tal com es demana.


-- 5

(SELECT a2.Name, COUNT(a.ArtistId)
FROM Album a JOIN Artist a2  ON a.ArtistId = a2.ArtistId)


SELECT Name
FROM Artist
WHERE ArtistId IN (
    SELECT ArtistId
    FROM Album
    GROUP BY ArtistId
    HAVING COUNT(*) IN (SELECT * FROM (SELECT DISTINCT COUNT(*)
            						   FROM Album
           							   GROUP BY ArtistId
            						   ORDER BY COUNT(*) DESC
           							   LIMIT 4) AS top_counts))
ORDER BY Name ASC;

-- 6

SELECT i.InvoiceId, i.Total
FROM Invoice i
JOIN (SELECT InvoiceId, SUM(UnitPrice * Quantity) AS total
      FROM InvoiceLine
      GROUP BY InvoiceId)as total2 ON i.InvoiceId = total2.InvoiceId
WHERE i.Total <> total2.total
ORDER BY i.InvoiceId

-- 7

SELECT a.Title, COUNT(t.TrackId) AS Cantitat_Cancons
FROM Album a
JOIN Track t ON a.AlbumId = t.AlbumId
GROUP BY a.AlbumId, a.Title
HAVING COUNT(t.TrackId) = (SELECT COUNT(t2.TrackId)
    					   FROM Track t2
    					   JOIN Album a2 ON t2.AlbumId = a2.AlbumId
   						   WHERE a2.Title = 'Live After Death')
ORDER BY a.Title;

-- 8

SELECT a.Title, COUNT(t.TrackId) AS Cantitat_Cancons
FROM Album a
JOIN Track t ON a.AlbumId = t.AlbumId
GROUP BY a.AlbumId, a.Title
HAVING COUNT(t.TrackId) = (
    SELECT COUNT(t2.TrackId)
    FROM Track t2
    GROUP BY t2.AlbumId
    ORDER BY COUNT(t2.TrackId) ASC
    LIMIT 1
)
ORDER BY a.Title

-- 9 

SELECT c.CustomerId, c.FirstName, c.LastName, SUM(il.Quantity) AS TotalCancons
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY c.CustomerId, c.FirstName, c.LastName
HAVING SUM(il.Quantity) = (
    SELECT SUM(il2.Quantity)
    FROM Customer c2
    JOIN Invoice i2 ON c2.CustomerId = i2.CustomerId
    JOIN InvoiceLine il2 ON i2.InvoiceId = il2.InvoiceId
    WHERE c2.FirstName = 'Camille' AND c2.LastName = 'Bernard'
)
ORDER BY c.CustomerId;

-- 10

SELECT a.Title, SUM(t.Milliseconds) / 60000.0 AS Minutes
FROM Album a
JOIN Track t ON a.AlbumId = t.AlbumId
GROUP BY a.AlbumId, a.Title
HAVING SUM(t.Milliseconds) < (SELECT SUM(t2.Milliseconds)
    						  FROM Track t2
   							  JOIN Album a2 ON t2.AlbumId = a2.AlbumId
    						  WHERE a2.Title = 'Bach: Goldberg Variations')
ORDER BY a.Title;