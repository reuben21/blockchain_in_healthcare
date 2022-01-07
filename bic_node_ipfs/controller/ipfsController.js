const IPFS = require('ipfs-http-client');

const ipfs = IPFS.create('http://127.0.0.1:5001');


exports.ipfsAdd = async (req, res, next) => { 
 const doc = JSON.stringify({
    foo: "bar",
    tic: ["reuben","data"]
  });
  
   const cid  = await ipfs.add(doc);


   res.send({
       "hash": cid.path
   });

}



  

  

