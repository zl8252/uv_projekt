import 'dart:html';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';

import 'package:coin_data/coin_data.dart';

BrowserClient browserClient;

CoinData coinData;

Future<Null> main() async {
  browserClient = new BrowserClient();
  querySelector('#output').text = 'Your Dart app is running.';

  await initCoinData();

  for (Wallet wallet in coinData.wallets){
    print(wallet);
  }
}

Future<Null> initCoinData() async {
  print("Initialising coin data");

  coinData = new CoinData(
    browserClient: browserClient,
    apiKey: "keyGcsgiFPE0sSfS7",
  );

  await coinData.refreshAllData();

  print("Coin data initialised");
}
