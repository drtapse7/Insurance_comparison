SET GLOBAL log_bin_trust_function_creators = 1;

DROP PROCEDURE CompareInsurancePlans;
DROP FUNCTION CalculatePremium;
DROP FUNCTION CalculateDiscount;
DROP FUNCTION CalculateVehicleAge;
DROP TRIGGER Users_Audit_Trigger;
DROP TRIGGER Users_Audit_Trigger_DELETE;
DROP TRIGGER Users_Audit_Trigger_UPDATE;

-- STORED PROCEDURES

-- 1. Compare Insurance Plans:
DELIMITER //

CREATE PROCEDURE CompareInsurancePlansWithCoveragePref (
    IN userBudget DECIMAL(10, 2),
    IN coveragePreference VARCHAR(50)
)
BEGIN
    SELECT IC.CompanyName, IP.PolicyName, IP.PolicyPrice, IP.DamageCover
    FROM InsurancePlans IP
    JOIN InsuranceCompanies IC ON IP.CompanyID = IC.CompanyID
    WHERE IP.PolicyPrice <= userBudget
    AND IP.DamageCover = coveragePreference;
END //

DELIMITER ;

-- Run:
CALL CompareInsurancePlansWithCoveragePref(5000, 'Accidental Damage');
CALL CompareInsurancePlansWithCoveragePref(7000, 'Accidental Damage, Theft, Fire, Natural Disasters');


-- 2. Compare Insurance Plans Without Coverage Preferance:
DELIMITER //

CREATE PROCEDURE CompareInsurancePlansWithBudget (
    IN userBudget DECIMAL(10, 2)1
)
BEGIN
    SELECT IC.CompanyName, IP.PolicyName, IP.PolicyPrice, IP.DamageCover
    FROM InsurancePlans IP
    JOIN InsuranceCompanies IC ON IP.CompanyID = IC.CompanyID
    WHERE IP.PolicyPrice <= userBudget LIMIT 5;
END //

DELIMITER ;

-- RUn:
CALL CompareInsurancePlansWithBudget(5000);
CALL CompareInsurancePlansWithBudget(7000);

-- FUNCTIONS

-- 1. Calculate Premium
DELIMITER //

CREATE FUNCTION CalculatePremium(
    PolicyPrice DECIMAL(10,2),
    coverageType VARCHAR(50),
    vehicleAge INT,
    ZeroDebtAndThirdParty VARCHAR(5)
)
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE premium DECIMAL(10, 2);
    IF coverageType = 'Accidental Damage, Theft, Fire, Natural Disasters' THEN
        SET premium = 7000;
    ELSEIF coverageType = 'Accidental Damage, Theft, Fire' THEN
        SET premium = 6000;
    ELSEIF coverageType = 'Accidental Damage, Theft' THEN
        SET premium = 5000;
    ELSEIF coverageType = 'Accidental Damage' THEN
        SET premium = 4000;
    ELSE
        SET premium = 3000 + PolicyPrice;
    END IF;

    IF vehicleAge > 10 THEN
        SET premium = premium * 2;
    ELSEIF vehicleAge <= 5 THEN
        SET premium = premium * 1.5;
    END IF;

    IF ZeroDebtAndThirdParty = 'Yes' THEN
        SET premium = premium * 2.0;
    END IF;

    SET premium = premium + PolicyPrice;

    RETURN premium;
END //

DELIMITER ;

-- Run:
-- SELECT CalculatePremium(7000,'Accidental Damage',4,'Yes') 'Premium';
-- SELECT CalculatePremium(4000,('Accidental Damage' 'Theft'),4,'No') 'Premium';

SELECT CONCAT(u.Title, ' ', u.Name) AS FullName, v.VehicleID, v.VehicleNumber, I.DamageCover,u.ZeroDebtAndThirdParty 'ZeroDebt',
(SELECT CalculatePremium(I.PolicyPrice, I.DamageCover, CalculateVehicleAge(v.RegistrationDate), u.ZeroDebtAndThirdParty)) AS 'Premium'
FROM Users u
JOIN VehicleInformation v ON u.UserID = v.UserID
JOIN InsurancePlans I ON v.VehicleID = I.VehicleID;


--2. Calculate discount (Extra: can be changed)
DELIMITER //

