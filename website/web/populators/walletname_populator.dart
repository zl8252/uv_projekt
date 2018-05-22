import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

class WalletNamePopulator {
  WalletNamePopulator({
    @required this.walletNameDiv,
  });

  final DivElement walletNameDiv;

  void clear() {
    walletNameDiv.innerHtml = "<h1>Wallet Name</h1>";
  }

  void populate({
    @required WalletData currentWallet,
  }) {
    walletNameDiv.innerHtml = "<h1>${currentWallet.wallet.name}</h1>"
        "<h3>(${currentWallet.currency.name})</h3>";
  }
}
