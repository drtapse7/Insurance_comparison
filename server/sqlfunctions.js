var sql = require("mysql2");

var con = sql.createConnection({
  host: "localhost",
  user: "root",
  password: "govind",
  database: "project",
});

con.connect(function (err) {
  if (!err) {
    console.log("connection established");
  } else {
    console.log("connection failed");
  }
});

exports.getAllUsers = function (callback) {
  //const q = `SELECT * FROM employees LIMIT 25`;
  const q = `SELECT * FROM Users`;
  con.query(q, function (err, result) {
    if (err) {
      callback(err, null);
    } else {
      callback(null, result);
    }
  });
};

exports.setUser = function (Title, NAME, EMAIL, PHONE, callback) {
  var titleNumber = parseInt(Title);
  var title;

  if (titleNumber === 1) {
    title = "Mr.";
  } else if (titleNumber === 2) {
    title = "Mrs.";
  } else if (titleNumber === 3) {
    title = "Ms.";
  } else if (titleNumber === 4) {
    title = "Dr.";
  } else {
    title = "";
  }
  //var query = `INSERT INTO Users (Title, Name, Email, PhoneNumber, NewExistingUser, Budget, ZeroDebtAndThirdParty, VehicleRegistrationNumber) VALUES('${Title}','${NAME}','${EMAIL}',${PHONE},'${NEWEXISTING}',${BUDGET},'${ZeroDebtAndThirdParty}','${VehicleRegistrationNumber}');`;
  var query = `INSERT INTO Users (Title, Name, Email, PhoneNumber) VALUES('${title}','${NAME}','${EMAIL}',${PHONE});`;
  con.query(query, [Title, NAME, EMAIL, PHONE], function (err) {
    console.log(query);
    if (!err) {
      callback(true);
    } else {
      callback(false);
    }
  });
};

exports.checkAuthentication = function (email, password, role, callback) {
  var q = "";
  if (role == 0) {
    q = `SELECT UserID FROM UserAuth WHERE Email = '${email}' AND Password = '${password}';`;
  } else if (role == 1) {
    q = `SELECT AdminID FROM AdminAuth WHERE Email = '${email}' AND Password = '${password}';`;
  } else if (role == 2) {
    q = `SELECT ProviderID FROM ProviderAuth WHERE Email = '${email}' AND Password = '${password}';`;
  }
  con.query(q, function (err, result) {
    if (err) {
      callback(err, null, false);
    } else {
      if (result && result.length > 0) {
        // select * from Users_Audit;
        if (role == 0){
          var uid = result[0].UserID;
          
          q = `INSERT INTO Users_Audit (UserID, Action, Timestamp) VALUES(${uid},'LOGIN',NOW());`;
          console.log(q);
          con.query(q,function(err){
            if(!err){
              console.log('insert query successful')
            }
          })
        }
        if (role == 1){
          console.log("the admin id "+result[0].AdminID)
        }
        if(role == 2){
          console.log("the provider id "+result[0].ProviderID)
        }
        callback(null, result, true);
      } else {
        callback(null, result, false);
      }
    }
  }); 
};

exports.getAllCompanies = function (callback) {
  var q = "SELECT CompanyName FROM InsuranceCompanies";
  con.query(q, function (err, result) {
    if (err) {
      callback(err, null);
    } else {
      callback(null, result);
    }
  });
};

exports.checkEmailExist = function (email, callback) {
  var q = `SELECT Email FROM Users WHERE Email = '${email}';`;
  con.query(q, function (err, result) {
    if (err) {
      callback(false);
    } else {
      if (result && result.length > 0) {
        callback(true);
      } else {
        callback(false);
      }
    }
  });
};

exports.setUserAuth = function(email, password, callback){
  var q = `INSERT INTO UserAuth (UserID, Email, Password) VALUES(LAST_INSERT_ID(),'${email}','${password}');`;
  con.query(q,[email, password], function(err){
    if (!err) {
      callback(true);
    } else {
      callback(false);
    }
  })
}

exports.getUserInfoByID = function (userid, callback) {
  const q = `SELECT * FROM Users WHERE UserID = ${userid}`;
  con.query(q, function (err, result) {
    if (err) {
      callback(err, null);
    } else {
      callback(null, result);
    }
  });
};

exports.getAdminInfoByID = function (adminid, callback) {
  const q = `SELECT * FROM Admin WHERE AdminID = ${adminid}`;
  con.query(q, function (err, result) {
    if (err) {
      callback(err, null);
    } else {
      callback(null, result);
    }
  });
};

exports.getProviderInfoByID = function (providerid, callback) {
  const q = `SELECT IC.CompanyID, IC.CompanyName, IC.CustomerServiceRating, IC.ClaimSettlementRatio,
  SP.ProviderID, SP.Title, SP.Name, SP.Email, SP.PhoneNumber
FROM InsuranceCompanies AS IC
JOIN ServiceProvider AS SP ON IC.CompanyID = SP.CompanyID
WHERE SP.ProviderID = ${providerid};`
  con.query(q, function (err, result) {
    if (err) {
      callback(err, null);
    } else {
      callback(null, result);
    }
  });
};

exports.getVehicleInfoByID = function (userid, callback) {
  const q = `SELECT * FROM VehicleInformation WHERE UserID = ${userid}`;
  con.query(q, function (err, result) {
    if (err) {
      callback(err, null);
    } else {
      callback(null, result);
    }
  });
}

exports.setPassword = function(email, pw, callback){
  var query = "select * from UserAuth where email=(?)";
  con.query(query, [email], function (err, result) {
    if (result.length > 0) {
      var query = "UPDATE UserAuth set Password=(?) WHERE Email=(?);";
      con.query(query, [pw, email], function (err) {
        if (!err) {
          callback("Success");
        } else {
          callback("failure");
        }
      });
    } else {
      callback("User not found");
    }
  });
}