DROP DATABASE IF EXISTS BDA_TPI;

CREATE DATABASE BDA_TPI DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;

USE BDA_TPI;

CREATE TABLE IF NOT EXISTS Agencia(
	nombre VARCHAR(45),
	personal INT UNSIGNED NOT NULL,
	tipo VARCHAR(45) NOT NULL,
	CONSTRAINT pk_agencias PRIMARY KEY(nombre)
);

CREATE TABLE IF NOT EXISTS Publica(
	nombre VARCHAR(45),
	nombre_e VARCHAR(45) NOT NULL,
	CONSTRAINT pk_publica PRIMARY KEY (nombre),
	CONSTRAINT fk_publica FOREIGN KEY (nombre) REFERENCES Agencia(nombre)
	ON DELETE NO ACTION
	ON UPDATE CASCADE
);

CREATE INDEX idx_nombre_e ON Publica(nombre_e) USING HASH;

CREATE TABLE IF NOT EXISTS Privada(
	nombre VARCHAR(45),
	nombre_publica VARCHAR(45) NOT NULL,
	CONSTRAINT pk_publica PRIMARY KEY(nombre),
	CONSTRAINT fk_publica_agencia FOREIGN KEY (nombre) REFERENCES Agencia(nombre),
	CONSTRAINT fk_publica_supervisa FOREIGN KEY (nombre_publica) REFERENCES Publica(nombre_e)
	ON DELETE NO ACTION
	ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Empresa(
	CIF VARCHAR(45),
	nombre VARCHAR(45) NOT NULL,
	capital DECIMAL(11,2) UNSIGNED NOT NULL,
	CONSTRAINT pk_empresas PRIMARY KEY(CIF)
);

CREATE TABLE IF NOT EXISTS Financia(
	nombre VARCHAR(45),
	CIF VARCHAR(45),
	porcentaje SMALLINT NOT NULL,
	CONSTRAINT pk_financia PRIMARY KEY (nombre, CIF),
	CONSTRAINT fk_financia_privada FOREIGN KEY (nombre) REFERENCES Privada(nombre),
	CONSTRAINT fk_financia_empresa FOREIGN KEY (CIF) REFERENCES Empresa(CIF)
);

CREATE TABLE IF NOT EXISTS Clase_nave(
	prefijo VARCHAR(45),
	nombre VARCHAR(45) NOT NULL,
	CONSTRAINT pk_clase_nave PRIMARY KEY (prefijo)
);

CREATE TABLE IF NOT EXISTS Nave(
	prefijo VARCHAR(45),
	matricula VARCHAR(10),
	mision VARCHAR(45),
	nombre VARCHAR(45),
	nombre_agencia_prop VARCHAR(45),
	CONSTRAINT pk_nave PRIMARY KEY (prefijo, matricula),
	CONSTRAINT fk_clase_nave FOREIGN KEY (prefijo) REFERENCES Clase_nave(prefijo) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE,
	CONSTRAINT fk_naves_agencia_prop FOREIGN KEY (nombre_agencia_prop) REFERENCES Agencia(nombre)
);

CREATE INDEX idx_matricula ON Nave(matricula) USING HASH;

CREATE TABLE IF NOT EXISTS Tipo_componente(
	codigo SMALLINT AUTO_INCREMENT,
	diametro DECIMAL(7,2) UNSIGNED NOT NULL,
	peso DECIMAL(7,2) UNSIGNED NOT NULL,
	prefijo VARCHAR(45) NOT NULL,
	CONSTRAINT pk_componente PRIMARY KEY (codigo),
	CONSTRAINT fk_componente FOREIGN KEY (prefijo) REFERENCES Clase_nave(prefijo)
);

CREATE TABLE IF NOT EXISTS Orbita(
	excentricidad DECIMAL(11,2),
	altura DECIMAL(11,2),
	sentido ENUM('positivo', 'negativo'),
	geostacionario BOOLEAN,
	circular BOOLEAN,
	-- CREAMOS UN TRIGGER PARA CHEQUEAR QUE SI excentricidad=0 --> circular = true
	CONSTRAINT pk_orbita PRIMARY KEY (excentricidad, altura, sentido)
);

DELIMITER //
CREATE TRIGGER verificar_excent_orbita BEFORE INSERT on Orbita for each row
	begin
		IF (new.excentricidad = 0) then
			SET new.circular= true;
		ELSE
			SET new.circular=false;
		end IF;
	end
//
DELIMITER ;

CREATE INDEX idx_altura ON Orbita(altura) USING BTREE;
CREATE INDEX idx_sentido ON Orbita(sentido) USING BTREE;

CREATE TABLE IF NOT EXISTS Basura(
	id_basura INT AUTO_INCREMENT,
	basura_padre INT DEFAULT NULL,
	velocidad DECIMAL(11,2) NOT NULL,
	tamaño DECIMAL(11,2) NOT NULL,
	peso DECIMAL(11,2) NOT NULL,
	excentricidad_orb DECIMAL(11,2) NOT NULL,
	altura_orb DECIMAL(11,2) NOT NULL,
	sentido_orb ENUM('positivo', 'negativo') NOT NULL,
	fecha DATETIME NOT NULL,
	CONSTRAINT pk_basura PRIMARY KEY (id_basura),
	CONSTRAINT fk_posicion_orb FOREIGN KEY (excentricidad_orb,altura_orb,sentido_orb) REFERENCES Orbita(excentricidad,altura,sentido),
	CONSTRAINT fk_basura_padre FOREIGN KEY (basura_padre) REFERENCES Basura(id_basura)
);

CREATE TABLE IF NOT EXISTS Posicion(
	id_basura INT,
	fecha_pos DATETIME NOT NULL,
	altura DECIMAL(11,2) NOT NULL,
	sentido ENUM('positivo', 'negativo'),
	excentricidad DECIMAL(11,2) NOT NULL,
	CONSTRAINT pk_posicion PRIMARY KEY (id_basura, fecha_pos),
	CONSTRAINT fk_posicion FOREIGN KEY (id_basura) REFERENCES Basura(id_basura) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Produce(
	prefijo VARCHAR(45),
	matricula VARCHAR(10),
	id_basura INT,
	CONSTRAINT fk_produce_basura FOREIGN KEY (id_basura) REFERENCES Basura(id_basura),
	CONSTRAINT fk_produce_nave FOREIGN KEY (prefijo, matricula) REFERENCES Nave(prefijo, matricula)
);

CREATE TABLE IF NOT EXISTS Lanza(
	fecha_lanzamiento DATETIME NOT NULL,
    nombre_agencia VARCHAR(45),
	excentricidad DECIMAL(11,2),
	altura DECIMAL(11,2),
	sentido ENUM('positivo', 'negativo'),
	prefijo VARCHAR(45),
	matricula VARCHAR(10),
	CONSTRAINT pk_lanza PRIMARY KEY (nombre_agencia, excentricidad, altura, sentido, prefijo, matricula),
	CONSTRAINT fk_lanza_nombre FOREIGN KEY (nombre_agencia) REFERENCES Agencia(nombre),
	CONSTRAINT fk_lanza_excentricidad FOREIGN KEY (excentricidad) REFERENCES Orbita(excentricidad),
	CONSTRAINT fk_lanza_altura FOREIGN KEY (altura) REFERENCES Orbita(altura),
	CONSTRAINT fk_lanza_sentido FOREIGN KEY (sentido) REFERENCES Orbita(sentido),
	CONSTRAINT fk_lanza_matricula FOREIGN KEY (prefijo, matricula) REFERENCES Nave(prefijo, matricula)
);

CREATE TABLE IF NOT EXISTS esta(
	fecha_ini DATETIME,
	fecha_fin DATETIME,
	excentricidad DECIMAL(11,2),
	altura DECIMAL(11,2),
	sentido  ENUM('positivo', 'negativo'),
	matricula VARCHAR(10) NOT NULL,
	CONSTRAINT pk_esta PRIMARY KEY (matricula, excentricidad, altura, sentido),
	CONSTRAINT fk_esta_excentricidad FOREIGN KEY (excentricidad) REFERENCES Orbita(excentricidad),
	CONSTRAINT fk_esta_altura FOREIGN KEY (altura) REFERENCES Orbita(altura),
	CONSTRAINT fk_esta_sentido FOREIGN KEY (sentido) REFERENCES Orbita(sentido),
	CONSTRAINT fk_esta_matricula FOREIGN KEY (matricula) REFERENCES Nave(matricula)
);

CREATE TABLE IF NOT EXISTS Tripulante(
	nombre VARCHAR(40) NOT NULL,
	CONSTRAINT pk_nom_tripulante PRIMARY KEY (nombre)
);

CREATE TABLE IF NOT EXISTS Tiene(
	matricula VARCHAR(10),
	nombre_trip VARCHAR(40),
	CONSTRAINT pk_nave_tiene_trip PRIMARY KEY (matricula,nombre_trip),
	CONSTRAINT fk_tiene_matricula FOREIGN KEY (matricula) REFERENCES Nave(matricula),
	CONSTRAINT fk_tiene_nombre_trip FOREIGN KEY (nombre_trip) REFERENCES Tripulante(nombre)
);