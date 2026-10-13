# Smart City Transportation System — Database I (Database Systems) project

**Module:** 25CSIS03C — Database I (Database Systems)
**Programme:** Informatics and Computer Science, The British University in Egypt (BUE)
**Semester:** One, 2025–2026 · **Module leader:** Dr. Doaa Elzanfaly · **Proof reader:** Dr. Nermin Othman · **Supervising TA:** Amira
**Team:** Group 8 (5 members) · **Weight:** 50% of the module mark (Phase 1 40%, Phase 2 50%, presentation 10%)

A relational database for a smart-city public transport network: users (passengers and staff),
vehicles (bus / metro / taxi), routes and stops, trips with live GPS locations, tickets, smart cards
and loyalty programmes. Designed as a conceptual EERD, mapped to a relational schema and implemented
as a T-SQL script for Microsoft SQL Server with seed data, ALTER statements, 80 queries, a trigger and a view.

## Team and contributions

| Student ID | Name | BUE e-mail | Entities owned (mapping / creation / insertion / queries) |
|---|---|---|---|
| 257678 | Mahmoud Samir Moustafa | Mahmoud257678@bue.edu.eg | USER, STAFF, DRIVER, DISPATCHER, MAINTENANCE_STAFF (also: trigger, view, 2 ALTERs) |
| 255322 | Yousef Mahmoud Ali | Yousef255322@bue.edu.eg | TRIP_LOCATION, LOYALTY_PROGRAM, ENROLLED_IN (also: 1 ALTER) |
| 257511 | Ibrahim Moustafa | Ibrahim257511@bue.edu.eg | VEHICLE, BUS, METRO, TAXI (also: 1 ALTER) |
| 258748 | Seif Adel Mahmoud | Seif258748@bue.edu.eg | TRIP, TICKET, ROUTE (also: 1 ALTER) |
| 255444 | Hassan Moustafa Nosir | Hassan255444@bue.edu.eg | ROUTE_STOP, SMART_CARD, PASSENGER |

Taken from the contribution table in the final report and cross-checked against the author markers
(`--Mahmoud Queries--`, `--Ibrahim Queries--`, …) inside the SQL script.

## Repository layout

```
.
├── README.md                        this file
├── .gitignore / .gitattributes
├── docs/
│   ├── 01-brief/                    coursework brief (PDF) + extracted requirements
│   ├── 02-project-proposal/         Proposal #1 (team, topic, one-paragraph description)
│   ├── 03-proposal-feedback/        feedback received on the proposal / EERD
│   ├── 04-phase1-logical-design/    Phase 1 report: description, scope, functions, EERD, constraints
│   ├── 05-phase2-final-report/      Phase 2 final report (mapping + implementation + code)
│   ├── DATA-DICTIONARY.md           every table, column, key and constraint (generated)
│   ├── SCHEMA-MAPPING.md            how the EERD was mapped to tables, and the constraint gaps
│   └── CONTRIBUTIONS.md             per-member work split
├── diagrams/
│   ├── 01-eerd-v25-phase1.jpg       EERD as submitted in Phase 1
│   ├── 02-eerd-final.jpg            EERD after the feedback
│   ├── 03-mapping-schema.jpg        conceptual → relational mapping
│   └── 04-team-contribution.jpg     contribution table image from the final report
└── sql/
    └── SmartCityTransportationDB.sql   full T-SQL script: DDL + DML + ALTERs + 80 queries + trigger + view
```

Live EERD / mapping board (Figma): https://www.figma.com/board/U90n8pGLmvWIeLn9qIPGVp/EERD-V.25

## The schema at a glance

* 18 tables, 147 seed rows, 18 primary keys, 18 foreign keys, 1 UNIQUE constraint, 1 CHECK constraint.
* 3 generalization/specialization hierarchies:
  * `USER` → `PASSENGER` / `STAFF` — total, disjoint (every user is one or the other)
  * `STAFF` → `DRIVER` / `DISPATCHER` / `MAINTENANCE_STAFF` — partial, **overlapping** (one staff member may hold several roles)
  * `VEHICLE` → `BUS` / `METRO` / `TAXI` — total, disjoint (every vehicle is exactly one type)
* 1 weak entity: `TICKET`, identified by passenger + trip, PK `(TicketNo, PassengerID, TripID)`.
* 2 associative tables: `TICKET` (passenger ↔ trip) and `ENROLLED_IN` (passenger ↔ loyalty programme).
* `TRIP_LOCATION` is the GPS/log table, PK `(TripID, Timestamp)` — one row per update, many per trip.

