import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

import 'callbacks.dart';

class WalletsPopulator {
  WalletsPopulator({
    @required this.walletsDiv,
  });

  final DivElement walletsDiv;

  void clear() {
    walletsDiv.innerHtml = "";
  }

  void populate({
    @required List<WalletData> allWalletData,
    @required IdCallback onClick,
  }) {
    clear();

    for (WalletData walletData in allWalletData) {
      Element element = _createWalletElement(walletData);
      element.addEventListener("click", (_) {
        onClick(walletData.wallet.id);
      });

      walletsDiv.children.add(element);
    }
  }

  Element _createWalletElement(WalletData walletData) {
    TableElement r = new TableElement();

    TableRowElement row1 = r.addRow();
    TableCellElement walletNameCell = row1.addCell();
    walletNameCell.colSpan = 2;
    walletNameCell.innerHtml = "${walletData.wallet.name}";

    TableRowElement row2 = r.addRow();

    TableCellElement currencyCell = row2.addCell();
    currencyCell.innerHtml = "${walletData.currency.name}";

    TableCellElement balanceCell = row2.addCell();
    balanceCell.innerHtml = "${walletData.confirmedBalance}";

    return r;
  }
}
