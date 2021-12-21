# Blockchain in Healthcare

## In the root directory of this repo
a) Installation:
1. Run `npm install -g truffle`
2. Run `npm install -g cli`.

b) Run `truffle develop` :
1. Run` develop`
2. In the console run `deploy`

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
