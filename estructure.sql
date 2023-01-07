DROP TRIGGER CONTRUNSERVER;
DROP TRIGGER CONTENEDOR_SERVIDOR_ASIGNACION;
DROP TRIGGER CAMBIO_ESTADO_EN_CONTENEDOR;
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
CREATE OR REPLACE TRIGGER cambio_estado_en_contenedor BEFORE INSERT OR DELETE OR UPDATE ON contenedor
    REFERENCING OLD AS old
    for each row
        declare oldState varchar(12);
    begin
    IF UPDATING THEN
        if (:old.estado != :new.estado)then
            INSERT INTO LOG(usuario,accion,destino,argumentos) VALUES('1','ContainerCh',:new.id,:new.estado);
        else
            INSERT INTO LOG(usuario,accion,destino) VALUES('1','nothing',:new.id);
        END IF;
    END IF;
    
    IF INSERTING THEN
        INSERT INTO LOG(usuario,accion,destino,argumentos) VALUES('1','AppUp',:new.id,:new.aplicacion);
    END IF;
    
    IF DELETING THEN
        INSERT INTO LOG(usuario,accion,destino,argumentos) VALUES('1','AppDown',:new.id,:new.aplicacion);
    END IF;
    
    END;
/


CREATE OR REPLACE TRIGGER contenedor_servidor_asignacion BEFORE INSERT OR UPDATE ON contenedorServidor
    referencing old as old
    for each row
    declare
         EXITSCONTAINER character;
    begin
        select id into exitsContainer from contenedor where id=:old.contenedor_id;
        if exitsContainer != '' THEN
            INSERT INTO contenedorServidor VALUES(:old.servidor_nombre,:old.contenedor_id);
        ELSE 
            RAISE_APPLICATION_ERROR(12,'El contenedor que estas intentando asociar al servidor no existe');
        END IF;
    end;

/
CREATE OR REPLACE TRIGGER contrunserver BEFORE INSERT OR UPDATE ON contenedorServidor
    referencing OLD as old
    for each row
    DECLARE
         totalContainerRunning NUMBER;
         serversize VARCHAR(2);
         limitExeced BOOLEAN;
    BEGIN      
        select COUNT (*) into totalContainerRunning from contenedor where estado='running';
        select servidorsize into serversize from servidor where nombre=:old.servidor_nombre;
        case serversize
            when 's' THEN
                if (totalContainerRunning < 5) then
                    limitExeced := true;
                end if;
            when 'm' THEN
               if (totalContainerRunning < 10) then
                    limitExeced := true;
                end if;
            when 'l' THEN
               if (totalContainerRunning < 15) then
                    limitExeced := true;
                end if;
            when 'xl' THEN
              if (totalContainerRunning < 50) then
                    limitExeced := true;
                end if;
            else
                limitExeced := false;
        end case;
        if limitExeced then
            RAISE_APPLICATION_ERROR(-9000,'El servidor no puede ejecutar más contenedores');
        end if;
     END;
/
CREATE or replace TRIGGER domainRegister BEFORE UPDATE OR INSERT on registro
    for each row
   declare
    type array_t is varray(8) of varchar2(12);
    array array_t := array_t ('A','AAAA','CAA','CNAME','MX','NS','SRV','TXT');
     correct boolean :=false;
    begin
        for i in 1..array.count loop
          if :new.tipo = array(i) then
            correct := true;
        end if;
       end loop;
        if correct = false then
            RAISE_APPLICATION_ERROR(-9001,'El registro tiene un tipo invalido');
        end if;
END;
