----------------
-- #Query 1.1#
--

SELECT 
    c.id_club AS "ID Club",
    c.nombre AS "Nombre Club",
    p.id_partido,
    p.goles_local AS "Goles Locales",
    p.goles_visitante AS "Goles Visitantes",
    p.fecha AS "Fecha del Partido",
    comp.nombre AS "Competición",
    pct.genero AS "Categoría",
    c_rival.nombre AS "Nombre Club Rival"
FROM 
    Club c
JOIN 
    Partido p ON c.id_club = p.id_local
JOIN
    Partido_Competicion_Temporada pct ON p.id_partido = pct.id_partido
JOIN
    Competicion comp ON pct.id_competicion = comp.id_competicion
JOIN
    Club c_rival ON p.id_visitante = c_rival.id_club
WHERE 
    c.ciudad LIKE 'Girona%'
    AND p.goles_local > p.goles_visitante
ORDER BY 
    p.fecha ASC;


-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen clubes en Girona.
SELECT * FROM Club WHERE ciudad LIKE 'Girona%';
-- Expected output: Muestra los clubes con ciudad Girona

-- Validar que estos clubes han ganado partidos como locales.
SELECT count(*) FROM Partido WHERE goles_local > goles_visitante AND id_local IN (SELECT id_club FROM Club WHERE ciudad LIKE 'Girona%');
-- Expected output: Muestra el numero de partidos en los que ha ganado el equipo local de la ciudad Girona

----------------
-- #Query 1.2#
--

SELECT 
    p.id_persona AS "ID Jugador",
    p.nombre AS "Nombre del Jugador",
    c1.id_club AS "ID Club",
    c1.nombre AS "Nombre del Club",
    jc1.fecha_acaba AS "Fecha Fin Club"
FROM 
    Jugador_Club jc1
JOIN 
    Club c1 ON jc1.id_club = c1.id_club
JOIN 
    Persona p ON jc1.id_persona = p.id_persona
WHERE 
    c1.ciudad LIKE 'Barcelona%'
    AND EXTRACT(YEAR FROM jc1.fecha_acaba) = 2022
ORDER BY 
    jc1.fecha_acaba ASC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen clubes en Barcelona.
SELECT * FROM Club WHERE ciudad LIKE 'Barcelona%';
-- Expected output: Lista de clubes en Barcelona.

-- Validar que existen contratos de jugadores que finalizaron en 2022 en estos clubes.
SELECT count(*) FROM Jugador_Club WHERE EXTRACT(YEAR FROM fecha_acaba) = 2022 AND id_club IN (SELECT id_club FROM Club WHERE ciudad LIKE 'Barcelona%');
-- Expected output: Número de contratos de jugadores que finalizaron en 2022 en clubes de Barcelona.

----------------
-- #Query 1.3#
--

SELECT 
    ec.id_persona AS "Identificador persona",
    p.nombre AS "Nombre Entrenador",
    c.id_club AS "Identificador club",
    c.nombre AS "Nombre Club",
    (ec.fecha_acaba - ec.fecha_empieza) AS "Duración Entrenador"
FROM 
    Entrenador_Club ec
JOIN 
    Persona p ON ec.id_persona = p.id_persona
JOIN 
    Club c ON ec.id_club = c.id_club
WHERE 
    (ec.fecha_acaba - ec.fecha_empieza) > (
        SELECT AVG(ec2.fecha_acaba - ec2.fecha_empieza)
        FROM Entrenador_Club ec2
        WHERE ec2.fecha_acaba IS NOT NULL AND ec2.fecha_empieza IS NOT NULL
    )
ORDER BY 
    (ec.fecha_acaba - ec.fecha_empieza) DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar el promedio de tiempo que los entrenadores han estado en un club:
SELECT AVG(ec2.fecha_acaba - ec2.fecha_empieza)FROM Entrenador_Club ec2 WHERE ec2.fecha_acaba IS NOT NULL AND ec2.fecha_empieza IS NOT NULL;

----------------
-- #Query 1.4#
--

SELECT DISTINCT
    pe.id_persona AS "Identificador persona",
    pe.nombre AS "Nombre Arbitro VAR",
    arb.certificacion AS "Certificación Arbitro VAR"
FROM 
    Partido p
JOIN 
    Arbitro_Partido ap ON p.id_partido = ap.id_partido
JOIN 
    Arbitro arb ON ap.id_persona = arb.id_persona
JOIN 
    Persona pe ON arb.id_persona = pe.id_persona
WHERE 
    ap.rol = 'VAR'
    AND (arb.certificacion LIKE '%FIFA%' OR arb.certificacion LIKE '%UEFA%')
    AND p.posesion_local = p.posesion_visitante
ORDER BY pe.nombre;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Hemos decidido no hacer validates debido a la sencillez del código y lo díficil que seria que haya un error en el mismo

----------------
-- #Query 1.5#
--

SELECT 
    c.nombre AS "Nombre Competición",
    c.genero AS "Genenro Competición",
    COUNT(pct.id_partido) AS "Número de Partidos"
FROM 
    Competicion c
JOIN 
    Partido_Competicion_Temporada pct ON c.id_competicion = pct.id_competicion
GROUP BY 
    c.nombre, c.genero
HAVING 
    COUNT(pct.id_partido) >= 500
ORDER BY 
    "Número de Partidos" DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Hemos decidido no hacer validates debido a la sencillez del código y lo díficil que seria que haya un error en el mismo

----------------
-- #Query 1.6#
--

SELECT 
    cl.nombre AS nombre_club,
    COUNT(*) AS n_veces_media_tabla
FROM 
    Competicion_Club_Temporada cct 
JOIN
    Competicion c ON cct.id_competicion = c.id_competicion
JOIN 
    Club cl ON cct.id_club = cl.id_club
WHERE
    cct.posicion <= (cct.n_equipos / 2)
    AND c.nombre NOT LIKE '%Segunda División%'
    AND cl.id_club IN (
        SELECT DISTINCT cct_2.id_club
        FROM Competicion_Club_Temporada cct_2 
        JOIN Competicion c2 ON cct_2.id_competicion = c2.id_competicion
        WHERE c2.nombre LIKE '%Segunda División%'
    ) 
    AND cl.id_club IN (
        SELECT id_club
        FROM Competicion_Club_Temporada cct_1
        GROUP BY id_club
        HAVING COUNT(DISTINCT id_competicion) > 1
    )
GROUP BY 
    cl.nombre
ORDER BY
    n_veces_media_tabla DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen clubes que han participado en la "Segunda División" y en más de una competición distinta
