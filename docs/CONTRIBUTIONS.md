# Contributions — Group 8

Verbatim from the "Team Contribution Table" in the Phase 2 final report
(`docs/05-phase2-final-report/`), cross-checked against the author markers inside
`sql/SmartCityTransportationDB.sql` (`--Mahmoud Queries--`, `--Ibrahim Queries--`, `--Hassan Queries--`,
`--Seif Queries--`, `--Youssef Queries--` and the matching `--X Alter--` blocks).

| Student ID | Student name | Contribution as submitted |
|---|---|---|
| 257678 | Mahmoud Samir Moustafa | (USER & STAFF & DRIVER & DISPATCHER & MAINTENANCE_STAFF) Mapping, Creation, Insertion, Queries |
| 255322 | Yousef Mahmoud Ali | (TRIP_LOCATION & LOYALTY_PROGRAM & ENROLLED_IN) Mapping, Creation, Insertion, Queries |
| 257511 | Ibrahim Moustafa | (VEHICLE & BUS & METRO & Taxi) Mapping, Creation, Insertion, Queries |
| 258748 | Seif Adel Mahmoud | (TRIP & TICEKT & ROUTE) Mapping, Creation, Insertion, Queries |
| 255444 | Hassan Moustafa Nosir | (ROUTE_STOP & SMART_CARD & PASSENGER) Mapping, Creation, Insertion, Queries |

*The surname in the fourth row is spelled "TICEKT" in the submitted report; kept as-is here so this file
matches what was handed in.*

## Extra work found in the script, by author

| Author | Beyond their entities |
|---|---|
| Mahmoud (257678) | `ALTER TABLE [USER] ADD Email`; `ALTER TABLE TRIP` duplicate FK; `CREATE TRIGGER trg_UpdateLoyaltyPoints`; `CREATE VIEW vw_PassengerTrips` |
| Youssef (255322) | `ALTER TABLE TRIP_LOCATION ADD SignalStrength` (added twice — one version has a 0–100 CHECK) |
| Ibrahim (257511) | `ALTER TABLE METRO ADD StartOperationDate` |
| Seif (258748) | `ALTER TABLE TRIP ADD CONSTRAINT CK_TRIP_Status` |
| Hassan (255444) | — |

## Per-member deliverable ownership for the discussion

The Phase 1 marking note requires each member to state clearly their part in creating entities,
attributes and relationships ("marks will be deducted for messy, unclear or absent division of work"), and
the database-mapping and code marks are individual. Per member:

| Student | Entities / tables | Files to point at |
|---|---|---|
| Mahmoud | USER, STAFF, DRIVER, DISPATCHER, MAINTENANCE_STAFF | tables 1–6, 2 ALTERs, trigger, view, queries 1–16 in the script |
| Ibrahim | VEHICLE, BUS, METRO, TAXI | tables 7–10, METRO ALTER, vehicle/bus/metro/taxi queries |
| Seif | TRIP, TICKET, ROUTE | tables 11(ROUTE), 13(TRIP), 15(TICKET), CK_TRIP_Status, trip/ticket/route queries |
| Hassan | ROUTE_STOP, SMART_CARD, PASSENGER | tables 3(PASSENGER), 12(ROUTE_STOP), 16(SMART_CARD), route-stop/smart-card/passenger queries |
| Youssef | TRIP_LOCATION, LOYALTY_PROGRAM, ENROLLED_IN | tables 14, 17, 18, SignalStrength ALTER, trip-location/loyalty queries |
