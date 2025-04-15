-- Gerard:
-- Paso 1: Insertar datos de jugadores en la tabla Persona
INSERT INTO Persona (nombre, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT name, city, BirthDate, NULL
FROM ds1_players
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p 
    WHERE p.nombre = ds1_players.name
      AND (p.pais_nacimiento = ds1_players.city OR (p.pais_nacimiento IS NULL AND ds1_players.city IS NULL))
      AND (p.data_nacimiento = ds1_players.BirthDate OR (p.data_nacimiento IS NULL AND ds1_players.BirthDate IS NULL))
);

-- Paso 2: Insertar datos de entrenadores en la tabla Persona
INSERT INTO Persona (nombre, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT home_manager, home_manager_city, home_date, home_gender
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p WHERE p.nombre = ds1_match.home_manager
)
UNION
SELECT DISTINCT away_manager, away_manager_city, away_date, away_gender
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p WHERE p.nombre = ds1_match.away_manager
);

-- Paso 3: Insertar datos de árbitros en la tabla Persona sin duplicados
-- Insertar datos del árbitro principal en la tabla Persona
INSERT INTO Persona (nombre, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT referee, NULL, NULL, NULL
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p 
    WHERE p.nombre = ds1_match.referee
);

-- Insertar datos del primer asistente en la tabla Persona
INSERT INTO Persona (nombre, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT ar1, NULL, NULL, NULL
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p 
    WHERE p.nombre = ds1_match.ar1
);

-- Insertar datos del segundo asistente en la tabla Persona
INSERT INTO Persona (nombre, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT ar2, NULL, NULL, NULL
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p 
    WHERE p.nombre = ds1_match.ar2
);

-- Insertar datos del cuarto árbitro en la tabla Persona
INSERT INTO Persona (nombre, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT fourth, NULL, NULL, NULL
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p 
    WHERE p.nombre = ds1_match.fourth
);

-- Insertar datos del VAR en la tabla Persona
INSERT INTO Persona (nombre, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT var, NULL, NULL, NULL
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Persona p 
    WHERE p.nombre = ds1_match.var
);

-- Paso 4: Insertar datos en la tabla Club
INSERT INTO Club (nombre, ciudad)
SELECT DISTINCT home, home_city
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Club c WHERE c.nombre = ds1_match.home
)
UNION
SELECT DISTINCT away, away_city
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Club c WHERE c.nombre = ds1_match.away
);

-- Paso 5: Insertar datos de temporadas en la tabla Temporada
INSERT INTO Temporada (año)
SELECT DISTINCT EXTRACT(YEAR FROM match_date) AS año
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Temporada t WHERE t.año = EXTRACT(YEAR FROM ds1_match.match_date)
);

-- Paso 6: Insertar datos en la tabla Competicion
INSERT INTO Competicion (nombre, genero)
SELECT DISTINCT league, gender
FROM ds1_match
WHERE NOT EXISTS (
    SELECT 1 FROM Competicion c WHERE c.nombre = ds1_match.league AND c.genero = ds1_match.gender
);

-- Paso 7: Insertar datos en la tabla Temporada_Competicion
INSERT INTO Temporada_Competicion (id_temporada, id_competicion)
SELECT DISTINCT t.id_temporada, c.id_competicion
FROM ds1_match m
JOIN Competicion c ON m.league = c.nombre AND m.gender = c.genero
JOIN Temporada t ON EXTRACT(YEAR FROM m.match_date) = t.año
WHERE NOT EXISTS (
    SELECT 1 FROM Temporada_Competicion tc
    WHERE tc.id_temporada = t.id_temporada AND tc.id_competicion = c.id_competicion
);


-- Paso 8: Insertar datos en la tabla Competicion_Club_Temporada
INSERT INTO Competicion_Club_Temporada (id_club, id_competicion, id_temporada, genero)
SELECT DISTINCT
    c.id_club,
    comp.id_competicion,
    t.id_temporada,
    m.gender
FROM
    ds1_match m
JOIN
    Club c ON (m.home = c.nombre OR m.away = c.nombre)
JOIN
    Competicion comp ON m.league = comp.nombre AND m.gender = comp.genero
JOIN
    Temporada t ON EXTRACT(YEAR FROM m.match_date) = t.año
WHERE NOT EXISTS (
    SELECT 1 
    FROM Competicion_Club_Temporada cct
    WHERE cct.id_club = c.id_club 
      AND cct.id_competicion = comp.id_competicion
      AND cct.id_temporada = t.id_temporada
      AND cct.genero = m.gender
);

-- Paso 9: Insertar datos de persona y entrenador en la tabla Entrenador
INSERT INTO Entrenador (id_persona, tacticas, estilo_entrenamiento)
SELECT DISTINCT p.id_persona, m.home_tactics, m.home_style
FROM ds1_match m
JOIN Persona p ON m.home_manager = p.nombre
WHERE NOT EXISTS (
    SELECT 1 FROM Entrenador e WHERE e.id_persona = p.id_persona
)
UNION
SELECT DISTINCT p.id_persona, m.away_tactics, m.away_style
FROM ds1_match m
JOIN Persona p ON m.away_manager = p.nombre
WHERE NOT EXISTS (
    SELECT 1 FROM Entrenador e WHERE e.id_persona = p.id_persona
);

