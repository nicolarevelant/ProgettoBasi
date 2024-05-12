CREATE DATABASE GestioneCondomini;

create table condominio(
    codice integer PRIMARY KEY,
    contoCorrente varchar(12) NOT NULL, -- ZEROFILL
    indirizzo varchar(50) NOT NULL,
    ammontareComplessivo numeric(6,2) DEFAULT 0.00
);

create table spesa (
    dataOra timestamp,
    condominio integer REFERENCES condominio (codice),
    importo numeric(6,2) NOT NULL CHECK (importo > 0.00),
    causale varchar(50) NOT NULL,
    CONSTRAINT pk_spesa primary key (dataOra, condominio)
);

create domain cf as varchar(16)
    CHECK (length(value) = 16);

create table persona (
    cf_ cf PRIMARY KEY,
    dataNascita date,
    nome varchar(20),
    indirizzo varchar(50),
    numeroAppartamento integer NOT NULL,
    condominio integer NOT NULL
);

create table appartamento (
    numero integer check ((numero >= 1) and (numero <= 50)),
    condominio integer REFERENCES condominio (codice),
    quotaAnnoCorrente numeric(6,2) NOT NULL CHECK (quotaAnnoCorrente >= 0),
    sommaPagata numeric(6,2) NOT NULL,
    telefono varchar(10) check (telefono SIMILAR TO '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    superficie integer NOT NULL check (superficie >= 1),
    proprietario cf NOT NULL,
    CONSTRAINT pk_appartamento PRIMARY KEY (numero, condominio)
);

ALTER TABLE persona
    ADD CONSTRAINT fk_persona_app FOREIGN KEY (numeroAppartamento, condominio)
    REFERENCES appartamento(numero, condominio);

ALTER TABLE appartamento
    ADD CONSTRAINT fk_app_persona FOREIGN KEY (proprietario) REFERENCES persona(cf_);

-- indirizzo proprietario è null SSE possiede l'appartamento (numeroAppartamento, condominio), nel quale ci abita
CREATE OR REPLACE FUNCTION deriva_indirizzo_persona()
RETURN trigger AS
$$
    DECLARE
        indirizzo_derivato varchar(50);
    BEGIN
        PERFORM appartamento.numero, appartamento.condominio
        FROM appartamento
        WHERE appartamento.proprietario = new.cf_
            AND appartamento.numero = new.numeroAppartamento
            AND appartamento.condominio = new.condominio;

        IF FOUND THEN
            UPDATE persona
            SET indirizzo = NULL
            WHERE OLD.cf_ = NEW.cf_;
        ELSE
            SELECT c.indirizzo INTO indirizzo_derivato
            FROM condominio AS c
            WHERE c.codice = new.condominio;

            UPDATE persona
            SET indirizzo = indirizzo_derivato
            WHERE OLD.cf_ = NEW.cf_;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_ind_persona
AFTER INSERT OR UPDATE ON persona
FOR EACH ROW
EXECUTE PROCEDURE deriva_indirizzo_persona();


CREATE INDEX idx_appartamento_proprietario ON appartamento (proprietario);

CREATE INDEX idx_condominio_ammontareComplessivo ON condominio (ammontareComplessivo);

CREATE INDEX idx_persona_dataNascita ON persona (dataNascita);

CREATE INDEX idx_appartamento_superficie ON appartamento (superficie);