SELECT DISTINCT cct.id_club, cl.nombre
FROM Competicion_Club_Temporada cct
JOIN Competicion c ON cct.id_competicion = c.id_competicion
JOIN Club cl ON cct.id_club = cl.id_club
WHERE cl.id_club IN (
    SELECT DISTINCT cct_2.id_club
    FROM Competicion_Club_Temporada cct_2 
    JOIN Competicion c2 ON cct_2.id_competicion = c2.id_competicion
    WHERE c2.nombre LIKE '%Segunda División%'
) 
AND cl.id_club IN (
    SELECT id_club
    FROM Competicion_Club_Temporada cct_1
    GROUP BY id_club
    HAVING COUNT(DISTINCT id_competicion) > 1
);
-- Expected output: Lista de clubes que cumplen ambas condiciones (han jugado en segunda división y otra competición).
-- Validar que el club "Levante" o el que elijas ha participado en diversas competiciones y obtener detalles sobre sus posiciones y el número de equipos.
SELECT 
    c.nombre AS nombre_competicion,
    t.año AS año,
    cct.posicion AS posicion,
    cct.n_equipos AS numero_equipos
FROM 
    Competicion_Club_Temporada cct
JOIN 
    Competicion c ON cct.id_competicion = c.id_competicion
JOIN 
    Temporada t ON cct.id_temporada = t.id_temporada
JOIN 
    Club cl ON cct.id_club = cl.id_club
WHERE 
    cl.nombre = 'Granada'
ORDER BY 
    t.año, c.nombre;
-- Expected output: las competiciones y temporadas del club que hayas elegido poner como nombre, en este caso 'Levante'

----------------
-- #Trigger 1.1#
--

CREATE OR REPLACE TRIGGER trigger_possesiones_inconsistentes
AFTER UPDATE OF posesion_local, posesion_visitante ON Partido
FOR EACH ROW
DECLARE
    v_sum_possession NUMBER;
BEGIN
    v_sum_possession := :NEW.posesion_local + :NEW.posesion_visitante;
    
    IF v_sum_possession <> 100 THEN
        INSERT INTO WarningsList (affected_table, error_message, id_reference, date_warning, user_warning)
        VALUES ('Partido', 'home_possession y away_possession no suman 100', :NEW.id_partido, :NEW.fecha, 'xd');
    END IF;
END;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Insertar un partido con posesiones incorrectas
INSERT INTO Partido (id_partido, id_local, id_visitante, id_instalacion, fecha, posesion_local, posesion_visitante, goles_local, goles_visitante)
VALUES ('P123', 1, 2, 1, TO_DATE('2023-09-25', 'YYYY-MM-DD'), 60, 40, 1, 0);

-- Actualizar el partido con posesiones incorrectas para activar el trigger
UPDATE Partido 
SET posesion_local = 60, posesion_visitante = 30 
WHERE id_partido = 'P123';

-- Validar si se ha insertado un registro en WarningsList
SELECT * FROM WarningsList WHERE id_reference = 'P123';

-- Expected output: Debería mostrar un registro en la tabla WarningsList con el mensaje de error sobre las posesiones incorrectas

-- Limpieza de datos
DELETE FROM Partido WHERE id_partido = 'P123';
DELETE FROM WarningsList WHERE id_reference = 'P123';

----------------
-- #Query 2.1#
--

SELECT p.medida as product_size, count(p.medida) AS num_of_sizes
FROM Producto p
JOIN Tipo t
  ON p.id_tipo = t.id_tipo
WHERE t.nombre LIKE 'Short%'
GROUP BY p.medida
ORDER BY num_of_sizes DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

--Select para contar todas las veces que aparece cada medida para ver si los números concuerdan.
SELECT p.medida as product_size, count(p.medida) AS num_of_sizes
FROM Producto p
JOIN Tipo t
    ON p.id_tipo = t.id_tipo
GROUP BY p.medida;

--Validar que existen un tipo de producto con el nombre shorts
SELECT * 
FROM Tipo 
WHERE nombre LIKE 'Short%';

----------------
-- #Query 2.2#
--

SELECT p.nombre AS name, p.coste AS price
FROM Producto p
WHERE p.medida = 'XL' AND p.coste > 350
UNION
SELECT p.nombre AS name, p.coste AS price
FROM Producto p
JOIN Actividad a ON a.id_actividad = p.id_actividad
WHERE a.nombre = 'Casual Wear' AND p.coste > 110
UNION
SELECT p.nombre AS name, p.coste AS price
FROM Producto p
JOIN Accesorio c ON p.id_producto = c.id_accesorio
WHERE c.caracteristica = 'UV Protection' AND p.coste > 55
ORDER BY name;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

--Probar el primer select por separado para ver lo que sale, sin las otras dos.
SELECT p.nombre AS name, p.coste AS price
FROM Producto p
WHERE p.medida = 'XL' AND p.coste > 350;

--Validar el segundo select por separado también para comprobar que salgan productos distintos.
SELECT p.nombre AS name, p.coste AS price
FROM Producto p
JOIN Actividad a ON a.id_actividad = p.id_actividad
WHERE a.nombre = 'Casual Wear' AND p.coste > 110;

--Validar el tercer select, como se puede observar si lo compilas, no sale nada, ya que no hay productos que cumplan las dos cosas.
SELECT p.nombre AS name, p.coste AS price
FROM Producto p
JOIN Accesorio c ON p.id_producto = c.id_accesorio
WHERE c.caracteristica = 'UV Protection' AND p.coste > 55;

--Validar que existen accesorios con esa caracteristica, sin el coste, para demostrar que no sale mal, porque el precio más alto es 55.
SELECT p.nombre AS name, p.coste AS price
FROM Producto p
JOIN Accesorio c ON p.id_producto = c.id_accesorio
WHERE c.caracteristica = 'UV Protection';

----------------
-- #Query 2.3#
--

SELECT p.id_actividad AS ID, COUNT(p.id_actividad) as numero_veces, a.nombre AS name, a.descripcion 
FROM Actividad a
JOIN Producto p ON a.id_actividad = p.id_actividad
GROUP BY p.id_actividad, a.descripcion, a.nombre
ORDER BY numero_veces DESC
FETCH FIRST 5 ROWS ONLY;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que el FETCH FIRST 5 ROWS FUNCIONA, al quitarlo salen todas las posibles
SELECT p.id_actividad AS ID, COUNT(p.id_actividad) as numero_veces, a.nombre AS name, a.descripcion 
FROM Actividad a
JOIN Producto p ON a.id_actividad = p.id_actividad
GROUP BY p.id_actividad, a.descripcion, a.nombre
ORDER BY numero_veces DESC;