-- Paso 10: Insertar datos en la tabla Entrenador_Club
-- Insertar datos de entrenadores locales en la tabla Entrenador_Club con fechas calculadas
INSERT INTO Entrenador_Club (id_club, id_persona, fecha_empieza, fecha_acaba)
SELECT DISTINCT 
    c.id_club, 
    e.id_persona, 
    (SELECT MIN(m2.match_date) 
     FROM ds1_match m2 
     WHERE m2.home_manager = p.nombre 
       AND m2.home = c.nombre) AS fecha_empieza,
    (SELECT MAX(m2.match_date) 
     FROM ds1_match m2 
     WHERE m2.home_manager = p.nombre 
       AND m2.home = c.nombre) AS fecha_acaba
FROM ds1_match m
JOIN Persona p ON m.home_manager = p.nombre
JOIN Entrenador e ON p.id_persona = e.id_persona
JOIN Club c ON m.home = c.nombre
JOIN Competicion_Club_Temporada cc ON c.id_club = cc.id_club
JOIN Competicion comp ON cc.id_competicion = comp.id_competicion AND comp.nombre = m.league
WHERE NOT EXISTS (
    SELECT 1 
    FROM Entrenador_Club ec
    WHERE ec.id_club = c.id_club 
      AND ec.id_persona = e.id_persona
);

-- Insertar datos de entrenadores visitantes en la tabla Entrenador_Club con fechas calculadas
INSERT INTO Entrenador_Club (id_club, id_persona, fecha_empieza, fecha_acaba)
SELECT DISTINCT 
    c.id_club, 
    e.id_persona, 
    (SELECT MIN(m2.match_date) 
     FROM ds1_match m2 
     WHERE m2.away_manager = p.nombre 
       AND m2.away = c.nombre) AS fecha_empieza,
    (SELECT MAX(m2.match_date) 
     FROM ds1_match m2 
     WHERE m2.away_manager = p.nombre 
       AND m2.away = c.nombre) AS fecha_acaba
FROM ds1_match m
JOIN Persona p ON m.away_manager = p.nombre
JOIN Entrenador e ON p.id_persona = e.id_persona
JOIN Club c ON m.away = c.nombre
JOIN Competicion_Club_Temporada cc ON c.id_club = cc.id_club
JOIN Competicion comp ON cc.id_competicion = comp.id_competicion AND comp.nombre = m.league
WHERE NOT EXISTS (
    SELECT 1 
    FROM Entrenador_Club ec
    WHERE ec.id_club = c.id_club 
      AND ec.id_persona = e.id_persona
);

-- Paso 11: Insertar datos en la tabla Jugador
-- Insertar datos en la tabla Jugador con posición favorita y pie favorito calculados
INSERT INTO Jugador (id_persona, posicion_favorita, pie_favorito)
SELECT DISTINCT
    p.id_persona,
    (SELECT MAX(position) KEEP (DENSE_RANK FIRST ORDER BY position_count DESC)
     FROM (SELECT dp.position, COUNT(*) AS position_count
           FROM ds1_players dp
           WHERE dp.name = p.nombre
             AND (dp.City = p.pais_nacimiento OR (dp.City IS NULL AND p.pais_nacimiento IS NULL))
             AND (dp.BirthDate = p.data_nacimiento OR (dp.BirthDate IS NULL AND p.data_nacimiento IS NULL))
           GROUP BY dp.position)) AS posicion_favorita,
    (SELECT MAX(Footed) KEEP (DENSE_RANK FIRST ORDER BY footed_count DESC)
     FROM (SELECT dp.Footed, COUNT(*) AS footed_count
           FROM ds1_players dp
           WHERE dp.name = p.nombre
             AND (dp.City = p.pais_nacimiento OR (dp.City IS NULL AND p.pais_nacimiento IS NULL))
             AND (dp.BirthDate = p.data_nacimiento OR (dp.BirthDate IS NULL AND p.data_nacimiento IS NULL))
           GROUP BY dp.Footed)) AS pie_favorito
FROM
    Persona p
WHERE
    EXISTS (SELECT 1 FROM ds1_players dp 
            WHERE dp.name = p.nombre
              AND (dp.City = p.pais_nacimiento OR (dp.City IS NULL AND p.pais_nacimiento IS NULL))
              AND (dp.BirthDate = p.data_nacimiento OR (dp.BirthDate IS NULL AND p.data_nacimiento IS NULL)));

-- Paso 12: Insertar datos en la tabla Jugador_Club con fechas calculadas
INSERT INTO Jugador_Club (id_club, id_persona, fecha_empieza, fecha_acaba)
SELECT DISTINCT 
    c.id_club, 
    p.id_persona, 
    MIN(m.match_date) AS fecha_empieza, 
    MAX(m.match_date) AS fecha_acaba
FROM ds1_players dp
JOIN ds1_match m ON dp.match_id = m.match_id
JOIN Persona p ON dp.name = p.nombre
JOIN Club c ON dp.club = c.nombre
JOIN Competicion_Club_Temporada cc ON c.id_club = cc.id_club
JOIN Competicion comp ON cc.id_competicion = comp.id_competicion AND comp.nombre = m.league
JOIN Jugador j ON p.id_persona = j.id_persona
WHERE NOT EXISTS (
    SELECT 1 
    FROM Jugador_Club jc 
    WHERE jc.id_club = c.id_club 
      AND jc.id_persona = p.id_persona
)
GROUP BY dp.name, dp.club, c.id_club, p.id_persona;

