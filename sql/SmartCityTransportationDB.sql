/* =========================
   CREATE DATABASE
========================= */
CREATE DATABASE SmartCityTransportationDB;
GO
USE SmartCityTransportationDB;
GO

/* =========================
   TABLES
========================= */

--1--(USER) TABLE
CREATE TABLE [USER] (
    UserID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    LastName VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    CONSTRAINT PK_USER PRIMARY KEY (UserID)
);

--2--(STAFF) TABLE
CREATE TABLE STAFF (
    StaffID INT NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL,
    Department VARCHAR(50) NOT NULL,
    CONSTRAINT PK_STAFF PRIMARY KEY (StaffID),
    CONSTRAINT FK_STAFF_USER FOREIGN KEY (StaffID) REFERENCES [USER](UserID)
);

--3--(PASSENGER) TABLE
CREATE TABLE PASSENGER (
    PassengerID INT NOT NULL,
    LoyaltyPoints INT NOT NULL DEFAULT 0,
    CONSTRAINT PK_PASSENGER PRIMARY KEY (PassengerID),
    CONSTRAINT FK_PASSENGER_USER FOREIGN KEY (PassengerID) REFERENCES [USER](UserID)
);

--4--(DRIVER) TABLE
CREATE TABLE DRIVER (
    DriverID INT NOT NULL,
    LicenseNo VARCHAR(30) NOT NULL,
    LicenseExpiry DATE NOT NULL,
    CONSTRAINT PK_DRIVER PRIMARY KEY (DriverID),
    CONSTRAINT FK_DRIVER_STAFF FOREIGN KEY (DriverID) REFERENCES STAFF(StaffID)
);

--5--(DISPATCHER) TABLE
CREATE TABLE DISPATCHER (
    DispatcherID INT NOT NULL,
    ShiftTime VARCHAR(30) NOT NULL,
    CONSTRAINT PK_DISPATCHER PRIMARY KEY (DispatcherID),
    CONSTRAINT FK_DISPATCHER_STAFF FOREIGN KEY (DispatcherID) REFERENCES STAFF(StaffID)
);

--6--(MAINTENANCE_STAFF) TABLE
CREATE TABLE MAINTENANCE_STAFF (
    MaintenanceID INT NOT NULL,
    SkillType VARCHAR(50) NOT NULL,
    CONSTRAINT PK_MAINTENANCE_STAFF PRIMARY KEY (MaintenanceID),
    CONSTRAINT FK_MAINTENANCE_STAFF_STAFF FOREIGN KEY (MaintenanceID) REFERENCES STAFF(StaffID)
);

--7--(VEHICLE) TABLE
CREATE TABLE VEHICLE (
    VehicleID INT NOT NULL,
    PlateNumber VARCHAR(20) NOT NULL,
    Manufacturer VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    CONSTRAINT PK_VEHICLE PRIMARY KEY (VehicleID),
    CONSTRAINT UQ_VEHICLE_PlateNumber UNIQUE (PlateNumber)
);

--8--(BUS) TABLE
CREATE TABLE BUS (
    VehicleID INT NOT NULL,
    BusType VARCHAR(30) NOT NULL,
    CONSTRAINT PK_BUS PRIMARY KEY (VehicleID),
    CONSTRAINT FK_BUS_VEHICLE FOREIGN KEY (VehicleID) REFERENCES VEHICLE(VehicleID)
);

--9--(METRO) TABLE
CREATE TABLE METRO (
    VehicleID INT NOT NULL,
    NumberOfCabins INT NOT NULL,
    CONSTRAINT PK_METRO PRIMARY KEY (VehicleID),
    CONSTRAINT FK_METRO_VEHICLE FOREIGN KEY (VehicleID) REFERENCES VEHICLE(VehicleID)
);

--10--(TAXI) TABLE
CREATE TABLE TAXI (
    VehicleID INT NOT NULL,
    FareRatePerKM DECIMAL(6,2) NOT NULL,
    CONSTRAINT PK_TAXI PRIMARY KEY (VehicleID),
    CONSTRAINT FK_TAXI_VEHICLE FOREIGN KEY (VehicleID) REFERENCES VEHICLE(VehicleID)
);

--11--(ROUTE) TABLE
CREATE TABLE ROUTE (
    RouteID INT NOT NULL,
    RouteName VARCHAR(50) NOT NULL,
    EstimatedDuration INT NOT NULL,
    CONSTRAINT PK_ROUTE PRIMARY KEY (RouteID)
);

--12--(ROUTE_STOP) TABLE
CREATE TABLE ROUTE_STOP (
    RouteStopID INT NOT NULL,
    StopName VARCHAR(50) NOT NULL,
    GPS_Latitude DECIMAL(9,6) NOT NULL,
    GPS_Longitude DECIMAL(9,6) NOT NULL,
    RouteID INT NOT NULL,
    CONSTRAINT PK_ROUTE_STOP PRIMARY KEY (RouteStopID),
    CONSTRAINT FK_ROUTE_STOP_ROUTE FOREIGN KEY (RouteID) REFERENCES ROUTE(RouteID)
);