-- En este estoy validando que el count de las veces que sale cada actividad y group by funcionen como esperado
SELECT p.id_actividad, COUNT(p.id_actividad) as numero_veces
FROM Producto p
GROUP BY p.id_actividad;

-- Validar que el nombre y la descripcion salgan bien con la actividad indicada
SELECT a.id_actividad, a.nombre, a.descripcion
FROM Actividad a
JOIN Producto p ON a.id_actividad = p.id_actividad;

----------------
-- #Query 2.4#
--

SELECT t.num_tarjeta, SUM(p.coste) AS sum_value
FROM Tarjeta t
JOIN Venta v ON t.id_tarjeta = v.id_tarjeta
JOIN Producto p ON p.id_producto = v.id_producto
GROUP BY num_tarjeta
ORDER BY sum_value DESC
FETCH FIRST 10 ROWS ONLY;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar el join entre las entidades y enseña todas las compras que hace una tarjeta, y el producto que compra, con el coste
SELECT t.num_tarjeta, v.id_venta, p.id_producto, p.coste
FROM Tarjeta t
JOIN Venta v ON t.id_tarjeta = v.id_tarjeta
JOIN Producto p ON p.id_producto = v.id_producto;

--Validar que el sum funcione como debe, sin el limite.
SELECT t.num_tarjeta, SUM(p.coste) AS sum_value
FROM Tarjeta t
JOIN Venta v ON t.id_tarjeta = v.id_tarjeta
JOIN Producto p ON p.id_producto = v.id_producto
GROUP BY num_tarjeta
ORDER BY sum_value DESC;

----------------
-- #Query 2.5#
--

SELECT i.nombre, t.descripcion, SUM(a.stock) AS stock
FROM Tienda t
JOIN Instalacion i ON i.id_instalacion = t.id_tienda
JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
JOIN Producto p ON a.id_producto = p.id_producto
JOIN Club c ON p.id_club = c.id_club
WHERE c.ciudad = 'Barcelona, Spain'
GROUP BY i.nombre, t.descripcion
HAVING SUM(a.stock) > 5 * (
SELECT mini
FROM (
    SELECT SUM(a.stock) AS mini
    FROM Tienda t
    JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
    JOIN Producto p ON a.id_producto = p.id_producto
    GROUP BY t.id_tienda
    ORDER BY mini ASC
    FETCH FIRST ROW ONLY)
)
ORDER BY stock DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Esta es la subquery sin el limite de 1, para ver que calcula bien el stock, y encuentra el más pequeño
SELECT SUM(a.stock) AS mini
    FROM Tienda t
    JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
    JOIN Producto p ON a.id_producto = p.id_producto
    GROUP BY t.id_tienda
    ORDER BY mini ASC;
    
--Esta valida la calculacion de los stocks combinado de sus productos en cada tienda de Barcelona
--Si se quita el where, se puede comprobar para todas las tiendas

SELECT i.nombre, t.descripcion, SUM(a.stock) AS stock
FROM Tienda t
JOIN Instalacion i ON i.id_instalacion = t.id_tienda
JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
JOIN Producto p ON a.id_producto = p.id_producto
JOIN Club c ON p.id_club = c.id_club
WHERE c.ciudad = 'Barcelona, Spain'
GROUP BY i.nombre, t.descripcion;

----------------
-- #Query 2.6#
--

SELECT p.id_producto, p.nombre, p.coste
FROM producto p
LEFT JOIN venta v ON p.id_producto = v.id_producto
WHERE p.coste > 350 AND v.id_producto IS NULL
ORDER BY p.nombre;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- #Validation#
-- Validar que existen los productos con coste de más de 350
SELECT * 
FROM producto 
WHERE coste > 350;

--Validar que el left join funciona correctamente
SELECT p.id_producto, p.nombre, p.coste, v.id_producto AS venta_id_producto
FROM producto p
LEFT JOIN venta v ON p.id_producto = v.id_producto
WHERE p.coste > 350;

-- Este valida que sin el left join no funciona el query de forma correcta
SELECT p.id_producto, p.nombre, p.coste
FROM producto p
JOIN venta v ON p.id_producto = v.id_producto
WHERE p.coste > 350 AND v.id_producto IS NULL
ORDER BY p.nombre;

-- Validate para comprobar que hay productos que no se han vendido

SELECT p.id_producto, p.nombre, p.coste
FROM producto p
LEFT JOIN venta v ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;

----------------
-- #Trigger 2.1#
--

CREATE OR REPLACE TRIGGER update_stock
AFTER INSERT ON Venta
FOR EACH ROW
DECLARE new_stock NUMBER;
BEGIN
    UPDATE Almacenamiento 
    SET stock = stock - :NEW.cantidad
    WHERE id_producto = :NEW.id_producto AND id_instalacion = :NEW.id_instalacion;

    SELECT stock INTO new_stock
    FROM Almacenamiento
    WHERE id_producto = :NEW.id_producto AND id_instalacion = :NEW.id_instalacion;

    IF new_stock < 0 THEN
    UPDATE Almacenamiento
    SET stock = 0
    WHERE id_producto = :NEW.id_producto AND id_instalacion = :NEW.id_instalacion;

    INSERT INTO WarningsList (affected_table, error_message, id_reference, date_warning, user_warning)
    VALUES (
        'Almacenamiento', 
        'Insufficient stock for sale. Stock set to 0.', 
        TO_CHAR(:NEW.id_producto), 
        SYSDATE, 
        USER
);
END IF;
END;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Crear un insert para que salte el trigger
INSERT INTO Venta (fecha, cantidad, descuento, id_instalacion, id_tarjeta, id_producto)
VALUES ('2024-06-30 12:00:00', 2000, '10%', 1, 1, 1);

--Validar que sale en la tabla de Warning List
SELECT *
FROM WarningsList w;

----------------
-- #Query 3.1#
--

SELECT e.nombre AS hashtag, COUNT(*) AS hashtag_count
FROM Publicacion p
JOIN Añadir a ON p.id_publicacion = a.id_publicacion
JOIN Etiqueta e ON a.id_etiqueta = e.id_etiqueta
WHERE p.likes > (SELECT AVG(likes) FROM Publicacion)
AND e.nombre LIKE '%CF'
GROUP BY e.nombre
ORDER BY hashtag_count DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar el promedio de likes en Publicacion
SELECT AVG(likes) AS avg_likes FROM Publicacion;
-- Expected output: Muestra el promedio de likes

