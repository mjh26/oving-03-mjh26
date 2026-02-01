# Besvarelse av refleksjonsspørsmål - DATA1500 Oppgavesett 1.3

Skriv dine svar på refleksjonsspørsmålene fra hver oppgave her.

---

## Oppgave 1: Docker-oppsett og PostgreSQL-tilkobling

### Spørsmål 1: Hva er fordelen med å bruke Docker i stedet for å installere PostgreSQL direkte på maskinen?

**Ditt svar:**

Docker gir et ferdig og isolert miljø som fungerer likt på alle maskiner, slik at man unngår komplisert installasjon og 
at PostgreSQL påvirker resten av systemet.

---

### Spørsmål 2: Hva betyr "persistent volum" i docker-compose.yml? Hvorfor er det viktig?

**Ditt svar:**

Betyr at data lagres utenfor containeren, slik at databasen ikke forsvinner når containeren stoppes eller slettes.
Dette muliggjør å starte og stoppe systemet uten å miste data.

---

### Spørsmål 3: Hva skjer når du kjører `docker-compose down`? Mister du dataene?

**Ditt svar:**

Det stopper og fjerner containeren, men dataene beholdes da de ligger i et persistent volum. 
Man mister da ikke databasen selv om containeren slettes.

---

### Spørsmål 4: Forklar hva som skjer når du kjører `docker-compose up -d` første gang vs. andre gang.

**Ditt svar:**

Første gang lastes bildet ned, containeren opprettes og databasen initialiseres. 
Den andre gangen bruker Docker de eksisterende filene og volumene, så containeren starter mye raskere uten å sette opp databasen igjen.

---

### Spørsmål 5: Hvordan ville du delt docker-compose.yml-filen med en annen student? Hvilke sikkerhetshensyn må du ta?

**Ditt svar:**

Jeg ville delt via Git eller som en vanlig tekstfil, men sørge for at det ikke inneholder passord eller andre verdier.
Slike kan ligge i miljøvariabler, ikke i selve compose-filen.

---

## Oppgave 2: SQL-spørringer og databaseskjema

### Spørsmål 1: Hva er forskjellen mellom INNER JOIN og LEFT JOIN? Når bruker du hver av dem?

**Ditt svar:**

INNER JOIN viser rader som er lik i begge tabeller.
LEFT JOIN viser alle rader fra venstre tabell, i tillegg til de som ikke er like i høyre tabell.
INNER JOIN kan brukes når man vil kun ha data som hører sammen i begge tabeller, mens LEFT JOIN når man vil beholde alle rader
fra venstre tabell, selv om noen ikke kobler sammen.
---

### Spørsmål 2: Hvorfor bruker vi fremmednøkler? Hva skjer hvis du prøver å slette et program som har studenter?

**Ditt svar:**

Det brukes for å sikre at data henger sammen riktig f.eks. en student peker alltid på et gyldig program.
Hvis man prøver å slette et program som fortsatt har studenter, vil databasen stoppe for det ville opprettet ødelagte referanser.

---

### Spørsmål 3: Forklar hva `GROUP BY` gjør og hvorfor det er nødvendig når du bruker aggregatfunksjoner.

**Ditt svar:**

GROUP BY samler rader i grupper basert på en kolonne, slik at man kan bruke funksjoner som COUNT,
SUM eller AVG på hver gruppe. Dette er nødvendig for databasen som må vite hvordan radene skal grupperes før den 
kan regne ut totalsummer eller gjennomsnitt.

---

### Spørsmål 4: Hva er en indeks og hvorfor er den viktig for ytelse?

**Ditt svar:**

En indeks er som et register i en bok som gjør det raskere å finne data. 
Den er viktig for ytelse for den gjør søk og filtrering raskere, spesielt i store tabeller.

---

### Spørsmål 5: Hvordan ville du optimalisert en spørring som er veldig treg?

**Ditt svar:**

Man kan sjekke om tabellene har riktige indekser, forenkle spørringen, unngått unødvendige JOINs
og filtrert data med WHERE. Spørringen blir ofte raskere når det legges til en indeks på kolonner 
som brukes i søk eller JOIN.

---

## Oppgave 3: Brukeradministrasjon og GRANT

### Spørsmål 1: Hva er prinsippet om minste rettighet? Hvorfor er det viktig?

**Ditt svar:**

Det vil si at en bruker kun skal få akkurat de rettighetene som er nødvendige for å gjøre oppgaven sin.
Dette er viktig for å redusere risikoen for feil, misbruk og sikkerhetsbrudd.
Hvis en bruker får mye tilgang, kan en ødelegge eller endre data ved et uhell.

---

### Spørsmål 2: Hva er forskjellen mellom en bruker og en rolle i PostgreSQL?

**Ditt svar:**

Forskjellen er at en bruker er en konto som kan logge inn i databasen, mens en rolle er en samling rettigheter
som kan gis til brukere. Brukere kan være medlemmer av en eller flere roller og arve deres rettigheter.

---

### Spørsmål 3: Hvorfor er det bedre å bruke roller enn å gi rettigheter direkte til brukere?

**Ditt svar:**

Det er bedre for det gjør administrasjonen enklere. I stedet for å gi rettigheter til enkelte brukere,
gir man rettigheter til en rolle og legger brukerne inn i rollen. 
Dette unngår å endre rettigheter for hver bruker en etter en.

---

### Spørsmål 4: Hva skjer hvis du gir en bruker `DROP` rettighet? Hvilke sikkerhetsproblemer kan det skape?

**Ditt svar:**

Brukeren kan slette tabeller, views eller hele databasen. Det fører til tap av data, ødelagte systemer
og store sikkerhetsproblemer. Kun administratorer bør ha DROP.

---

### Spørsmål 5: Hvordan ville du implementert at en student bare kan se sine egne karakterer, ikke andres?

**Ditt svar:**

Man kan lag et VIEW som filtrerer karakter basert på hvem som er logget inn, og 
gitt studenten SELECT-rettigheter på dette. Da kan studenten kun se egen data, og ikke hele tabellen.

---

## Notater og observasjoner

Bruk denne delen til å dokumentere interessante funn, problemer du møtte, eller andre observasjoner:

Jeg oppdaget at roller må testes ved å legge inn på dem for å sjekke hva slags rettigheter en faktisk har.
REVOKE fjerner ikke alltid rettigheter hvis de kommer fra en annen rolle. 
Også når man kjører SQL-filen flere ganger, får man "role already exists", men det påvirket ikke noe.


## Oppgave 4: Brukeradministrasjon og GRANT

1. **Hva er Row-Level Security og hvorfor er det viktig?**
   - Svar her...

2. **Hva er forskjellen mellom RLS og kolonnebegrenset tilgang?**
   - Svar her...

3. **Hvordan ville du implementert at en student bare kan se karakterer for sitt eget program?**
   - Svar her...

4. **Hva er sikkerhetsproblemene ved å bruke views i stedet for RLS?**
   - Svar her...

5. **Hvordan ville du testet at RLS-policyer fungerer korrekt?**
   - Svar her...

---

## Referanser

- PostgreSQL dokumentasjon: https://www.postgresql.org/docs/
- Docker dokumentasjon: https://docs.docker.com/

