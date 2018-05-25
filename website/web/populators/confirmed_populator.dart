import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

import 'callbacks.dart';

class ConfirmedPopulator {
  ConfirmedPopulator({
    @required this.confirmedDiv,
  });

  final DivElement confirmedDiv;

  void clear() {
    confirmedDiv.innerHtml = "";
  }

  void populate({
    @required WalletData walletData,
    @required CoinData coinData,
    @required VoidCallback onRefresh,
  }) {
    TableElement tableElement = new TableElement();
    confirmedDiv.children.add(tableElement);

    for (ITransaction transaction in walletData.transactions) {
      if (transaction is Deposit) {
        // skip unconfirmed
        if (!transaction.completed) {
          continue;
        }

        Element element = _buildDeposit(
            deposit: transaction,
            walletData: walletData,
            onChanged: (Deposit newDeposit) {
              coinData.updateDeposit(newDeposit).then(
                (_) {
                  onRefresh();
                },
              );
            },
            onDelete: (Deposit deposit) {
              coinData.deleteDeposit(deposit).then(
                (_) {
                  onRefresh();
                },
              );
            });

        confirmedDiv.children.add(element);
      }

      if (transaction is Withdrawal) {
        // skip unconfirmed
        if (!transaction.completed) {
          continue;
        }

        Element element = _buildWithdrawal(
          withdrawal: transaction,
          walletData: walletData,
          onChanged: (Withdrawal newWithdrawal) {
            coinData.updateWithdrawal(newWithdrawal).then(
              (_) {
                onRefresh();
              },
            );
          },
          onDelete: (Withdrawal withdrawal) {
            coinData.deleteWithdrawal(withdrawal).then(
              (_) {
                onRefresh();
              },
            );
          },
        );

        confirmedDiv.children.add(element);
      }

      if (transaction is Transfer) {
        // skip unconfirmed
        if (!transaction.completed) {
          continue;
        }

        Element element = _buildTransfer(
          transfer: transaction,
          coinData: coinData,
          walletData: walletData,
          onChanged: (Transfer newTransfer) {
            coinData.updateTransfer(newTransfer).then(
              (String s) {
                onRefresh();
              },
            );
          },
          onDelete: (Transfer transfer) {
            coinData.deleteTransfer(transfer).then(
              (_) {
                onRefresh();
              },
            );
          },
        );

        confirmedDiv.children.add(element);
      }
    }
  }

  Element _buildDeposit({
    @required Deposit deposit,
    @required WalletData walletData,
    @required DepositCallback onChanged,
    @required DepositCallback onDelete,
  }) {
    bool isExpanded = false;

    TableElement r = new TableElement();
    r.classes.add("confirmedDeposit");

    TableRowElement row = r.addRow();

    row.addCell()
      ..classes.add("confirmedTransactionTitle")
      ..innerHtml = "Deposit";
    row.addCell().innerHtml =
        "<span class=\"unconfirmedAmount\">${deposit.amount}</span> "
        "${walletData.currency.name}";

    TableRowElement expandedRow = r.addRow();
    TableCellElement expandedCell = expandedRow.addCell();
    expandedCell.colSpan = 2;

    TableElement expandedTable = new TableElement();
    expandedTable.classes.add("expandedTable");
    TableRowElement expandedTableRow1 = expandedTable.addRow();
    TableCellElement r1c1 = expandedTableRow1.addCell();
    r1c1.classes.add("expandedColumn1");
    r1c1.innerHtml = "&#9656; Time stamp: ";
    TableCellElement r1c2 = expandedTableRow1.addCell();
    DateTime timeStamp =
        new DateTime.fromMillisecondsSinceEpoch(deposit.timeStamp);
    r1c2.innerHtml =
        "${timeStamp.year}.${timeStamp.month}.${timeStamp.day} ${timeStamp.hour}:${timeStamp.minute}";

    TableRowElement expandedTableRow2 = expandedTable.addRow();
    TableCellElement r2c1 = expandedTableRow2.addCell();
    r2c1.classes.add("expandedColumn1");
    r2c1.innerHtml = "&#9656; Actions: ";
    TableCellElement r2c2 = expandedTableRow2.addCell();

    ButtonElement buttonDelete = new ButtonElement();
    // row.addCell()..classes.add("td_right")..children.add(buttonDelete);
    buttonDelete.innerHtml = "Delete";
    buttonDelete.addEventListener("click", (_) {
      onDelete(deposit);
    });

    r2c2.children.addAll([
      buttonDelete,
    ]);

    r.addEventListener("click", (_) {
      isExpanded = !isExpanded;
      print("isExpanded: $isExpanded");
      if (isExpanded) {
        expandedCell.children.add(expandedTable);
      } else {
        expandedCell.innerHtml = "";
      }
    });

    return r;
  }

