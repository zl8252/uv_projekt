import 'dart:async';

import 'package:coin_data/coin_data.dart';
import 'package:http/browser_client.dart';

import 'authentication.dart';

Future main() async {
  CoinData coinData = new CoinData.fromAuthentication(
    browserClient: new BrowserClient(),
    authentication: authentication,
  );

  await coinData.refreshAllData();

  Deposit d = coinData.deposit(50);

  Wallet w = coinData.wallet(2);

  WalletData walletData = coinData.walletData(w.id);

  double balance = walletData.confirmedBalance;

  int a = 1;
}
