CREATE TABLE DNS(
    nombre varchar(12) not null,
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
