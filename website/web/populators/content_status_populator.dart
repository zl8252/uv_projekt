import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

class ContentStatusPopulator {
  ContentStatusPopulator({
    @required this.statusTable,
  });

  final TableElement statusTable;

  void clear() {
    statusTable.innerHtml = "";
  }

  void populate(WalletData walletData) {
    TableCellElement cell = statusTable.addRow().addCell();

    TableElement table = new TableElement();
    table.classes.add("tableStatusInnerTable");
    cell.children.add(table);
    TableRowElement rowHeaders = table.addRow();
    TableRowElement rowNums = table.addRow();

    // fils row Headers
    TableCellElement hDeposited = rowHeaders.addCell();
    hDeposited
      ..innerHtml = "Deposited"
      ..classes.add(".statusLabel");

    TableCellElement hWithdrawaled = rowHeaders.addCell();
    hWithdrawaled
      ..innerHtml = "Withdrawaled"
      ..classes.add(".statusLabel");

    TableCellElement hConfirmed = rowHeaders.addCell();
    hConfirmed
      ..innerHtml = "Confirmed Balance"
      ..classes.add(".statusLabel");

    TableCellElement hPotential = rowHeaders.addCell();
    hPotential
      ..innerHtml = "Potential Balance"
      ..classes.add(".statusLabel");

    // fills row Nums
    TableCellElement nDeposited = rowNums.addCell();
    nDeposited
      ..innerHtml = "${walletData.confirmedDeposited}"
      ..classes.add(".statusLabel");

    TableCellElement nWithdrawaled = rowNums.addCell();
    nWithdrawaled
      ..innerHtml = "${walletData.confirmedWithdrawaled}"
      ..classes.add(".statusLabel");

    TableCellElement nConfirmed = rowNums.addCell();
    nConfirmed
      ..innerHtml = "${walletData.confirmedBalance}"
      ..classes.add(".statusLabel");

    TableCellElement nPotential = rowNums.addCell();
    nPotential
      ..innerHtml = "${walletData.potentialBalance}"
      ..classes.add(".statusLabel");
  }
}
