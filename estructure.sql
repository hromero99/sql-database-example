DROP TABLE registro;
DROP TABLE DNS;
drop table contenedorServidor;
drop table aplicacionServidor;
DROP TABLE servidor;
DROP TABLE aplicacion;
DROP TABLE contenedor;
DROP TABLE aplicacion;


CREATE TABLE DNS(
    nombre varchar(12) primary key,
    expirar_date DATE,
    protegido boolean
);

CREATE TABLE registro (

    nombre varchar(12) not null,
    valor varchar(12) not null,
    ttl number default 3600 not null,
    dns varchar(12),
    tipo varchar(12),
    constraint dns FOREIGN KEY (dns) references dns(nombre),
    constraint dnstype check (tipo in ('A','AAAA','CAA','CNAME','MX','NS','SRV','TXT'))
);

CREATE TABLE servidor (

    nombre varchar(12) primary key,
    ipv4 varchar(12) not null
);

CREATE TABLE contenedor (

    id varchar(64) primary key,
    nombre varchar(20) not null,
    estado varchar(10),
    constraint estadotype check (estado in ('running','stopped','restarting','aborted'))
);

CREATE TABLE contenedorServidor(
    servidor_nombre varchar(12),
    contenedor_id varchar(64),
    constraint servidor foreign KEY (servidor_nombre) references servidor(nombre),
    constraint contenedor foreign key (contenedor_id) references contenedor(id)
    
);

CREATE TABLE aplicacion (

    nombre varchar(12) primary key,
    descripcion varchar(200),
    tipo varchar(12),
    playbook BFILE
);

CREATE TABLE aplicacionServidor(
    aplicacionNombre varchar(12),
    servidorNombre varchar(12),
    constraint servidorAplicacionFK foreign key (servidorNombre) references servidor(nombre),
    constraint aplicacionServidorFK foreign key (aplicacionNombre) references aplicacion(nombre)
);

