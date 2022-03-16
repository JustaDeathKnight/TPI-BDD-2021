-- Modificaciones del Esquema

ALTER TABLE Tipo_componente
ADD nro integer DEFAULT NULL,
ADD precio decimal(9,2) DEFAULT NULL,
ADD nombre varchar(45) DEFAULT NULL;
create index componente_index ON  Tipo_componente(nro);

CREATE TABLE compuesto_por(
componente_contenedor  int,
componente_contenido int,
CONSTRAINT pk_compuesto_por PRIMARY KEY(componente_contenedor, componente_contenido));
create index componente_contenedor_index ON compuesto_por(componente_contenedor);
create index componente_contenido_index ON compuesto_por(componente_contenido);

ALTER TABLE compuesto_por
ADD CONSTRAINT fk_componente_contenedor FOREIGN KEY(componente_contenedor) REFERENCES  Tipo_componente(nro),
ADD CONSTRAINT fk_componente_contenido FOREIGN KEY(componente_contenido) REFERENCES  Tipo_componente(nro);

-- DATOS

-- #5 esta formado por 6 y 7
-- #6 esta formado por 8
-- #7 esta formado por 15
-- #8 esta formado por 14
-- #9 esta formado por 10 y 11
-- #12 esta formado por 11 y 13
-- #13 esta formado por 11 */

UPDATE  Tipo_componente SET nro = 1,  nombre ='Conducto Dual Interno' WHERE codigo = 1;
UPDATE  Tipo_componente SET nro = 2,  nombre ='Computadora avionica' WHERE codigo = 2;
UPDATE  Tipo_componente SET nro = 3,  nombre ='Actuador Catalitico' WHERE codigo = 3;
UPDATE  Tipo_componente SET nro = 4,  nombre ='Conmutador de Flujo' WHERE codigo = 4;
UPDATE  Tipo_componente SET nro = 5,  nombre ='Inyector Subdual Plasmatico' WHERE codigo = 5;
UPDATE  Tipo_componente SET nro = 6,  nombre ='Tornillo N45' WHERE codigo = 6;
UPDATE  Tipo_componente SET nro = 7,  nombre ='Reciclador Catalitico Interno' WHERE codigo = 7;
UPDATE  Tipo_componente SET nro = 8,  nombre ='Giroscopio Coaxial Automatico' WHERE codigo = 8;
UPDATE  Tipo_componente SET nro = 9,  nombre ='Junta Holografica Principal' WHERE codigo = 9;
UPDATE  Tipo_componente SET nro = 10, nombre ='Inyector Holografico' WHERE codigo = 10;
UPDATE  Tipo_componente SET nro = 11, nombre ='Interruptor Subespacial De Emergencia' WHERE codigo= 11;
UPDATE  Tipo_componente SET nro = 12, nombre ='Reciclador Coaxial' WHERE codigo = 12;
UPDATE  Tipo_componente SET nro = 13, nombre ='Giroscopio Dual Automatico' WHERE codigo = 13;
UPDATE  Tipo_componente SET nro = 14, nombre ='Conmutador Holografico Plasmatico' WHERE codigo = 14;
UPDATE  Tipo_componente SET nro = 15, nombre ='Inyector Trifasico Rotatorio' WHERE codigo = 15;
UPDATE  Tipo_componente SET nro = 16, nombre ='Sanguchito de Miga Aeroespacial' WHERE codigo =16;
insert into compuesto_por(componente_contenedor, componente_contenido) values(1,2);
insert into compuesto_por(componente_contenedor, componente_contenido) values(1,3);
insert into compuesto_por(componente_contenedor, componente_contenido) values(1,4);
insert into compuesto_por(componente_contenedor, componente_contenido) values(1,16);
insert into compuesto_por(componente_contenedor, componente_contenido) values(5,6);
insert into compuesto_por(componente_contenedor, componente_contenido) values(5,7);
insert into compuesto_por(componente_contenedor, componente_contenido) values(6,8);
insert into compuesto_por(componente_contenedor, componente_contenido) values(7,15);
insert into compuesto_por(componente_contenedor, componente_contenido) values(8,14);
insert into compuesto_por(componente_contenedor, componente_contenido) values(9,10);
insert into compuesto_por(componente_contenedor, componente_contenido) values(9,11);
insert into compuesto_por(componente_contenedor, componente_contenido) values(12,11);
insert into compuesto_por(componente_contenedor, componente_contenido) values(12,13);
insert into compuesto_por(componente_contenedor, componente_contenido) values(13,11);