import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

import 'callbacks.dart';

class TableWalletsPopulator {
  TableWalletsPopulator({
    @required this.table,
  });

  final TableElement table;

  void clear(){
    table.innerHtml = "";
  }

  void populate({
    @required List<WalletData> allWalletData,
    @required IdCallback onClick,
  }) {
    clear();

    for (WalletData walletData in allWalletData) {
      HtmlElement walletElement = _buildWallet(
        walletData: walletData,
        onClick: onClick,
      );

      table.addRow().addCell()..children.add(walletElement);
    }
  }

  Element _buildWallet({
    @required WalletData walletData,
    @required IdCallback onClick,
  }) {
    TableElement r = new TableElement();
    r.classes.add("wallet");
    r.addEventListener(
      "click",
      (_) {
        onClick(walletData.wallet.id);
      },
    );

    TableRowElement row0 = r.addRow();
    TableRowElement row1 = r.addRow();

    // fills row0
    TableCellElement walletNameCell = row0.addCell();
    walletNameCell.children.add(_buildWalletName(walletData));

    // fills row1
    TableCellElement currencyCell = row1.addCell();
    currencyCell.children.add(_buildCurrency(walletData));

    TableCellElement ballanceCell = row1.addCell();
    ballanceCell.children.add(_buildBallance(walletData));

    return r;
  }

  Element _buildWalletName(WalletData walletData) {
    SpanElement spanElement = new SpanElement();
    spanElement.classes.add("walletWalletName");
    spanElement.innerHtml = walletData.wallet.name;

    return spanElement;
  }

  Element _buildCurrency(WalletData walletData) {
    SpanElement spanElement = new SpanElement();
    spanElement.classes.add("walletCurrency");
    spanElement.innerHtml = walletData.currency.name;

    return spanElement;
  }

  Element _buildBallance(WalletData walletData) {
    SpanElement spanElement = new SpanElement();
    spanElement.classes.add("walletConfirmedBallance");
    spanElement.innerHtml = "${walletData.confirmedBalance}";

    return spanElement;
  }
}