--13--(TRIP) TABLE
CREATE TABLE TRIP (
    TripID INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    Status VARCHAR(30) NOT NULL,
    RouteID INT NOT NULL,
    VehicleID INT NOT NULL,
    DriverID INT NOT NULL,
    CONSTRAINT PK_TRIP PRIMARY KEY (TripID),
    CONSTRAINT FK_TRIP_ROUTE FOREIGN KEY (RouteID) REFERENCES ROUTE(RouteID),
    CONSTRAINT FK_TRIP_VEHICLE FOREIGN KEY (VehicleID) REFERENCES VEHICLE(VehicleID),
    CONSTRAINT FK_TRIP_DRIVER FOREIGN KEY (DriverID) REFERENCES DRIVER(DriverID)
);

--14--(TRIP_LOCATION) TABLE
CREATE TABLE TRIP_LOCATION (
    TripID INT NOT NULL,
    [Timestamp] DATETIME NOT NULL,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    Speed DECIMAL(6,2) NOT NULL,
    CONSTRAINT PK_TRIP_LOCATION PRIMARY KEY (TripID, [Timestamp]),
    CONSTRAINT FK_TRIP_LOCATION_TRIP FOREIGN KEY (TripID) REFERENCES TRIP(TripID)
);

--15--(TICKET) TABLE
CREATE TABLE TICKET (
    TicketNo INT NOT NULL,
    PassengerID INT NOT NULL,
    TripID INT NOT NULL,
    Price DECIMAL(6,2) NOT NULL,
    PurchaseTime DATETIME NOT NULL,
    CONSTRAINT PK_TICKET PRIMARY KEY (TicketNo, PassengerID, TripID),
    CONSTRAINT FK_TICKET_PASSENGER FOREIGN KEY (PassengerID) REFERENCES PASSENGER(PassengerID),
    CONSTRAINT FK_TICKET_TRIP FOREIGN KEY (TripID) REFERENCES TRIP(TripID)
);

--16--(SMART_CARD) TABLE
CREATE TABLE SMART_CARD (
    CardID INT NOT NULL,
    CardType VARCHAR(30) NOT NULL,
    IssueDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    Balance DECIMAL(8,2) NOT NULL,
    PassengerID INT NOT NULL,
    CONSTRAINT PK_SMART_CARD PRIMARY KEY (CardID),
    CONSTRAINT FK_SMART_CARD_PASSENGER FOREIGN KEY (PassengerID) REFERENCES PASSENGER(PassengerID)
);

--17--(LOYALTY_PROGRAM) TABLE
CREATE TABLE LOYALTY_PROGRAM (
    ProgramID INT NOT NULL,
    ProgramName VARCHAR(50) NOT NULL,
    TierName VARCHAR(30) NOT NULL,
    DiscountRate DECIMAL(4,2) NOT NULL,
    PointsPerTrip INT NOT NULL,
    CONSTRAINT PK_LOYALTY_PROGRAM PRIMARY KEY (ProgramID)
);

--18--(ENROLLED_IN) TABLE
CREATE TABLE ENROLLED_IN (
    PassengerID INT NOT NULL,
    ProgramID INT NOT NULL,
    CONSTRAINT PK_ENROLLED_IN PRIMARY KEY (PassengerID, ProgramID),
    CONSTRAINT FK_ENROLLED_IN_PASSENGER FOREIGN KEY (PassengerID) REFERENCES PASSENGER(PassengerID),
    CONSTRAINT FK_ENROLLED_IN_LOYALTY_PROGRAM FOREIGN KEY (ProgramID) REFERENCES LOYALTY_PROGRAM(ProgramID)
);

/* =========================
   INSERT
========================= */
/* 1. [USER] */
INSERT INTO [USER] (UserID, FirstName, MiddleName, LastName, BirthDate, Gender)
VALUES
-- Passengers
(101, 'Ahmed',  'Mahmoud', 'Hassan',   '1995-01-01', 'M'),
(102, 'Sara',   'Ali',     'Youssef',  '1996-02-02', 'F'),
(103, 'Omar',   'Khaled',  'Ibrahim',  '1997-03-03', 'M'),
(104, 'Mona',   'Hassan',  'Fathy',    '1998-04-04', 'F'),
(105, 'Youssef','Ahmed',   'Samir',    '1999-05-05', 'M'),
(106, 'Nour',   'Mahmoud', 'Adel',     '2000-06-06', 'F'),
(107, 'Karim',  'Mostafa', 'Said',     '2001-07-07', 'M'),

