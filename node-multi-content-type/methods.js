const axios = require("axios");
const cp = require("child_process");
const database = require('./database/mysql');
const fs = require("fs");

const Mongoose = require("mongoose");
Mongoose.Promise = global.Promise;
Mongoose.connect("mongodb://localhost/injectable1");

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

let imageNo = 1;

const saveFile = (req, res) => {
    let filePath = "temp/image" + imageNo + ".png";
    imageNo++;
    const writeStream = fs.createWriteStream(filePath);
    req.pipe(writeStream);
    writeStream.on('finish', () => {
        res.end('File saved successfully.');
    });

    writeStream.on('error', (err) => {
        console.log('Error in writing file.', err);
        return res.sendStatus(500);
    });

    req.on('end', () => {
        console.log("Request ended");
    });

    req.on('error', (err) => {
        console.log('Error in request.', err);
        return res.sendStatus(500);
    });
}

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
    try {
        const response = await axios.get(url);
        return response.data.toString();
    } catch (err) {
        console.log("Error in SSRF: ", err)
    }
}

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

//sqli
const sqli = async (request) => {

    var email = request.email;
    var password = request.password;

    try {
        const results = await query("SELECT * FROM users WHERE email = '" + email + "' AND password = '" + password + "'");
        return results;
    } catch (error) {
        console.error('Error executing query:', error);
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

module.exports = {
    rce,
    sqli,
    fileRead,
    fileIntegrity,
    xpathAttack,
    ldap,
    ssrf,
    nosqli,
    saveFile,
    rxss
}