-- Validar que existen publicaciones con más likes que el promedio
SELECT * 
FROM Publicacion 
WHERE likes > (SELECT AVG(likes) FROM Publicacion);
-- Expected output: Muestra las publicaciones con más likes que el promedio

-- Validar que existen etiquetas que contienen 'CF'
SELECT * 
FROM Etiqueta 
WHERE nombre LIKE '%CF';
-- Expected output: Muestra las etiquetas que contienen 'CF'

-- Validar la relación en la tabla Añadir
SELECT * 
FROM Añadir 
WHERE id_publicacion IN (
    SELECT id_publicacion 
    FROM Publicacion 
    WHERE likes > (SELECT AVG(likes) FROM Publicacion)
)
AND id_etiqueta IN (
    SELECT id_etiqueta 
    FROM Etiqueta 
    WHERE nombre LIKE '%CF'
);
-- Expected output: Muestra las relaciones entre publicaciones y etiquetas que cumplen con los criterios

----------------
-- #Query 3.2#
--

SELECT m.ciudad_sede AS ciudad, COUNT(*) AS total_canales
FROM Medio_Comunicacion m
JOIN Contener c ON m.ID_Medio = c.id_Medio
JOIN TV t ON c.ID_TV = t.ID_TV
WHERE m.ciudad_sede LIKE '%ona'
GROUP BY m.ciudad_sede
ORDER BY COUNT(t.titulo) DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen medios de comunicación en ciudades que terminan en 'ona'
SELECT * 
FROM Medio_Comunicacion 
WHERE ciudad_sede LIKE '%ona';
-- Expected output: Muestra los medios de comunicación en ciudades que terminan en 'ona'

-- Validar la relación en la tabla Contener
SELECT * 
FROM Contener 
WHERE id_Medio IN (
    SELECT ID_Medio 
    FROM Medio_Comunicacion 
    WHERE ciudad_sede LIKE '%ona'
);
-- Expected output: Muestra las relaciones de 'Contener' con medios de comunicación en ciudades que terminan en 'ona'

----------------
-- #Query 3.3#
--

SELECT p.texto, p.data_creacion
FROM Publicacion p
JOIN Respuesta r ON r.id_publicacion = p.id_publicacion
GROUP BY p.id_publicacion, p.texto, p.data_creacion
ORDER BY COUNT(r.respuesta) DESC
FETCH FIRST 1 ROW ONLY;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen publicaciones que tienen respuestas
SELECT * 
FROM Publicacion 
WHERE id_publicacion IN (SELECT id_publicacion FROM Respuesta);
-- Expected output: Muestra las publicaciones que tienen respuestas

-- Validar que existen respuestas asociadas a publicaciones
SELECT * 
FROM Respuesta 
WHERE id_publicacion IN (SELECT id_publicacion FROM Publicacion);
-- Expected output: Muestra las respuestas asociadas a publicaciones
    
-- Validar el recuento de respuestas por publicación
SELECT p.id_publicacion, COUNT(r.respuesta) AS total_respuestas
FROM Publicacion p
JOIN Respuesta r ON r.id_publicacion = p.id_publicacion
GROUP BY p.id_publicacion
ORDER BY total_respuestas DESC;
-- Expected output: Muestra las publicaciones ordenadas por el número de respuestas en orden descendente

----------------
-- #Query 3.4#
--

SELECT e.nombre AS hashtag, COUNT(a.id_etiqueta) AS hashtag_count
FROM Añadir a
JOIN Publicacion p ON a.id_publicacion = p.id_publicacion
JOIN Mime m ON p.id_publicacion = m.id_publicacion
JOIN Usuario u ON a.id_usuario = u.id_usuario
JOIN Etiqueta e ON a.id_etiqueta = e.id_etiqueta
WHERE m.tipo LIKE '%tiff' AND EXTRACT(YEAR FROM u.data_creacion) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY e.nombre
ORDER BY hashtag_count DESC
FETCH FIRST 10 ROW ONLY;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen publicaciones con tipo MIME '%tiff'
SELECT * 
FROM Mime 
WHERE tipo LIKE '%tiff';
-- Expected output: Muestra las publicaciones con tipo MIME '%tiff'

-- Validar que existen usuarios creados en el año actual
SELECT * 
FROM Usuario 
WHERE EXTRACT(YEAR FROM data_creacion) = EXTRACT(YEAR FROM SYSDATE);
-- Expected output: Muestra los usuarios creados en el año actual

-- Validar la relación entre Añadir y Publicacion
SELECT * 
FROM Añadir 
WHERE id_publicacion IN (
    SELECT id_publicacion 
    FROM Publicacion 
    WHERE id_publicacion IN (SELECT id_publicacion FROM Mime WHERE tipo LIKE '%tiff')
);
-- Expected output: Muestra las relaciones de 'Añadir' con publicaciones que tienen tipo MIME '%tiff'

-- Validar la relación entre Añadir y Usuario
SELECT * 
FROM Añadir 
WHERE id_usuario IN (
    SELECT id_usuario 
    FROM Usuario 
    WHERE EXTRACT(YEAR FROM data_creacion) = EXTRACT(YEAR FROM SYSDATE)
);
-- Expected output: Muestra las relaciones de 'Añadir' con usuarios creados en el año actual

----------------
-- #Query 3.5#
--

SELECT u.username AS Username, COUNT(p.id_publicacion) AS Posts, EXTRACT(YEAR FROM p.data_creacion) AS Año
FROM Usuario u
JOIN Publicar pu ON pu.id_usuario = u.id_usuario
JOIN Publicacion p ON p.id_publicacion = pu.id_publicacion
JOIN (SELECT id_publicacion
     FROM Publicacion
     ORDER BY republicaciones DESC
     FETCH FIRST 500 ROWS ONLY
) tp ON p.id_publicacion = tp.id_publicacion
GROUP BY u.username, EXTRACT(YEAR FROM p.data_creacion)
ORDER BY Año DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen usuarios en la base de datos
SELECT * 
FROM Usuario;
-- Expected output: Muestra todos los usuarios

-- Validar que existen publicaciones en la base de datos
SELECT * 
FROM Publicacion;
-- Expected output: Muestra todas las publicaciones

-- Validar la relación entre Usuario y Publicar
SELECT * 
FROM Publicar 
WHERE id_usuario IN (SELECT id_usuario FROM Usuario);
-- Expected output: Muestra las relaciones de 'Publicar' con usuarios

-- Validar la relación entre Publicar y Publicacion
SELECT * 
FROM Publicar 
WHERE id_publicacion IN (SELECT id_publicacion FROM Publicacion);
-- Expected output: Muestra las relaciones de 'Publicar' con publicaciones

