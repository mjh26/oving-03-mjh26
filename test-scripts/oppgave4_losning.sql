--1. Implementer RLS på `studenter`-tabellen slik at studenter bare ser sitt eget data
   --Hint: Bruk samme pattern som `emneregistreringer`
--Aktivert RLS på studenter, laget en policy som bruker current-user og bruker_student_mapping:
ALTER TABLE studenter ENABLE ROW LEVEL SECURITY;

CREATE POLICY student_see_self ON studenter
    FOR SELECT
    TO student_role
    USING (
        student_id = (
            SELECT student_id
            FROM bruker_student_mapping
            WHERE brukernavn = current_user
        )
    );


--2. Opprett en policy som tillater foreleser å se alle karakterer
   --Hint: Opprett en policy for `foreleser_role` uten USING-betingelse
--Lagde SELECT-policy for foreleser-role på emneregistrering med USING (true):
CREATE POLICY foreleser_see_all ON emneregistreringer
    FOR SELECT
    TO foreleser_role
    USING (true);


--3. Lag en view `foreleser_karakteroversikt` som viser studentnavn, emnenavn og karakterer
   --Hint: JOIN `studenter`, `emner` og `emneregistreringer`
--Lagde et view som JOIN studenter, emner og emneregistrering for forelesere har samlet oversiktig:
CREATE OR REPLACE VIEW foreleser_karakteroversikt AS
SELECT
    s.student_id,
    s.fornavn,
    s.etternavn,
    e.emne_navn,
    er.karakter,
    er.semester
FROM emneregistreringer er
JOIN studenter s ON er.student_id = s.student_id
JOIN emner e ON er.emne_id = e.emne_id;

GRANT SELECT ON foreleser_karakteroversikt TO foreleser_role;


--4. Implementer en policy som forhindrer at noen sletter karakterer (bare admin kan gjøre det)
   --Hint: Bruk `FOR DELETE` i policyen
--Lagde en DELETE-policy med USING (false) for at ingen brukere kan slette karakterer.
CREATE POLICY no_delete_grades ON emneregistreringer
    FOR DELETE
    USING (false);


--5. Lag en audit-tabell som logger alle endringer av karakterer
   --Hint: Bruk triggers (se Bonus-seksjonen under)
--Laget en audit-tabell og en trigger som logger karakterendringer:
CREATE TABLE IF NOT EXISTS karakter_audit (
    audit_id SERIAL PRIMARY KEY,
    registrering_id INT,
    gammel_karakter TEXT,
    ny_karakter TEXT,
    endret_av TEXT,
    endret_tidspunkt TIMESTAMP DEFAULT now()
);

CREATE OR REPLACE FUNCTION logg_karakter_endring()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.karakter IS DISTINCT FROM OLD.karakter THEN
        INSERT INTO karakter_audit (
            registrering_id,
            gammel_karakter,
            ny_karakter,
            endret_av
        )
        VALUES (
            OLD.registrering_id,
            OLD.karakter,
            NEW.karakter,
            current_user
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_logg_karakter_endring
AFTER UPDATE ON emneregistreringer
FOR EACH ROW
EXECUTE FUNCTION logg_karakter_endring();