-- Staff
(201, 'Mahmoud','Ali',     'Salem',    '1980-01-10', 'M'),
(202, 'Hoda',   'Yassin',  'Kamal',    '1981-02-11', 'F'),
(203, 'Tarek',  'Hassan',  'Gomaa',    '1982-03-12', 'M'),
(204, 'Dina',   'Mostafa', 'Nabil',    '1983-04-13', 'F'),
(205, 'Ayman',  'Sayed',   'Farouk',   '1984-05-14', 'M'),
(206, 'Reem',   'Ahmed',   'Lotfy',    '1985-06-15', 'F'),
(207, 'Khaled', 'Samir',   'Abdelrahman','1986-07-16','M');


/* 2. PASSENGER */
INSERT INTO PASSENGER (PassengerID, LoyaltyPoints)
VALUES
(101, 120),
(102, 90),
(103, 60),
(104, 200),
(105, 150),
(106, 80),
(107, 300);

/* 3. STAFF */
INSERT INTO STAFF (StaffID, Salary, HireDate, Department)
VALUES
(201, 5000, '2020-01-01', 'Transport'),
(202, 5100, '2020-02-01', 'Operations'),
(203, 5200, '2020-03-01', 'Maintenance'),
(204, 5300, '2020-04-01', 'Driving'),
(205, 5400, '2020-05-01', 'Dispatch'),
(206, 5500, '2020-06-01', 'Technical'),
(207, 5600, '2020-07-01', 'Administration');

/* 4. DRIVER */
INSERT INTO DRIVER (DriverID, LicenseNo, LicenseExpiry)
VALUES
(201, 'DL201', '2030-01-01'),
(202, 'DL202', '2030-02-01'),
(203, 'DL203', '2030-03-01'),
(204, 'DL204', '2030-04-01'),
(205, 'DL205', '2030-05-01'),
(206, 'DL206', '2030-06-01'),
(207, 'DL207', '2030-07-01');

/* 5. DISPATCHER */
INSERT INTO DISPATCHER (DispatcherID, ShiftTime)
VALUES
(201, '06:00-14:00'),
(202, '14:00-22:00'),
(203, '22:00-06:00'),
(204, '08:00-16:00'),
(205, '16:00-00:00'),
(206, '07:00-15:00'),
(207, '15:00-23:00');

/* 6. MAINTENANCE_STAFF */
INSERT INTO MAINTENANCE_STAFF (MaintenanceID, SkillType)
VALUES
(201, 'Engine'),
(202, 'Brakes'),
(203, 'Electronics'),
(204, 'Tires'),
(205, 'Hydraulics'),
(206, 'Paint'),
(207, 'Software');

/* 7. VEHICLE */
INSERT INTO VEHICLE (VehicleID, PlateNumber, Manufacturer, Model)
VALUES
-- BUS: 301-307
(301, 'BUS001', 'Volvo', 'B10M'),
(302, 'BUS002', 'Scania', 'K250UB'),
(303, 'BUS003', 'Mercedes', 'Citaro'),
(304, 'BUS004', 'MAN', 'Lion'),
(305, 'BUS005', 'Iveco', 'Urbanway'),
(306, 'BUS006', 'DAF', 'SB3000'),
(307, 'BUS007', 'Renault', 'Agilis'),
-- METRO: 308-314
(308, 'MET001', 'Alstom', 'Metropolis'),
(309, 'MET002', 'Siemens', 'Inspiro'),
(310, 'MET003', 'Bombardier', 'Movia'),
(311, 'MET004', 'CAF', 'Series5K'),
(312, 'MET005', 'Hitachi', 'AT300'),
(313, 'MET006', 'Talgo', 'MetroX'),
(314, 'MET007', 'Stadler', 'FLIRT'),
-- TAXI: 315-321
(315, 'TAX001', 'Toyota', 'Camry'),
(316, 'TAX002', 'Honda', 'Accord'),
(317, 'TAX003', 'Hyundai', 'Elantra'),
(318, 'TAX004', 'Nissan', 'Sentra'),
(319, 'TAX005', 'Chevrolet', 'Malibu'),
(320, 'TAX006', 'Kia', 'Optima'),
(321, 'TAX007', 'VW', 'Jetta');

/* 8. BUS */
INSERT INTO BUS (VehicleID, BusType)
VALUES
(301,'Single'),
(302,'Double'),
(303,'Articulated'),
(304,'MiniBus'),
(305,'Electric'),
(306,'Hybrid'),
(307,'Standard');

/* 9. METRO */
INSERT INTO METRO (VehicleID, NumberOfCabins)
VALUES
(308,6),
(309,8),
(310,5),
(311,7),
(312,6),
(313,4),
(314,8);

/* 10. TAXI */
INSERT INTO TAXI (VehicleID, FareRatePerKM)
VALUES
(315,2.50),
(316,2.40),
(317,2.30),
(318,2.20),
(319,2.60),
(320,2.10),
(321,2.70);