-- Validar que existen las 500 publicaciones más republicadas
SELECT id_publicacion
FROM Publicacion
ORDER BY republicaciones DESC
FETCH FIRST 500 ROWS ONLY;
-- Expected output: Muestra las 500 publicaciones con más republicaciones

----------------
-- #Query 3.6#
--

SELECT pd.nombre, pd.tipo_programa, pd.length
FROM (
    SELECT p.nombre, 'TV' AS tipo_programa, LENGTH(p.nombre) AS length,
           (SELECT AVG(LENGTH(p2.nombre))
            FROM Programa p2
            JOIN Programa_TV pt2 ON p2.id_programa = pt2.id_programa_TV) AS avg_length
    FROM Programa p
    JOIN Programa_TV pt ON p.id_programa = pt.id_programa_TV
    UNION ALL
    SELECT p.nombre, 'Radio' AS tipo_programa, LENGTH(p.nombre) AS length,
           (SELECT AVG(LENGTH(p2.nombre))
            FROM Programa p2
            JOIN Programa_Radio pr2 ON p2.id_programa = pr2.id_programa_radio) AS avg_length
    FROM Programa p
    JOIN Programa_Radio pr ON p.id_programa = pr.id_programa_radio
) pd
WHERE pd.length > pd.avg_length
ORDER BY pd.length DESC
FETCH FIRST 10 ROWS ONLY;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar las longitudes de nombres de canales de TV
SELECT p.nombre, LENGTH(p.nombre) AS length
FROM Programa p
JOIN Programa_TV pt ON p.id_programa = pt.id_programa_TV;
-- Expected output: Muestra los programas de TV junto con la longitud de sus nombres

-- Validar las longitudes de nombres de canales de Radio
SELECT p.nombre, LENGTH(p.nombre) AS length
FROM Programa p
JOIN Programa_Radio pr ON p.id_programa = pr.id_programa_radio;
-- Expected output: Muestra los programas de Radio junto con la longitud de sus nombres

-- Validar el promedio de longitudes de nombres de programas de TV
SELECT AVG(LENGTH(p.nombre)) AS avg_length
FROM Programa p
JOIN Programa_TV pt ON p.id_programa = pt.id_programa_TV;
-- Expected output: Muestra el promedio de longitudes de nombres de programas de TV

-- Validar el promedio de longitudes de nombres de programas de Radio
SELECT AVG(LENGTH(p.nombre)) AS avg_length
FROM Programa p
JOIN Programa_Radio pr ON p.id_programa = pr.id_programa_radio;
-- Expected output: Muestra el promedio de longitudes de nombres de programas de Radio

-- Validar que existen programas de TV con longitud de nombre mayor que el promedio
SELECT p.nombre, LENGTH(p.nombre) AS length
FROM Programa p
JOIN Programa_TV pt ON p.id_programa = pt.id_programa_TV
WHERE LENGTH(p.nombre) > (
    SELECT AVG(LENGTH(p2.nombre))
    FROM Programa p2
    JOIN Programa_TV pt2 ON p2.id_programa = pt2.id_programa_TV
);
-- Expected output: Muestra los programas de TV con longitud de nombre mayor que el promedio

-- Validar que existen programas de Radio con longitud de nombre mayor que el promedio
SELECT p.nombre, LENGTH(p.nombre) AS length
FROM Programa p
JOIN Programa_Radio pr ON p.id_programa = pr.id_programa_radio
WHERE LENGTH(p.nombre) > (
    SELECT AVG(LENGTH(p2.nombre))
    FROM Programa p2
    JOIN Programa_Radio pr2 ON p2.id_programa = pr2.id_programa_radio
);
-- Expected output: Muestra los programas de Radio con longitud de nombre mayor que el promedio

----------------
-- #Trigger 3.1#
--

DROP TRIGGER trigger_post;

CREATE OR REPLACE TRIGGER trigger_post
AFTER INSERT ON Publicar
FOR EACH ROW
DECLARE
    user_warning_tri VARCHAR2(255);
    pub_likes NUMBER;
BEGIN
    -- Obtener el número de likes de la publicación
    SELECT likes 
    INTO pub_likes 
    FROM Publicacion 
    WHERE id_publicacion = :NEW.id_publicacion;

    -- Verificar si los likes son menores a 100
    IF pub_likes < 100 THEN
        -- Obtener el nombre de usuario
        SELECT username 
        INTO user_warning_tri 
        FROM Usuario 
        WHERE id_usuario = :NEW.id_usuario;

        -- Insertar en WarningsList
        INSERT INTO WarningsList (
            affected_table, 
            error_message, 
            id_reference, 
            date_warning, 
            user_warning
        ) VALUES (
            'Publicacion', 
            'Post with less than 100 likes detected', 
            TO_CHAR(:NEW.id_publicacion), 
            SYSDATE,
            user_warning_tri
        );
    END IF;
END;
/


-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Asegúrate de que el nombre de usuario sea único antes de insertar
DELETE FROM Usuario WHERE username = 'skibidi';

-- Insertar un usuario con una fecha manual específica
INSERT INTO Usuario (username, data_creacion, verificado, ciudad_residencia) 
VALUES ('skibidi', TO_DATE('2024-01-01', 'YYYY-MM-DD'), 0, 'Washington');

-- Insertar una publicación con menos de 100 likes y un ID específico
INSERT INTO Publicacion (id_publicacion, texto, data_creacion, likes, republicaciones) 
VALUES (792156347915, 'Fortnite Battle Pass', SYSDATE, 50, 23);

-- Obtener el ID del usuario y relacionar la publicación con el usuario
DECLARE
    new_id_usuario NUMBER(38);
BEGIN
    SELECT id_usuario INTO new_id_usuario 
    FROM Usuario 
    WHERE username = 'skibidi' AND ROWNUM = 1;

    INSERT INTO Publicar (id_usuario, id_publicacion)
    VALUES (new_id_usuario, 792156347915);
END;
/

-- Verificar si se ha insertado un registro en WarningsList
SELECT * FROM WarningsList WHERE id_reference = '792156347915';
-- Expected output: Debería mostrar un registro en la tabla WarningsList con el mensaje de error sobre la publicación con menos de 100 likes

-- Limpieza de datos
DECLARE
    new_id_publicacion NUMBER(38) := 792156347915;
BEGIN
    DELETE FROM Publicar WHERE id_publicacion = new_id_publicacion;
    DELETE FROM Publicacion WHERE id_publicacion = new_id_publicacion;
    DELETE FROM Usuario WHERE username = 'skibidi';
    DELETE FROM WarningsList WHERE id_reference = TO_CHAR(new_id_publicacion);
