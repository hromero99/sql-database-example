DROP TABLE registro;
DROP TABLE DNS;
DROP TABLE log;
DROP TABLE log_servidor;
DROP TABLE contenedorServidor;
DROP TABLE contenedor;
DROP TABLE servidor;
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
    ipv4 varchar(12) not null,
    servidorsize varchar(12) not null,
    constraint tiposervidor check (servidorsize in ('s','m','l','xl'))
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
    constraint contenedorfk foreign key (contenedor_id) references contenedor(id),
    constraint servidorfk FOREIGN KEY (servidor_nombre) references servidor(nombre)
);


-- Trigger para generar entradas en la auditoria
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

CREATE OR REPLACE TRIGGER contenedor_servidor_asignacion BEFORE INSERT OR UPDATE ON contenedorServidor
    referencing old as old
    declare character exitsContainer := "";
    begin
        select id into exitsContainer from contenedor where id=:old.contenedor_id;
        if exitsContainer != "" THEN
            INSERT INTO contenedorServidor VALUES(:old.servidor_nombre,:old.contenedor_id);
        ELSE 
            RAISE_APPLICATION_ERROR('El contenedor que estas intentando asociar al servidor no existe');
        END IF;
    end;

-- Trigger para comprobar que no se excede el numero de conenedores

CREATE OR REPLACE TRIGGER contenedores_running_en_servidor_tamano BEFORE UPDATE OR INSERT ON contenedor
    referencing old as old
    for each row
    DECLARE NUMBER totalContainerRunning;
    begin
        select COUNT (*) into totalContainerRunning from contenedor where estado='running';
end;
/

INSERT INTO contenedor(id,nombre,estado) values('123','prueba1','running');
update contenedor set estado='stopped' where id='123';

select * from log;
delete from  log where usuario != -1;


insert into servidor values ('111','192.168.1.1','xl');
INSERT INTO aplicacion(nombre,descripcion,tipo) values('ExpenseseApp','Aplicación para la gestión de gastos', 'ERP');
insert into contenedor values('1','1','running','ExpenseseApp');
insert into contenedorServidor values('111','1');
select count(*) from contenedor,contenedorservidor where estado='running' and contenedorservidor.contenedor_id=contenedor.id;
