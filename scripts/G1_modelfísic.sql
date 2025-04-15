-- Borrar todas las tablas en el orden correcto
-- Tablas que dependen de otras
DROP TABLE Emplazamiento_Instalacion CASCADE CONSTRAINTS;
DROP TABLE Publicitan CASCADE CONSTRAINTS;
DROP TABLE Publicar CASCADE CONSTRAINTS;
DROP TABLE Añadir CASCADE CONSTRAINTS;
DROP TABLE Imagen CASCADE CONSTRAINTS;
DROP TABLE Mime CASCADE CONSTRAINTS;
DROP TABLE Respuesta CASCADE CONSTRAINTS;
DROP TABLE Ubicar CASCADE CONSTRAINTS;
DROP TABLE Localizar CASCADE CONSTRAINTS;
DROP TABLE Diseminar CASCADE CONSTRAINTS;
DROP TABLE Participar CASCADE CONSTRAINTS;
DROP TABLE Comunicador CASCADE CONSTRAINTS;
DROP TABLE Contener CASCADE CONSTRAINTS;
DROP TABLE Poseer CASCADE CONSTRAINTS;
DROP TABLE Tener CASCADE CONSTRAINTS;
DROP TABLE Programa_TV CASCADE CONSTRAINTS;
DROP TABLE Programa_Radio CASCADE CONSTRAINTS;
DROP TABLE Publicacion CASCADE CONSTRAINTS;
DROP TABLE Difundir CASCADE CONSTRAINTS;
DROP TABLE SubCategoria CASCADE CONSTRAINTS;
DROP TABLE Anuncio CASCADE CONSTRAINTS;
DROP TABLE Dirigida CASCADE CONSTRAINTS;
DROP TABLE Categoria CASCADE CONSTRAINTS;
DROP TABLE Campaña CASCADE CONSTRAINTS;
DROP TABLE Venta CASCADE CONSTRAINTS;
DROP TABLE Gestionar CASCADE CONSTRAINTS;
DROP TABLE Almacenamiento CASCADE CONSTRAINTS;
DROP TABLE Accesorio CASCADE CONSTRAINTS;
DROP TABLE Ropa CASCADE CONSTRAINTS;
DROP TABLE Calzado CASCADE CONSTRAINTS;
DROP TABLE Producto CASCADE CONSTRAINTS;
DROP TABLE Tienda CASCADE CONSTRAINTS;
DROP TABLE Instalacion CASCADE CONSTRAINTS;
DROP TABLE Dependiente CASCADE CONSTRAINTS;
DROP TABLE Jugador_Partido CASCADE CONSTRAINTS;
DROP TABLE Arbitro_Partido CASCADE CONSTRAINTS;
DROP TABLE Partido_Competicion_Temporada CASCADE CONSTRAINTS;
DROP TABLE Competicion_Club_Temporada CASCADE CONSTRAINTS;
DROP TABLE Temporada_Competicion CASCADE CONSTRAINTS;
DROP TABLE Partido CASCADE CONSTRAINTS;
DROP TABLE Jugador_Club CASCADE CONSTRAINTS;
DROP TABLE Entrenador_Club CASCADE CONSTRAINTS;

-- Tablas base
DROP TABLE Usuario CASCADE CONSTRAINTS;
DROP TABLE Programa CASCADE CONSTRAINTS;
DROP TABLE Radio CASCADE CONSTRAINTS;
DROP TABLE TV CASCADE CONSTRAINTS;
DROP TABLE Medio_Comunicacion CASCADE CONSTRAINTS;
DROP TABLE Etiqueta CASCADE CONSTRAINTS;
DROP TABLE Audiencia CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TABLE Emplazamiento CASCADE CONSTRAINTS;
DROP TABLE Tarjeta CASCADE CONSTRAINTS;
DROP TABLE Tipo CASCADE CONSTRAINTS;
DROP TABLE Actividad CASCADE CONSTRAINTS;
DROP TABLE Jugador CASCADE CONSTRAINTS;
DROP TABLE Arbitro CASCADE CONSTRAINTS;
DROP TABLE Entrenador CASCADE CONSTRAINTS;
DROP TABLE Competicion CASCADE CONSTRAINTS;
DROP TABLE Temporada CASCADE CONSTRAINTS;
DROP TABLE Club CASCADE CONSTRAINTS;
DROP TABLE Persona CASCADE CONSTRAINTS;
DROP TABLE WarningsList CASCADE CONSTRAINTS;


