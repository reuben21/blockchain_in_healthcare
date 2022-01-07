const IPFS = require('ipfs-http-client');

const ipfs = IPFS.create();


exports.ipfsAdd = async (req, res, next) => { 
 const doc = JSON.stringify({
    foo: "bar",
    tic: "tac"
  });
  
   const cid  = await ipfs.add(doc);


   res.send({
       "hash": cid.path
   });

}