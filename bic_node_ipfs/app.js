const express = require("express");
const app = express();
const port = 3000 || process.env.PORT;
const bodyParser = require("body-parser");



const ipfsRoutes = require('./routes/ipfsRoutes');



// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());



app.use("/ipfs", ipfsRoutes);

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET, POST, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});





app.listen(port, () => {
 
  console.log("Express Listening at http://localhost:" + port);
});
