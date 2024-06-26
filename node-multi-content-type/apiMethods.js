const getRawBody = require('raw-body');
const { rce, fileRead, fileIntegrity, rxss, ssrf, nosqli, sqli, xpathAttack, ldap, saveFile } = require('./methods');

const textPlain = async (req, res) => {
  try {
    if (!req.body) {
      return res.send(400);
    }

    console.log("Request received: ", req.body);
    var data = req.body;
    if (typeof data === 'object') {
      data = JSON.stringify(data);
    }

    var output = {};
    output["rce"] = rce(data);
    output["fileRead"] = fileRead(data);
    output["fileIntegrity"] = fileIntegrity(data);
    output["rxss"] = rxss(data);     
    output["xpathAttack"] = xpathAttack(data);
    output["ldap"] = ldap(data);
    output["sqli"] = await sqli(data);
    output["nosqli"] = await nosqli(data);    
    res.send(output);
  } catch (err) {
    console.log(err);
    res.send(500);
  }
};

const textPlainSSRF = async (req, res) => {
  try {
    if (!req.body) {
      return res.send(400);
    }
    console.log("Request received: ", req.body);
    var data = req.body;
    var output = {};
    output["ssrf"] = await ssrf(data); 
    res.send(output);
  } catch (err) {
    console.log(err);
    res.send(500);
  }
};

const xml = async (req, res) => {
  try {
    if (!req.body || !req.body.data) {
      return res.send(400);
    }
    console.log("Request received: ", req.body);
    const data = req.body.data;

    var output = {}
    output["rce"] = rce(data.cmd);
    output["fileRead"] = fileRead(data.filename);
    output["fileIntegrity"] = fileIntegrity(data.filename);
    output["rxss"] = rxss(data.script);                   /* RXSS cannot be detected here because during fuzzing, IC will generate script alerts which will be considered child tags of script tags in curl */
    output["ssrf"] = await ssrf(data.url);
    output["xpathAttack"] = xpathAttack(data.xpath[0]);
    output["ldap"] = ldap(data.username[0]);
    output["sqli"] = await sqli(data.sqli[0])
    output["nosqli"] = await nosqli(data.nosqli[0])       /* NoSQLi cannot be detected as mongo only accepts querying in json format and fuzzing on json inside xml tags isn't supported by IC */

    res.send(output);
  } catch (err) {
    console.log(err);
    res.send(500);
  }
}

const textXml = async (req, res) => {
  try {
    if (!req.body || !req.body.data) {
      return res.send(400);
    }
    console.log("Request received: ", req.body);
    const data = req.body.data;

    var output = {}
    output["rce"] = rce(data.cmd);
    output["fileRead"] = fileRead(data.filename);
    output["fileIntegrity"] = fileIntegrity(data.filename);
    output["rxss"] = rxss(data.script);                   /* RXSS cannot be detected here because during fuzzing, IC will generate script alerts which will be considered child tags of script tags in curl */
    output["ssrf"] = await ssrf(data.url);
    output["xpathAttack"] = xpathAttack(data.xpath[0]);
    output["ldap"] = ldap(data.username[0]);
    output["sqli"] = await sqli(data.sqli[0])
    output["nosqli"] = await nosqli(data.nosqli[0])       /* NoSQLi cannot be detected as mongo only accepts querying in json format and fuzzing on json inside xml tags isn't supported by IC */

    res.send(output);
  } catch (err) {
    console.log(err);
    res.send(500);
  }
}

const applicationJson = async (req, res) => {
  try {
    if (!req.body || !req.body.data) {
      return res.send(400);
    }
    console.log("Request received: ", req.body);
    const data = req.body.data;

    var output = {}
    output["rce"] = rce(data.cmd);
    output["fileRead"] = fileRead(data.filename);
    output["fileIntegrity"] = fileIntegrity(data.filename);
    output["rxss"] = rxss(data.script);
    output["ssrf"] = await ssrf(data.url);
    output["xpathAttack"] = xpathAttack(data.xpath);
    output["ldap"] = ldap(data.username);
    output["sqli"] = await sqli(data.sqli)
    output["nosqli"] = await nosqli(data.nosqli)

    res.send(output);
  } catch (err) {
    console.log(err);
    res.send(500);
  }
}

const applicationUrlencoded = async (req, res) => {
  try {
    if (!req.body) {
      return res.send(400);
    }
    console.log("Request received: ", req.body);
    const data = req.body;

    var output = {}
    output["rce"] = rce(data.cmd);
    output["fileRead"] = fileRead(data.filename);
    output["fileIntegrity"] = fileIntegrity(data.filename);
    output["rxss"] = rxss(data.script);
    output["ssrf"] = await ssrf(data.url);
    output["xpathAttack"] = xpathAttack(data.xpath);
    output["ldap"] = ldap(data.username);
    output["sqli"] = await sqli(data.sqli)
    output["nosqli"] = await nosqli(data.nosqli)

    res.send(output);
  } catch (err) {
    console.log(err);
    res.send(500);
  }
}

const multipartFormdata = async (req, res) => {
  try {
    if (!req.body) {
      return res.send(400);
    }
    console.log("Request received: ", req.body);
    const data = req.body;

    var output = {}
    output["rce"] = rce(data.cmd);
    output["fileRead"] = fileRead(data.filename);
    output["fileIntegrity"] = fileIntegrity(data.filename);
    output["rxss"] = rxss(data.script);
    output["ssrf"] = await ssrf(data.url);
    output["xpathAttack"] = xpathAttack(data.xpath);
    output["ldap"] = ldap(data.username);
    output["sqli"] = await sqli(data.sqli)
    output["nosqli"] = await nosqli(data.nosqli)

    res.send(output);
  } catch (err) {
    console.log(err);
    res.send(500);
  }
}



const octetStream = async (req, res) => {
  try {
    if (req.is('application/octet-stream')) {
      getRawBody(req, {
        length: req.headers['content-length'],
        limit: '10mb',  // limit the size of incoming request, you can change it as per your requirement 
      }, function (err, string) {
        if (err) return res.sendStatus(500);

        console.log('Received Raw Data:', string);
        saveFile(req, res)
      });
    } else {
      res.status(415).end('Unsupported Media Type');
    }
  } catch (err) {
    console.log(err);
    res.send(500);
  }
}


const imagePng = async (req, res) => {
  try {
    if (req.is('image/png')) {
      getRawBody(req, {
        length: req.headers['content-length'],
        limit: '10mb',  // limit the size of incoming request, you can change it as per your requirement 
      }, function (err, string) {
        if (err) return res.sendStatus(500);

        console.log('Received Raw Data:', string);
        saveFile(req, res)
      });
    } else {
      res.status(415).end('Unsupported Media Type');
    }
  } catch (err) {
    console.log(err);
    res.send(500);
  }
}

module.exports = {
  textPlain,
  textPlainSSRF,
  textXml,
  applicationJson,
  multipartFormdata,
  applicationUrlencoded,
  xml,
  octetStream,
  imagePng
}