/* 11. ROUTE */
INSERT INTO ROUTE (RouteID, RouteName, EstimatedDuration)
VALUES
(401, 'Downtown Loop', 45),
(402, 'Airport Express', 60),
(403, 'University Line', 35),
(404, 'North Metro', 50),
(405, 'East Metro', 55),
(406, 'Taxi Zone A', 20),
(407, 'Taxi Zone B', 25);

/* 12. ROUTE_STOP */
INSERT INTO ROUTE_STOP (RouteStopID, StopName, GPS_Latitude, GPS_Longitude, RouteID)
VALUES
(501,'Central Station',34.0522,-118.2437,401),
(502,'City Hall',34.0537,-118.2428,402),
(503,'Airport',33.9416,-118.4085,402),
(504,'University',34.0689,-118.4452,403),
(505,'North Terminal',34.1478,-118.1445,404),
(506,'East Mall',34.0736,-118.1524,405),
(507,'Downtown Taxi',34.0505,-118.2478,406);

/* 13. TRIP */
INSERT INTO TRIP (TripID, StartTime, EndTime, Status, RouteID, VehicleID, DriverID)
VALUES
(601,'2025-12-20 08:00','2025-12-20 08:45','Completed',401,301,201),
(602,'2025-12-20 09:00','2025-12-20 10:00','Completed',402,302,202),
(603,'2025-12-20 10:30',NULL,'In Progress',403,303,203),
(604,'2025-12-20 11:00','2025-12-20 11:50','Completed',404,308,204),
(605,'2025-12-20 12:00','2025-12-20 12:55','Completed',405,309,205),
(606,'2025-12-20 13:00','2025-12-20 13:20','Completed',406,315,206),
(607,'2025-12-20 14:00','2025-12-20 14:25','Completed',407,316,207);

/* 14. TRIP_LOCATION */
INSERT INTO TRIP_LOCATION (TripID, [Timestamp], Latitude, Longitude, Speed)
VALUES
(601,'2025-12-20 08:15',34.0525,-118.2440,25.5),
(602,'2025-12-20 09:30',33.9600,-118.3900,60.2),
(603,'2025-12-20 10:45',34.0700,-118.4500,30.0),
(604,'2025-12-20 11:25',34.1000,-118.2000,40.8),
(605,'2025-12-20 12:30',34.0800,-118.1600,38.5),
(606,'2025-12-20 13:10',34.0510,-118.2480,22.0),
(607,'2025-12-20 14:15',34.0520,-118.2400,24.3);

/* 15. TICKET */
INSERT INTO TICKET (TicketNo, PassengerID, TripID, Price, PurchaseTime)
VALUES
(7001,101,601,2.50,'2025-12-20 07:55'),
(7002,102,602,5.00,'2025-12-20 08:55'),
(7003,103,603,2.00,'2025-12-20 10:25'),
(7004,104,604,3.50,'2025-12-20 10:55'),
(7005,105,605,3.50,'2025-12-20 11:55'),
(7006,106,606,4.00,'2025-12-20 12:55'),
(7007,107,607,4.00,'2025-12-20 13:55');

/* 16. SMART_CARD */
INSERT INTO SMART_CARD (CardID, CardType, IssueDate, ExpiryDate, Balance, PassengerID)
VALUES
(801,'Standard','2024-01-01','2026-01-01',50.00,101),
(802,'Student','2024-02-01','2026-02-01',30.00,102),
(803,'Senior','2024-03-01','2026-03-01',40.00,103),
(804,'Standard','2024-04-01','2026-04-01',60.00,104),
(805,'Corporate','2024-05-01','2026-05-01',100.00,105),
(806,'Student','2024-06-01','2026-06-01',25.00,106),
(807,'Standard','2024-07-01','2026-07-01',45.00,107);

/* 17. LOYALTY_PROGRAM */
INSERT INTO LOYALTY_PROGRAM (ProgramID, ProgramName, TierName, DiscountRate, PointsPerTrip)
VALUES
(901,'CityRider','Bronze',5.00,10),
(902,'CityRider','Silver',10.00,15),
(903,'CityRider','Gold',15.00,20),
(904,'EcoTrans','Basic',4.00,8),
(905,'EcoTrans','Plus',8.00,12),
(906,'StudentPass','Discount',20.00,5),
(907,'SeniorRide','Priority',25.00,5);

/* 18. ENROLLED_IN */
INSERT INTO ENROLLED_IN (PassengerID, ProgramID)
VALUES
(101,901),
(102,906),
(103,903),
(104,902),
(105,905),
(106,904),
(107,907);

/* =========================
   Alter
========================= */
--Mahmoud Alter--
/*This command modifies the USER table by adding a
new column to store the user’s email address*/
ALTER TABLE [USER]
ADD Email VARCHAR(100);
/*This command adds a foreign key constraint to 
ensure that every trip is associated with a valid route*/
ALTER TABLE TRIP
ADD CONSTRAINT FK_TRIP_ROUTE
FOREIGN KEY (RouteID) REFERENCES ROUTE(RouteID);

