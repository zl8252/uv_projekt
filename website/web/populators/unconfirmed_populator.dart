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

        unconfirmedDiv.children.add(element);
      }

      if (transaction is Withdrawal) {
        // skip confirmed
        if (transaction.completed) {
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

        unconfirmedDiv.children.add(element);
      }

      if (transaction is Transfer) {
        if (transaction.completed) {
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

        unconfirmedDiv.children.add(element);
      }
    }
  }

  Element _buildDeposit({
    @required Deposit deposit,
    @required WalletData walletData,
    @required DepositCallback onChanged,
    @required DepositCallback onDelete,
  }) {
    TableElement r = new TableElement();

    TableRowElement row = r.addRow();

    row.addCell().innerHtml = "Deposit";
    row.addCell().innerHtml = "${deposit.amount}";
    row.addCell().innerHtml = "${walletData.currency.name}";

    ButtonElement buttonConfirm = new ButtonElement();
    row.addCell().children.add(buttonConfirm);
    buttonConfirm.innerHtml = "Confirm";
    buttonConfirm.addEventListener(
      "click",
      (_) {
        Deposit newDeposit = deposit.copyWith(completed: true);

        onChanged(newDeposit);
      },
    );

    ButtonElement buttonDelete = new ButtonElement();
    row.addCell().children.add(buttonDelete);
    buttonDelete.innerHtml = "Delete";
    buttonDelete.addEventListener("click", (_) {
      onDelete(deposit);
    });

    return r;
  }

  Element _buildWithdrawal({
    @required Withdrawal withdrawal,
    @required WalletData walletData,
    @required WithdrawalCallback onChanged,
    @required WithdrawalCallback onDelete,
  }) {
    TableElement r = new TableElement();

    TableRowElement row = r.addRow();

    row.addCell().innerHtml = "Withdrawal";
    row.addCell().innerHtml = "${withdrawal.amount}";
    row.addCell().innerHtml = "${walletData.currency.name}";

    ButtonElement buttonConfirm = new ButtonElement();
    row.addCell().children.add(buttonConfirm);
    buttonConfirm.innerHtml = "Confirm";
    buttonConfirm.addEventListener(
      "click",
      (_) {
        Withdrawal newWithdrawal = withdrawal.copyWith(complete: true);

        onChanged(newWithdrawal);
      },
    );

    ButtonElement buttonDelete = new ButtonElement();
    row.addCell().children.add(buttonDelete);
    buttonDelete.innerHtml = "Delete";
    buttonDelete.addEventListener(
      "click",
      (_) {
        onDelete(withdrawal);
      },
    );

    return r;
  }

  Element _buildTransfer({
    @required Transfer transfer,
    @required CoinData coinData,
    @required WalletData walletData,
    @required TransferCallback onChanged,
    @required TransferCallback onDelete,
  }) {
    TableElement r = new TableElement();

    TableRowElement row = r.addRow();

    Wallet toWallet = coinData.getWallet(transfer.toWalletId);

    row.addCell().innerHtml = "Transfer";
    row.addCell().innerHtml = "${transfer.fromWalletAmount}";
    row.addCell().innerHtml = "${walletData.currency.name}";
    row.addCell().innerHtml = "to";
    row.addCell().innerHtml = "${toWallet.name} wallet";
    row.addCell().innerHtml = "as";
    row.addCell().innerHtml = "${transfer.toWalletAmount}";
    row.addCell().innerHtml =
        "${coinData.getCurrency(toWallet.currencyId).name}";

    ButtonElement buttonConfirm = new ButtonElement();
    row.addCell().children.add(buttonConfirm);
    buttonConfirm.innerHtml = "Confirm";
    buttonConfirm.addEventListener(
      "click",
      (_) {
        Transfer newTransfer = transfer.copyWith(completed: true);

        onChanged(newTransfer);
      },
    );

    ButtonElement buttonDelete = new ButtonElement();
    row.addCell().children.add(buttonDelete);
    buttonDelete.innerHtml = "Delete";
    buttonDelete.addEventListener(
      "click",
      (_) {
        onDelete(transfer);
      },
    );

    return r;
  }
}