Details per table: [docs/DATA-DICTIONARY.md](docs/DATA-DICTIONARY.md).

## How to run the script

Requires Microsoft SQL Server (Express / Developer / LocalDB) and SSMS or Azure Data Studio.
`sqlcmd` and SQL Server are **not** installed on the machine this repo was assembled on, so the script here
has only been analysed statically, never executed.

1. Open `sql/SmartCityTransportationDB.sql` and execute the whole file (F5).
2. The first batch (`CREATE DATABASE SmartCityTransportationDB; GO` + `USE …; GO`) needs database-creation
   permission. If the database already exists or you lack the right, start from the `CREATE TABLE [USER]`
   statement and add your own `USE`.
3. The script is not idempotent — see the two defects below. To re-run it, drop the database first, or
   comment out lines 428–430 and one of the two `SignalStrength` ALTERs (lines 445–446 / 448–449).

## Known defects in the script (static analysis, left unfixed)

1. **Duplicate foreign key** — `FK_TRIP_ROUTE` is declared inside `CREATE TABLE TRIP` and added again by
   `ALTER TABLE TRIP` (lines 428–430). The ALTER will raise *constraint already exists*.
2. **Duplicate column** — `TRIP_LOCATION.SignalStrength` is added twice: lines 445–446 (with `CHECK 0–100`)
   and 448–449 (without). The second statement will raise *column already exists*; the script comment says
   the team preferred the version without the CHECK, so the first one should be deleted.
3. **Ordering** — the trigger and the view are defined after the query sections, so the query blocks cannot be
   run standalone against a fresh database (`vw_PassengerTrips` would not exist yet).

## Design vs implementation — gaps worth knowing before the discussion

* Composite attribute `Name` is implemented as `FirstName` / `MiddleName` / `LastName`, but the composite
  `Address` (city / street / postal code) has **no columns at all**, and `Email` was bolted on by an
  `ALTER TABLE` instead of appearing in the `CREATE TABLE`.
* Multivalued `PhoneNumber` and the complex attribute `ContactInfo` are in the EERD but not implemented.
* The derived attribute `TripDuration` (EndTime − StartTime) is documented, not stored — correct, but it is
  never computed in the queries either (queries use `ROUTE.EstimatedDuration` instead).
* `trg_UpdateLoyaltyPoints` always adds a flat **10** points, although `LOYALTY_PROGRAM.PointsPerTrip` holds
  10/15/20/8/12/5/5 per tier — the trigger never reads that table.
* `CK_TRIP_Status` only accepts `'Completed'` and `'In Progress'`, so a cancelled or scheduled trip cannot be stored.
* Disjointness ("a vehicle cannot be both a bus and a taxi") is a *conceptual* constraint only; nothing in the
  relational schema enforces it across the subtype tables (SQL would need triggers or a discriminator column).
* `PASSENGER.LoyaltyPoints` duplicates information that also exists in `LOYALTY_PROGRAM` / `ENROLLED_IN`, which
  is the kind of redundancy normalisation targets.

These are all normal for a Phase-2 submission and are the questions a marker is most likely to ask —
see [docs/SCHEMA-MAPPING.md](docs/SCHEMA-MAPPING.md) for the full mapping rationale.

## Verification performed while building this repo

* Parsed the script: 18 `CREATE TABLE`, 147 `INSERT` rows, 6 `ALTER TABLE`, 1 trigger, 1 view, 2 `GO` batches, 80 `SELECT`.
* All 18 foreign keys resolve to an existing table and column (18/18); every FK constraint name is unique.
* Every seed row satisfies every declared foreign key (no orphans), all seed primary keys are unique, and every
  `INSERT` row has exactly as many values as its column list.
* **Not verified by execution** — no T-SQL engine on this machine.

## Files to be careful with before publishing

| Path | Size | Note |
|---|---|---|
| `docs/05-phase2-final-report/…docx` | 81 MB | 130 embedded screenshots of the code |
| `diagrams/01-eerd-v25-phase1.jpg` | 17.9 MB | full-resolution scan |
| `diagrams/02-eerd-final.jpg` | 16.6 MB | full-resolution scan |

GitHub warns above 50 MB per file. Nothing has been pushed to a remote yet.

## Academic note

Coursework for module 25CSIS03C (BUE). No licence is granted; the brief prohibits the use of generative AI
tools for the submitted work, so the files under `docs/` are the team's own submission and are kept unmodified.
