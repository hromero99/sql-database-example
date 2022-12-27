-- Insertar catalogo de aplicaciones

INSERT INTO aplicacion(nombre,descripcion,tipo) values('Wordpress','CMS para poder crear contenido web de forma simple basada en PHP', 'website');
INSERT INTO aplicacion(nombre,descripcion,tipo) values('Odoo','ERP/CRM para el control y la gestión de todos los procesos de una compañia', 'ERP');
INSERT INTO aplicacion(nombre,descripcion,tipo) values('Dolibarr','ERP para la gestión de compañias', 'ERP');
INSERT INTO aplicacion(nombre,descripcion,tipo) values('ExpenseseApp','Aplicación para la gestión de gastos', 'ERP');
INSERT INTO aplicacion(nombre,descripcion,tipo) values('Nextcloud','Sistema de gestión online de ficheros de código abierto', 'utilidades');
INSERT INTO aplicacion(nombre,descripcion,tipo) values('Vault','Aplicación para almacenar y compartir de forma segura contraseñas', 'seguridad');
INSERT INTO aplicacion(nombre,descripcion,tipo) values('Moodle','CMS para gestionar contenido de docencia', 'website');

-- Insertar catalogo de DNS

INSERT INTO dns(nombre,expirar_date,protegido) VALUES('hromerol.es','01-12-2023',0);
INSERT INTO dns(nombre,expirar_date,protegido) VALUES('hromero99.es','01-12-2023',0);
INSERT INTO dns(nombre,expirar_date,protegido) VALUES('aplicacioneshromero.es','01-12-2023',0);
INSERT INTO dns(nombre,expirar_date,protegido) VALUES('demoaplicaciones.es','01-12-2023',1);



-- Insertar catalogo de registros
INSERT INTO registro(nombre,valor,ttl,tipo,dns) VALUES('cliente1.hromerol.es','192.168.1.10',3600,'A',1);
INSERT INTO registro(nombre,valor,ttl,tipo,dns) VALUES('cliente2.hromerol.es','192.168.1.12',3600,'A',1);
INSERT INTO registro(nombre,valor,ttl,tipo,dns) VALUES('cliente3.hromerol.es','192.168.1.13',3600,'A',1);
INSERT INTO registro(nombre,valor,ttl,tipo,dns) VALUES('cliente4.hromerol.es','192.168.1.14',3600,'A',1);

select * from dns;