-- Paso 13: Insertar datos en la tabla Instalacion
INSERT INTO Instalacion (id_club, nombre)
SELECT DISTINCT c.id_club, m.venue
FROM ds1_match m
JOIN Club c ON m.home = c.nombre
WHERE NOT EXISTS (
    SELECT 1 
    FROM Instalacion i 
    WHERE i.nombre = m.venue AND i.id_club = c.id_club
);

-- Paso 14: Insertar datos en la tabla Partido
INSERT INTO Partido (id_partido, id_local, id_visitante, id_instalacion, fecha, posesion_local, posesion_visitante, goles_local, goles_visitante)
SELECT DISTINCT
    m.match_id,
    c_local.id_club,
    c_visitante.id_club,
    i.id_instalacion,
    m.match_date,
    m.HOME_POSS,
    m.AWAY_POSS,
    0,
    0
FROM
    ds1_match m
JOIN
    Club c_local ON m.home = c_local.nombre
JOIN
    Club c_visitante ON m.away = c_visitante.nombre
LEFT JOIN
    Instalacion i ON c_local.id_club = i.id_club AND i.nombre = m.venue
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Partido p
        WHERE p.id_partido = m.match_id
    );

-- Paso 15: Insertar datos en la tabla Jugador_Partido
INSERT INTO Jugador_Partido (
    id_persona, id_partido, pie_jugado, altura, peso, chutes, chutes_puerta, amarillas, rojas, goles, asistencias, posicion
)
SELECT DISTINCT
    p.id_persona,
    dp.match_id,
    dp.Footed,
    dp.Height,
    dp.Weight,
    dp.shots,
    dp.shots_on_target,
    dp.yellow_cards,
    dp.red_cards,
    dp.goals,
    dp.assists,
    dp.position
FROM
    ds1_players dp
JOIN
    Persona p ON dp.name = p.nombre
              AND (dp.City = p.pais_nacimiento OR (dp.City IS NULL AND p.pais_nacimiento IS NULL))
              AND (dp.BirthDate = p.data_nacimiento OR (dp.BirthDate IS NULL AND p.data_nacimiento IS NULL))
JOIN
    Jugador j ON p.id_persona = j.id_persona;

--- Paso 16: Insertar datos en la tabla Arbitro
-- Insertar datos del árbitro principal en la tabla Arbitro
INSERT INTO Arbitro (id_persona, certificacion)
SELECT DISTINCT
    p.id_persona,
    m.referee_cert
FROM
    ds1_match m
JOIN
    Persona p ON m.referee = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro a
        WHERE a.id_persona = p.id_persona
    );

-- Insertar datos del primer asistente en la tabla Arbitro
INSERT INTO Arbitro (id_persona, certificacion)
SELECT DISTINCT
    p.id_persona,
    m.ar1_cert
FROM
    ds1_match m
JOIN
    Persona p ON m.ar1 = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro a
        WHERE a.id_persona = p.id_persona
    );

-- Insertar datos del segundo asistente en la tabla Arbitro
INSERT INTO Arbitro (id_persona, certificacion)
SELECT DISTINCT
    p.id_persona,
    m.ar2_cert
FROM
    ds1_match m
JOIN
    Persona p ON m.ar2 = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro a
        WHERE a.id_persona = p.id_persona
    );

-- Insertar datos del cuarto árbitro en la tabla Arbitro
INSERT INTO Arbitro (id_persona, certificacion)
SELECT DISTINCT
    p.id_persona,
    m.fourth_cert
FROM
    ds1_match m
JOIN
    Persona p ON m.fourth = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro a
        WHERE a.id_persona = p.id_persona
    );

-- Insertar datos del VAR en la tabla Arbitro
INSERT INTO Arbitro (id_persona, certificacion)
SELECT DISTINCT
    p.id_persona,
    m.var_cert
FROM
    ds1_match m
JOIN
    Persona p ON m.var = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro a
        WHERE a.id_persona = p.id_persona
    );

    
-- Paso 17: Insertar datos en la tabla Arbitro_Partido
-- Insertar datos del árbitro principal en la tabla Arbitro_Partido
INSERT INTO Arbitro_Partido (id_persona, id_partido, rol)
SELECT DISTINCT
    p.id_persona,
    m.match_id,
    'Referee' AS rol
FROM
    ds1_match m
JOIN
    Persona p ON m.referee = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro_Partido ap
        WHERE ap.id_persona = p.id_persona AND ap.id_partido = m.match_id AND ap.rol = 'Referee'
    );

-- Insertar datos del primer asistente en la tabla Arbitro_Partido
INSERT INTO Arbitro_Partido (id_persona, id_partido, rol)
SELECT DISTINCT
    p.id_persona,
    m.match_id,
    'Assistant Referee 1' AS rol
FROM
    ds1_match m
JOIN
    Persona p ON m.ar1 = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro_Partido ap
        WHERE ap.id_persona = p.id_persona AND ap.id_partido = m.match_id AND ap.rol = 'Assistant Referee 1'
    );

