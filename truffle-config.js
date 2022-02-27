

module.exports = {
  networks: {
    development: {
      host: "192.168.0.100",
      port: 7545,
      network_id: 5777,
    },
    advanced: {
      websockets: true, // Enable EventEmitter interface for web3 (default: false)
    },
  },
  contracts_build_directory: "./bic_android_web_support/assets/abis/",
  compilers: {
    solc: {
      version: "0.8.0", // A version or constraint - Ex. "^0.5.0"
      // Can be set to "native" to use a native solc or
      // "pragma" which attempts to autodetect compiler versions
      docker: false, // Use a version obtained through docker
      parser: "solcjs", // Leverages solc-js purely for speedy parsing
      settings: {
        optimizer: {
          enabled: true,
         runs: 200,// Optimize for how many times you intend to run the code
        }, // Default: "istanbul"
      },
    },
  },
};