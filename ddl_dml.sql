create database GestioneCondomini;

create table condominio(
    codice integer primary key,
    contoCorrente varchar(12) NOT NULL, -- ZEROFILL
    indirizzo varchar(50) NOT NULL,
    ammontareComplessivo numeric(6,2) DEFAULT 0.00
);

create table spesa (
    dataOra timestamp,
    condominio integer references condominio (codice),
    importo numeric(6,2) NOT NULL check (importo > 0.00),
    causale varchar(50) NOT NULL,
    CONSTRAINT pk_spesa primary key (dataOra, condominio)
);

create domain cf as varchar(16)
    CHECK (length(value) = 16);

create table persona (
    cf_ cf primary key,
    nome varchar(20),
    indirizzo varchar(50),
    numeroAppartamento integer,
    condominio integer
);

create table appartamento (
    numero integer check ((numero >= 1) and (numero <= 50)),
    condominio integer references condominio (codice),
    quotaAnnoCorrente numeric(6,2) NOT NULL check (quotaAnnoCorrente >= 0),
    sommaPagata numeric(6,2) NOT NULL,
    telefono varchar(10) check (telefono SIMILAR TO '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    superficie integer NOT NULL check (superficie >= 1),
    proprietario cf NOT NULL,
    CONSTRAINT pk_appartamento primary key (numero, condominio)
);

ALTER TABLE persona
    ADD CONSTRAINT fk_persona_app foreign key (numeroAppartamento, condominio)
    references appartamento(numero, condominio);

ALTER TABLE appartamento
    ADD CONSTRAINT fk_app_persona foreign key (proprietario) references persona(cf_);

