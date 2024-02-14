SET GLOBAL log_bin_trust_function_creators = 1;

DROP TRIGGER IF EXISTS Users_Audit_Trigger;
DROP TRIGGER IF EXISTS Users_Audit_Trigger_UPDATE;
DROP TRIGGER IF EXISTS Users_Audit_Trigger_DELETE;
DROP PROCEDURE IF EXISTS CompareInsurancePlansWithCoveragePref;
DROP PROCEDURE IF EXISTS CompareInsurancePlansWithBudget;
DROP FUNCTION IF EXISTS CalculatePremium;
DROP FUNCTION IF EXISTS CalculateDiscount;
DROP FUNCTION IF EXISTS CalculateVehicleAge;

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

DELIMITER //

CREATE PROCEDURE CompareInsurancePlansWithBudget (
    IN userBudget DECIMAL(10, 2)
)
BEGIN
    SELECT IC.CompanyName, IP.PolicyName, IP.PolicyPrice, IP.DamageCover
    FROM InsurancePlans IP
    JOIN InsuranceCompanies IC ON IP.CompanyID = IC.CompanyID
    WHERE IP.PolicyPrice <= userBudget LIMIT 5;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Users_Audit_Trigger AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO Users_Audit (UserID, Action, Timestamp)
    VALUES (NEW.UserID, 'INSERT', NOW());
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Users_Audit_Trigger_UPDATE AFTER UPDATE ON Users
FOR EACH ROW
BEGIN
    INSERT INTO Users_Audit (UserID, Action, Timestamp)
    VALUES (NEW.UserID, 'UPDATE', NOW());
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER Users_Audit_Trigger_DELETE AFTER DELETE ON Users
FOR EACH ROW
BEGIN
    INSERT INTO Users_Audit (UserID, Action, Timestamp)
    VALUES (OLD.UserID, 'DELETE', NOW());
END //

DELIMITER ;

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



CREATE VIEW InsurancePlanSummary AS
SELECT IP.PlanID, IP.PolicyName, IP.PolicyPrice, IP.DamageCover, IC.CompanyName
FROM InsurancePlans IP
JOIN InsuranceCompanies IC ON IP.CompanyID = IC.CompanyID;