  Element _buildWithdrawal({
    @required Withdrawal withdrawal,
    @required WalletData walletData,
    @required WithdrawalCallback onChanged,
    @required WithdrawalCallback onDelete,
  }) {
    bool isExpanded = false;

    TableElement r = new TableElement();
    r.classes.add("confirmedWithdrawal");

    TableRowElement row = r.addRow();

    row.addCell()
      ..classes.add("confirmedTransactionTitle")
      ..innerHtml = "Withdrawal";
    row.addCell().innerHtml =
        "<span class=\"unconfirmedAmount\">${withdrawal.amount}</span> "
        "${walletData.currency.name}";

    TableRowElement expandedRow = r.addRow();
    TableCellElement expandedCell = expandedRow.addCell();
    expandedCell.colSpan = 2;

    TableElement expandedTable = new TableElement();
    expandedTable.classes.add("expandedTable");
    TableRowElement expandedTableRow1 = expandedTable.addRow();
    TableCellElement r1c1 = expandedTableRow1.addCell();
    r1c1.classes.add("expandedColumn1");
    r1c1.innerHtml = "&#9656; Time stamp: ";
    TableCellElement r1c2 = expandedTableRow1.addCell();
    DateTime timeStamp =
        new DateTime.fromMillisecondsSinceEpoch(withdrawal.timeStamp);
    r1c2.innerHtml =
        "${timeStamp.year}.${timeStamp.month}.${timeStamp.day} ${timeStamp.hour}:${timeStamp.minute}";

    TableRowElement expandedTableRow2 = expandedTable.addRow();
    TableCellElement r2c1 = expandedTableRow2.addCell();
    r2c1.classes.add("expandedColumn1");
    r2c1.innerHtml = "&#9656; Actions: ";
    TableCellElement r2c2 = expandedTableRow2.addCell();

    ButtonElement buttonDelete = new ButtonElement();
    // row.addCell()..classes.add("td_right")..children.add(buttonDelete);
    buttonDelete.innerHtml = "Delete";
    buttonDelete.addEventListener(
      "click",
      (_) {
        onDelete(withdrawal);
      },
    );

    r2c2.children.add(buttonDelete);

    r.addEventListener("click", (_) {
      isExpanded = !isExpanded;
      print("isExpanded: $isExpanded");
      if (isExpanded) {
        expandedCell.children.add(expandedTable);
      } else {
        expandedCell.innerHtml = "";
      }
    });

    return r;
  }

  Element _buildTransfer({
    @required Transfer transfer,
    @required CoinData coinData,
    @required WalletData walletData,
    @required TransferCallback onChanged,
    @required TransferCallback onDelete,
  }) {
    bool isExpanded = false;

    TableElement r = new TableElement();
    r.classes.add("confirmedTransfer");

    TableRowElement row = r.addRow();

    Wallet fromWallet = coinData.getWallet(transfer.fromWalletId);
    Wallet toWallet = coinData.getWallet(transfer.toWalletId);

    row.addCell()
      ..classes.add("confirmedTransactionTitle")
      ..innerHtml = "Transfer";
    row.addCell().innerHtml =
        "<span class=\"unconfirmedAmount\">${transfer.fromWalletAmount}</span>"
        " ${coinData.getCurrency(fromWallet.currencyId).name}";
    if (fromWallet.id == walletData.wallet.id) {
      row.addCell()
        ..classes.add("text_center")
        ..innerHtml = "to <br>"
            "<span class=\"unconfirmedAmount\"> ${toWallet.name}</span>";
    } else {
      row.addCell()
        ..classes.add("text_center")
        ..innerHtml = "from <br>"
            "<span class=\"unconfirmedAmount\"> ${fromWallet.name}</span>";
    }
    row.addCell()
      ..classes.add("text_center")
      ..innerHtml = "as <br>"
          "<span class=\"unconfirmedAmount\">${transfer.toWalletAmount} </span>"
          "${coinData.getCurrency(toWallet.currencyId).name}";

    TableRowElement expandedRow = r.addRow();
    TableCellElement expandedCell = expandedRow.addCell();
    expandedCell.colSpan = 4;

    TableElement expandedTable = new TableElement();
    expandedTable.classes.add("expandedTable");
    TableRowElement expandedTableRow1 = expandedTable.addRow();
    TableCellElement r1c1 = expandedTableRow1.addCell();
    r1c1.classes.add("expandedColumn1");
    r1c1.innerHtml = "&#9656; Time stamp: ";
    TableCellElement r1c2 = expandedTableRow1.addCell();
    DateTime timeStamp =
        new DateTime.fromMillisecondsSinceEpoch(transfer.timeStamp);
    r1c2.innerHtml =
        "${timeStamp.year}.${timeStamp.month}.${timeStamp.day} ${timeStamp.hour}:${timeStamp.minute}";

    TableRowElement expandedTableRow2 = expandedTable.addRow();
    TableCellElement r2c1 = expandedTableRow2.addCell();
    r2c1.classes.add("expandedColumn1");
    r2c1.innerHtml = "&#9656; Actions: ";
    TableCellElement r2c2 = expandedTableRow2.addCell();

    ButtonElement buttonDelete = new ButtonElement();
    // row.addCell()..classes.add("td_right")..children.add(buttonDelete);
    buttonDelete.innerHtml = "Delete";
    buttonDelete.addEventListener(
      "click",
      (_) {
        onDelete(transfer);
      },
    );

    r2c2.children.addAll([
      buttonDelete,
    ]);

    r.addEventListener("click", (_) {
      isExpanded = !isExpanded;
      print("isExpanded: $isExpanded");
      if (isExpanded) {
        expandedCell.children.add(expandedTable);
      } else {
        expandedCell.innerHtml = "";
      }
    });

    return r;
  }
}
