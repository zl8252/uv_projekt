import 'dart:html';

import 'package:meta/meta.dart';

import 'package:coin_data/coin_data.dart';

import 'callbacks.dart';

class TableWalletsPopulator {
  TableWalletsPopulator({
    @required this.table,
  });

  final TableElement table;

  void populate({
    @required List<WalletData> allWalletData,
    @required IdCallback onClicked,
  }) {
    // Clears the table
    table.innerHtml = "";

    for (WalletData walletData in allWalletData){
      HtmlElement walletElement = buildWallet(walletData);

      table.addRow().addCell()..children.add(walletElement);
    }
  }

  HtmlElement buildWallet(WalletData walletData){
    return new HtmlElement()..innerHtml= "${walletData.wallet.name}";
  }
}