-- Insertar datos del segundo asistente en la tabla Arbitro_Partido
INSERT INTO Arbitro_Partido (id_persona, id_partido, rol)
SELECT DISTINCT
    p.id_persona,
    m.match_id,
    'Assistant Referee 2' AS rol
FROM
    ds1_match m
JOIN
    Persona p ON m.ar2 = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro_Partido ap
        WHERE ap.id_persona = p.id_persona AND ap.id_partido = m.match_id AND ap.rol = 'Assistant Referee 2'
    );

-- Insertar datos del cuarto árbitro en la tabla Arbitro_Partido
INSERT INTO Arbitro_Partido (id_persona, id_partido, rol)
SELECT DISTINCT
    p.id_persona,
    m.match_id,
    'Fourth Official' AS rol
FROM
    ds1_match m
JOIN
    Persona p ON m.fourth = p.nombre
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Arbitro_Partido ap
        WHERE ap.id_persona = p.id_persona AND ap.id_partido = m.match_id AND ap.rol = 'Fourth Official'
    );

-- Insertar datos del VAR en la tabla Arbitro_Partido
INSERT INTO Arbitro_Partido (id_persona, id_partido, rol)
SELECT DISTINCT
    p.id_persona,
    m.match_id,
    'VAR' AS rol
FROM
    ds1_match m
LEFT JOIN
    Persona p ON m.var = p.nombre
WHERE
    m.var IS NOT NULL
    AND p.id_persona IS NOT NULL
    AND NOT EXISTS (
        SELECT 1
        FROM Arbitro_Partido ap
        WHERE ap.id_persona = p.id_persona 
          AND ap.id_partido = m.match_id
          AND ap.rol = 'VAR'
    );

-- Paso 18: Insertar datos en la tabla Partido_Competicion_Temporada
INSERT INTO Partido_Competicion_Temporada (id_partido, id_competicion, id_temporada, genero)
SELECT DISTINCT
    m.match_id,
    c.id_competicion,
    t.id_temporada,
    m.gender
FROM
    ds1_match m
JOIN
    Competicion c ON m.league = c.nombre AND m.gender = c.genero
JOIN
    Temporada t ON EXTRACT(YEAR FROM m.match_date) = t.año
WHERE
    NOT EXISTS (
        SELECT 1 
        FROM Partido_Competicion_Temporada pct
        WHERE pct.id_partido = m.match_id
          AND pct.id_competicion = c.id_competicion
          AND pct.id_temporada = t.id_temporada
          AND pct.genero = m.gender
    );

-- Paso 19: Actualizar goles en la tabla Partido
-- Actualizar goles de los equipos locales
UPDATE Partido p
SET goles_local = (
    SELECT COALESCE(SUM(dp.goals), 0)
    FROM ds1_players dp
    JOIN ds1_match m ON dp.match_id = m.match_id
    JOIN Club c ON dp.club = c.nombre
    WHERE m.match_id = p.id_partido
      AND c.id_club = p.id_local
);

-- Actualizar goles de los equipos visitantes
UPDATE Partido p
SET goles_visitante = (
    SELECT COALESCE(SUM(dp.goals), 0)
    FROM ds1_players dp
    JOIN ds1_match m ON dp.match_id = m.match_id
    JOIN Club c ON dp.club = c.nombre
    WHERE m.match_id = p.id_partido
      AND c.id_club = p.id_visitante
);

-- Actualizar puntos de los equipos en la tabla Competicion_Club_Temporada
UPDATE Competicion_Club_Temporada cct
SET puntos = (
    SELECT SUM(
        CASE
            WHEN p.id_local = cct.id_club AND p.goles_local > p.goles_visitante THEN 3
            WHEN p.id_local = cct.id_club AND p.goles_local = p.goles_visitante THEN 1
            WHEN p.id_visitante = cct.id_club AND p.goles_visitante > p.goles_local THEN 3
            WHEN p.id_visitante = cct.id_club AND p.goles_visitante = p.goles_local THEN 1
            ELSE 0
        END
    )
    FROM Partido p
    JOIN Partido_Competicion_Temporada pct ON p.id_partido = pct.id_partido
    WHERE pct.id_competicion = cct.id_competicion
      AND pct.id_temporada = cct.id_temporada
      AND (p.id_local = cct.id_club OR p.id_visitante = cct.id_club)
)
WHERE EXISTS (
    SELECT 1
    FROM Partido p
    JOIN Partido_Competicion_Temporada pct ON p.id_partido = pct.id_partido
    WHERE pct.id_competicion = cct.id_competicion
      AND pct.id_temporada = cct.id_temporada
      AND (p.id_local = cct.id_club OR p.id_visitante = cct.id_club)
);

-- Actualizar el número de partidos jugados por cada club
UPDATE Competicion_Club_Temporada cct
SET partidos = (
    SELECT COUNT(*)
    FROM Partido p
    JOIN Partido_Competicion_Temporada pct ON p.id_partido = pct.id_partido
    WHERE pct.id_competicion = cct.id_competicion
      AND pct.id_temporada = cct.id_temporada
      AND (p.id_local = cct.id_club OR p.id_visitante = cct.id_club)
)
WHERE EXISTS (
    SELECT 1
    FROM Partido p
    JOIN Partido_Competicion_Temporada pct ON p.id_partido = pct.id_partido
    WHERE pct.id_competicion = cct.id_competicion
      AND pct.id_temporada = cct.id_temporada
      AND (p.id_local = cct.id_club OR p.id_visitante = cct.id_club)
);

