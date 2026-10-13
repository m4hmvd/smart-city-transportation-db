# Data dictionary — SmartCityTransportationDB

Derived from `sql/SmartCityTransportationDB.sql` by static analysis (no live SQL Server was available).
18 tables · 18 primary keys · 18 foreign keys · 1 UNIQUE · 1 CHECK · 147 seed rows.

Three columns do **not** appear in the `CREATE TABLE` statements because they were added later by
`ALTER TABLE` — include them when describing the effective schema:

| Added column | Table | Statement |
|---|---|---|
| `Email VARCHAR(100)` | `USER` | `ALTER TABLE [USER] ADD Email VARCHAR(100)` |
| `StartOperationDate DATE` | `METRO` | `ALTER TABLE METRO ADD StartOperationDate DATE` |
| `SignalStrength TINYINT` | `TRIP_LOCATION` | added twice in the script (see defects below) |

## Tables overview

| Table | Columns | Primary key | FKs out | Seed rows |
|---|---|---|---|---|
| `USER` | 6 | `UserID` | 0 | 14 |
| `STAFF` | 4 | `StaffID` | 1 | 7 |
| `PASSENGER` | 2 | `PassengerID` | 1 | 7 |
| `DRIVER` | 3 | `DriverID` | 1 | 7 |
| `DISPATCHER` | 2 | `DispatcherID` | 1 | 7 |
| `MAINTENANCE_STAFF` | 2 | `MaintenanceID` | 1 | 7 |
| `VEHICLE` | 4 | `VehicleID` | 0 | 21 |
| `BUS` | 2 | `VehicleID` | 1 | 7 |
| `METRO` | 2 | `VehicleID` | 1 | 7 |
| `TAXI` | 2 | `VehicleID` | 1 | 7 |
| `ROUTE` | 3 | `RouteID` | 0 | 7 |
| `ROUTE_STOP` | 5 | `RouteStopID` | 1 | 7 |
| `TRIP` | 7 | `TripID` | 3 | 7 |
| `TRIP_LOCATION` | 5 | `TripID + Timestamp` | 1 | 7 |
| `TICKET` | 5 | `TicketNo + PassengerID + TripID` | 2 | 7 |
| `SMART_CARD` | 6 | `CardID` | 1 | 7 |
| `LOYALTY_PROGRAM` | 5 | `ProgramID` | 0 | 7 |
| `ENROLLED_IN` | 2 | `PassengerID + ProgramID` | 2 | 7 |

## Columns

### `USER`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `UserID` | `INT` | NO | — | PK |
| `FirstName` | `VARCHAR(50)` | NO | — | — |
| `MiddleName` | `VARCHAR(50)` | YES | — | — |
| `LastName` | `VARCHAR(50)` | NO | — | — |
| `BirthDate` | `DATE` | NO | — | — |
| `Gender` | `CHAR(1)` | NO | — | — |

Seed data: `UserID`, `FirstName`, `MiddleName`, `LastName`, `BirthDate`, `Gender` — 14 row(s).

### `STAFF`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `StaffID` | `INT` | NO | — | PK, FK → USER.UserID |
| `Salary` | `DECIMAL(10,2)` | NO | — | — |
| `HireDate` | `DATE` | NO | — | — |
| `Department` | `VARCHAR(50)` | NO | — | — |

Seed data: `StaffID`, `Salary`, `HireDate`, `Department` — 7 row(s).

### `PASSENGER`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `PassengerID` | `INT` | NO | — | PK, FK → USER.UserID |
| `LoyaltyPoints` | `INT` | NO | `0` | — |

Seed data: `PassengerID`, `LoyaltyPoints` — 7 row(s).

### `DRIVER`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `DriverID` | `INT` | NO | — | PK, FK → STAFF.StaffID |
| `LicenseNo` | `VARCHAR(30)` | NO | — | — |
| `LicenseExpiry` | `DATE` | NO | — | — |

Seed data: `DriverID`, `LicenseNo`, `LicenseExpiry` — 7 row(s).

### `DISPATCHER`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `DispatcherID` | `INT` | NO | — | PK, FK → STAFF.StaffID |
| `ShiftTime` | `VARCHAR(30)` | NO | — | — |

Seed data: `DispatcherID`, `ShiftTime` — 7 row(s).

### `MAINTENANCE_STAFF`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `MaintenanceID` | `INT` | NO | — | PK, FK → STAFF.StaffID |
| `SkillType` | `VARCHAR(50)` | NO | — | — |

Seed data: `MaintenanceID`, `SkillType` — 7 row(s).

### `VEHICLE`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `VehicleID` | `INT` | NO | — | PK |
| `PlateNumber` | `VARCHAR(20)` | NO | — | — |
| `Manufacturer` | `VARCHAR(50)` | NO | — | — |
| `Model` | `VARCHAR(50)` | NO | — | — |

Extra constraints:
- `CONSTRAINT UQ_VEHICLE_PlateNumber UNIQUE (PlateNumber)`

Seed data: `VehicleID`, `PlateNumber`, `Manufacturer`, `Model` — 21 row(s).

