import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

class TableTransactionsPopulator {
  TableTransactionsPopulator({
    @required this.unconfirmedTable,
    @required this.confirmedTable,
  });

  final TableElement unconfirmedTable;
  final TableElement confirmedTable;

  void clear() {
    unconfirmedTable.innerHtml = "";
    confirmedTable.innerHtml = "";
  }

  void populate({
    @required WalletData walletData,
    @required CoinData coinData,
  }) {
    clear();

    for (ITransaction transaction in walletData.transactions) {
      // Deposit
      if (transaction is Deposit) {
        Element deposit = _buildDeposit(
          transaction,
          walletData.currency.name,
        );

        if (transaction.completed) {
          TableRowElement row = confirmedTable.addRow();
          TableCellElement cell = row.addCell();
          cell.children.add(deposit);
        } else {
          TableRowElement row = unconfirmedTable.addRow();
          TableCellElement cell = row.addCell();
          cell.children.add(deposit);
        }
      }
      // Withdrawal
      if (transaction is Withdrawal) {
        Element withdrawal = _buildWithdrawal(
          transaction,
          walletData.currency.name,
        );

        if (transaction.completed) {
          TableRowElement row = confirmedTable.addRow();
          TableCellElement cell = row.addCell();
          cell.children.add(withdrawal);
        } else {
          TableRowElement row = unconfirmedTable.addRow();
          TableCellElement cell = row.addCell();
          cell.children.add(withdrawal);
        }
      }
      // Transfer
      if (transaction is Transfer) {
        WalletData fromWallet = coinData.walletData(transaction.fromWalletId);
        WalletData toWallet = coinData.walletData(transaction.toWalletId);

        Element transfer = _buildTransfer(
          transfer: transaction,
          fromWalletName: fromWallet.wallet.name,
          fromCurrencyName: fromWallet.currency.name,
          toWalletName: toWallet.wallet.name,
          toCurrencyName: toWallet.currency.name,
        );

        if (transaction.completed) {
          TableRowElement row = confirmedTable.addRow();
          TableCellElement cell = row.addCell();
          cell.children.add(transfer);
        } else {
          TableRowElement row = unconfirmedTable.addRow();
          TableCellElement cell = row.addCell();
          cell.children.add(transfer);
        }
      }
    }
  }

  Element _buildDeposit(Deposit deposit, String currencyName) {
    TableElement tableElement = new TableElement();
    tableElement.classes.add("transactionDepositTable");
    TableRowElement row = tableElement.addRow();

    TableCellElement transactionCaption = row.addCell();
    transactionCaption.classes.add("transactionCaption");
    transactionCaption.innerHtml = "Deposit";

    TableCellElement transactionAmount = row.addCell();
    transactionAmount.classes.add("transactionAmount");
    transactionAmount.innerHtml = "${deposit.amount}";

    TableCellElement transactionCurrency = row.addCell();
    transactionCurrency.classes.add("transactionCurrency");
    transactionCurrency.innerHtml = "$currencyName";

    return tableElement;
  }

  Element _buildWithdrawal(Withdrawal withdrawal, String currencyName) {
    TableElement tableElement = new TableElement();
    tableElement.classes.add("transactionWithdrawalTable");
    TableRowElement row = tableElement.addRow();

    TableCellElement transactionCaption = row.addCell();
    transactionCaption.classes.add("transactionCaption");
    transactionCaption.innerHtml = "Withdrawal";

    TableCellElement transactionAmount = row.addCell();
    transactionAmount.classes.add("transactionAmount");
    transactionAmount.innerHtml = "${withdrawal.amount}";

    TableCellElement transactionCurrency = row.addCell();
    transactionCurrency.classes.add("transactionCurrency");
    transactionCurrency.innerHtml = "$currencyName";

    return tableElement;
  }

  Element _buildTransfer({
    @required Transfer transfer,
    @required String fromWalletName,
    @required String fromCurrencyName,
    @required String toWalletName,
    @required String toCurrencyName,
  }) {
    TableElement tableElement = new TableElement();
    tableElement.classes.add("transactionTransferTable");
    TableRowElement row = tableElement.addRow();

    TableCellElement transactionCaption = row.addCell();
    transactionCaption.classes.add("transactionCaption");
    transactionCaption.innerHtml = "Transfer";

    TableCellElement from = row.addCell();
    from.classes.add("transactionFrom");
    from.innerHtml = fromWalletName;

    TableCellElement fromAmount = row.addCell();
    fromAmount.classes.add("transactionAmount");
    fromAmount.innerHtml = "${transfer.fromWalletAmount}";

    TableCellElement fromCurrency = row.addCell();
    fromCurrency.classes.add("transactionCurrency");
    fromCurrency.innerHtml = "$fromCurrencyName";

    TableCellElement to = row.addCell();
    to.classes.add("transactionFrom");
    to.innerHtml = toWalletName;

    TableCellElement toAmount = row.addCell();
    toAmount.classes.add("transactionAmount");
    toAmount.innerHtml = "${transfer.toWalletAmount}";

    TableCellElement toCurrency = row.addCell();
    toCurrency.classes.add("transactionCurrency");
    toCurrency.innerHtml = "$toCurrencyName";

    return tableElement;
  }
}
