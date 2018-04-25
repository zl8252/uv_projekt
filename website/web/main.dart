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

// Add
var tableCellDeposit;
var tableCellWithdrawal;
var tableCellTransfer;

var addContent;

// table tansactions
TableElement tableUnconfirmed;
TableElement tableConfirmed;

// Populators
TableWalletsPopulator tableWalletsPopulator;
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
  tableCellDeposit = querySelector("#tableCellDeposit");
  tableCellDeposit.addEventListener("click", (_) {
    onTableCellDeposit();
  });

  tableCellWithdrawal = querySelector("#tableCellWithdrawal");
  tableCellWithdrawal.addEventListener("click", (_) {
    onTableCellWithdrawal();
  });

  tableCellTransfer = querySelector("#tableCellTransfer");
  tableCellTransfer.addEventListener("click", (_) {
    onTableCellTransfer();
  });

  // Tables transaction
  tableUnconfirmed = querySelector("#tableUnconfirmed");
  tableConfirmed = querySelector("#tableConfirmed");
  tableTransactionsPopulator = new TableTransactionsPopulator(
    unconfirmedTable: tableUnconfirmed,
    confirmedTable: tableConfirmed,
  );

  addContent = querySelector("#addContent");
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

  tableTransactionsPopulator.populate(
    walletData: coinData.walletData(selectedWalletId),
    coinData: coinData
  );
}

void onWalletSelected(int walletId) {
  print("Wallet with id: $walletId selected");

  selectedWalletId = walletId;
  populateAll();
}

void clearAll() {
  tableWalletsPopulator.clear();
  tableTransactionsPopulator.clear();
}

// Add -----------------------------------------------------------------------------

void onTableCellDeposit() {
  print("selected add/Deposit");
}

void onTableCellWithdrawal() {
  print("selected add/Withdrawal");
}

void onTableCellTransfer() {
  print("selected add/Transfer");
}
