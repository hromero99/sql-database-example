DROP TABLE registro;
DROP TABLE DNS;
DROP TABLE log;
DROP TABLE log_servidor;
DROP TABLE contenedor;
DROP TABLE servidor;
DROP TABLE contenedorServidor;
DROP TABLE aplicacion;



CREATE TABLE DNS(
    nombre varchar(40) primary key,
    expirar_date DATE,
    protegido number(1,0)
);

CREATE TABLE registro (

    nombre varchar(40) not null,
    valor varchar(40) not null,
    ttl number default 3600 not null,
    dns varchar(12),
    tipo varchar(12),
    constraint dns FOREIGN KEY (dns) references dns(nombre),
    constraint dnstype check (tipo in ('A','AAAA','CAA','CNAME','MX','NS','SRV','TXT'))
);

CREATE TABLE servidor(

    nombre varchar(12) primary key,
    ipv4 varchar(12) not null
);

CREATE TABLE LOG (
    usuario varchar(20) not null,
    accion varchar(14) not null,
    destino varchar(14) not null,
    argumentos varchar(14),
    estampatiempo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(usuario,accion,estampatiempo)
);

CREATE TABLE log_servidor(
    servidor varchar(12) not null,
    CONSTRAINT servidorLog FOREIGN KEY (servidor) REFERENCES servidor(nombre)
);


CREATE TABLE aplicacion (

    nombre varchar(12) primary key,
    descripcion varchar(200),
    tipo varchar(12),
    playbook BFILE
);


CREATE TABLE contenedor (

    id varchar(64) primary key,
    nombre varchar(20) not null,
    estado varchar(10),
    aplicacion varchar(12),
    constraint contenedorAplicacion FOREIGN KEY (aplicacion) references aplicacion(nombre),
    constraint estadotype check (estado in ('running','stopped','restarting','aborted'))
);


CREATE TABLE contenedorServidor(
    servidor_nombre varchar(12),
    contenedor_id varchar(64),
    constraint servidor foreign KEY (servidor_nombre) references servidor(nombre),
    constraint contenedor foreign key (contenedor_id) references contenedor(id)
    
);


-- Trigger para generar entradas en la auditoria
DROP TRIGGER cambio_estado_en_contenedor;
CREATE OR REPLACE TRIGGER cambio_estado_en_contenedor BEFORE UPDATE ON contenedor
    REFERENCING OLD AS old
    for each row
        declare oldState varchar(12);
    begin
    if (:old.estado != :new.estado)then
        INSERT INTO LOG(usuario,accion,destino,argumentos) VALUES('1','ContainerCh',:new.id,:new.estado);
    else
        INSERT INTO LOG(usuario,accion,destino) VALUES('1','nothing',:new.id);
    END IF;
    END;
/
INSERT INTO contenedor(id,nombre,estado) values('123','prueba1','running');
update contenedor set estado='stopped' where id='123';

select * from log;
delete from  log where usuario != -1;
