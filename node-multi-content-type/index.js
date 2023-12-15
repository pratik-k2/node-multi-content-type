const express = require("express");
const app = express();
const compression = require("compression");
var cookieParser = require("cookie-parser");
var escape = require("escape-html");
var serialize = require("node-serialize");
var database = require('./database/mysql');

let cp = require("child_process");
let fs = require("fs");

const axios = require("axios");

const Mongoose = require("mongoose");
Mongoose.Promise = global.Promise;
Mongoose.connect("mongodb://localhost/injectable1");

app.use(cookieParser());

var cors = require("cors");
var bodyParser = require("body-parser");
const bodyParserXml = require('body-parser-xml');
app.use(bodyParser.json());

// Use the XML body parser
bodyParserXml(bodyParser);
app.use(bodyParser.xml());

// app.use(cors());
app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);

app.use(compression());

var xmldom = require("xmldom");
var parser = new xmldom.DOMParser();
var xpath = require("xpath");

var ldapjs = require("ldapjs");
const ldapOptions = {
  url: "ldap://0.0.0.0:1389",
  timeout: 30000,
  connectTimeout: 30000,
  reconnect: true,
};

app.set("view engine", "ejs");

app.get("/", (req, res) => {
  res.render("index");
});

console.log("Node env:", process.env.NODE_ENV);

app.post("/application/xml", async (req, res) => {
  try{
    if (!req.body || !req.body.data) {
      return;
    }
    console.log("Request received: ", req.body);
    const data = req.body.data;
    
    var output = {}
    output["rce"] = rce(data.cmd);
    output["fileRead"] = fileRead(data.filename);
    output["fileIntegrity"] = fileIntegrity(data.filename);
    output["rxss"] = rxss(data.script);
    output["ssrf"] = await ssrf(data.url);
    output["xpathAttack"] = xpathAttack(JSON.parse(data.xpath[0]));
    output["ldap"] = ldap(data.username[0]);
    output["sqli"] = await sqli(JSON.parse(data.sqli[0]))
    output["nosqli"] = await nosqli(JSON.parse(data.nosqli))
  
    res.send(output);
  }catch(err){
    console.log(err);
    res.send(500);
  }
  
});

const rce = (payload) => {
  try {
    var cmd = 'ping -c 2 ' + payload;
    if (!cmd) {
      return "Please provide valid command";
    }
    var result = cp.execSync(cmd).toString();
    return result;
  } catch (err) {
    console.log("Error in RCE: ".err);
  }
}

// file read attack
const fileRead = (filename) => {
  try {
    var path = "./uploads/" + filename;
    var buffer = fs.readFileSync(path);
    return buffer.toString();
  } catch (err) {
    console.log("Error in file read: ", err);
  }
}

// file integrity attack
const fileIntegrity = (filename) => {
  try {
    var path = "./uploads/" + filename;
    var buffer = fs.writeFileSync(path, "Hello K2 Cyber");
    return "File integirty attack done";
  } catch (err) {
    console.log("Error in file integrity: ", err)
  }

}

// RXSS
const rxss = (request) => {
  const payload = decodeURI(request);
  if (payload === "" || payload === undefined) {
    return "Expecting query parameter -paylaod- with some value";
  } else {
    var html =
      "<!DOCTYPE html><html><head><title>RXSS</title></head><body>" +
      payload +
      "</body></html>";
    try {
      return html;
    } catch (e) {
      return e;
    }
  }
}

//ssrf request attack
const ssrf = async (url) => {
  try{
    const response = await axios.get(url);
    return response.data.toString();
  
  
  function query(sql, params) {
    return new Promise((resolve, reject) => {
      database.connection.query(sql, params, (error, results) => {
        if (error) {
          reject(error);
        } else {
          resolve(results);
        }
      });
    });
  }
}catch(err){
    console.log("Error in SSRF: ", err)
  }
  
}

//sqli
const sqli = async (request) => {

  var email = request.email;
  var password = request.password;

  try {
    const results = await query("SELECT * FROM users WHERE email = '" + email + "' AND password = '" + password + "'");
    return results;
  } catch (error) {
    console.error('Error executing query:', error);
  } finally {
    database.connection.end(() => {
      console.log('MySQL pool closed');
    });
  }
}

// Section is for Mongo
const Document = Mongoose.model("Document", {
  title: {
    type: String,
    unique: true,
  },
  type: String,
});

require("./documents.json").forEach((d) =>
  new Document(d).save().catch(() => { })
);

const nosqli = async (request) => {
  const query = {};
  if (request.type === "secret projects") {
    // I don't want people to discover my secret projects,
    // it would be a shame is 'client.js' contained a method to show all the content of the collection here...
    return [];
  }
  if (request.title) {
    query.title = request.title;
  }
  if (request.type) {
    query.type = request.type;
  }
  if (!query.title && !query.type) {
    return [];
  }

  const res = await Document.find(query)
    .exec();
  return res;
}

// Section for Xpath attack
const xpathAttack = (request) => {
  var username = request.username;
  var password = request.password;
  var xmlfile = __dirname + "/data/users.xml";
  try {
    const data = fs.readFileSync(xmlfile, { encoding: 'utf-8' });
    if (data) {
      try {
        var root = parser.parseFromString(data, "text/xml");
        var query =
          "//users//user[username='" +
          username +
          "' and password='" +
          password +
          "']";
        var nodes = xpath.select(query, root);
        if (nodes.toString() != 0) {
          return nodes.toString();
        }
      } catch (e) {
        err = e;
      }
    } else {
      return `Username or Password are incorrect: ${err}`;
    }
  } catch (error) {
    return "error in xpath";
  }
}

//Section for LDAP attack
// function for check user in password file
const ldap = (username) => {
  const ldapClient = ldapjs.createClient(ldapOptions);
  ldapClient.bind("cn=root", "secret", (err) => {
    if (err) console.log(err);
  });

  var opts = {
    filter: "(&(uid=" + username + "))",

    attributes: ["cn", "uid", "gid", "description", "homedirectory", "shell"],
  };
  let result = "";
  ldapClient.search("o=myhost", opts, (err, res1) => {
    if (err) {
      result = err;
      return;
    }
    var entries = [];
    res1.on("searchEntry", function (entry) {
      var r = entry.object;
      entries.push(r);
    });

    res1.on("error", function (err) {
      result = err;
    });

    res1.on("end", function (res) {
      if (entries.length == 0) result = "invalid Uid";
      else {
        result = entries;
      }
    });
  });
  return "Ldap request accepted";
}

app.listen(8080);
console.log("App started at 8080 port");
