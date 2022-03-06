# Blockchain in Healthcare

### Flutter Version 2.8.1 
### Null Safety is on https://dart.dev/null-safety/migration-guide

## In the root directory of this repo
a) Download:
1. Node Version 16 and above
2. Android Studio
3. Visual Studio 2019(Visual Studio Community 2019 (version 16.11)) and select Desktop Development with C++

b) Installation:
1. Run `npm install -g truffle`
2. Run `npm install -g ganache cli`.



https://user-images.githubusercontent.com/49688611/147677483-5cd09c3b-d56a-47ba-a123-3e6b9bb2591c.mp4




c) Run `truffle develop` : (Check Videos Directly)
1. Run` develop`
2. In the console run `deploy`
3. Setup for Desktop Application



https://user-images.githubusercontent.com/49688611/147718684-f1112a92-8c28-4613-b5b2-5cbe754ea7e7.mp4



### After this restart IDE Then follow next video



https://user-images.githubusercontent.com/49688611/147716201-345649a8-64ea-44ba-8409-f9acfae807b0.mp4

## Next is Setting up Meta Mask



https://user-images.githubusercontent.com/49688611/147718320-74467e8d-a63d-47e3-8753-5f0963e45277.mp4




## In the backend folder

1. Run `npm install` only once
2. Run `npm start` everytime to run the server

## Open the frontend folder in Android Studio

1. Run the Flutter App
2. It will start on create_wallet.dart file and then go to wallet_view.dart
3. wallet.dart is different from wallet_view.dart

## Current Status

### Working with Files -> main.dart, create_wallet.dart, view_wallet.dart, wallet_database.dart

1. After Entering Password, An account is created through the node server that and the encrypted key is sent to the flutter app from the node server. we are storing the wallet address, password to encrypted key and encrypted key in SQLite database where you find it in the databases folder the wallet_database.dart has the code.

2. The next screen your redirected to a view_wallet.dart screen where you can select an account and after selecting the account Ether price is dispalyed. (Make sure truffle console and node server is running.)

## Work to be done
 
 1. The view_wallet.dart shows the ether price for one account, that was previously created, add a create button beside send button to create another account (refer to createWallet function in  wallet.dart in providers folder) to be added to the drop down menu, also when u select another account that maybe the 3rd or 4th account in the added list, the entire Image and price in Ether should vertically scroll automatically to that account showing the price for the account selected. 
 Use Package https://pub.dev/packages/scrollable_positioned_list to implement automatic vertical scrolling.


 2. Implement A TextField https://material.io/components/text-fields/flutter#filled-text component when clicked should open a qr scanner. The link https://flutterawesome.com/a-basic-qr-scanner-app-built-using-flutter/ can be refered for opening a qr scanner, get the data from qr scanner to be enterd in text.

### NOTE
1. A Wallet can have multiple accounts
