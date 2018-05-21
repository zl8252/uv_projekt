import 'dart:html';
import 'dart:async';

import 'package:http/browser_client.dart';

import 'coin_data/coin_data.dart';
import 'populators/all.dart';

BrowserClient browserClient;

CoinData coinData;

int selectedWalletId;

// Webpage components ------------------------------------------

// wallets
TableElement tableWallets;

// status
TableElement tableStatus;

// table tansactions
TableElement tableUnconfirmed;
TableElement tableConfirmed;

// Populators
WalletsPopulator walletsPopulator;
AddPopulator addPopulator;
StatusPopulator statusPopulator;
UnconfiemedPopulator unconfiemedPopulator;
ConfirmedPopulator confirmedPopulator;

Future<Null> main() async {
  initWebpageComponentsAndPopulators();

  browserClient = new BrowserClient();
  await initCoinData();

  populateAll();
}

void initWebpageComponentsAndPopulators() {
  ButtonElement clearAllButton = querySelector("#clearAllButton");
  clearAllButton.addEventListener("click", (_) {
    clearAll();
  });

  ButtonElement populateAllButton = querySelector("#populateAllButton");
  populateAllButton.addEventListener("click", (_) {
    populateAll();
  });

  // Wallets
  DivElement walletsDiv = querySelector("#walletsDiv");
  walletsPopulator = new WalletsPopulator(
    walletsDiv: walletsDiv,
  );

  // Add
  DivElement addDivNavigation = querySelector("#addDivNavigation");
  DivElement addDivContent = querySelector("#addDivContent");
  addPopulator = new AddPopulator(
    addDivNavigation: addDivNavigation,
    addDivContent: addDivContent,
  );

  // Status
  DivElement statusDiv = querySelector("#statusDiv");
  statusPopulator = new StatusPopulator(
    statusDiv: statusDiv,
  );

  // Unconfirmed
  DivElement unconfirmedDiv = querySelector("#unconfirmedDiv");
  unconfiemedPopulator = new UnconfiemedPopulator(
    unconfirmedDiv: unconfirmedDiv,
  );

  // Confirmed
  DivElement confirmedDiv = querySelector("#confirmedDiv");
  confirmedPopulator = new ConfirmedPopulator(
    confirmedDiv: confirmedDiv,
  );
}

Future<Null> initCoinData() async {
  print("Initialising coin data");

  coinData = new CoinData(
    browserClient: browserClient,
    apiKey: "keyGcsgiFPE0sSfS7",
  );

  await coinData.refreshAllData();

  selectedWalletId = coinData.allWalletData.first.wallet.id;

  print("Coin data initialised");
}

void populateAll() {
  clearAll();

  // Wallets
  walletsPopulator.populate(
    allWalletData: coinData.allWalletData,
    onClick: onWalletSelected,
  );

  // Add
  addPopulator.populate(
    coinData: coinData,
    currentWalletData: coinData.walletData(selectedWalletId),
    onRefresh: () {
      clearAll();
      initCoinData().then((_) {
        populateAll();
      });
    },
  );

  // Status
  statusPopulator.populate(
    coinData.walletData(selectedWalletId),
  );

  // Unconfirmed
  unconfiemedPopulator.populate(
      coinData: coinData,
      walletData: coinData.walletData(selectedWalletId),
      onRefresh: () {
        clearAll();
        initCoinData().then((_) {
          populateAll();
        });
      });

  // Confirmed
  confirmedPopulator.populate(
      coinData: coinData,
      walletData: coinData.walletData(selectedWalletId),
      onRefresh: () {
        clearAll();
        initCoinData().then((_) {
          populateAll();
        });
      });
}

void onWalletSelected(int walletId) {
  print("Wallet with id: $walletId selected");

  selectedWalletId = walletId;
  populateAll();
}

void clearAll() {
  walletsPopulator.clear();
  addPopulator.clear();
  statusPopulator.clear();
  unconfiemedPopulator.clear();
  confirmedPopulator.clear();
}