### `BUS`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `VehicleID` | `INT` | NO | — | PK, FK → VEHICLE.VehicleID |
| `BusType` | `VARCHAR(30)` | NO | — | — |

Seed data: `VehicleID`, `BusType` — 7 row(s).

### `METRO`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `VehicleID` | `INT` | NO | — | PK, FK → VEHICLE.VehicleID |
| `NumberOfCabins` | `INT` | NO | — | — |

Seed data: `VehicleID`, `NumberOfCabins` — 7 row(s).

### `TAXI`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `VehicleID` | `INT` | NO | — | PK, FK → VEHICLE.VehicleID |
| `FareRatePerKM` | `DECIMAL(6,2)` | NO | — | — |

Seed data: `VehicleID`, `FareRatePerKM` — 7 row(s).

### `ROUTE`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `RouteID` | `INT` | NO | — | PK |
| `RouteName` | `VARCHAR(50)` | NO | — | — |
| `EstimatedDuration` | `INT` | NO | — | — |

Seed data: `RouteID`, `RouteName`, `EstimatedDuration` — 7 row(s).

### `ROUTE_STOP`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `RouteStopID` | `INT` | NO | — | PK |
| `StopName` | `VARCHAR(50)` | NO | — | — |
| `GPS_Latitude` | `DECIMAL(9,6)` | NO | — | — |
| `GPS_Longitude` | `DECIMAL(9,6)` | NO | — | — |
| `RouteID` | `INT` | NO | — | FK → ROUTE.RouteID |

Seed data: `RouteStopID`, `StopName`, `GPS_Latitude`, `GPS_Longitude`, `RouteID` — 7 row(s).

### `TRIP`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `TripID` | `INT` | NO | — | PK |
| `StartTime` | `DATETIME` | NO | — | — |
| `EndTime` | `DATETIME` | YES | — | — |
| `Status` | `VARCHAR(30)` | NO | — | — |
| `RouteID` | `INT` | NO | — | FK → ROUTE.RouteID |
| `VehicleID` | `INT` | NO | — | FK → VEHICLE.VehicleID |
| `DriverID` | `INT` | NO | — | FK → DRIVER.DriverID |

Seed data: `TripID`, `StartTime`, `EndTime`, `Status`, `RouteID`, `VehicleID`, `DriverID` — 7 row(s).

### `TRIP_LOCATION`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `TripID` | `INT` | NO | — | PK, FK → TRIP.TripID |
| `Timestamp` | `DATETIME` | NO | — | PK |
| `Latitude` | `DECIMAL(9,6)` | NO | — | — |
| `Longitude` | `DECIMAL(9,6)` | NO | — | — |
| `Speed` | `DECIMAL(6,2)` | NO | — | — |

Seed data: `TripID`, `Timestamp`, `Latitude`, `Longitude`, `Speed` — 7 row(s).

### `TICKET`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `TicketNo` | `INT` | NO | — | PK |
| `PassengerID` | `INT` | NO | — | PK, FK → PASSENGER.PassengerID |
| `TripID` | `INT` | NO | — | PK, FK → TRIP.TripID |
| `Price` | `DECIMAL(6,2)` | NO | — | — |
| `PurchaseTime` | `DATETIME` | NO | — | — |

Seed data: `TicketNo`, `PassengerID`, `TripID`, `Price`, `PurchaseTime` — 7 row(s).

### `SMART_CARD`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `CardID` | `INT` | NO | — | PK |
| `CardType` | `VARCHAR(30)` | NO | — | — |
| `IssueDate` | `DATE` | NO | — | — |
| `ExpiryDate` | `DATE` | NO | — | — |
| `Balance` | `DECIMAL(8,2)` | NO | — | — |
| `PassengerID` | `INT` | NO | — | FK → PASSENGER.PassengerID |

Seed data: `CardID`, `CardType`, `IssueDate`, `ExpiryDate`, `Balance`, `PassengerID` — 7 row(s).

### `LOYALTY_PROGRAM`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `ProgramID` | `INT` | NO | — | PK |
| `ProgramName` | `VARCHAR(50)` | NO | — | — |
| `TierName` | `VARCHAR(30)` | NO | — | — |
| `DiscountRate` | `DECIMAL(4,2)` | NO | — | — |
| `PointsPerTrip` | `INT` | NO | — | — |

Seed data: `ProgramID`, `ProgramName`, `TierName`, `DiscountRate`, `PointsPerTrip` — 7 row(s).

### `ENROLLED_IN`

| Column | Type | Nullable | Default | Key |
|---|---|---|---|---|
| `PassengerID` | `INT` | NO | — | PK, FK → PASSENGER.PassengerID |
| `ProgramID` | `INT` | NO | — | PK, FK → LOYALTY_PROGRAM.ProgramID |

Seed data: `PassengerID`, `ProgramID` — 7 row(s).

## Foreign keys (18)

