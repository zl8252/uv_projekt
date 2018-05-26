import 'dart:html';
import 'dart:async';

import 'package:http/browser_client.dart';

import 'coin_data/coin_data.dart';
import 'populators/all.dart';

BrowserClient browserClient;

CoinData coinData;

int selectedWalletId;

DisplayedContnet displayedContnet = DisplayedContnet.wallet;

enum DisplayedContnet {
  createCurrency,
  createWallet,
  wallet,
}

// Webpage components ------------------------------------------

// Content
DivElement contentCreateCurrency;
DivElement contentCreateWallet;
DivElement contentWallet;

// Populators
WalletNamePopulator walletNamePopulator;
WalletsPopulator walletsPopulator;
AddPopulator addPopulator;
StatusPopulator statusPopulator;
UnconfiemedPopulator unconfiemedPopulator;
ConfirmedPopulator confirmedPopulator;
CreateCurrencyPopulator createCurrencyPopulator;

Future<Null> main() async {
  initWebpageComponentsAndPopulators();

  updateDisplayedContent();

  browserClient = new BrowserClient();
  await initCoinData();

  populateAll();
}

void initWebpageComponentsAndPopulators() {
  contentCreateCurrency = querySelector("#content_createCurrency");
  contentCreateWallet = querySelector("#content_createWallet");
  contentWallet = querySelector("#content_wallet");

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

  // Wallet Name
  DivElement walletNameDiv = querySelector("#walletNameDiv");
  walletNamePopulator = new WalletNamePopulator(
    walletNameDiv: walletNameDiv,
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

  // CreateCurrency
  TableRowElement createCurrencyRow = querySelector("#createCurrencyRow");
  createCurrencyRow.addEventListener("click", (_) {
    displayedContnet = DisplayedContnet.createCurrency;
    updateDisplayedContent();
  });
  createCurrencyPopulator = new CreateCurrencyPopulator(createCurrencyDiv: contentCreateCurrency);
  

  // CreateWallet
  TableRowElement createWalletRow = querySelector("#createWalletRow");
  createWalletRow.addEventListener("click", (_) {
    displayedContnet = DisplayedContnet.createWallet;
    updateDisplayedContent();
  });
}

Future<Null> initCoinData() async {
  print("Initialising coin data");

  coinData = new CoinData(
    browserClient: browserClient,
    apiKey: "keyGcsgiFPE0sSfS7",
  );

  await coinData.refreshAllData();

  if (selectedWalletId == null) {
    selectedWalletId = coinData.allWalletData.first.wallet.id;
  }

  print("Coin data initialised");
}

void updateDisplayedContent() {
  switch (displayedContnet) {
    case DisplayedContnet.wallet:
      {
        contentWallet.style.display = "block";
        contentCreateCurrency.style.display = "none";
        contentCreateWallet.style.display = "none";
        break;
      }
    case DisplayedContnet.createCurrency:
      {
        contentWallet.style.display = "none";
        contentCreateCurrency.style.display = "block";
        contentCreateWallet.style.display = "none";
        break;
      }
    case DisplayedContnet.createWallet:
      {
        contentWallet.style.display = "none";
        contentCreateCurrency.style.display = "none";
        contentCreateWallet.style.display = "block";
        break;
      }
  }
}

void populateAll() {
  clearAll();

  // Wallets
  walletsPopulator.populate(
    allWalletData: coinData.allWalletData,
    onClick: onWalletSelected,
  );

  // WalletName
  walletNamePopulator.populate(
    currentWallet: coinData.walletData(selectedWalletId),
  );

  // Status
  statusPopulator.populate(
    coinData.walletData(selectedWalletId),
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

  // CreateCurrency
  createCurrencyPopulator.populate(coinData: coinData, onRefresh: (){
    clearAll();
    initCoinData().then((_){
      populateAll();
    });
  });
}

void onWalletSelected(int walletId) {
  print("Wallet with id: $walletId selected");

  displayedContnet = DisplayedContnet.wallet;
  updateDisplayedContent();

  selectedWalletId = walletId;
  populateAll();
}

void clearAll() {
  walletsPopulator.clear();
  walletNamePopulator.clear();
  addPopulator.clear();
  statusPopulator.clear();
  unconfiemedPopulator.clear();
  confirmedPopulator.clear();
  createCurrencyPopulator.clear();
}
