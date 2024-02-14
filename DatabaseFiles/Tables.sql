CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT,
    Title VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(20),
    NewExistingUser VARCHAR(20) DEFAULT 'New',
    Budget DECIMAL(10,2),
    ZeroDebtAndThirdParty VARCHAR(5),
    VehicleRegistrationNumber VARCHAR(20),
    CONSTRAINT uc_Email UNIQUE (Email),
    CONSTRAINT chk_Budget CHECK (Budget >= 0),
    CONSTRAINT chk_phone CHECK ((LENGTH(PhoneNumber) = 10) AND PhoneNumber > 0),
    CONSTRAINT pk_UserID PRIMARY KEY(UserID)
);

CREATE INDEX idx_Name ON Users(Name);


CREATE TABLE IF NOT EXISTS VehicleInformation (
    VehicleID INT AUTO_INCREMENT,
    VehicleNumber VARCHAR(20) UNIQUE NOT NULL,
    FuelType VARCHAR(50) NOT NULL,
    Model VARCHAR(100) NOT NULL,
    Company VARCHAR(100) NOT NULL,
    VehicleType VARCHAR(50) NOT NULL,
    RegistrationDate DATE NOT NULL,
    UserID INT NOT NULL,
    CONSTRAINT fk_VehicleID PRIMARY KEY(VehicleID),
    CONSTRAINT fk_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS InsuranceCompanies (
    CompanyID INT NOT NULL AUTO_INCREMENT,
    CompanyName VARCHAR(100) NOT NULL,
    CustomerServiceRating DECIMAL(3,2),
    ClaimSettlementRatio DECIMAL(5,2),
    CONSTRAINT pk_CompanyID PRIMARY KEY(CompanyID)
);


CREATE TABLE IF NOT EXISTS InsurancePlans (
    PlanID INT AUTO_INCREMENT,
    CompanyID INT NOT NULL,
    PolicyNumber VARCHAR(50) NOT NULL,
    PolicyName VARCHAR(100) NOT NULL,
    PolicyPrice DECIMAL(10,2) NOT NULL,
    DamageCover VARCHAR(100) NOT NULL,
    Duration INT NOT NULL,
    Discount DECIMAL(5,2),
    TotalCost DECIMAL(10,2) NOT NULL,
    VehicleID INT,
    CONSTRAINT PK_PlanID PRIMARY KEY(PlanID),
    CONSTRAINT fk_companyID FOREIGN KEY (CompanyID) REFERENCES InsuranceCompanies(CompanyID) ON DELETE CASCADE,
    CONSTRAINT fk_VehicleID FOREIGN KEY (VehicleID) REFERENCES VehicleInformation(VehicleID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Users_Audit (
    AuditID INT AUTO_INCREMENT,
    UserID INT,
    Action VARCHAR(10),
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_AuditID PRIMARY KEY(AuditID)
);

CREATE TABLE Comparison (
    ResultID INT AUTO_INCREMENT PRIMARY KEY,
    PolicyName VARCHAR(100),
    PolicyPrice DECIMAL(10, 2),
    DamageCover VARCHAR(50),
    Company VARCHAR(100)
);

INSERT INTO Comparison (PolicyName, PolicyPrice, DamageCover, Company)
SELECT 
    ip.PolicyName, 
    ip.PolicyPrice, 
    ip.DamageCover,
    vi.Company
FROM InsurancePlans ip
JOIN VehicleInformation vi ON ip.VehicleID = vi.VehicleID;



CREATE TABLE IF NOT EXISTS Admin (
    AdminID INT AUTO_INCREMENT,
    Title VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    CONSTRAINT pk_AdminID PRIMARY KEY(AdminID)
);

CREATE TABLE IF NOT EXISTS ServiceProvider (
    ProviderID INT AUTO_INCREMENT,
    Title VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(20),
    CompanyID INT NOT NULL,
    CONSTRAINT pk_ProviderID PRIMARY KEY(ProviderID),
    FOREIGN KEY (CompanyID) REFERENCES InsuranceCompanies(CompanyID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS UserAuth(
    UserID INT,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS AdminAuth (
    AdminID INT,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    FOREIGN KEY (AdminID) REFERENCES Admin(AdminID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ProviderAuth (
    ProviderID INT,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    FOREIGN KEY (ProviderID) REFERENCES ServiceProvider(ProviderID) ON DELETE CASCADE
);