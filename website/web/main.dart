import 'dart:html';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';

import 'package:coin_data/coin_data.dart';

import 'populators/all.dart';

BrowserClient browserClient;

CoinData coinData;

// Webpage components
TableElement tableWallets;

// Populators
TableWalletsPopulator tableWalletsPopulator;

Future<Null> main() async {
  initWebpageComponentsAndPopulators();

  browserClient = new BrowserClient();
  await initCoinData();

  populateAll();
}

void initWebpageComponentsAndPopulators() {
  tableWallets = querySelector(".tableWallets");
  tableWalletsPopulator = new TableWalletsPopulator(table: tableWallets);
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

void populateAll() {
  List<WalletData> allWalletData = coinData.allWalletData;

  tableWalletsPopulator.populate(
    allWalletData: allWalletData,
    onClicked: (int clickedWalletId) {},
  );
}
