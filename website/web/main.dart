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

  coinData = new CoinData(
    browserClient: browserClient,
    apiKey: "keyGcsgiFPE0sSfS7",
  );

  await coinData.refreshAllData();
  
  for (Wallet wallet in coinData.wallets){
    print(wallet);
  }

  int a = 1;
}