-- Actualizar posiciones de los equipos en la tabla Competicion_Club_Temporada
UPDATE Competicion_Club_Temporada cct1
SET posicion = (
    SELECT COUNT(*) + 1
    FROM Competicion_Club_Temporada cct2
    WHERE cct2.id_competicion = cct1.id_competicion
      AND cct2.id_temporada = cct1.id_temporada
      AND cct2.puntos > cct1.puntos
)
WHERE EXISTS (
    SELECT 1
    FROM Competicion_Club_Temporada cct2
    WHERE cct2.id_competicion = cct1.id_competicion
      AND cct2.id_temporada = cct1.id_temporada
);


-- Daniel:
INSERT INTO Tarjeta (num_tarjeta, fecha_caducidad, proveedor)
SELECT DISTINCT 
    creditcard_num, 
    creditcard_expiry, 
    creditcard_provider 
FROM ds2_product_sales
WHERE creditcard_num IS NOT NULL;


INSERT INTO Instalacion (id_club, nombre)
SELECT DISTINCT 
    c.id_club,
    s.SHOP
FROM ds2_product_sales s
JOIN Club c ON s.TEAM = c.nombre
GROUP BY c.id_club, s.shop;

INSERT INTO Tienda (descripcion, id_tienda)
SELECT DISTINCT 
    s.SHOP_DESCRIPTION,
    i.id_instalacion
FROM DS2_PRODUCT_SALES s
JOIN Instalacion i ON s.SHOP = i.nombre;

