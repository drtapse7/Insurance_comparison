var exp = require("express");
var sqlfunctions = require("./sqlfunctions");
var cors = require("cors");

var app = exp();
app.use(cors());

var bp = require("body-parser");
app.use(bp.json());

app.listen(9000, function () {
  console.log("server started on 9000");
});

app.get("/", function (req, res) {
  res.send("<h1>This is Home</h1>");
});

app.get("/users", function (req, res) {
  sqlfunctions.getAllUsers(function (err, result) {
    if (!err) {
      res.json(result);
    } else {
      console.log("error in retrieving data");
    }
  });
});

app.post("/insertuser", function (req, res) {
  var title = req.body.title;
  var name = req.body.name;
  var email = req.body.email;
  var phone = req.body.phone;
  var pwd = req.body.pwd;
  // console.log("receiverd pw: " + pwd);
  // var newexist = req.body.newexist;
  // var budget = req.body.budget;
  // var debt = req.body.debt;
  // var vrn = req.body.vrn;

  sqlfunctions.setUser(title, name, email, phone, function (executed) {
    var status = null;
    if (executed) {
      status = { registered: true };
      sqlfunctions.setUserAuth(email, pwd, function (err) {
        if (!err) {
          console.log("reg successful");
        } else {
          console.log("reg not successful");
        }
      });
    } else {
      status = { registered: false };
    }
    console.log("reg status: " + status.registered);
    res.json(status);
  });
});

app.post("/verifylogin", function (req, res) {
  var email = req.body.email;
  var pwd = req.body.pwd;
  // user 0, admin 1, provider 2
  var role = req.body.role;
  var auth = null;
  sqlfunctions.checkAuthentication(
    email,
    pwd,
    role,
    function (err, result, status) {
      if (!err) {
        try {
          auth = { login_status: status };
          auth = { ...auth, result };
          res.json(auth);
        } catch (e) {
          res.json("Not found");
        }
      } else {
        console.log("error in retrieving data");
      }
    }
  );
});

app.get("/getcompanies", function (req, res) {
  sqlfunctions.getAllCompanies(function (err, result) {
    if (!err) {
      res.json(result);
    } else {
      console.log("error in retrieving data");
    }
  });
});

app.get("/getuserinfobyid", function (req, res) {
  userid = req.query.id;
  sqlfunctions.getUserInfoByID(userid, function (err, result) {
    if (!err) {
      res.json(result);
    } else {
      console.log("error in retrieving data");
    }
  });
});

app.post("/getadmininfobyid", function (req, res) {
  adminid = req.body.aid;
  sqlfunctions.getAdminInfoByID(adminid, function (err, result) {
    if (!err) {
      res.json(result);
    } else {
      console.log("error in retrieving data");
    }
  });
});

// remains
app.post("/getproviderinfobyid", function (req, res) {
  providerid = req.body.pid;
  sqlfunctions.getProviderInfoByID(providerid, function (err, result) {
    if (!err) {
      res.json(result);
    } else {
      console.log("error in retrieving data");
    }
  });
});

app.get("/getvehicleinfobyid", function (req, res) {
  userid = req.query.id;
  sqlfunctions.getVehicleInfoByID(userid, function (err, result) {
    if (!err) {
      res.json(result);
    } else {
      console.log("error in retrieving data");
    }
  });
});

app.post("/checkemailexist", function (req, res) {
  var uemail = req.body.email;
  sqlfunctions.checkEmailExist(uemail, function (status) {
    res.json(status);
  });
});

app.post("/updatepassword", function (req, res) {
  var email = req.body.emailId;
  var setpass = req.body.setPassword;
  sqlfunctions.setPassword(email,setpass, function(result){
      res.json(result);
  })
});

app.get("*", function (req, res) {
  res.send("<h1>invalid page<h1/>");
});
