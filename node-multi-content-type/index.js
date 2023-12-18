const express = require("express");
const compression = require("compression");
const cookieParser = require("cookie-parser");
const multer = require('multer');
const bodyParser = require("body-parser");
const bodyParserXml = require('body-parser-xml');
const { textPlain, applicationJson, multipartFormdata, applicationUrlencoded, xml, octetStream, imagePng } = require("./apiMethods");

const app = express();
exports.app = app;

app.use(cookieParser());
app.use(bodyParser.json());
// Use the XML body parser
bodyParserXml(bodyParser);
app.use(bodyParser.xml());
app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);
app.use(compression());
app.set("view engine", "ejs");

app.get("/", (req, res) => {
  res.render("index");
});

//===========================
// text/plain
//===========================
app.get("/text/plain", async (req, res) => {
  await textPlain(req, res);
});

app.post("/text/plain", async (req, res) => {
  await textPlain(req, res);
});

//===========================
// application/xml
//===========================
app.get("/application/xml", async (req, res) => {
  await xml(req, res)
});

app.post("/application/xml", async (req, res) => {
  await xml(req, res)
});

//===========================
// text/xml
//===========================
app.get("/text/xml", async (req, res) => {
  await xml(req, res)
});

app.post("/text/xml", async (req, res) => {
  await xml(req, res)
});

//===========================
// application/json
//===========================
app.get("/application/json", async (req, res) => {
  await applicationJson(req, res)
});

app.post("/application/json", async (req, res) => {
  await applicationJson(req, res)
});

//===========================
// application/urlencoded
//===========================
app.get("/application/urlencoded", async (req, res) => {
  await applicationUrlencoded(req, res)
  });

app.post("/application/urlencoded", async (req, res) => {
await applicationUrlencoded(req, res)
});

//===========================
// /multipart/formdat
//===========================
app.get("/multipart/formdata", multer().none(), async (req, res) => {
  await multipartFormdata(req, res)
  });

app.post("/multipart/formdata", multer().none(), async (req, res) => {
await multipartFormdata(req, res)
});

//===========================
// /application/octet-stream
//===========================
app.get("/application/octet-stream", async (req, res) => {
  await octetStream(req, res)
  });

app.post("/application/octet-stream", async (req, res) => {
await octetStream(req, res)
});

//===========================
// /image/png
//===========================
app.get("/image/png", async (req, res) => {
  await imagePng(req, res)
  });

app.post("/image/png", async (req, res) => {
await imagePng(req, res)
});

app.listen(8000);
console.log("App started at 8000 port");