END;
/

----------------
-- #Query 4.1#
--

SELECT c.id_campaña, c.nombre nombre_campaña, COUNT(a.id_anuncio) numero_anuncios
FROM Campaña c
JOIN Cliente cli ON c.id_cliente = cli.id_cliente
JOIN Anuncio a ON c.id_campaña = a.id_campaña
WHERE cli.direccion_basica = 'Madrid, Spain' AND a.data_creacion BETWEEN TO_DATE('2023/01/01', 'YYYY/MM/DD') AND TO_DATE('2023/12/31', 'YYYY/MM/DD')
GROUP BY c.id_campaña, c.nombre
ORDER BY numero_anuncios DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que existen clientes en Madrid.
SELECT * FROM Cliente WHERE direccion_basica = 'Madrid, Spain';
-- Expected output: Lista de clientes en Madrid.

-- Validar que existen anuncios creados en 2023.
SELECT * FROM Anuncio WHERE data_creacion BETWEEN TO_DATE('2023/01/01', 'YYYY/MM/DD') AND TO_DATE('2023/12/31', 'YYYY/MM/DD');
-- Expected output: Lista de anuncios creados en 2023.

-- Validar que existen campañas asociadas a estos anuncios.
SELECT * FROM Campaña WHERE id_campaña IN (SELECT id_campaña FROM Anuncio WHERE data_creacion BETWEEN TO_DATE('2023/01/01', 'YYYY/MM/DD') AND TO_DATE('2023/12/31', 'YYYY/MM/DD'));
-- Expected output: Lista de campañas con anuncios creados en 2023.

----------------
-- #Query 4.2#
--

SELECT DISTINCT c.nombre AS nombre_campaña
FROM Campaña c
JOIN Anuncio a ON c.id_campaña = a.id_campaña
JOIN Categoria cat ON a.id_categoria = cat.id_categoria
WHERE a.estado LIKE 'Active'
AND EXISTS (
    (SELECT a2.descripcion
    FROM Anuncio a2 
    WHERE a2.id_campaña = a.id_campaña
    AND lower(a2.descripcion) LIKE '%' || lower(cat.nombre) || '%')
);

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

–-Aqui para validar haremos lo mismo pero añadiremos la descripcion i el nombre para comprobar visualmente que se el nombre aparezca en la  descripción.

SELECT DISTINCT c.nombre AS nombre_campaña, (SELECT a2.descripcion
    FROM Anuncio a2 
    WHERE a2.id_campaña = a.id_campaña
    AND lower(a2.descripcion) LIKE '%' || lower(cat.nombre) || '%') as descripcio, cat.nombre
FROM Campaña c
JOIN Anuncio a ON c.id_campaña = a.id_campaña
JOIN Categoria cat ON a.id_categoria = cat.id_categoria
WHERE a.estado LIKE 'Active'
AND EXISTS (
    SELECT 1 
    FROM Anuncio a2 
    WHERE a2.id_campaña = a.id_campaña
    AND lower(a2.descripcion) LIKE '%' || lower(cat.nombre) || '%'
);

----------------
-- #Query 4.3#
--

SELECT c.id_campaña, SUM(cl.presupuesto) AS total_presupuesto, COUNT(DISTINCT cl.id_cliente) AS numero_clientes
FROM Campaña c
JOIN Cliente cl ON c.id_cliente = cl.id_cliente
WHERE c.id_campaña LIKE '4%' 
  AND cl.presupuesto > (SELECT AVG(presupuesto) FROM Cliente)
GROUP BY c.id_campaña
HAVING SUM(cl.presupuesto) = (
    SELECT MAX(total_presupuesto)
    FROM (
        SELECT SUM(cl.presupuesto) AS total_presupuesto
        FROM Campaña c
        JOIN Cliente cl ON c.id_cliente = cl.id_cliente
        WHERE c.id_campaña LIKE '4%' 
          AND cl.presupuesto > (SELECT AVG(presupuesto) FROM Cliente)
        GROUP BY c.id_campaña
    ) subquery
)
ORDER BY total_presupuesto DESC, numero_clientes;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Para validar hacemos miramos que la subquery coja el precio máximo

SELECT MAX(total_presupuesto)
    FROM (
        SELECT SUM(cl.presupuesto) AS total_presupuesto
        FROM Campaña c
        JOIN Cliente cl ON c.id_cliente = cl.id_cliente
        WHERE c.id_campaña LIKE '4%' 
          AND cl.presupuesto > (SELECT AVG(presupuesto) FROM Cliente)
        GROUP BY c.id_campaña
    ) subquery

----------------
-- #Query 4.4#
--

SELECT e.tipo AS tipo_emplazamiento, SUM(e.coste) AS total_coste
FROM Emplazamiento e
JOIN Difundir d ON e.id_emplazamiento = d.id_emplazamiento
JOIN Anuncio a ON d.id_anuncio = a.id_anuncio
JOIN Campaña c ON a.id_campaña = c.id_campaña
JOIN Dirigida dir ON c.id_campaña = dir.id_campaña
JOIN Audiencia aud ON dir.id_audiencia = aud.id_audiencia
WHERE TO_NUMBER(SUBSTR(aud.rango_edades, 1, INSTR(aud.rango_edades, '-') - 1)) > (SELECT AVG(TO_NUMBER(SUBSTR(rango_edades, 1, INSTR(rango_edades, '-') - 1)))FROM Audiencia)
GROUP BY e.tipo
ORDER BY total_coste DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

--Este select verifica que el avg del rango de edades, sea correcto.
SELECT AVG(TO_NUMBER(SUBSTR(rango_edades, 1, INSTR(rango_edades, '-') - 1))) AS promedio_inicio_rango
FROM Audiencia;

----------------
-- #Query 4.5#
--

SELECT a.id_anuncio, a.titulo AS nombre_anuncio
FROM Anuncio a
JOIN Campaña c ON a.id_campaña = c.id_campaña
JOIN Cliente cli ON c.id_cliente = cli.id_cliente
WHERE a.titulo LIKE '%Friday%' 
GROUP BY a.id_anuncio, a.titulo
HAVING COUNT(CASE WHEN cli.direccion_basica = 'Girona, Spain' THEN cli.id_cliente END) > COUNT(CASE WHEN cli.direccion_basica != 'Girona, Spain' THEN cli.id_cliente END);

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

--Aquí hace falta poca validación, simplemente es observar que el nombre del anuncio aparece la palabra Friday.
--Podemos verificar que existen clientes en Girona.
SELECT * FROM Cliente WHERE direccion_basica = 'Girona, Spain';