--Mahmoud Alter--
--Seif Alert--
ALTER TABLE TRIP
ADD CONSTRAINT CK_TRIP_Status
CHECK (Status IN ('Completed', 'In Progress'));
--Seif Alert--
--Ibrahim Alter--
ALTER TABLE METRO
ADD StartOperationDate DATE;
--Ibrahim Alter--

--Youssef Alter--
-- Add a 'SignalStrength' column to TRIP_LOCATION to support IoT fleet monitoring
ALTER TABLE TRIP_LOCATION
ADD SignalStrength TINYINT CHECK (SignalStrength BETWEEN 0 AND 100);
-- Without CHECK (as per your preference):
ALTER TABLE TRIP_LOCATION
ADD SignalStrength TINYINT;
--Youssef Alter--


/* =========================
   QUERIES
========================= */
--Mahmoud Queries--
--1-This query retrieves all records from the USER table--
SELECT *
FROM [USER];
--2-This query selects specific columns instead of all attributes--
SELECT FirstName, LastName, BirthDate
FROM [USER];
--3-This query filters users based on gender using the WHERE clause--
SELECT *
FROM [USER]
WHERE Gender = 'M';
--4-This query retrieves staff identifiers and their salaries--
SELECT StaffID, Salary
FROM STAFF;
--5-This query filters staff members by department--
SELECT *
FROM STAFF
WHERE Department = 'Operations';
--6-This query sorts staff salaries from highest to lowest--
SELECT StaffID, Salary
FROM STAFF
ORDER BY Salary DESC;
--7-This query calculates the average salary of all staff members--
SELECT AVG(Salary) AS AverageSalary
FROM STAFF;
--8-This query returns the maximum salary value--
SELECT MAX(Salary) AS MaxSalary
FROM STAFF;
--9-This query groups staff by department and counts employees in each one--
SELECT Department, COUNT(*) AS StaffCount
FROM STAFF
GROUP BY Department;
--10-This query filters grouped results using the HAVING clause--
SELECT Department, COUNT(*) AS StaffCount
FROM STAFF
GROUP BY Department
HAVING COUNT(*) >= 1;
--11-This query joins USER, STAFF, and DRIVER tables to show driver details--
SELECT U.FirstName, U.LastName, D.LicenseNo
FROM DRIVER D
JOIN STAFF S ON D.DriverID = S.StaffID
JOIN [USER] U ON S.StaffID = U.UserID;
--12-This query uses a subquery to find staff who are also drivers--
SELECT StaffID
FROM STAFF
WHERE StaffID IN (SELECT DriverID FROM DRIVER);
---13-This query lists each staff member along with the number of roles they hold--
SELECT 
    u.FirstName,
    u.LastName,
    s.Department,
    (CASE WHEN d.DriverID IS NOT NULL THEN 1 ELSE 0 END +
     CASE WHEN ds.DispatcherID IS NOT NULL THEN 1 ELSE 0 END +
     CASE WHEN m.MaintenanceID IS NOT NULL THEN 1 ELSE 0 END) AS RoleCount
FROM STAFF s
JOIN [USER] u ON s.StaffID = u.UserID
LEFT JOIN DRIVER d ON s.StaffID = d.DriverID
LEFT JOIN DISPATCHER ds ON s.StaffID = ds.DispatcherID
LEFT JOIN MAINTENANCE_STAFF m ON s.StaffID = m.MaintenanceID
ORDER BY RoleCount DESC;
--14-This query retrieves maintenance staff IDs and their skill types--
SELECT MaintenanceID, SkillType
FROM MAINTENANCE_STAFF;
--15-This query joins USER, STAFF, and MAINTENANCE_STAFF to display full maintenance staff details--
SELECT U.FirstName, U.LastName, M.SkillType
FROM MAINTENANCE_STAFF M
JOIN STAFF S ON M.MaintenanceID = S.StaffID
JOIN [USER] U ON S.StaffID = U.UserID;
--16-Displays staff members whose salary is above the average salary--
SELECT *
FROM STAFF
WHERE Salary > (SELECT AVG(Salary) FROM STAFF);

--Mahmoud Queries--

--Ibrahim Queries--
--Vehicle Queris--
 SELECT COUNT(*) AS TotalVehicles
 FROM VEHICLE;

 SELECT DISTINCT V.VehicleID, V.PlateNumber
FROM VEHICLE V
JOIN TRIP t ON V.VehicleID = t.VehicleID;

-- as we expecting, shows which route each vehicle has been used.
SELECT V.PlateNumber, R.RouteName 
FROM VEHICLE V
JOIN TRIP t ON V.VehicleID = t.VehicleID
JOIN ROUTE R ON t.RouteID = R.RouteID;

 --TAXI Queris--
 Select SUM (FareRatePerKM), AVG (FareRatePerKM) , MAX(FareRatePerKM)
 , MIN(FareRatePerKM)
 From TAXI;
 
 SELECT VehicleID, AVG (FareRatePerKM), COUNT (*)