CREATE FUNCTION CalculateDiscount(
    policyTenure INT
)
RETURNS DECIMAL(5, 2)
BEGIN
    DECLARE discount DECIMAL(5, 2);
    IF policyTenure > 24 THEN
        SET discount =  0.2;
    ELSEIF policyTenure <= 24 AND policyTenure > 12 THEN
        SET discount = 0.12;
    ELSEIF policyTenure > 6 AND policyTenure <= 12 THEN
        SET discount = 0.08;
    ELSEIF policyTenure >= 3 AND policyTenure <= 6  THEN
        SET discount = 0.01;
    ELSE
        SET discount = 0;
    END IF;

    RETURN discount;
END //

DELIMITER ;

-- RUn:
SELECT u.UserID, CONCAT(u.Title, ' ', u.Name) AS `Full Name`, I.Duration AS `Tenure`, CONCAT(CalculateDiscount(I.Duration) * 100, '%') AS `Discount`
FROM Users u
JOIN VehicleInformation V ON u.UserID = V.UserID
JOIN InsurancePlans I ON V.VehicleID = I.VehicleID;



--3. Calculate Vehicle age
DELIMITER //

CREATE FUNCTION CalculateVehicleAge(
    registrationDate DATE
)
RETURNS INT
BEGIN
    DECLARE todayDate DATE;
    DECLARE vehicleAge INT;
    SET todayDate = CURDATE();
    SET vehicleAge = YEAR(todayDate) - YEAR(registrationDate);
    IF MONTH(todayDate) < MONTH(registrationDate) OR (MONTH(todayDate) = MONTH(registrationDate) AND DAY(todayDate) < DAY(registrationDate)) THEN
        SET vehicleAge = vehicleAge - 1;
    END IF;

    RETURN vehicleAge;
END //

DELIMITER ;

-- Run:
SELECT v.VehicleNumber, v.RegistrationDate, CalculateVehicleAge(v.RegistrationDate) 'Age' FROM VehicleInformation v;

-- TRIGGERS

-- 1. Insert trigger
DELIMITER //

CREATE TRIGGER Users_Audit_Trigger AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO Users_Audit (UserID, Action, Timestamp)
    VALUES (NEW.UserID, 'INSERT', NOW());
END //

DELIMITER ;

-- 2. Update trigger
DELIMITER //

CREATE TRIGGER Users_Audit_Trigger_UPDATE AFTER UPDATE ON Users
FOR EACH ROW
BEGIN
    INSERT INTO Users_Audit (UserID, Action, Timestamp)
    VALUES (NEW.UserID, 'UPDATE', NOW());
END //

DELIMITER ;

-- 3. Delete trigger
DELIMITER //

CREATE TRIGGER Users_Audit_Trigger_DELETE AFTER DELETE ON Users
FOR EACH ROW
BEGIN
    INSERT INTO Users_Audit (UserID, Action, Timestamp)
    VALUES (OLD.UserID, 'DELETE', NOW());
END //


DELIMITER ;

-- 4. Email format check
DELIMITER //

CREATE TRIGGER ValidateEmailFormat BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    DECLARE emailPattern VARCHAR(100);
    SET emailPattern = '^[a-zA-Z0-9._%+-]{3,}@[a-zA-Z0-9.-]{3,}\\.[a-zA-Z]{2,}$';

    IF NEW.Email REGEXP emailPattern = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format. Please provide a valid email.';
    END IF;
END //

DELIMITER ;

-- Run (email check)
INSERT INTO Users (UserID, Title, Name, Email, PhoneNumber, NewExistingUser, Budget, ZeroDebtAndThirdParty, VehicleRegistrationNumber)
VALUES (99, 'Mr.', 'Rahul Sharma', 'rahulsharma.com', '9876543210', '', 5000.00, 'Yes', 'MH01AB1234');

-- Run (For trigger Insert, Update, Delete Demo)
-- 1 Insert
INSERT INTO Users (UserID, Title, Name, Email, PhoneNumber, NewExistingUser, Budget, ZeroDebtAndThirdParty, VehicleRegistrationNumber)
VALUES (100, 'Mr.', 'Andy Sharma', 'email@example.com', '1234567890', 'New', 5000.00, 'Yes', 'MH03AB5678');
-- 2 Update
UPDATE Users SET PhoneNumber = "9876543210" WHERE UserID = 100;
-- 3 Delete
DELETE FROM Users WHERE UserID = 100;

SELECT * FROM Users;
SELECT * FROM Users_Audit;

-- VIEWS


CREATE VIEW InsurancePlanSummary AS
SELECT IP.PlanID, IP.PolicyName, IP.PolicyPrice, IP.DamageCover, IC.CompanyName
FROM InsurancePlans IP
JOIN InsuranceCompanies IC ON IP.CompanyID = IC.CompanyID;

-- Run
SELECT * FROM InsurancePlanSummary;