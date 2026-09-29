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