-- Crear tablas

-- Tabla Persona
CREATE TABLE Persona (
    id_persona NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    pais_nacimiento VARCHAR(255),
    data_nacimiento DATE,
    genero VARCHAR(26),
    PRIMARY KEY(id_persona)
);

-- Tabla Cliente
CREATE TABLE Cliente (
    id_cliente NUMBER(38) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    nombre VARCHAR(128),
    direccion_basica VARCHAR(128),
    presupuesto NUMBER(38),
    PRIMARY KEY (id_cliente)
);

-- Tabla Club
CREATE TABLE Club (
    id_club NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR(255),
    ciudad VARCHAR(255),
    PRIMARY KEY(id_club)
);

-- Tabla Temporada
CREATE TABLE Temporada (
    id_temporada NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    año NUMBER(4),
    PRIMARY KEY(id_temporada)
);

-- Tabla Competicion
CREATE TABLE Competicion (
    id_competicion NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR(255),
    genero VARCHAR(255),
    PRIMARY KEY(id_competicion)
);

-- Tabla Instalacion
CREATE TABLE Instalacion (
    id_instalacion NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    id_club NUMBER(38),
    nombre VARCHAR(255),
    PRIMARY KEY(id_instalacion),
    FOREIGN KEY(id_club) REFERENCES Club(id_club)
);

-- Tabla Producto
CREATE TABLE Producto (
    id_producto NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(128),
    coste NUMBER(38),
    oficialidad VARCHAR2(128), 
    medida VARCHAR2(128),
    caracteristica VARCHAR2(128),
    descripcion VARCHAR2(128),
    id_tipo NUMBER(38),
    id_club NUMBER(38),
    id_actividad NUMBER(38),
    PRIMARY KEY(id_producto),
    FOREIGN KEY(id_club) REFERENCES Club(id_club)
);

-- Tabla Tarjeta
CREATE TABLE Tarjeta (
    id_tarjeta NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    num_tarjeta VARCHAR2(26),
    fecha_caducidad VARCHAR2(26),
    proveedor VARCHAR2(128),
    PRIMARY KEY(id_tarjeta)
);

-- Tabla Tienda
CREATE TABLE Tienda (
    id_tienda NUMBER(38),
    descripcion VARCHAR2(128),
    PRIMARY KEY(id_tienda),
    FOREIGN KEY(id_tienda) REFERENCES Instalacion(id_instalacion)
);

-- Tabla Competicion_Club_Temporada
CREATE TABLE Competicion_Club_Temporada (
    id_club NUMBER(38),
    id_competicion NUMBER(38),
    id_temporada NUMBER(38),
    genero VARCHAR(255),
    posicion NUMBER(38),
    partidos NUMBER(38),
    puntos NUMBER(38),
    PRIMARY KEY(id_club, id_competicion, id_temporada),
    FOREIGN KEY(id_club) REFERENCES Club(id_club),
    FOREIGN KEY(id_competicion) REFERENCES Competicion(id_competicion),
    FOREIGN KEY(id_temporada) REFERENCES Temporada(id_temporada)
);

-- Tabla Partido
CREATE TABLE Partido (
    id_partido VARCHAR2(26),
    id_local NUMBER(38),
    id_visitante NUMBER(38),
    id_instalacion NUMBER(38),
    fecha DATE,
    posesion_local NUMBER(38),
    posesion_visitante NUMBER(38),
    goles_local NUMBER(38),
    goles_visitante NUMBER(38),
    PRIMARY KEY(id_partido),
    FOREIGN KEY(id_local) REFERENCES Club(id_club),
    FOREIGN KEY(id_visitante) REFERENCES Club(id_club),
    FOREIGN KEY(id_instalacion) REFERENCES Instalacion(id_instalacion)
);
-- Tabla Temporada_Competicion
CREATE TABLE Temporada_Competicion (
    id_temporada NUMBER(38),
    id_competicion NUMBER(38),
    PRIMARY KEY(id_temporada, id_competicion),
    FOREIGN KEY(id_temporada) REFERENCES Temporada(id_temporada),
    FOREIGN KEY(id_competicion) REFERENCES Competicion(id_competicion)
);
-- Tabla Partido_Competicion_Temporada
CREATE TABLE Partido_Competicion_Temporada (
    id_partido VARCHAR2(26),
    id_competicion NUMBER(38),
    id_temporada NUMBER(38),
    genero VARCHAR(255),
    PRIMARY KEY(id_partido, id_competicion, id_temporada),
    FOREIGN KEY(id_partido) REFERENCES Partido(id_partido),
    FOREIGN KEY(id_competicion) REFERENCES Competicion(id_competicion),
    FOREIGN KEY(id_temporada) REFERENCES Temporada(id_temporada)
);

