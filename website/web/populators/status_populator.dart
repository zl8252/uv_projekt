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
    print("Populating Status");

    TableElement table = new TableElement();
    table.id = "statusTable";
    statusDiv.children.add(table);

    TableRowElement titleRow = table.addRow();
    TableRowElement valueRow = table.addRow();

    // Deposited
    titleRow.addCell()
      ..classes.add("statusTable_title")
      ..innerHtml = "Deposited";
    valueRow.addCell()
      ..classes.add("statusTable_value")
      ..innerHtml = "${walletData.confirmedDeposited}";

    // Withdrawaled
    titleRow.addCell()
      ..classes.add("statusTable_title")
      ..innerHtml = "Withdrawaled";
    valueRow.addCell()
      ..classes.add("statusTable_value")
      ..innerHtml = "${walletData.confirmedWithdrawaled}";

    // ConfirmedBallance
    titleRow.addCell()
      ..classes.add("statusTable_title")
      ..innerHtml = "Confirmed Balance";
    valueRow.addCell()
      ..classes.add("statusTable_value")
      ..innerHtml = "${walletData.confirmedBalance}";

    // PotentialBallance
    titleRow.addCell()
      ..classes.add("statusTable_title")
      ..innerHtml = "Potential Balance";
    valueRow.addCell()
      ..classes.add("statusTable_value")
      ..innerHtml = "${walletData.potentialBalance}";
  }
}
