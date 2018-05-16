import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

import 'callbacks.dart';

class UnconfiemedPopulator {
  UnconfiemedPopulator({
    @required this.unconfirmedDiv,
  });

  final DivElement unconfirmedDiv;

  void clear() {
    unconfirmedDiv.innerHtml = "";
  }

  void populate({
    @required WalletData walletData,
    @required CoinData coinData,
    @required VoidCallback onRefresh,
  }) {
    TableElement tableElement = new TableElement();
    unconfirmedDiv.children.add(tableElement);

    for (ITransaction transaction in walletData.transactions) {
      if (transaction is Deposit) {
        // skip confirmed
        if (transaction.completed) {
          continue;
        }
      }
    }
  }

  Element _buildDeposit({
    @required Deposit deposit,
    @required WalletData walletData,
    @required DepositCallback onChanged,
  }) {
    TableElement r = new TableElement();

    TableRowElement row = r.addRow();

    row.addCell().innerHtml = "Deposit";
    row.addCell().innerHtml = "${deposit.amount}";
    row.addCell().innerHtml = "${walletData.currency.name}";

    ButtonElement buttonConfirm = new ButtonElement();
    row.addCell().children.add(buttonConfirm);
    buttonConfirm.innerHtml = "Confirm";
    buttonConfirm.addEventListener("click", (_) {
      Deposit newDeposit = deposit.copyWith(completed: true);

      onChanged(newDeposit);
    });

    return r;
  }
}