----------------
-- #Query 4.6#
--

SELECT a.id_anuncio, a.titulo
FROM Anuncio a
JOIN (
    SELECT id_anuncio, COUNT(*) AS num_emplazamientos
    FROM Difundir
    GROUP BY id_anuncio
    HAVING COUNT(*) < 2 * (SELECT AVG(COUNT(*)) FROM Difundir GROUP BY id_anuncio)
) sub ON a.id_anuncio = sub.id_anuncio
ORDER BY sub.num_emplazamientos, a.id_anuncio
FETCH FIRST 5 ROWS ONLY;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

--Aqui podemos hacer varias cossas entre una de ellas, verificar que la subconsulta funcione correctamente.

SELECT id_anuncio, COUNT(*) AS num_emplazamientos
FROM Difundir
GROUP BY id_anuncio
HAVING COUNT(*) < 2 * (SELECT AVG(COUNT(*)) FROM Difundir GROUP BY id_anuncio);

--Una vez verificado esto se verifica el promedio por anuncios.

SELECT AVG(COUNT(*))
FROM Difundir
GROUP BY id_anuncio;

----------------
-- #Trigger 4.1#
--

CREATE OR REPLACE TRIGGER trigger_campaña
AFTER UPDATE OF id_cliente ON Campaña
FOR EACH ROW
DECLARE
    anuncio_count NUMBER;
    user_warning_tri VARCHAR2(255);
BEGIN
    SELECT COUNT(*)
    INTO anuncio_count
    FROM Anuncio
    WHERE id_campaña = :OLD.id_campaña;

    SELECT USER INTO user_warning_tri FROM dual;

    IF anuncio_count > 5 THEN
        INSERT INTO WarningsList (affected_table, error_message, id_reference, date_warning, user_warning)
        VALUES (
            'Campaña', 
            'Updated client name from campaign with more than 5 ads', 
            :OLD.id_campaña, 
            SYSDATE, 
            user_warning_tri
        );
    END IF;
END;
/

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)


