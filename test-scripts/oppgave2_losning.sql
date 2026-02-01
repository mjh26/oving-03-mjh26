--1. Hent alle studenter som ikke har noen emneregistreringer
--(Fra 2.1) Endrer programmer til emneregistreringer, bytter join-kolonne og legger WHERE er.student_id IS NULL:
SELECT
    s.student_id,
    s.fornavn,
    s.etternavn
FROM studenter s
LEFT JOIN emneregistreringer er ON s.student_id = er.student_id
WHERE er.student_id IS NULL;


--2. Hent alle emner som ingen studenter er registrert på
--(Fra 2.1) Endrer til emner, LEFT JOIN med emneregistreringer og sjekker WHERE er.emne_id IS NULL:
SELECT
    e.emne_id, e.emne_kode, e.emne_navn
FROM emner e
LEFT JOIN emneregistreringer er ON e.emne_id = er.emne_id
WHERE er.emne_id IS NULL;


--3. Hent studentene med høyeste karakter per emne
--(Fra 3.2) Endrer AVG til MAX, og subquery for å finne studentene med høyeste karakter per emne:
SELECT
    e.emne_navn,
    s.fornavn,
    s.etternavn,
    er.karakter
FROM emneregistreringer er
JOIN studenter s ON er.student_id = s.student_id
JOIN emner e ON er.emne_id = e.emne_id
WHERE er.karakter = (
    SELECT MAX(er2.karakter)
    FROM emneregistreringer er2
    WHERE er2.emne_id = er.emne_id
);


--4. Lag en rapport som viser hver student, deres program, og antall emner de er registrert på
--(Fra 3.1) Endrer til studenter og deres program for å telle registrering_id:
SELECT
    s.fornavn,
    s.etternavn,
    p.program_navn,
    COUNT(er.registrering_id) AS antall_emner
FROM studenter s
LEFT JOIN programmer p ON s.program_id = p.program_id
LEFT JOIN emneregistreringer er ON s.student_id = er.student_id
GROUP BY s.student_id, s.fornavn, s.etternavn, p.program_navn
ORDER BY antall_emner DESC;


--5. Hent alle studenter som er registrert på både DATA1500 og DATA1100
--(Fra 2.2) Lager to SELECT spørringer, og bruker INTERSECT for å finne studenter i samme emner:
SELECT s.student_id, s.fornavn, s.etternavn
FROM studenter s
WHERE s.student_id IN (
    SELECT er.student_id
    FROM emneregistreringer er
    JOIN emner e ON er.emne_id = e.emne_id
    WHERE e.emne_kode = 'DATA1500'
)
INTERSECT
SELECT s.student_id, s.fornavn, s.etternavn
FROM studenter s
WHERE s.student_id IN (
    SELECT er.student_id
    FROM emneregistreringer er
    JOIN emner e ON er.emne_id = e.emne_id
    WHERE e.emne_kode = 'DATA1100'
);

