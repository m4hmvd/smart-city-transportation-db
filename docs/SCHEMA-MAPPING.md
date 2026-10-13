# Conceptual (EERD) → relational mapping

How the Smart City Transportation System EERD became the 18 tables in
`sql/SmartCityTransportationDB.sql`. See `DATA-DICTIONARY.md` for column-level detail and
`../diagrams/03-mapping-schema.jpg` for the team's own mapping diagram.

## Rules applied

| # | Conceptual construct | Relational result | Where |
|---|---|---|---|
| 1 | Strong entity with simple attributes | One table, PK unchanged | `ROUTE`, `VEHICLE`, `USER`, `LOYALTY_PROGRAM` |
| 2 | Composite attribute | Flattened into its component columns (no extra table) | `Name` → `FirstName`, `MiddleName`, `LastName` in `USER` |
| 3 | Generalization / specialization | One table per supertype **and** one per subtype; the subtype PK is also an FK to the supertype PK | `STAFF`/`PASSENGER` → `USER`; `DRIVER`, `DISPATCHER`, `MAINTENANCE_STAFF` → `STAFF`; `BUS`, `METRO`, `TAXI` → `VEHICLE` |
| 4 | 1:M relationship | FK on the many side | `TRIP.RouteID`, `TRIP.VehicleID`, `TRIP.DriverID`, `ROUTE_STOP.RouteID`, `TRIP_LOCATION.TripID`, `SMART_CARD.PassengerID` |
| 5 | M:N relationship | Associative table with a composite PK | `ENROLLED_IN` (PassengerID + ProgramID); `TICKET` also resolves passenger ↔ trip |
| 6 | Weak entity with identifying relationships | Table with a composite PK made of its own partial key plus both owner keys, and FKs to both owners | `TICKET` PK `(TicketNo, PassengerID, TripID)` |
| 7 | Derived attribute | Not stored | `TripDuration` = EndTime − StartTime |

The SUPERCLASS/SUBCLASS strategy chosen for both hierarchies is *one table per subtype* (option 8.2 of
Elmasri & Navathe). It keeps subtype-specific columns free of NULLs — `METRO.NumberOfCabins` only exists
for metro units — at the cost of requiring a join back to the supertype for shared attributes, which is
exactly what the queries do (`USER ⋈ STAFF ⋈ DRIVER`, `VEHICLE ⋈ TAXI`, …).

## Constraint → enforcement

| Conceptual constraint | Enforced in the relational schema? |
|---|---|
| PK uniqueness, FK existence, NOT NULL | Yes — declared on every table |
| `VEHICLE.PlateNumber` unique | Yes — `UQ_VEHICLE_PlateNumber` |
| Trip status limited to two values | Yes — `CK_TRIP_Status` (added by ALTER) |
| Smart card always bound to one passenger | Yes — `SMART_CARD.PassengerID` NOT NULL FK |
| `USER` total + disjoint (passenger XOR staff) | **No** — nothing stops a row existing in both `PASSENGER` and `STAFF`, nor in neither |
| `VEHICLE` total + disjoint | **No** — a `VehicleID` could appear in `BUS` *and* `TAXI` |
| `STAFF` partial + overlapping | Naturally supported — a staff row simply appears in one, several or none of the three role tables |
| Ticket existence dependency | Partly — FKs are NOT NULL, so an orphan ticket cannot exist; the composite PK mirrors the weak-entity key |
| Derived `TripDuration` | Not stored, not computed |
| Multivalued `Email`, `PhoneNumber`; complex `ContactInfo`; composite `Address` | **Not implemented** — only `Email` exists, added late as a single `VARCHAR(100)` column |

Disjointness and totality across subtype tables cannot be expressed by PK/FK declarations in T-SQL; a real
system would need a discriminator column on the supertype, a `CHECK`-backed view with `WITH CHECK OPTION`,
or triggers. Worth saying out loud if asked "how is the 'd' in the circle enforced in the code?".

## Compliance with the Phase 1 feedback

The feedback (`docs/03-proposal-feedback/`) asked for six EERD changes; the final mapping reflects them:

| Feedback item | Status in the final design |
|---|---|
| Remove all foreign keys from the EERD | Done — the EERD shows relationships only; FKs appear only in the relational mapping |
| Overlapping `STAFF` → DRIVER / DISPATCHER / MAINTENANCE_STAFF is intentional | Kept, documented as overlapping + partial |
| `PASSENGER` OWNS `SMART_CARD` → make participation total | Kept total (a passenger must own a card in this system) |
| `TRIP` ISSUES `TICKET` → partial from the TRIP side | Kept partial |
| `PASSENGER` PURCHASES `TICKET` → partial from the PASSENGER side | Kept partial |
| Remove the loop in the EERD | Done |
| Remove primary keys from the subtypes in the EERD | Done in the EERD; the relational mapping necessarily reintroduces the key as PK = FK to the supertype |

## Structural notes on the implementation

* `TRIP` carries three FKs (route, vehicle, driver) and `TICKET` two, so the "many" side of every 1:M
  relationship is the side that was changed — the supertype/subtype tables only inherit keys.
* `TRIP_LOCATION.Timestamp` is a reserved word and is bracketed everywhere it is used (`[Timestamp]`); the
  same applies to the table name `[USER]`.
* Latitude/longitude are `DECIMAL(9,6)` — enough precision for metre-level GPS, consistent with the
  `ROUTE_STOP` and `TRIP_LOCATION` samples. Note the seed coordinates are Los Angeles and the `WHERE`
  range query in the Youssef section filters a Cairo-like box (30.00–30.10, 31.20–31.30), so that query
  returns no rows with the shipped data.
* Money columns are `DECIMAL(6,2)`/`DECIMAL(8,2)`/`DECIMAL(10,2)` rather than `FLOAT`, which is the right call.
