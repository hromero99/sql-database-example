CREATE TABLE aplicacion (

    nombre varchar(12) primary key,
    descripcion varchar(200),
    tipo varchar(12)
);


CREATE TABLE contenedor (

    id varchar(64) primary key,
    nombre varchar(20) not null,
    estado varchar(10),
    aplicacion varchar(12),
    FOREIGN KEY (aplicacion) references aplicacion(nombre)
);