| # | Child table | Column | References | Constraint |
|---|---|---|---|---|
| 1 | `STAFF` | `StaffID` | `USER(UserID)` | `FK_STAFF_USER` |
| 2 | `PASSENGER` | `PassengerID` | `USER(UserID)` | `FK_PASSENGER_USER` |
| 3 | `DRIVER` | `DriverID` | `STAFF(StaffID)` | `FK_DRIVER_STAFF` |
| 4 | `DISPATCHER` | `DispatcherID` | `STAFF(StaffID)` | `FK_DISPATCHER_STAFF` |
| 5 | `MAINTENANCE_STAFF` | `MaintenanceID` | `STAFF(StaffID)` | `FK_MAINTENANCE_STAFF_STAFF` |
| 6 | `BUS` | `VehicleID` | `VEHICLE(VehicleID)` | `FK_BUS_VEHICLE` |
| 7 | `METRO` | `VehicleID` | `VEHICLE(VehicleID)` | `FK_METRO_VEHICLE` |
| 8 | `TAXI` | `VehicleID` | `VEHICLE(VehicleID)` | `FK_TAXI_VEHICLE` |
| 9 | `ROUTE_STOP` | `RouteID` | `ROUTE(RouteID)` | `FK_ROUTE_STOP_ROUTE` |
| 10 | `TRIP` | `RouteID` | `ROUTE(RouteID)` | `FK_TRIP_ROUTE` |
| 11 | `TRIP` | `VehicleID` | `VEHICLE(VehicleID)` | `FK_TRIP_VEHICLE` |
| 12 | `TRIP` | `DriverID` | `DRIVER(DriverID)` | `FK_TRIP_DRIVER` |
| 13 | `TRIP_LOCATION` | `TripID` | `TRIP(TripID)` | `FK_TRIP_LOCATION_TRIP` |
| 14 | `TICKET` | `PassengerID` | `PASSENGER(PassengerID)` | `FK_TICKET_PASSENGER` |
| 15 | `TICKET` | `TripID` | `TRIP(TripID)` | `FK_TICKET_TRIP` |
| 16 | `SMART_CARD` | `PassengerID` | `PASSENGER(PassengerID)` | `FK_SMART_CARD_PASSENGER` |
| 17 | `ENROLLED_IN` | `PassengerID` | `PASSENGER(PassengerID)` | `FK_ENROLLED_IN_PASSENGER` |
| 18 | `ENROLLED_IN` | `ProgramID` | `LOYALTY_PROGRAM(ProgramID)` | `FK_ENROLLED_IN_LOYALTY_PROGRAM` |

## Programmable objects

- `CREATE TRIGGER trg_UpdateLoyaltyPoints` on `TICKET` (AFTER INSERT) — adds a flat +10 to `PASSENGER.LoyaltyPoints` for the inserted passenger(s).
- `CREATE VIEW vw_PassengerTrips` — passenger name, ticket no, trip id, route name, price (TICKET → PASSENGER → USER → TRIP → ROUTE).

## ALTER statements (6)

- `ALTER TABLE [USER] ADD Email VARCHAR(100)`
- `ALTER TABLE TRIP ADD CONSTRAINT FK_TRIP_ROUTE FOREIGN KEY (RouteID) REFERENCES ROUTE(RouteID)`
- `ALTER TABLE TRIP ADD CONSTRAINT CK_TRIP_Status CHECK (Status IN ('Completed', 'In Progress'))`
- `ALTER TABLE METRO ADD StartOperationDate DATE`
- `ALTER TABLE TRIP_LOCATION ADD SignalStrength TINYINT CHECK (SignalStrength BETWEEN 0 AND 100)`
- `ALTER TABLE TRIP_LOCATION ADD SignalStrength TINYINT`

## Query inventory

80 SELECT statements, grouped by the author sections marked in the script:

- **Mahmoud** — USER / STAFF / DRIVER / DISPATCHER / MAINTENANCE_STAFF: 16 queries (joins, subqueries, GROUP BY, HAVING, ORDER BY, CASE, `> AVG` subquery)
- **Ibrahim** — VEHICLE / BUS / METRO / TAXI: counts, DISTINCT, joins, nested aggregate with multiple WHERE predicates
- **Hassan** — ROUTE / ROUTE_STOP / PASSENGER / SMART_CARD / LOYALTY_PROGRAM: implicit-join syntax, GROUP BY + HAVING, `> AVG`, MAX subquery, IN, EXISTS
- **Seif** — TRIP / TICKET / ROUTE: inner joins, LEFT JOIN for 'trips by vehicle type', LEFT JOIN … IS NULL for routes with no trips
- **Youssef** — TRIP_LOCATION / LOYALTY_PROGRAM / ENROLLED_IN: GROUP BY aggregates, BETWEEN, TOP 1, NOT IN

## Known script defects (static analysis, not fixed here)

1. `FK_TRIP_ROUTE` is declared in `CREATE TABLE TRIP` and added again by `ALTER TABLE TRIP` (lines 428–430) → *constraint already exists* when the script runs.
2. `TRIP_LOCATION.SignalStrength` is added twice — lines 445–446 (with `CHECK 0–100`) and 448–449 (plain) → *column already exists* on the second statement.
3. The trigger and the view are defined at the end of the file, after the query sections, so the query blocks cannot be run standalone against a fresh database.
