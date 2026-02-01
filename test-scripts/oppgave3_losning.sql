--1. Opprett en rolle `program_ansvarlig` som kan lese og oppdatere programmer-tabellen, men ikke slette
CREATE ROLE program_ansvarlig LOGIN PASSWORD 'program_pass';

GRANT SELECT, UPDATE ON programmer TO program_ansvarlig;


--2. Opprett en rolle `student_self_view` som bare kan se sitt eget studentdata (hint: bruk en VIEW)
CREATE OR REPLACE VIEW student_self_view AS
SELECT student_id, fornavn, etternavn, epost, program_id
FROM studenter;

CREATE ROLE student_self_view LOGIN PASSWORD 'student_view_pass';

GRANT SELECT ON student_self_view TO student_self_view;


--3. Gi `foreleser_role` tilgang til å lese fra `student_view` (som allerede er opprettet)
GRANT SELECT ON student_view TO foreleser_role;


--4. Opprett en rolle `backup_bruker` som bare har SELECT-rettighet på alle tabeller
CREATE ROLE backup_bruker LOGIN PASSWORD 'backup_pass';

GRANT SELECT ON ALL TABLES IN SCHEMA public TO backup_bruker;


--5. Lag en oversikt over alle roller og deres rettigheter
SELECT
    grantee AS rolle,
    table_name AS tabell,
    privilege_type AS rettighet
FROM information_schema.role_table_grants
WHERE grantee NOT LIKE 'pg_%'
ORDER BY rolle, tabell, rettighet;

