-- Codice SQL per la creazione delle tabelle, e dei trigger
-- 
-- Alcuni campi sono racchiusi tra doppi apici poiché PostgreSQL
-- è case-insensitive anche sul nome dei campi
-- (a meno che non siano racchiusi tra doppi apici)

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table condominio(
    codice INTEGER PRIMARY KEY,
    "contoCorrente" VARCHAR(12) NOT NULL, -- ZEROFILL
    indirizzo VARCHAR(50) NOT NULL,
    "ammontareComplessivo" NUMERIC(8,2) DEFAULT 0.00
);

create table spesa (
    "dataOra" TIMESTAMP,
    condominio INTEGER REFERENCES condominio (codice),
    importo NUMERIC(6,2) NOT NULL CHECK (importo > 0.00),
    causale VARCHAR(50) NOT NULL,
    CONSTRAINT pk_spesa PRIMARY KEY ("dataOra", condominio)
);

create domain cf_domain as varchar(16)
    CHECK (length(value) = 16);

create table persona (
    cf cf_domain PRIMARY KEY,
    "dataNascita" DATE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    indirizzo VARCHAR(50),
    "numeroAppartamento" INTEGER NOT NULL,
    condominio INTEGER NOT NULL
);

create table appartamento (
    numero INTEGER CHECK ((numero >= 1) and (numero <= 50)),
    condominio INTEGER REFERENCES condominio (codice),
    "quotaAnnoCorrente" NUMERIC(6,2) NOT NULL CHECK ("quotaAnnoCorrente" >= 0),
    "sommaPagata" NUMERIC(6,2) NOT NULL,
    telefono CHAR(10) CHECK (telefono SIMILAR TO '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    superficie INTEGER NOT NULL CHECK (superficie >= 1),
    proprietario cf_domain NOT NULL,
    CONSTRAINT pk_appartamento PRIMARY KEY (numero, condominio)
);

ALTER TABLE persona
    ADD CONSTRAINT fk_persona_app FOREIGN KEY ("numeroAppartamento", condominio)
    REFERENCES appartamento(numero, condominio);

ALTER TABLE appartamento
    ADD CONSTRAINT fk_app_persona FOREIGN KEY (proprietario) REFERENCES persona(cf)
    DEFERRABLE INITIALLY DEFERRED;

CREATE VIEW proprietario AS
SELECT cf, indirizzo
FROM persona AS P
JOIN appartamento AS A ON P.cf = A.proprietario;

-- indirizzo proprietario è null SSE possiede l'appartamento (numeroAppartamento, condominio),
-- nel quale ci abita
CREATE OR REPLACE FUNCTION deriva_indirizzo_persona()
RETURNS trigger AS
$$
DECLARE
    indirizzo_derivato VARCHAR(50);
BEGIN
    PERFORM numero
    FROM appartamento A WHERE A.proprietario = new.cf;

    IF FOUND THEN
        PERFORM numero
        FROM appartamento A
        WHERE A.numero = new."numeroAppartamento"
            AND A.condominio = new.condominio
            AND A.proprietario = new.cf;

        IF NOT FOUND THEN
            SELECT C.indirizzo INTO indirizzo_derivato
            FROM condominio C
            WHERE C.codice = new.condominio;
            new.indirizzo = indirizzo_derivato;
        ELSE
            new.indirizzo = NULL;
        END IF;
    ELSE
        new.indirizzo = NULL;
    END IF;

    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_ind_persona
BEFORE INSERT OR UPDATE ON persona
FOR EACH ROW
EXECUTE FUNCTION deriva_indirizzo_persona();


CREATE OR REPLACE FUNCTION aggiorna_ammontareComplessivo()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE condominio
    SET "ammontareComplessivo" = "ammontareComplessivo" + new.importo
    WHERE codice = new.condominio;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aggiorna_ammontare
AFTER INSERT ON spesa
FOR EACH ROW
EXECUTE FUNCTION aggiorna_ammontareComplessivo();

CREATE INDEX idx_appartamento_proprietario ON appartamento (proprietario);

CREATE INDEX idx_condominio_ammontareComplessivo ON condominio ("ammontareComplessivo");

CREATE INDEX idx_persona_dataNascita ON persona ("dataNascita");

CREATE INDEX idx_appartamento_superficie ON appartamento (superficie);
