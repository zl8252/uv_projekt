import 'dart:html';
import 'dart:async';

import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';

import 'coin_data/coin_data.dart';
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
  ButtonElement clearAllButton = querySelector("#clearAllButton");
  clearAllButton.addEventListener("click", (_){
    clearAll();
  });

  ButtonElement populateAllButton = querySelector("#populateAllButton");
  populateAllButton.addEventListener("click", (_){
    populateAll();
  });

  tableWallets = querySelector("#tableWallets");
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
    onClick: (int clickedWalletId) {
      print("Clicked on wallet id:$clickedWalletId");
    },
  );
}

void clearAll(){
  tableWalletsPopulator.clear();
}