FROM TAXI
GROUP BY VehicleID
HAVING AVG (FareRatePerKM) > 1 ;

select V.PlateNumber , v.Manufacturer , v.Model 
From VEHICLE V
JOIN TAXI T
ON V.VehicleID = T.VehicleID
Where 
V.PlateNumber = 'TAX001'
And V.Manufacturer = 'Toyota'
AND V.Model = 'Camry';
 -- METRO Queris --
SELECT AVG (NumberOfCabins) AS AverageCabins
FROM METRO;

SELECT VehicleID, NumberOfCabins
FROM METRO
WHERE NumberOfCabins > 6;

SELECT V.PlateNumber, V.Manufacturer, V.Model, M.NumberOfCabins
FROM VEHICLE V -- 'V' as a name of it and M like the same to Avoid Misleading--
JOIN METRO  M
ON V.VehicleID = M.VehicleID;
-- Bus Queris --

SELECT BusType, COUNT(*) AS BusCount
FROM BUS
GROUP BY BusType;

SELECT V.PlateNumber, B.BusType
FROM VEHICLE V
JOIN BUS B ON V.VehicleID = B.VehicleID
WHERE B.BusType IN ('Electric', 'Hybrid');
--Ibrahim Queries--

--Hassan Queries--
SELECT [USER].UserID, [USER].FirstName, [USER].LastName,
       PASSENGER.LoyaltyPoints,
       SMART_CARD.CardID, SMART_CARD.CardType, SMART_CARD.Balance
FROM [USER], PASSENGER, SMART_CARD
WHERE [USER].UserID = PASSENGER.PassengerID
  AND PASSENGER.PassengerID = SMART_CARD.PassengerID;


SELECT ROUTE.RouteID, ROUTE.RouteName,
       ROUTE_STOP.RouteStopID, ROUTE_STOP.StopName
FROM ROUTE, ROUTE_STOP
WHERE ROUTE.RouteID = ROUTE_STOP.RouteID;

SELECT ROUTE.RouteID, ROUTE.RouteName,
       COUNT(ROUTE_STOP.RouteStopID) AS StopsCount
FROM ROUTE, ROUTE_STOP
WHERE ROUTE.RouteID = ROUTE_STOP.RouteID
GROUP BY ROUTE.RouteID, ROUTE.RouteName;

SELECT ROUTE.RouteID, ROUTE.RouteName,
       COUNT(ROUTE_STOP.RouteStopID) AS StopsCount
FROM ROUTE, ROUTE_STOP
WHERE ROUTE.RouteID = ROUTE_STOP.RouteID
GROUP BY ROUTE.RouteID, ROUTE.RouteName
HAVING COUNT(ROUTE_STOP.RouteStopID) >= 2;

SELECT LOYALTY_PROGRAM.ProgramName, LOYALTY_PROGRAM.TierName,
       COUNT(ENROLLED_IN.PassengerID) AS PassengerCount
FROM LOYALTY_PROGRAM, ENROLLED_IN
WHERE LOYALTY_PROGRAM.ProgramID = ENROLLED_IN.ProgramID
GROUP BY LOYALTY_PROGRAM.ProgramName, LOYALTY_PROGRAM.TierName;

SELECT AVG(Balance) AS AverageBalance
FROM SMART_CARD;

SELECT SMART_CARD.CardID, SMART_CARD.PassengerID, SMART_CARD.Balance
FROM SMART_CARD
WHERE SMART_CARD.Balance > (SELECT AVG(Balance) FROM SMART_CARD);

SELECT [USER].UserID, [USER].FirstName, [USER].LastName,
       PASSENGER.LoyaltyPoints
FROM [USER], PASSENGER
WHERE [USER].UserID = PASSENGER.PassengerID
  AND PASSENGER.LoyaltyPoints = (SELECT MAX(LoyaltyPoints) FROM PASSENGER);

SELECT [USER].UserID, [USER].FirstName, [USER].LastName
FROM [USER], PASSENGER
WHERE [USER].UserID = PASSENGER.PassengerID
  AND PASSENGER.PassengerID IN (
      SELECT ENROLLED_IN.PassengerID
      FROM ENROLLED_IN, LOYALTY_PROGRAM
      WHERE ENROLLED_IN.ProgramID = LOYALTY_PROGRAM.ProgramID
        AND LOYALTY_PROGRAM.ProgramName = 'CityRider'
  );

  SELECT [USER].UserID, [USER].FirstName, [USER].LastName
FROM [USER], PASSENGER
WHERE [USER].UserID = PASSENGER.PassengerID
  AND EXISTS (
      SELECT *
      FROM ENROLLED_IN
      WHERE ENROLLED_IN.PassengerID = PASSENGER.PassengerID
  );
