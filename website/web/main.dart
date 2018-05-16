import 'dart:html';
import 'dart:async';

import 'package:meta/meta.dart';
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
TableWalletsPopulator tableWalletsPopulator;
AddPopulator addPopulator;
StatusPopulator statusPopulator;
TableTransactionsPopulator tableTransactionsPopulator;

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

  // Table Wallets
  tableWallets = querySelector("#tableWallets");
  tableWalletsPopulator = new TableWalletsPopulator(table: tableWallets);

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

  // Tables transaction
  tableUnconfirmed = querySelector("#tableUnconfirmed");
  tableConfirmed = querySelector("#tableConfirmed");
  tableTransactionsPopulator = new TableTransactionsPopulator(
    unconfirmedTable: tableUnconfirmed,
    confirmedTable: tableConfirmed,
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

  tableWalletsPopulator.populate(
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

  tableTransactionsPopulator.populate(
    walletData: coinData.walletData(selectedWalletId),
    coinData: coinData,
  );

  statusPopulator.populate(
    coinData.walletData(selectedWalletId),
  );
}

void onWalletSelected(int walletId) {
  print("Wallet with id: $walletId selected");

  selectedWalletId = walletId;
  populateAll();
}

void clearAll() {
  tableWalletsPopulator.clear();
  addPopulator.clear();
  statusPopulator.clear();
  tableTransactionsPopulator.clear();
}

// Add -----------------------------------------------------------------------------
