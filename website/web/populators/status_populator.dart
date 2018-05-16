import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

class StatusPopulator {
  StatusPopulator({
    @required this.statusDiv,
  });

  final DivElement statusDiv;

  void clear() {
    statusDiv.innerHtml = "";
  }

  void populate(WalletData walletData) {
    TableElement table = new TableElement();
    statusDiv.children.add(table);

    TableRowElement titleRow = table.addRow();
    TableRowElement valueRow = table.addRow();

    // Deposited
    titleRow.addCell().innerHtml = "Deposited";
    valueRow.addCell().innerHtml = "${walletData.confirmedDeposited}";

    // Withdrawaled
    titleRow.addCell().innerHtml = "Withdrawaled";
    valueRow.addCell().innerHtml = "${walletData.confirmedWithdrawaled}";

    // ConfirmedBallance
    titleRow.addCell().innerHtml = "Confirmed Balance";
    valueRow.addCell().innerHtml = "${walletData.confirmedBalance}";

    // PotentialBallance
    titleRow.addCell().innerHtml = "Potential Balance";
    valueRow.addCell().innerHtml = "${walletData.potentialBalance}";
    

    // // fils row Headers
    // TableCellElement hDeposited = rowHeaders.addCell();
    // hDeposited
    //   ..innerHtml = "Deposited"
    //   ..classes.add(".statusLabel");

    // TableCellElement hWithdrawaled = rowHeaders.addCell();
    // hWithdrawaled
    //   ..innerHtml = "Withdrawaled"
    //   ..classes.add(".statusLabel");

    // TableCellElement hConfirmed = rowHeaders.addCell();
    // hConfirmed
    //   ..innerHtml = "Confirmed Balance"
    //   ..classes.add(".statusLabel");

    // TableCellElement hPotential = rowHeaders.addCell();
    // hPotential
    //   ..innerHtml = "Potential Balance"
    //   ..classes.add(".statusLabel");

    // // fills row Nums
    // TableCellElement nDeposited = rowNums.addCell();
    // nDeposited
    //   ..innerHtml = "${walletData.confirmedDeposited}"
    //   ..classes.add(".statusLabel");

    // TableCellElement nWithdrawaled = rowNums.addCell();
    // nWithdrawaled
    //   ..innerHtml = "${walletData.confirmedWithdrawaled}"
    //   ..classes.add(".statusLabel");

    // TableCellElement nConfirmed = rowNums.addCell();
    // nConfirmed
    //   ..innerHtml = "${walletData.confirmedBalance}"
    //   ..classes.add(".statusLabel");

    // TableCellElement nPotential = rowNums.addCell();
    // nPotential
    //   ..innerHtml = "${walletData.potentialBalance}"
    //   ..classes.add(".statusLabel");
  }
}
