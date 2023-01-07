drop type dnst;
drop type aplicaciont;
drop type servidort;
drop type registro;
drop type registros_dns;
drop type dns;
drop type aplicacion;
drop type contenedores_servidor;
drop type contenedor;
drop type servidor;
drop type logreg;

CREATE TYPE registro AS OBJECT(
    nombre varchar(40),
    valor varchar(40),
    ttl number,
    tipo varchar(12)
);

CREATE TYPE registros_dns AS TABLE OF registro;

CREATE TYPE dns AS OBJECT (
    nombre varchar(40),
    expirar_date DATE,
    registros registros_dns
);
CREATE TYPE aplicacion AS OBJECT(
    nombre varchar(12),
    descripcion varchar(200),
    tipo varchar(12),
    playbook BFILE
);

CREATE TYPE contenedor AS OBJECT(
    nombre varchar(20),
    estado varchar(10),
    aplicacion aplicacion
);
CREATE TYPE contenedores_servidor AS VARRAY(50) OF contenedor;
CREATE TYPE servidor AS OBJECT(
    nombre varchar(12),
    ipv4 varchar(12),
    servidorsize varchar(2),
    contenedores contenedores_servidor
);


CREATE TYPE logreg AS OBJECT(
    usuario varchar(20),
    accion varchar(14),
    destino varchar(14),
    argumentos varchar(14),
    servidor servidor   
);


CREATE TABLE registrot of registro;
CREATE TABLE dnst of dns (PRIMARY KEY(nombre)) nested table registros store as registrost;
CREATE TABLE aplicaciont of aplicacion;
CREATE TABLE servidort of servidor (nombre primary key);

 -- Insertar en la tabla de aplicaciones
INSERT INTO aplicaciont(nombre,descripcion,tipo) values('Wordpress','CMS para poder crear contenido web de forma simple basada en PHP', 'website');
INSERT INTO aplicaciont(nombre,descripcion,tipo) values('Odoo','ERP/CRM para el control y la gestión de todos los procesos de una compañia', 'ERP');
INSERT INTO aplicaciont(nombre,descripcion,tipo) values('Dolibarr','ERP para la gestión de compañias', 'ERP');
INSERT INTO aplicaciont(nombre,descripcion,tipo) values('ExpenseseApp','Aplicación para la gestión de gastos', 'ERP');
INSERT INTO aplicaciont(nombre,descripcion,tipo) values('Nextcloud','Sistema de gestión online de ficheros de código abierto', 'utilidades');
INSERT INTO aplicaciont(nombre,descripcion,tipo) values('Vault','Aplicación para almacenar y compartir de forma segura contraseñas', 'seguridad');
INSERT INTO aplicaciont(nombre,descripcion,tipo) values('Moodle','CMS para gestionar contenido de docencia', 'website');

-- Insertar en la tabla de DNS
INSERT INTO dnst select 'hromerol.es','03/06/2023',  registro('A','192.168.1.1','A','3600') FROM registro;

INSERT INTO REGISTRO VALUES('hromerol.es','192.168.1.1','A','3600');
INSERT INTO REGISTRO VALUES('hromerol.es','192.168.1.2','A','3600');
INSERT INTO REGISTRO VALUES('hromerol.es','192.168.1.3','A','3600');
INSERT INTO REGISTRO VALUES('hromerol.es','192.168.1.4','A','3600');
INSERT INTO REGISTRO VALUES('hromerol.es','192.168.1.5','A','3600');
