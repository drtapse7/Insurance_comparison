-- Registration Query

-- For User

INSERT INTO Users (Title, Name, Email, PhoneNumber, NewExistingUser, Budget, ZeroDebtAndThirdParty, VehicleRegistrationNumber)
VALUES ('Mr.', 'Mahesh Pharande', 'mahesh@example.com', '9876543210', 'New', 5000.00, 'Yes', 'MH12AB1234');

INSERT INTO UserAuth(UserID, Email, Password) VALUES (LAST_INSERT_ID(), 'mahesh@example.com', 'Mahesh@12345');

SELECT * FROM UserAuth;
SELECT * FROM Users;

-- For Admin

INSERT INTO Admin (Title, Name, Email, PhoneNumber) VALUES ('Mr.', 'Mahesh Pharande', 'mahesh@example.com', 9860696969);
INSERT INTO AdminAuth(AdminID, Email, Password) VALUES(LAST_INSERT_ID(),'mahesh@example.com','Mahesh@12345');

SELECT * FROM AdminAuth;
SELECT * FROM Admin;

-- For Provider

-- Get unique company list (dropdown)
SELECT CompanyName FROM InsuranceCompanies

-- Get Company ID by selecting company from drop down

INSERT INTO ServiceProvider (Title, Name, Email, PhoneNumber, CompanyID) VALUES ('Ms.', 'Pratiksha Kakade', 'kakadepratiksha18@example.com', 9860696969,9);
INSERT INTO ProviderAuth(ProviderID, Email, Password) VALUES(LAST_INSERT_ID(),'kakadepratiksha18@example.com','Pratiksha@321');

SELECT * FROM ProviderAuth;
SELECT * FROM ServiceProvider;


-- Check
-- User
-- Admin mahesh@example.com Mahesh@12345
-- Provider kakadepratiksha18@example.com Pratiksha@321