--Hassan Queries--

--Seif Queries--
--querys--
--trip querys--

--1-All trips include route name, vehicle details, and driver information.--
SELECT TRIP.TripID,TRIP.StartTime,TRIP.EndTime,TRIP.Status,ROUTE.RouteName,VEHICLE.PlateNumber,VEHICLE.Manufacturer,VEHICLE.Model,DRIVER.DriverID
FROM TRIP
JOIN ROUTE ON TRIP.RouteID = ROUTE.RouteID
JOIN VEHICLE ON TRIP.VehicleID = VEHICLE.VehicleID
JOIN DRIVER ON TRIP.DriverID = DRIVER.DriverID;

----------------------------

--2-Completed journeys only, with route duration--
SELECT TRIP.TripID,ROUTE.RouteName,ROUTE.EstimatedDuration,TRIP.Status
FROM TRIP
JOIN ROUTE ON TRIP.RouteID = ROUTE.RouteID
WHERE TRIP.Status = 'Completed';

----------------------------

--3-Number of trips per driver--
SELECT DRIVER.DriverID,COUNT(TRIP.TripID) AS TripsCount
FROM DRIVER
JOIN TRIP ON DRIVER.DriverID = TRIP.DriverID
GROUP BY DRIVER.DriverID;

----------------------------

--4-Trips by vehicle type (Bus / Metro / Taxi)--
SELECT TRIP.TripID,VEHICLE.PlateNumber,BUS.BusType,METRO.NumberOfCabins,TAXI.FareRatePerKM
FROM TRIP
JOIN VEHICLE ON TRIP.VehicleID = VEHICLE.VehicleID
LEFT JOIN BUS ON VEHICLE.VehicleID = BUS.VehicleID
LEFT JOIN METRO ON VEHICLE.VehicleID = METRO.VehicleID
LEFT JOIN TAXI ON VEHICLE.VehicleID = TAXI.VehicleID;

---------------------------
--5-Trips lasting longer than 40 minutes--
SELECT TRIP.TripID,ROUTE.RouteName,ROUTE.EstimatedDuration
FROM TRIP
JOIN ROUTE ON TRIP.RouteID = ROUTE.RouteID
WHERE ROUTE.EstimatedDuration > 40;

---------------------------
--ticket querys--
--6-All tickets with the passenger's name and route name--
SELECT TICKET.TicketNo,TICKET.Price,TICKET.PurchaseTime,[USER].FirstName,[USER].LastName,ROUTE.RouteName
FROM TICKET
JOIN PASSENGER ON TICKET.PassengerID = PASSENGER.PassengerID
JOIN [USER] ON PASSENGER.PassengerID = [USER].UserID
JOIN TRIP ON TICKET.TripID = TRIP.TripID
JOIN ROUTE ON TRIP.RouteID = ROUTE.RouteID;

---------------------------
--7-Number of tickets for each trip--
SELECT TRIP.TripID,ROUTE.RouteName,COUNT(TICKET.TicketNo) AS Tickets_Count
FROM TRIP
JOIN ROUTE ON TRIP.RouteID = ROUTE.RouteID
JOIN TICKET ON TRIP.TripID = TICKET.TripID
GROUP BY TRIP.TripID, ROUTE.RouteName;

--------------------------
--8-Total ticket price per trip--
SELECT TRIP.TripID,ROUTE.RouteName,SUM(TICKET.Price) AS TotalRevenue
FROM TRIP
JOIN ROUTE ON TRIP.RouteID = ROUTE.RouteID
JOIN TICKET ON TRIP.TripID = TICKET.TripID
GROUP BY TRIP.TripID, ROUTE.RouteName;

--------------------------
--9-Trips that sold tickets--
SELECT TRIP.TripID,ROUTE.RouteName,COUNT(TICKET.TicketNo) AS TicketsSold
FROM TRIP
JOIN ROUTE ON TRIP.RouteID = ROUTE.RouteID
JOIN TICKET ON TRIP.TripID = TICKET.TripID
GROUP BY TRIP.TripID, ROUTE.RouteName
HAVING COUNT(TICKET.TicketNo) >= 1;

--------------------------
--route querys
--10-Route has Trips running now--

SELECT ROUTE.RouteName,TRIP.TripID,TRIP.Status
FROM ROUTE
JOIN TRIP ON ROUTE.RouteID = TRIP.RouteID
WHERE TRIP.Status = 'In Progress';

--------------------------
--11-Route is not working at all [there are no trips on it]--
SELECT ROUTE.RouteID,ROUTE.RouteName
FROM ROUTE
LEFT JOIN TRIP ON ROUTE.RouteID = TRIP.RouteID
WHERE TRIP.TripID IS NULL;

--------------------------
--Seif Queries--

--Youssef Queries--
--Queries for ENROLLED_IN
SELECT *
FROM ENROLLED_IN;