-- Tabla Campaña
CREATE TABLE Campaña (
    id_campaña VARCHAR2(128),
    id_cliente NUMBER(38),
    nombre VARCHAR(128),
    objetivo VARCHAR(128),
    data_inicio DATE,
    data_final DATE,
    presupuesto_finalizado NUMBER(38),
    PRIMARY KEY(id_campaña),
    FOREIGN KEY(id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabla Dependiente
CREATE TABLE Dependiente (
    id_dependiente NUMBER(38),
    residencia VARCHAR2(128),
    vacaciones NUMBER(38),
    PRIMARY KEY (id_dependiente),
    FOREIGN KEY (id_dependiente) REFERENCES Persona (id_persona)
);

-- Tabla Tipo
CREATE TABLE Tipo (
    id_tipo NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(128),
    descripcion VARCHAR2(128),
    PRIMARY KEY(id_tipo)
);

-- Tabla Actividad
CREATE TABLE Actividad (
    id_actividad NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(128),
    descripcion VARCHAR2(128),
    PRIMARY KEY(id_actividad)
);

-- Tabla Venta
CREATE TABLE Venta (
    id_venta NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    fecha VARCHAR2(26),
    cantidad NUMBER(38),
    descuento VARCHAR2(126),
    id_instalacion NUMBER(38),
    id_tarjeta NUMBER(38),
    id_producto NUMBER(38),
    PRIMARY KEY(id_venta),
    FOREIGN KEY(id_instalacion) REFERENCES Instalacion(id_instalacion),
    FOREIGN KEY(id_tarjeta) REFERENCES Tarjeta(id_tarjeta),
    FOREIGN KEY(id_producto) REFERENCES Producto(id_producto)
);

-- Tabla Calzado
CREATE TABLE Calzado (
    id_calzado NUMBER(38),
    uso VARCHAR2(128),
    propiedades VARCHAR2(128),
    cierre VARCHAR2(128),
    PRIMARY KEY(id_calzado),
    FOREIGN KEY(id_calzado) REFERENCES Producto(id_producto)
);

-- Tabla Ropa
CREATE TABLE Ropa (
    id_ropa NUMBER(38),
    temporada VARCHAR2(128),
    material VARCHAR2(128),
    PRIMARY KEY(id_ropa),
    FOREIGN KEY(id_ropa) REFERENCES Producto(id_producto)
);

-- Tabla Accesorio
CREATE TABLE Accesorio (
    id_accesorio NUMBER(38),
    caracteristica VARCHAR2(128),
    PRIMARY KEY(id_accesorio),
    FOREIGN KEY(id_accesorio) REFERENCES Producto(id_producto)
);

-- Tabla Almacenamiento
CREATE TABLE Almacenamiento (
    id_producto NUMBER(38),
    id_instalacion NUMBER(38),
    stock NUMBER(38),
    PRIMARY KEY(id_producto, id_instalacion),
    FOREIGN KEY(id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY(id_instalacion) REFERENCES Instalacion(id_instalacion)
);

-- Tabla Gestionar
CREATE TABLE Gestionar (
    id_persona NUMBER(38),
    id_instalacion NUMBER(38),
    rol VARCHAR2(128),
    turno VARCHAR2(128),
    PRIMARY KEY(id_persona, id_instalacion, rol),
    FOREIGN KEY(id_persona) REFERENCES Persona(id_persona),
    FOREIGN KEY(id_instalacion) REFERENCES Instalacion(id_instalacion)
);

-- Tabla Publicitan
CREATE TABLE Publicitan (
    id_campaña VARCHAR2(128),
    id_producto NUMBER(38),
    PRIMARY KEY(id_campaña, id_producto),
    FOREIGN KEY(id_campaña) REFERENCES Campaña(id_campaña),
    FOREIGN KEY(id_producto) REFERENCES Producto(id_producto)
);

-- Tabla Etiqueta
CREATE TABLE Etiqueta (
    id_etiqueta NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(128),
    descripcion VARCHAR2(128),
    estado_tendencia VARCHAR2(128),
    PRIMARY KEY(id_etiqueta)
);

-- Tabla Emplazamiento
CREATE TABLE Emplazamiento (
    id_emplazamiento NUMBER(38),
    data DATE,
    coste NUMBER(38),
    exclusivo NUMBER(1),
    tipo VARCHAR(128),
    descripcion VARCHAR(128),
    PRIMARY KEY (id_emplazamiento)
);

-- Tabla Programa
CREATE TABLE Programa (
    id_programa NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(128),
    descripcion VARCHAR2(128),
    PRIMARY KEY(id_programa)
);

-- Tabla Radio
CREATE TABLE Radio (
    id_radio NUMBER(28) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(128),
    descripcion VARCHAR2(128),
    frecuencia VARCHAR(26),
    PRIMARY KEY(id_radio)
);

-- Tabla TV
CREATE TABLE TV (
    id_TV NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    titulo VARCHAR2(128),
    calidad VARCHAR(26),
    PRIMARY KEY(id_TV)
);

-- Tabla Medio_Comunicacion
CREATE TABLE Medio_Comunicacion (
    id_medio NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    nombre VARCHAR2(128),
    descripcion VARCHAR2(128),
    ciudad_sede VARCHAR2(128),
    PRIMARY KEY(id_medio)
);

-- Tabla Contener
CREATE TABLE Contener (
    id_radio NUMBER(38),
    id_TV NUMBER(38),
    id_medio NUMBER(38),
    PRIMARY KEY(id_radio, id_TV, id_medio),
    FOREIGN KEY(id_radio) REFERENCES Radio(id_radio),
    FOREIGN KEY(id_TV) REFERENCES TV(id_TV),
    FOREIGN KEY(id_medio) REFERENCES Medio_Comunicacion(id_medio)
);

-- Tabla Programa_TV
CREATE TABLE Programa_TV (
    id_programa_TV NUMBER(38),
    horario_emision VARCHAR(26),
    nombre_productora VARCHAR2(128),
    PRIMARY KEY(id_programa_TV),
    FOREIGN KEY(id_programa_TV) REFERENCES Programa(id_programa)
);

-- Tabla Poseer
CREATE TABLE Poseer (
    id_programa_TV NUMBER(38),
    id_TV NUMBER(38),
    PRIMARY KEY(id_programa_TV, id_TV),
    FOREIGN KEY(id_programa_TV) REFERENCES Programa_TV(id_programa_TV),
    FOREIGN KEY(id_TV) REFERENCES TV(id_TV)
);

-- Tabla Programa_Radio
CREATE TABLE Programa_Radio (
    id_programa_radio NUMBER(38),
    horario VARCHAR(26),
    podcast NUMBER(1),
    PRIMARY KEY(id_programa_radio),
    FOREIGN KEY(id_programa_radio) REFERENCES Programa(id_programa)
);

-- Tabla Tener
CREATE TABLE Tener (
    id_programa_radio NUMBER(38),
    id_radio NUMBER(38),
    PRIMARY KEY(id_programa_radio, id_radio),
    FOREIGN KEY(id_programa_radio) REFERENCES Programa_Radio(id_programa_radio),
    FOREIGN KEY(id_radio) REFERENCES Radio(id_radio)
);

-- Tabla Publicacion
CREATE TABLE Publicacion (
    id_publicacion NUMBER(38),
    texto VARCHAR2(1024),
    data_creacion DATE,
    likes NUMBER(38),
    republicaciones NUMBER(38),
    PRIMARY KEY(id_publicacion)
);

CREATE TABLE Mime (
    id_mime NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    tipo VARCHAR2(26),
    id_publicacion NUMBER(38),
    PRIMARY KEY(id_mime),
    FOREIGN KEY (id_publicacion) REFERENCES Publicacion (id_publicacion)
);

-- Tabla Usuario
CREATE TABLE Usuario (
    id_usuario NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    username VARCHAR2(128),
    data_creacion DATE,
    verificado NUMBER(1),
    ciudad_residencia VARCHAR2(128),
    PRIMARY KEY(id_usuario)
);

-- Tabla Comunicador
CREATE TABLE Comunicador (
    id_comunicador NUMBER(38),
    especialidades VARCHAR2(128),
    id_usuario NUMBER(38),
    PRIMARY KEY(id_comunicador),
    FOREIGN KEY(id_comunicador) REFERENCES Persona(id_persona),
    FOREIGN KEY(id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla Participar
CREATE TABLE Participar (
    id_participar NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    id_comunicador NUMBER(38),
    id_programa NUMBER(38),
    rol VARCHAR2(26),
    PRIMARY KEY(id_participar),
    FOREIGN KEY(id_comunicador) REFERENCES Comunicador(id_comunicador),
    FOREIGN KEY(id_programa) REFERENCES Programa(id_programa)
);

-- Tabla Diseminar
CREATE TABLE Diseminar (
    id_usuario NUMBER(38),
    id_programa NUMBER(38),
    PRIMARY KEY(id_usuario, id_programa),
    FOREIGN KEY(id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY(id_programa) REFERENCES Programa(id_programa)
);

-- Tabla Añadir
CREATE TABLE Añadir (
    id_etiqueta NUMBER(38),
    id_usuario NUMBER(38),
    id_publicacion NUMBER(38),
    PRIMARY KEY(id_etiqueta, id_usuario, id_publicacion),
    FOREIGN KEY(id_etiqueta) REFERENCES Etiqueta(id_etiqueta),
    FOREIGN KEY(id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY(id_publicacion) REFERENCES Publicacion(id_publicacion)
);

-- Tabla Imagen
CREATE TABLE Imagen (
    id_imagen NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    titulo VARCHAR2(128),
    ruta_archivo VARCHAR2(128),
    id_publicacion NUMBER(38),
    PRIMARY KEY(id_imagen),
    FOREIGN KEY(id_publicacion) REFERENCES Publicacion(id_publicacion)
);

-- Tabla Respuesta
CREATE TABLE Respuesta (
    id_respuesta NUMBER(38) GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    publicacion_asociada NUMBER(38),
    id_publicacion NUMBER(38),
    respuesta NUMBER(38),
    PRIMARY KEY(id_respuesta),
    FOREIGN KEY(id_publicacion) REFERENCES Publicacion(id_publicacion),
    FOREIGN KEY(respuesta) REFERENCES Respuesta(id_respuesta)
);

-- Tabla Ubicar
CREATE TABLE Ubicar (
    id_publicacion NUMBER(38),
    id_emplazamiento NUMBER(38),
    PRIMARY KEY(id_publicacion, id_emplazamiento),
    FOREIGN KEY(id_publicacion) REFERENCES Publicacion(id_publicacion),
    FOREIGN KEY(id_emplazamiento) REFERENCES Emplazamiento(id_emplazamiento)
);

-- Tabla Localizar
CREATE TABLE Localizar (
    id_emplazamiento NUMBER(38),
    id_programa NUMBER(38),
    PRIMARY KEY(id_emplazamiento, id_programa),
    FOREIGN KEY(id_emplazamiento) REFERENCES Emplazamiento(id_emplazamiento),
    FOREIGN KEY(id_programa) REFERENCES Programa(id_programa)
);

-- Tabla Publicar
CREATE TABLE Publicar (
    id_publicacion NUMBER(38),
    id_usuario NUMBER(38),
    PRIMARY KEY(id_publicacion, id_usuario),
    FOREIGN KEY(id_publicacion) REFERENCES Publicacion(id_publicacion),
    FOREIGN KEY(id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla Audiencia
CREATE TABLE Audiencia (
    id_audiencia NUMBER(38) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    rango_edades VARCHAR(28),
    interes_principal VARCHAR(128),
    PRIMARY KEY(id_audiencia)
);

-- Tabla Dirigida
CREATE TABLE Dirigida (
    id_campaña VARCHAR2(128),
    id_audiencia NUMBER(38),
    PRIMARY KEY(id_campaña, id_audiencia),
    FOREIGN KEY(id_campaña) REFERENCES Campaña(id_campaña),
    FOREIGN KEY(id_audiencia) REFERENCES Audiencia(id_audiencia)
);

-- Tabla Categoria
CREATE TABLE Categoria (
    id_categoria NUMBER(38) GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    nombre VARCHAR(128),
    descripcion VARCHAR(128),
    PRIMARY KEY(id_categoria)
);

-- Tabla Anuncio
CREATE TABLE Anuncio (
    id_anuncio NUMBER(38),
    id_categoria NUMBER(38),
    id_campaña VARCHAR2(128),
    titulo VARCHAR(128),
    descripcion VARCHAR(133),
    formato VARCHAR(128),
    estado VARCHAR(128),
    data_creacion DATE,
    PRIMARY KEY(id_anuncio),
    FOREIGN KEY(id_categoria) REFERENCES Categoria(id_categoria),
    FOREIGN KEY(id_campaña) REFERENCES Campaña(id_campaña)
);

-- Tabla SubCategoria
CREATE TABLE SubCategoria (
    id_categoria_padre NUMBER(38),
    id_subcategoria NUMBER(38),
    PRIMARY KEY(id_categoria_padre, id_subcategoria),
    FOREIGN KEY(id_categoria_padre) REFERENCES Categoria(id_categoria)
);

-- Tabla Difundir
CREATE TABLE Difundir (
    id_emplazamiento NUMBER(38),
    id_anuncio NUMBER(38),
    PRIMARY KEY(id_emplazamiento, id_anuncio),
    FOREIGN KEY(id_emplazamiento) REFERENCES Emplazamiento(id_emplazamiento),
    FOREIGN KEY(id_anuncio) REFERENCES Anuncio(id_anuncio)
);

-- Tabla Jugador
CREATE TABLE Jugador (
    id_persona NUMBER(38),
    posicion_favorita VARCHAR(26),
    pie_favorito VARCHAR(26),
    PRIMARY KEY(id_persona),
    FOREIGN KEY(id_persona) REFERENCES Persona(id_persona)
);

-- Tabla Jugador_Club
CREATE TABLE Jugador_Club (
    id_club NUMBER(38),
    id_persona NUMBER(38),
    fecha_empieza DATE,
    fecha_acaba DATE,
    PRIMARY KEY(id_persona, id_club),
    FOREIGN KEY(id_persona) REFERENCES Jugador(id_persona),
    FOREIGN KEY(id_club) REFERENCES Club(id_club)
);

-- Tabla Entrenador
CREATE TABLE Entrenador (
    id_persona NUMBER(38),
    tacticas VARCHAR(255),
    estilo_entrenamiento VARCHAR(255),
    PRIMARY KEY(id_persona),
    FOREIGN KEY(id_persona) REFERENCES Persona(id_persona)
);

-- Tabla Entrenador_Club
CREATE TABLE Entrenador_Club (
    id_club NUMBER(38),
    id_persona NUMBER(38),
    fecha_empieza DATE,
    fecha_acaba DATE,
    PRIMARY KEY(id_club, id_persona),
    FOREIGN KEY(id_club) REFERENCES Club(id_club),
    FOREIGN KEY(id_persona) REFERENCES Entrenador(id_persona)
);

-- Tabla Arbitro
CREATE TABLE Arbitro (
    id_persona NUMBER(38),
    certificacion VARCHAR(255),
    PRIMARY KEY(id_persona),
    FOREIGN KEY(id_persona) REFERENCES Persona(id_persona)
);

-- Tabla Jugador_Partido
CREATE TABLE Jugador_Partido (
    id_persona NUMBER(38),
    id_partido VARCHAR2(26),
    pie_jugado VARCHAR2(26),
    altura NUMBER(38),
    peso NUMBER(38),
    chutes NUMBER(38),
    chutes_puerta NUMBER(38),
    amarillas NUMBER(38),
    rojas NUMBER(38),
    goles NUMBER(38),
    asistencias NUMBER(38),
    posicion VARCHAR(255),
    PRIMARY KEY(id_persona, id_partido),
    FOREIGN KEY(id_partido) REFERENCES Partido(id_partido),
    FOREIGN KEY(id_persona) REFERENCES Jugador(id_persona)
);

-- Tabla Arbitro_Partido
CREATE TABLE Arbitro_Partido (
    id_persona NUMBER(38),
    id_partido VARCHAR2(26),
    rol VARCHAR(255),
    PRIMARY KEY(id_persona, id_partido, rol),
    FOREIGN KEY(id_persona) REFERENCES Arbitro(id_persona),
    FOREIGN KEY(id_partido) REFERENCES Partido(id_partido)
);

--TABLA Emplazamiento_Instalacion

CREATE TABLE Emplazamiento_Instalacion (
    id_instalacion NUMBER(38),
    id_emplazamiento NUMBER(38),
    PRIMARY KEY (id_instalacion, id_emplazamiento),
    FOREIGN KEY (id_instalacion) REFERENCES Instalacion (id_instalacion),
    FOREIGN KEY (id_emplazamiento) REFERENCES Emplazamiento (id_emplazamiento)
);

-- Tabla WarningsList
CREATE TABLE WarningsList (
    affected_table VARCHAR(30) NOT NULL,
    error_message VARCHAR(255) NOT NULL,
    id_reference VARCHAR(255) NOT NULL,
    date_warning DATE NOT NULL,
    user_warning VARCHAR(255) NOT NULL
);