-- Insertar una campaña con más de 5 anuncios.
INSERT INTO Campaña (id_campaña, id_cliente, nombre, objetivo, presupuesto_finalizado, data_inicio, data_final) VALUES ('c_prueba', 1, 'Campaña Test', 'Awareness', 5000, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'));
INSERT INTO Anuncio (id_anuncio, id_campaña, titulo, descripcion, estado, id_categoria, data_creacion) VALUES ('101', 'c_prueba', 'Anuncio Test 1', 'Descripción 1', 'Active', 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO Anuncio (id_anuncio, id_campaña, titulo, descripcion, estado, id_categoria, data_creacion) VALUES ('102', 'c_prueba', 'Anuncio Test 2', 'Descripción 2', 'Active', 1, TO_DATE('2024-01-02', 'YYYY-MM-DD'));
INSERT INTO Anuncio (id_anuncio, id_campaña, titulo, descripcion, estado, id_categoria, data_creacion) VALUES ('103', 'c_prueba', 'Anuncio Test 3', 'Descripción 3', 'Active', 1, TO_DATE('2024-01-03', 'YYYY-MM-DD'));
INSERT INTO Anuncio (id_anuncio, id_campaña, titulo, descripcion, estado, id_categoria, data_creacion) VALUES ('104', 'c_prueba', 'Anuncio Test 4', 'Descripción 4', 'Active', 1, TO_DATE('2024-01-04', 'YYYY-MM-DD'));
INSERT INTO Anuncio (id_anuncio, id_campaña, titulo, descripcion, estado, id_categoria, data_creacion) VALUES ('105', 'c_prueba', 'Anuncio Test 5', 'Descripción 5', 'Active', 1, TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO Anuncio (id_anuncio, id_campaña, titulo, descripcion, estado, id_categoria, data_creacion) VALUES ('106', 'c_prueba', 'Anuncio Test 6', 'Descripción 6', 'Active', 1, TO_DATE('2024-01-06', 'YYYY-MM-DD'));

-- Actualizar id_cliente de la campaña creada.
UPDATE Campaña SET id_cliente = 2 WHERE id_campaña = 'c_prueba';

-- Verificar que se ha insertado una advertencia en WarningsList.
SELECT * FROM WarningsList WHERE id_reference = 'c_prueba';
-- Expected output: Una advertencia relacionada con la campaña c_prueba.

-- Eliminar los anuncios insertados para la validación del Trigger 4.1
DELETE FROM Anuncio WHERE id_anuncio IN ('101', '102', '103', '104', '105', '106');

-- Eliminar la campaña insertada para la validación del Trigger 4.1
DELETE FROM Campaña WHERE id_campaña = 'c_prueba';

----------------
-- #Query 5.1#
--

SELECT c.nombre AS nombre_campaña, COUNT(p.id_producto) AS numero_productos
FROM Campaña c
JOIN Publicitan p ON c.id_campaña = p.id_campaña
GROUP BY c.nombre
ORDER BY numero_productos DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

--no hace falta

----------------
-- #Query 5.2#
--

SELECT
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones
FROM Dependiente d
JOIN Persona p ON p.id_persona = d.id_dependiente
JOIN Gestionar g ON g.id_persona = id_dependiente
JOIN Tienda t ON t.id_tienda = g.id_instalacion
JOIN Instalacion i ON t.id_tienda = i.id_instalacion
JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
JOIN Producto pr ON a.id_producto = pr.id_producto
JOIN Club c ON pr.id_club = c.id_club
WHERE c.ciudad = 'Girona, Spain' AND i.nombre LIKE '% - G%'
GROUP BY 
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones
HAVING d.vacaciones > (
    SELECT AVG(d.vacaciones) as media_vacaciones
    FROM dependiente d
)ORDER BY d.vacaciones ASC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar la media de vacaciones para todos los dependientes, así puedes ver que en el query completo solo salen por encima de esta media
SELECT AVG(d.vacaciones) as media_vacaciones
    FROM dependiente d
    
--Validar que los joins funcionan de manera correcta sin que la ciudad sea girona ni que la tienda empieze con g.
SELECT
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones
FROM Dependiente d
JOIN Persona p ON p.id_persona = d.id_dependiente
JOIN Gestionar g ON g.id_persona = id_dependiente
JOIN Tienda t ON t.id_tienda = g.id_instalacion
JOIN Instalacion i ON t.id_tienda = i.id_instalacion
JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
JOIN Producto pr ON a.id_producto = pr.id_producto
JOIN Club c ON pr.id_club = c.id_club
GROUP BY 
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones;
    
-- Validar que solo se cojan las tiendas en girona
SELECT
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones
FROM Dependiente d
JOIN Persona p ON p.id_persona = d.id_dependiente
JOIN Gestionar g ON g.id_persona = id_dependiente
JOIN Tienda t ON t.id_tienda = g.id_instalacion
JOIN Instalacion i ON t.id_tienda = i.id_instalacion
JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
JOIN Producto pr ON a.id_producto = pr.id_producto
JOIN Club c ON pr.id_club = c.id_club
WHERE c.ciudad = 'Girona, Spain'
GROUP BY 
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones;
    
-- Validar que solo coja las tiendas en Girona que también empiecen con g
SELECT
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones
FROM Dependiente d
JOIN Persona p ON p.id_persona = d.id_dependiente
JOIN Gestionar g ON g.id_persona = id_dependiente
JOIN Tienda t ON t.id_tienda = g.id_instalacion
JOIN Instalacion i ON t.id_tienda = i.id_instalacion
JOIN Almacenamiento a ON a.id_instalacion = t.id_tienda
JOIN Producto pr ON a.id_producto = pr.id_producto
JOIN Club c ON pr.id_club = c.id_club
WHERE c.ciudad = 'Girona, Spain' AND i.nombre LIKE '% - G%'
GROUP BY 
    p.nombre, 
    p.apellido, 
    i.nombre,
    d.vacaciones;

----------------
-- #Query 5.3#
--

SELECT c.nombre AS ClubName, c.ciudad AS City
FROM Club c
JOIN Producto p ON c.id_club = p.id_club
JOIN Tipo t ON p.id_tipo = t.id_tipo
WHERE t.nombre = 'Polo Shirt' AND p.oficialidad = 'Official'
GROUP BY c.nombre, c.ciudad
HAVING COUNT(p.id_producto) = 1
ORDER BY c.nombre ASC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar todos los productos por club para ver la diversidad de productos
SELECT c.nombre AS club_nombre, t.nombre AS tipo_nombre, p.oficialidad, COUNT(p.id_producto) AS product_count
FROM Club c
JOIN Producto p ON c.id_club = p.id_club
JOIN Tipo t ON p.id_tipo = t.id_tipo
GROUP BY c.nombre, t.nombre, p.oficialidad
ORDER BY c.nombre, t.nombre;

-- Esperado:
-- Devolver una lista de clubes, tipos de productos y la cantidad de cada tipo de producto por club
-- para verificar la diversidad de productos de cada club, en esta lista se podrá comprobar manualmente 
-- que el output del la query es correcto, por ejemplo el club almeria tiene dos productos del tipo
-- Polo Shirt, pero sin embargo uno de ellos no está oficializado, por lo que el output de este club es correcto

-- Validar el total de productos por club
SELECT c.nombre AS club_nombre, COUNT(p.id_producto) AS total_products
FROM Club c
JOIN Producto p ON c.id_club = p.id_club
GROUP BY c.nombre
ORDER BY c.nombre;

-- Esperado:
-- Devolver una lista de clubes y la cantidad total de productos por club para tener una visión general de la distribución de productos.

----------------
-- #Query 5.4#
--

SELECT nombre_campaña, numero_productos
FROM (
    SELECT c.nombre AS nombre_campaña, COUNT(p.id_producto) AS numero_productos
    FROM Campaña c
    JOIN Publicitan p ON c.id_campaña = p.id_campaña
    GROUP BY c.nombre
    ORDER BY numero_productos DESC
    FETCH FIRST 5 ROWS ONLY
) 
UNION ALL
SELECT nombre_campaña, numero_productos
FROM (
    SELECT c.nombre AS nombre_campaña, COUNT(p.id_producto) AS numero_productos
    FROM Campaña c
    JOIN Publicitan p ON c.id_campaña = p.id_campaña
    GROUP BY c.nombre
    ORDER BY numero_productos ASC
    FETCH FIRST 5 ROWS ONLY
)
ORDER BY numero_productos DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Validar que la subconsulta obtiene correctamente las 5 campañas con más productos.
SELECT c.nombre AS nombre_campaña, COUNT(p.id_producto) AS numero_productos
FROM Campaña c
JOIN Publicitan p ON c.id_campaña = p.id_campaña
GROUP BY c.nombre
ORDER BY numero_productos DESC
FETCH FIRST 5 ROWS ONLY;
-- Expected output: Lista de las 5 campañas con más productos.


-- Validar que la subconsulta obtiene correctamente las 5 campañas con menos productos.
SELECT c.nombre AS nombre_campaña, COUNT(p.id_producto) AS numero_productos
FROM Campaña c
JOIN Publicitan p ON c.id_campaña = p.id_campaña
GROUP BY c.nombre
ORDER BY numero_productos ASC
FETCH FIRST 5 ROWS ONLY;
-- Expected output: Lista de las 5 campañas con menos productos.

----------------
-- #Query 5.5#
--

--Solución 1
SELECT e.id_emplazamiento
FROM Emplazamiento e
WHERE NOT EXISTS (
    SELECT 1
    FROM Ubicar u
    WHERE u.id_emplazamiento = e.id_emplazamiento
)
ORDER BY e.id_emplazamiento DESC;

--Solución 2
SELECT e.id_emplazamiento
FROM Emplazamiento e
LEFT JOIN Ubicar u ON e.id_emplazamiento = u.id_emplazamiento
WHERE u.id_emplazamiento IS NULL
ORDER BY e.id_emplazamiento DESC;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Verificar que la tabla Emplazamiento no esté vacía
SELECT COUNT(*) AS total_emplazamientos
FROM Emplazamiento
HAVING COUNT(*) > 0;

----------------
-- #Query 5.6#
--

SELECT 'Entrenador' AS tipo_persona, COUNT(e.id_persona) AS cantidad
FROM Entrenador e
UNION
SELECT 'Jugador' AS tipo_persona, COUNT(j.id_persona) AS cantidad
FROM Jugador j
UNION
SELECT 'Arbitro' AS tipo_persona, COUNT(a.id_persona) AS cantidad
FROM Arbitro a
UNION
SELECT 'Dependiente' AS tipo_persona, COUNT(d.id_dependiente) AS cantidad
FROM Dependiente d
UNION
SELECT 'Comunicador' AS tipo_persona, COUNT(c.id_comunicador) AS cantidad
FROM Comunicador c;

-- #Validation#
-- if needed, write the validation queries (select, update, insert, delete)

-- Query muy sencilla(No validate needed).