SELECT ProgramID
FROM ENROLLED_IN
WHERE PassengerID = 101;

SELECT E.PassengerID, E.ProgramID
FROM ENROLLED_IN E
JOIN LOYALTY_PROGRAM L
ON E.ProgramID = L.ProgramID
WHERE L.ProgramName = 'CityRider';

SELECT E.PassengerID, L.ProgramName, L.DiscountRate
FROM ENROLLED_IN E
JOIN LOYALTY_PROGRAM L
ON E.ProgramID = L.ProgramID
WHERE L.DiscountRate >= 20;

SELECT E.PassengerID, L.TierName
FROM ENROLLED_IN E
JOIN LOYALTY_PROGRAM L
ON E.ProgramID = L.ProgramID;

SELECT L.ProgramName, COUNT(*) AS PassengerCount
FROM ENROLLED_IN E
JOIN LOYALTY_PROGRAM L
ON E.ProgramID = L.ProgramID
GROUP BY L.ProgramName;

SELECT E.PassengerID, P.LoyaltyPoints, L.ProgramName
FROM ENROLLED_IN E
JOIN PASSENGER P ON E.PassengerID = P.PassengerID
JOIN LOYALTY_PROGRAM L ON E.ProgramID = L.ProgramID;

SELECT L.ProgramName, L.TierName
FROM ENROLLED_IN E
JOIN LOYALTY_PROGRAM L
ON E.ProgramID = L.ProgramID
WHERE E.PassengerID = 107;

SELECT PassengerID
FROM PASSENGER
WHERE PassengerID NOT IN (
    SELECT PassengerID
    FROM ENROLLED_IN
);
--Queries for TRIP_LOCATION:
SELECT *
FROM TRIP_LOCATION;

SELECT *
FROM TRIP_LOCATION
WHERE TripID = 601
ORDER BY Timestamp;

SELECT TripID, MAX(Speed) AS MaxSpeed
FROM TRIP_LOCATION
GROUP BY TripID;

SELECT TripID, AVG(Speed) AS AverageSpeed
FROM TRIP_LOCATION
GROUP BY TripID;

SELECT MAX(Speed) AS HighestRecordedSpeed
FROM TRIP_LOCATION;

SELECT *
FROM TRIP_LOCATION
WHERE Speed > 30;

SELECT *
FROM TRIP_LOCATION
WHERE Latitude BETWEEN 30.00 AND 30.10
  AND Longitude BETWEEN 31.20 AND 31.30;

SELECT TripID, MAX(Timestamp) AS LastUpdate
FROM TRIP_LOCATION
GROUP BY TripID;

SELECT T.TripID, T.Status, TL.Timestamp, TL.Speed
FROM TRIP T
JOIN TRIP_LOCATION TL
ON T.TripID = TL.TripID
ORDER BY T.TripID, TL.Timestamp;
--Queries for LOYALTY_PROGRAM: 
SELECT * 
FROM LOYALTY_PROGRAM;

SELECT ProgramName, TierName, DiscountRate
FROM LOYALTY_PROGRAM;

SELECT *
FROM LOYALTY_PROGRAM
WHERE DiscountRate > 10;

SELECT TOP 1 *
FROM LOYALTY_PROGRAM
ORDER BY PointsPerTrip DESC;

SELECT AVG(DiscountRate) AS AverageDiscount
FROM LOYALTY_PROGRAM;

SELECT COUNT(*) AS TotalPrograms
FROM LOYALTY_PROGRAM;

SELECT ProgramName, TierName, DiscountRate
FROM LOYALTY_PROGRAM
ORDER BY DiscountRate DESC;

SELECT *
FROM LOYALTY_PROGRAM
WHERE PointsPerTrip BETWEEN 10 AND 16;

SELECT ProgramName, COUNT(*) AS NumberOfTiers
FROM LOYALTY_PROGRAM
GROUP BY ProgramName;
--Youssef Queries--

/* Trigger*/
--Mahmoud
CREATE TRIGGER trg_UpdateLoyaltyPoints
ON TICKET
AFTER INSERT
AS
BEGIN
    UPDATE PASSENGER
    SET LoyaltyPoints = LoyaltyPoints + 10
    WHERE PassengerID IN (SELECT PassengerID FROM inserted);
END;
/* View*/

--Mahmoud
CREATE VIEW vw_PassengerTrips
AS
SELECT 
    U.FirstName,
    U.LastName,
    T.TicketNo,
    Tr.TripID,
    R.RouteName,
    T.Price
FROM TICKET T
JOIN PASSENGER P ON T.PassengerID = P.PassengerID
JOIN [USER] U ON P.PassengerID = U.UserID
JOIN TRIP Tr ON T.TripID = Tr.TripID
JOIN ROUTE R ON Tr.RouteID = R.RouteID;
--
SELECT * FROM vw_PassengerTrips;