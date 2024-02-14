INSERT INTO Users (Title, Name, Email, PhoneNumber, NewExistingUser, Budget, ZeroDebtAndThirdParty, VehicleRegistrationNumber)
VALUES
    ('Mr.', 'Rahul Sharma', 'rahul.sharma@example.com', '9876543210', 'New', 5000.00, 'Yes', 'MH01AB1234'),
    ('Ms.', 'Priya Patel', 'priya.patel@example.com', '9765432109', 'Existing', 7000.50, 'No', 'GJ02CD5678'),
    ('Dr.', 'Suresh Kumar', 'suresh.kumar@example.com', '9654321098', 'New', 10000.00, 'Yes', 'DL03EF9012'),
    ('Mrs.', 'Anita Desai', 'anita.desai@example.com', '9543210987', 'Existing', 8000.75, 'No', 'KA04GH3456'),
    ('Mr.', 'Vikram Singh', 'vikram.singh@example.com', '9432109876', 'New', 6000.25, 'Yes', 'TN05IJ6789'),
    ('Ms.', 'Aisha Khan', 'aisha.khan@example.com', '9321098765', 'Existing', 9000.50, 'No', 'AP06KL1234'),
    ('Dr.', 'Neha Gupta', 'neha.gupta@example.com', '9210987654', 'New', 7500.00, 'Yes', 'MH07MN5678'),
    ('Mr.', 'Rajiv Verma', 'rajiv.verma@example.com', '9109876543', 'Existing', 8200.30, 'No', 'UP08OP9012'),
    ('Mrs.', 'Anjali Joshi', 'anjali.joshi@example.com', '9098765432', 'New', 9800.75, 'Yes', 'RJ09QR3456'),
    ('Ms.', 'Rohan Kapoor', 'rohan.kapoor@example.com', '9876543210', 'Existing', 6500.50, 'No', 'MP10ST6789');

INSERT INTO UserAuth (UserID, Email, Password)
VALUES
    (1, 'rahul.sharma@example.com', 'RahuSha0'),
    (2, 'priya.patel@example.com', 'PriyPat5'),
    (3, 'suresh.kumar@example.com', 'SureKum8'),
    (4, 'anita.desai@example.com', 'AnitDes6'),
    (5, 'vikram.singh@example.com', 'VikrSing2'),
    (6, 'aisha.khan@example.com', 'AishKhan7'),
    (7, 'neha.gupta@example.com', 'NehaGup5'),
    (8, 'rajiv.verma@example.com', 'RajiVerm4'),
    (9, 'anjali.joshi@example.com', 'AnjaJosh3'),
    (10, 'rohan.kapoor@example.com', 'RohaKapo9');

INSERT INTO VehicleInformation (VehicleNumber, FuelType, Model, Company, VehicleType, RegistrationDate, UserID)
VALUES
    ('MH01AB1234', 'Petrol', 'Sedan', 'Toyota', 'Personal', '2022-01-15', 1),
    ('GJ02CD5678', 'Diesel', 'SUV', 'Ford', 'Commercial', '2021-11-20', 1),
    ('DL03EF9012', 'Electric', 'Hatchback', 'Tesla', 'Commercial', '2014-03-05', 3),
    ('KA04GH3456', 'Petrol', 'Convertible', 'BMW', 'Personal', '2021-05-10', 4),
    ('TN05IJ6789', 'Hybrid', 'Crossover', 'Honda', 'Commercial', '2023-08-15', 4),
    ('AP06KL1234', 'Diesel', 'Truck', 'Chevrolet', 'Commercial', '2018-04-02', 6),
    ('MH07MN5678', 'Electric', 'Compact', 'Nissan', 'Personal', '2021-12-30', 7),
    ('UP08OP9012', 'Petrol', 'Coupe', 'Mercedes', 'Personal', '2015-02-18', 8),
    ('RJ09QR3456', 'Diesel', 'SUV', 'Ford', 'Commercial', '2017-07-25', 9),
    ('MP10ST6789', 'Hybrid', 'Sedan', 'Lexus', 'Personal', '2019-09-12', 10);

INSERT INTO InsuranceCompanies (CompanyName, CustomerServiceRating, ClaimSettlementRatio)
VALUES
    ('State Farm', 4.50, 95.20),
    ('Allstate Insurance', 4.20, 92.80),
    ('Geico', 4.80, 97.50),
    ('Progressive Insurance', 4.00, 89.60),
    ('Liberty Mutual', 4.60, 94.30),
    ('Nationwide', 4.30, 91.00),
    ('AIG', 4.70, 96.20),
    ('Travelers Insurance', 4.10, 88.70),
    ('MetLife', 4.40, 93.10),
    ('Chubb Limited', 4.90, 98.00);

INSERT INTO InsurancePlans (CompanyID, PolicyNumber, PolicyName, PolicyPrice, DamageCover, Duration, Discount, TotalCost, VehicleID)
VALUES
    (1, 'POL123', 'Comprehensive Coverage', 5000.00, 'Accidental Damage, Theft, Fire', 12, 0.10, 450.00, 1),
    (1, 'POL456', 'Basic Insurance', 3000.00, 'Accidental Damage', 6, 0.05, 285.00, 2),
    (3, 'POL789', 'Premium Protection', 7000.00, 'Accidental Damage, Theft, Fire, Natural Disasters', 18, 0.15, 595.00, 3),
    (4, 'POLABC', 'Standard Coverage', 4000.00, 'Accidental Damage, Theft', 9, 0.08, 368.00, 4),
    (5, 'POLDEF', 'Full Coverage', 6000.00, 'Accidental Damage, Theft, Fire, Natural Disasters', 24, 0.12, 528.00, 5),
    (5, 'POLGHI', 'Extended Warranty', 2000.00, 'Mechanical Breakdown', 12, 0.03, 194.00, 6),
    (7, 'POLUVW', 'Ultimate Shield', 8000.00, 'Accidental Damage, Theft, Fire, Natural Disasters', 36, 0.20, 640.00, 7),
    (8, 'POLJKL', 'Basic Protection', 3500.00, 'Accidental Damage', 15, 0.07, 325.50, 8),
    (8, 'POLMNO', 'Premium Plus', 9000.00, 'Accidental Damage, Theft, Fire, Natural Disasters', 30, 0.18, 738.00, 9),
    (10, 'POLRST', 'Value Plan', 2500.00, 'Accidental Damage', 8, 0.04, 240.00, 10);

INSERT INTO Comparison (PolicyName, PolicyPrice, DamageCover, Company)
SELECT 
    ip.PolicyName, 
    ip.PolicyPrice, 
    ip.DamageCover,
    vi.Company
FROM InsurancePlans ip
JOIN VehicleInformation vi ON ip.VehicleID = vi.VehicleID;


-- insert test admin
INSERT INTO Admin (Title, Name, Email, PhoneNumber) VALUES ('Mr.', 'Mahesh Pharande', 'mahesh@example.com', 9860696969);
INSERT INTO AdminAuth(AdminID, Email, Password) VALUES(LAST_INSERT_ID(),'mahesh@example.com','Mahesh@12345');

-- insert test provider

INSERT INTO ServiceProvider (Title, Name, Email, PhoneNumber, CompanyID) VALUES ('Ms.', 'Pratiksha Kakade', 'kakadepratiksha18@example.com', 9860696969,9);
INSERT INTO ProviderAuth(ProviderID, Email, Password) VALUES(LAST_INSERT_ID(),'kakadepratiksha18@example.com','Pratiksha@321');