INSERT INTO Persona (nombre, apellido, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT
    ds.firstname,
    ds.lastname,
    NULL,
    ds.birthdate,
    ds.gender
FROM ds2_shop_keepers ds;  

INSERT INTO Dependiente (id_dependiente, residencia, vacaciones)
SELECT DISTINCT 
    p.id_persona, 
    null, 
    ds.vacation_days 
FROM Persona p 
JOIN ds2_shop_keepers ds ON p.nombre = ds.firstname AND p.apellido = ds.lastname AND ds.birthdate = p.data_nacimiento
WHERE NOT EXISTS (
    SELECT 1 
    FROM Dependiente dep 
    WHERE dep.id_dependiente = p.id_persona);

INSERT INTO Tipo (nombre, descripcion)
SELECT DISTINCT type, type_description FROM ds2_product_sales;

INSERT INTO Actividad (nombre, descripcion)
SELECT DISTINCT activity, activity_description FROM ds2_product_sales;

INSERT INTO Producto (nombre, coste, oficialidad, medida, caracteristica, descripcion, id_tipo, id_club, id_actividad) 
SELECT DISTINCT 
    d.NAME, 
    d.COST, 
    d.OFFICIAL,     
    d.DIMENSIONS, 
    d.SPECIAL_FEATURE, 
    d.TYPE_DESCRIPTION, 
    t.id_tipo, 
    c.id_club, 
    a.id_actividad
FROM DS2_PRODUCT_SALES d 
JOIN Tipo t ON d.TYPE = t.nombre 
JOIN Club c ON d.TEAM = c.nombre
JOIN Actividad a ON d.ACTIVITY = a.nombre;


INSERT INTO Venta (fecha, cantidad, descuento, ID_Instalacion, ID_Tarjeta, ID_Producto)
SELECT DISTINCT
    p.PURCHASEDATE, 
    p.UNITS,    
    p.DISCOUNT,
    i.id_instalacion,                
    ta.id_tarjeta,
    pr.id_producto
FROM ds2_product_sales p
JOIN Instalacion i ON p.shop = i.nombre
JOIN Tarjeta ta ON p.CREDITCARD_NUM = ta.num_tarjeta AND ta.fecha_caducidad = p.creditcard_expiry
JOIN Producto pr ON p.NAME = pr.nombre;


INSERT INTO Calzado (id_calzado, uso, propiedades, cierre)
SELECT DISTINCT 
    p.id_producto, 
    dp.usage, 
    dp.property, 
    dp.closure 
FROM ds2_product_sales dp
JOIN Producto p ON p.nombre = dp.name
WHERE dp.usage IS NOT NULL
AND dp.property IS NOT NULL
AND dp.closure IS NOT NULL;

INSERT INTO Ropa (id_ropa, temporada, material)
SELECT DISTINCT 
    p.id_producto, 
    dp.season, 
    dp.material
FROM ds2_product_sales dp
JOIN Producto p ON p.nombre = dp.name
WHERE dp.season IS NOT NULL
AND dp.material IS NOT NULL;

INSERT INTO Accesorio (id_accesorio, caracteristica)
SELECT DISTINCT 
    p.id_producto, 
    dp.features 
FROM ds2_product_sales dp
JOIN Producto p ON p.nombre = dp.name
WHERE dp.features IS NOT NULL;

INSERT INTO Almacenamiento (ID_Producto, ID_instalacion, stock)
SELECT DISTINCT
    p.ID_Producto, 
    t.ID_instalacion,
    SUM(v.stock)
FROM ds2_product_sales v
JOIN Producto p ON v.name = p.nombre
JOIN Instalacion t ON v.shop = t.nombre
GROUP BY p.ID_Producto, t.ID_instalacion;


INSERT INTO Gestionar (ID_Persona, ID_instalacion, rol, turno)
SELECT DISTINCT
    p.ID_Persona,
    i.id_instalacion,
    sk.role,
    sk.shift
FROM ds2_shop_keepers sk
JOIN Persona p ON sk.firstname = p.nombre AND sk.lastname = p.apellido
JOIN Dependiente d ON d.id_dependiente = p.ID_Persona
JOIN Instalacion i ON sk.shop = i.nombre;

-- Yannick:
--TABLA Etiqueta--

INSERT INTO Etiqueta (nombre, descripcion, estado_tendencia)
SELECT DISTINCT hashtag, hashtag_desc, trending_status FROM DS3_POSTS;

--TABLA Programa--

INSERT INTO Programa (nombre, descripcion)
SELECT DISTINCT dt.programme, dt.description FROM DS3_TVS dt
UNION
SELECT DISTINCT dr.programme, dr.description FROM DS3_RADIOS dr;

--TABLA Radio--

INSERT INTO Radio (nombre, descripcion, frecuencia)
SELECT DISTINCT name_of_the_radio_station, description_of_the_radio_station, frequency_of_the_radio_station FROM DS3_RADIOS;

--TABLA TV--

INSERT INTO TV (titulo, calidad)
SELECT DISTINCT title_of_the_tv_channel, video_quality_of_the_tv_channel FROM DS3_TVS;

--TABLA Medio_Comunicacion--

INSERT INTO Medio_Comunicacion (nombre, descripcion, ciudad_sede)
SELECT DISTINCT dt.name_of_media_group, dt.description_of_media_group, dt.headquarters_of_the_media_group FROM DS3_TVS dt
UNION
SELECT DISTINCT dr.name_of_media_group, dr.description_of_media_group, dr.headquarters_of_the_media_group FROM DS3_RADIOS dr;

--TABLA Contener--

INSERT INTO Contener (ID_Radio, id_TV, ID_Medio)
SELECT DISTINCT r.ID_Radio, t.id_TV, m.ID_Medio
FROM DS3_Radios dr
JOIN Radio r ON r.nombre = dr.NAME_OF_THE_RADIO_STATION
JOIN Medio_Comunicacion m ON m.nombre = dr.NAME_OF_MEDIA_GROUP
JOIN DS3_TVS dt ON dt.NAME_OF_MEDIA_GROUP = dr.NAME_OF_MEDIA_GROUP
JOIN TV t ON t.titulo = dt.TITLE_OF_THE_TV_CHANNEL;

--TABLA Programa_TV--

INSERT INTO Programa_TV (id_programa_TV, horario_emision, nombre_productora)
SELECT DISTINCT p.id_programa, dt.schedule, dt.production_company
FROM Programa p
JOIN DS3_TVS dt ON p.nombre = dt.programme;

--TABLE Poseer-

INSERT INTO Poseer (id_programa_TV, id_TV)
SELECT DISTINCT pt.id_programa_TV, t.id_TV
FROM Programa_TV pt
JOIN DS3_TVS dt ON pt.id_programa_TV = (SELECT id_programa FROM Programa WHERE nombre = dt.programme)
JOIN TV t ON dt.title_of_the_tv_channel = t.titulo;

--TABLA Programa_Radio--

INSERT INTO Programa_Radio (id_programa_radio, horario, podcast)
SELECT DISTINCT p.id_programa, dr.schedule, dr.podcast
FROM Programa p
JOIN DS3_Radios dr ON p.nombre = dr.programme;

--TABLA Tener--

INSERT INTO Tener (id_programa_radio, id_radio)
SELECT DISTINCT pr.id_programa_radio, r.id_radio
FROM Programa_Radio pr
JOIN DS3_Radios dr ON pr.id_programa_radio = (SELECT id_programa FROM Programa WHERE nombre = dr.programme)
JOIN Radio r ON dr.name_of_the_radio_station = r.nombre;

--TABLA Persona--

INSERT INTO Persona (nombre, apellido, pais_nacimiento, data_nacimiento, genero)
SELECT DISTINCT dt.firstname, dt.lastname, NULL, dt.birthdate, dt.gender FROM DS3_TVS dt
UNION
SELECT DISTINCT dr.firstname, dr.lastname, NULL, dr.birthdate, dr.gender FROM DS3_Radios dr;

--TABLA Usuario--

INSERT INTO Usuario (username, data_creacion, verificado, ciudad_residencia)
SELECT DISTINCT dp.nickname, dp.creation_date, dp.verified, dp.localization
FROM DS3_POSTS dp
UNION
SELECT DISTINCT dt.username_LSSL, NULL, 1, NULL
FROM DS3_TVS dt
UNION
SELECT DISTINCT dr.username_LSSL, NULL, 1, NULL
FROM DS3_RADIOS dr;

--TABLA Comunicador--

INSERT INTO Comunicador (id_comunicador, especialidades, id_usuario)
SELECT DISTINCT p.id_persona, dt.specialization, u.id_usuario
FROM Persona p
JOIN DS3_TVS dt ON p.nombre = dt.firstname AND p.apellido = dt.lastname AND p.data_nacimiento = dt.birthdate AND p.genero = dt.gender
JOIN Usuario u ON dt.username_LSSL = u.username
WHERE NOT EXISTS(
    SELECT 1 FROM Comunicador 
    WHERE p.nombre = dt.firstname AND p.apellido = dt.lastname AND p.data_nacimiento = dt.birthdate AND p.genero = dt.gender AND dt.username_LSSL = u.username
)
UNION
SELECT DISTINCT p.id_persona, dr.specialization, u.id_usuario
FROM Persona p
JOIN DS3_Radios dr ON p.nombre = dr.firstname AND p.apellido = dr.lastname AND p.data_nacimiento = dr.birthdate AND p.genero = dr.gender
JOIN Usuario u ON u.username = dr.username_LSSL
WHERE NOT EXISTS(
    SELECT 1 FROM Comunicador 
    WHERE p.nombre = dr.firstname AND p.apellido = dr.lastname AND p.data_nacimiento = dr.birthdate AND p.genero = dr.gender AND u.username = dr.username_LSSL
);

--TABLA Participar--

INSERT INTO Participar (id_comunicador, id_programa, rol)
SELECT DISTINCT c.id_comunicador, p.id_programa, dr.role
FROM Comunicador c
JOIN Persona pe ON c.id_comunicador = pe.id_persona
JOIN ds3_radios dr ON pe.nombre = dr.firstname AND pe.apellido = dr.lastname AND pe.data_nacimiento = dr.birthdate AND pe.genero = dr.gender
JOIN Programa p ON dr.programme = p.nombre
WHERE NOT EXISTS (
    SELECT 1 FROM Participar cp
    WHERE cp.id_comunicador = c.id_comunicador AND cp.id_programa = p.id_programa
)
UNION
SELECT DISTINCT c.id_comunicador, p.id_programa, dt.role
FROM Comunicador c
JOIN Persona pe ON c.id_comunicador = pe.id_persona
JOIN ds3_tvs dt ON pe.nombre = dt.firstname AND pe.apellido = dt.lastname AND pe.data_nacimiento = dt.birthdate AND pe.genero = dt.gender
JOIN Programa p ON dt.programme = p.nombre
WHERE NOT EXISTS (
    SELECT 1 FROM Participar cp
    WHERE cp.id_comunicador = c.id_comunicador AND cp.id_programa = p.id_programa
);

--TABLA Publicacion--

INSERT INTO Publicacion (id_publicacion, texto, data_creacion, likes, republicaciones)
SELECT DISTINCT post_id, post, post_date, likes, reposts FROM DS3_POSTS;



--TABLA Mime--

INSERT INTO Mime (tipo, id_publicacion)
SELECT DISTINCT dp.mime, p.id_publicacion
FROM DS3_POSTS dp
JOIN Publicacion p ON dp.post_id = p.id_publicacion;

--TABLA Diseminar--

INSERT INTO Diseminar (id_usuario, id_programa)
SELECT DISTINCT u.id_usuario, p.id_programa
FROM Usuario u
JOIN Comunicador c ON u.id_usuario = c.id_usuario
JOIN Participar pa ON pa.id_comunicador = c.id_comunicador
JOIN Programa p ON p.id_programa = pa.id_programa
WHERE NOT EXISTS (
    SELECT 1 FROM Diseminar d
    WHERE d.id_usuario = u.id_usuario AND d.id_programa = p.id_programa
);

--TABLA Añadir--

INSERT INTO Añadir (id_etiqueta, id_usuario, id_publicacion)
SELECT DISTINCT e.id_etiqueta, u.id_usuario, p.id_publicacion 
FROM Etiqueta e
JOIN DS3_POSTS dp ON e.nombre = dp.hashtag
JOIN Usuario u ON u.username = dp.nickname
JOIN Publicacion p ON p.id_publicacion = dp.POST_ID;

--TABLA Imagen--

INSERT INTO Imagen (id_publicacion, titulo, ruta_archivo)
SELECT DISTINCT p.id_publicacion, dp.image, dp.path 
FROM DS3_POSTS dp
JOIN Publicacion p ON p.id_publicacion = dp.post_id;

--TABLA Respuesta--

INSERT INTO Respuesta (publicacion_asociada, respuesta, id_publicacion)
SELECT dp.reposts, dp.reply_to, p.id_publicacion 
FROM DS3_POSTS dp
JOIN Publicacion p ON p.texto = dp.post;

--TABLA Publicar--

INSERT INTO Publicar (id_publicacion, id_usuario)
SELECT DISTINCT p.id_publicacion, u.id_usuario
FROM Publicacion p
JOIN DS3_POSTS dp ON dp.post_ID = p.id_publicacion
JOIN Usuario u ON u.username = dp.nickname;

-- Axel:
INSERT INTO Cliente (nombre, presupuesto, direccion_basica)
SELECT DISTINCT client, client_budget, city FROM DS4_ADS;
/

INSERT INTO Campaña (id_campaña, nombre, objetivo, presupuesto_finalizado, data_inicio, data_final, id_cliente)
SELECT DISTINCT d.code, d.campaign, d.objective, d.budget, d.start_date, d.end_date, c.id_cliente FROM DS4_ADS d JOIN Cliente c ON d.client = c.nombre;
/

INSERT INTO Audiencia (rango_edades, interes_principal)
SELECT DISTINCT audience_segment, audience_interest  FROM DS4_ADS;
/

INSERT INTO Categoria (nombre, descripcion)
SELECT DISTINCT CATEGORY1, CATEGORY1_DESC FROM DS4_ADS;
/

INSERT INTO Categoria (nombre, descripcion)
SELECT DISTINCT CATEGORY2, CATEGORY2_DESC FROM DS4_ADS;
/

INSERT INTO Categoria (nombre, descripcion)
SELECT DISTINCT CATEGORY3, CATEGORY3_DESC FROM DS4_ADS;
/

INSERT INTO subcategoria (id_categoria_padre, id_subcategoria)
SELECT DISTINCT c.id_categoria, c1.id_categoria FROM Categoria c JOIN DS4_ADS d ON (c.nombre = d.CATEGORY1) AND (c.descripcion = d.CATEGORY1_DESC) JOIN Categoria c1 ON (c1.nombre = d.CATEGORY2) AND (c1.descripcion = d.CATEGORY2_DESC);
/

INSERT INTO subcategoria (id_categoria_padre, id_subcategoria)
SELECT DISTINCT c.id_categoria, c1.id_categoria FROM Categoria c JOIN DS4_ADS d ON (c.nombre = d.CATEGORY2) AND (c.descripcion = d.CATEGORY2_DESC) JOIN Categoria c1 ON (c1.nombre = d.CATEGORY3) AND (c1.descripcion = d.CATEGORY3_DESC);
/

INSERT INTO Dirigida (id_campaña, id_audiencia)
SELECT DISTINCT c.id_campaña, a.id_audiencia FROM DS4_ADS d JOIN Campaña c ON d.code = c.id_campaña JOIN Audiencia a ON a.rango_edades = d.audience_segment AND a.interes_principal = d.audience_interest;
/

INSERT INTO Anuncio (id_anuncio, titulo, descripcion, formato, estado, data_creacion, id_campaña, id_categoria)
SELECT DISTINCT d.num, d.title, d.description, d.format, d.status, d.addate, c.id_campaña, cat.id_categoria FROM DS4_ADS d JOIN Campaña c ON d.code = c.id_campaña JOIN Categoria cat ON (cat.nombre = d.CATEGORY1 AND cat.descripcion = d.CATEGORY1_DESC);

INSERT INTO Emplazamiento (id_emplazamiento, data, coste, exclusivo, descripcion, tipo)
SELECT DISTINCT d.ID, d.PLACEMENTDATE, d.cost, d.exclusives, d.type_description, d.PLACEMENT_TYPE FROM DS4_PLACEMENT d;
/

INSERT INTO Difundir (id_emplazamiento, id_anuncio)
SELECT DISTINCT e.id_emplazamiento, a.id_anuncio FROM DS4_PLACEMENT d JOIN Emplazamiento e ON d.ID = e.id_emplazamiento JOIN Anuncio a ON d.ADS = a.id_anuncio
/


--Juntar tablas:
INSERT INTO Publicitan (id_campaña, id_producto)
SELECT DISTINCT
    c.id_campaña,
    p.id_producto
FROM Campaña c 
JOIN DS4_ADS d ON c.id_campaña = d.code
JOIN Producto p ON p.nombre = d.product;

--TABLA Emplazamiento_Instalacion

INSERT INTO Emplazamiento_Instalacion (id_instalacion, id_emplazamiento)
SELECT DISTINCT i.id_instalacion, e.id_emplazamiento
FROM Instalacion i
JOIN DS4_PLACEMENT ds4 ON ds4.building = i.nombre
JOIN Emplazamiento e ON e.id_emplazamiento = ds4.ID;

--TABLA Localizar--

INSERT INTO Localizar (id_programa, id_emplazamiento)
SELECT DISTINCT p.id_programa, e.id_emplazamiento 
FROM Programa p
JOIN DS3_TVS dt ON p.nombre = dt.programme
JOIN DS4_PLACEMENT d4p ON dt.programme = d4p.PROGRAMME
JOIN Emplazamiento e ON d4p.ID = e.id_emplazamiento
UNION
SELECT DISTINCT p.id_programa, e.id_emplazamiento 
FROM Programa p
JOIN DS3_RADIOS dr ON p.nombre = dr.programme
JOIN DS4_PLACEMENT d4p ON dr.programme = d4p.PROGRAMME
JOIN Emplazamiento e ON d4p.ID = e.id_emplazamiento;

--TABLA Ubicar--

INSERT INTO Ubicar (id_publicacion, id_emplazamiento)
SELECT DISTINCT p.id_publicacion, e.id_emplazamiento 
FROM Publicacion p
JOIN DS3_POSTS dp ON p.id_publicacion = dp.post_ID
JOIN DS4_PLACEMENT dp4 ON dp.post_ID = dp4.post
JOIN Emplazamiento e ON dp4.ID = e.id_emplazamiento;