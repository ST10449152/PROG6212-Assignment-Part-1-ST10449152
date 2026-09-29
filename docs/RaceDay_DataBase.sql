CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

CREATE TABLE Users
(
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Venues
(
    VenueID INT IDENTITY(1,1) PRIMARY KEY,
    VenueName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Capacity INT NOT NULL,
    ContactNumber NVARCHAR(20),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventName NVARCHAR(100) NOT NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    VenueID INT NOT NULL,
    Description NVARCHAR(500),
    
    CONSTRAINT FK_Events_Venues
        FOREIGN KEY (VenueID)
        REFERENCES Venues(VenueID)
);
GO

CREATE TABLE Registrations
(
    RegistrationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    EventID INT NOT NULL,
    RegistrationDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    RegistrationStatus NVARCHAR(20) NOT NULL DEFAULT 'Registered',

    CONSTRAINT FK_Registrations_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Registrations_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID)
);
GO

ALTER TABLE Users
ADD CONSTRAINT UQ_Users_Email UNIQUE (Email);
GO

ALTER TABLE Users
ADD CONSTRAINT CK_Users_Role
CHECK (Role IN ('Organiser', 'Participant'));
GO

ALTER TABLE Venues
ADD CONSTRAINT CK_Venues_Capacity
CHECK (Capacity > 0);
GO

ALTER TABLE Events
ADD CONSTRAINT CK_Events_Time
CHECK (EndTime > StartTime);
GO

ALTER TABLE Registrations
ADD CONSTRAINT UQ_Registrations_User_Event
UNIQUE (UserID, EventID);
GO

ALTER TABLE Registrations
ADD CONSTRAINT CK_Registrations_Status
CHECK (RegistrationStatus IN ('Registered', 'Cancelled', 'Completed'));
GO

ALTER TABLE Events
ADD CONSTRAINT CK_Events_Description
CHECK (Description IS NULL OR LEN(Description) >= 10);
GO

ALTER TABLE Users
ADD CONSTRAINT CK_Users_Email
CHECK (
    Email LIKE '%_@_%._%'
);
GO

CREATE INDEX IX_Users_Email
ON Users(Email);
GO

CREATE INDEX IX_Events_EventDate
ON Events(EventDate);
GO

CREATE INDEX IX_Events_VenueID
ON Events(VenueID);
GO

CREATE INDEX IX_Registrations_EventID
ON Registrations(EventID);
GO

INSERT INTO Users
    (FirstName, LastName, Email, PasswordHash, Role)
VALUES
    ('Thabo', 'Mokoena', 'thabo@raceday.co.za', 'DemoHash001', 'Organiser'),
    ('Lerato', 'Dlamini', 'lerato@example.com', 'DemoHash002', 'Participant'),
    ('Jason', 'Naidoo', 'jason@example.com', 'DemoHash003', 'Participant');
GO

INSERT INTO Venues
    (VenueName, Address, Capacity, ContactNumber)
VALUES
    ('Johannesburg Race Track', 'Johannesburg, Gauteng', 5000, '0111234567'),
    ('Pretoria Sports Arena', 'Pretoria, Gauteng', 3500, '0127654321');
GO

INSERT INTO Events
    (EventName, EventDate, StartTime, EndTime, VenueID, Description)
VALUES
    ('Johannesburg 10K', '2026-11-15', '08:00', '12:00', 1,
     'Annual Johannesburg 10 kilometre road race'),

    ('Pretoria City Run', '2026-12-05', '07:00', '11:00', 2,
     'Community running event through Pretoria');
GO