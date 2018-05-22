import 'dart:html';
import 'package:meta/meta.dart';

import 'callbacks.dart';

import '../coin_data/coin_data.dart';

enum SelectedNavigation {
  none,
  deposit,
  withdrawal,
  transfer,
}

class AddPopulator {
  final DivElement addDivNavigation;
  final DivElement addDivContent;

  AddPopulator({
    @required this.addDivNavigation,
    @required this.addDivContent,
  });

  void clear() {
    addDivNavigation.innerHtml = "";
    addDivContent.innerHtml = "";
  }

  void populate({
    @required CoinData coinData,
    @required WalletData currentWalletData,
    @required VoidCallback onRefresh,
  }) {
    print("Populating Add");

    TableElement addTable = _createTableAdd(
      selectedNavigation: SelectedNavigation.none,
      onDeposit: () {
        _populateAddDeposit(
          addDivContent: addDivContent,
          coinData: coinData,
          currentWalletData: currentWalletData,
          onConfirmed: (Deposit deposit) {
            coinData.addDeposit(deposit).then((_) {
              onRefresh();
            });
          },
        );
      },
      onWithdrawal: () {
        _populateAddWithdrawal(
            addDivContent: addDivContent,
            coinData: coinData,
            currentWalletData: currentWalletData,
            onConfirmed: (Withdrawal withdrawal) {
              coinData.addWithdrawal(withdrawal).then((_) {
                onRefresh();
              });
            });
      },
      onTransfer: () {
        _populateAddTransfer(
            addDivContent: addDivContent,
            coinData: coinData,
            currentWalletData: currentWalletData,
            onConfirmed: (Transfer transfer) {
              coinData.addTransfer(transfer).then((_) {
                onRefresh();
              });
            });
      },
    );

    addDivNavigation.innerHtml = "";
    addDivNavigation.children.add(addTable);
  }

  TableElement _createTableAdd({
    @required VoidCallback onDeposit,
    @required VoidCallback onWithdrawal,
    @required VoidCallback onTransfer,
    @required SelectedNavigation selectedNavigation,
  }) {
    TableElement r = new TableElement();

    TableRowElement navigationRow = r.addRow();
    navigationRow.classes.add("addNavigation");

    TableCellElement deposit;
    TableCellElement withdrawal;
    TableCellElement transfer;

    void clearAddSelected() {
      deposit.classes.remove("addSelected");
      withdrawal.classes.remove("addSelected");
      transfer.classes.remove("addSelected");
    }

    // addNavigationDeposit
    deposit = navigationRow.addCell();
    deposit.innerHtml = "Deposit";
    if (selectedNavigation == SelectedNavigation.deposit) {
      deposit.classes.add("addSelected");
    } else {
      deposit.classes.remove("addSelected");
    }
    deposit.addEventListener("click", (_) {
      clearAddSelected();
      deposit.classes.add("addSelected");
      onDeposit();
    });

    // addNavigationWithdrawal
    withdrawal = navigationRow.addCell();
    if (selectedNavigation == SelectedNavigation.withdrawal) {
      deposit.classes.add("addSelected");
    } else {
      deposit.classes.remove("addSelected");
    }
    withdrawal.innerHtml = "Withdrawal";
    withdrawal.addEventListener("click", (_) {
      clearAddSelected();
      withdrawal.classes.add("addSelected");
      onWithdrawal();
    });

    // addNavigationTransfer
    transfer = navigationRow.addCell();
    if (selectedNavigation == SelectedNavigation.transfer) {
      deposit.classes.add("addSelected");
    } else {
      deposit.classes.remove("addSelected");
    }
    transfer.innerHtml = "Transfer";
    transfer.addEventListener("click", (_) {
      clearAddSelected();
      transfer.classes.add("addSelected");
      onTransfer();
    });

    return r;
  }

  void _populateAddDeposit({
    @required DivElement addDivContent,
    @required CoinData coinData,
    @required WalletData currentWalletData,
    @required DepositCallback onConfirmed,
  }) {
    addDivContent.innerHtml = "";

    TableElement table = new TableElement();
    addDivContent.children.add(table);
    table.classes.add("addContentTable");

    TableRowElement row = table.addRow();

    // amount
    TableCellElement amountCell = row.addCell();
    amountCell.classes.add("addDepositAmount");

    InputElement inputAmount = new InputElement(type: "number");
    inputAmount.placeholder = "amount";
    amountCell.children.add(inputAmount);

    // currncy
    TableCellElement currencyCell = row.addCell();
    currencyCell.classes.add("addDepositCurrency");

    currencyCell.innerHtml = "${currentWalletData.currency.name}";

    row = table.addRow();

    // confirmed
    TableCellElement confirmedCell = row.addCell();
    confirmedCell.classes.add("addDepositConfirmed");

    CheckboxInputElement confirmedCheckbox = new CheckboxInputElement();
    confirmedCheckbox.checked = true;
    SpanElement confirmedText = new SpanElement();
    confirmedText.innerHtml = "Confirmed";
    confirmedCell.children.add(confirmedCheckbox);
    confirmedCell.children.add(confirmedText);

    // submit
    TableCellElement submitCell = row.addCell();
    submitCell.classes.add("addDepositSubmit");

    ButtonElement submitButton = new ButtonElement();
    submitButton.innerHtml = "Submit";
    submitButton.addEventListener("click", (_) {
      if (inputAmount.value == "") {
        window.alert("Please insert Deposit amount");
        return;
      }

      Deposit deposit = new Deposit(
        id: coinData.generateNewDepositId(),
        timeStamp: new DateTime.now().millisecondsSinceEpoch,
        amount: double.parse(inputAmount.value),
        completed: confirmedCheckbox.checked,
        toWalletId: currentWalletData.wallet.id,
      );

      onConfirmed(deposit);
    });
    submitCell.children.add(submitButton);
  }

  void _populateAddWithdrawal({
    @required DivElement addDivContent,
    @required CoinData coinData,
    @required WalletData currentWalletData,
    @required WithdrawalCallback onConfirmed,
  }) {
    addDivContent.innerHtml = "";

    TableElement table = new TableElement();
    addDivContent.children.add(table);
    table.classes.add("addContentTable");

    TableRowElement row = table.addRow();

    // amount
    TableCellElement amountCell = row.addCell();
    amountCell.classes.add("addWithdrawalAmount");

    InputElement inputAmount = new InputElement(type: "number");
    inputAmount.placeholder = "amount";
    amountCell.children.add(inputAmount);

    // currncy
    TableCellElement currencyCell = row.addCell();
    currencyCell.classes.add("addWithdrawalCurrency");

    currencyCell.innerHtml = "${currentWalletData.currency.name}";

    row = table.addRow();

    // confirmed
    TableCellElement confirmedCell = row.addCell();
    confirmedCell.classes.add("addWithdrawalConfirmed");

    CheckboxInputElement confirmedCheckbox = new CheckboxInputElement();
    confirmedCheckbox.checked = true;
    SpanElement confirmedText = new SpanElement();
    confirmedText.innerHtml = "Confirmed";
    confirmedCell.children.add(confirmedCheckbox);
    confirmedCell.children.add(confirmedText);

    // submit
    TableCellElement submitCell = row.addCell();
    submitCell.classes.add("addWithdrawalSubmit");

    ButtonElement submitButton = new ButtonElement();
    submitButton.innerHtml = "Submit";
    submitButton.addEventListener("click", (_) {
      if (inputAmount.value == "") {
        window.alert("Please insert Withdrawal amount");
        return;
      }

      Withdrawal withdrawal = new Withdrawal(
        id: coinData.generateNewWithdrawalId(),
        timeStamp: new DateTime.now().millisecondsSinceEpoch,
        amount: double.parse(inputAmount.value),
        completed: confirmedCheckbox.checked,
        fromWalletId: currentWalletData.wallet.id,
      );

      onConfirmed(withdrawal);
    });
    submitCell.children.add(submitButton);
  }

  void _populateAddTransfer({
    @required DivElement addDivContent,
    @required CoinData coinData,
    @required WalletData currentWalletData,
    @required TransferCallback onConfirmed,
  }) {
    addDivContent.innerHtml = "";

    TableElement table = new TableElement();
    addDivContent.children.add(table);
    table.classes.add("addContentTable");

    TableRowElement row = table.addRow();

    // fromAmount
    TableCellElement fromAmountCell = row.addCell();
    fromAmountCell.classes.add("addTransferFromAmount");

    InputElement inputFromAmount = new InputElement(type: "number");
    inputFromAmount.placeholder = "amount";
    fromAmountCell.children.add(inputFromAmount);

    // fromCurrncy
    TableCellElement fromCurrencyCell = row.addCell();
    fromCurrencyCell.classes.add("addTransferFromCurrency");

    fromCurrencyCell.innerHtml = "${currentWalletData.currency.name}";

    row = table.addRow();

    // toText
    TableCellElement toTextCell = row.addCell();
    toTextCell.classes.add("addTransferToText");

    toTextCell.innerHtml = "to";

    // toWallet
    TableCellElement toWalletCell = row.addCell();
    toWalletCell.classes.add("addTransferToWaller");

    SelectElement toWalletSelect = new SelectElement();
    List<OptionElement> optionElements = <OptionElement>[];
    for (Wallet wallet in coinData.wallets) {
      OptionElement optionElement = new OptionElement(
        value: "${wallet.id}",
      );
      optionElement.text = wallet.name;

      optionElements.add(optionElement);
    }
    toWalletSelect.children.addAll(optionElements);
    toWalletCell.children.add(toWalletSelect);

    SpanElement asText = new SpanElement();
    asText.innerHtml = " as";
    toWalletCell.children.add(asText);

    // adds new row
    row = table.addRow();

    // toAmount
    TableCellElement toAmountCell = row.addCell();
    toAmountCell.classes.add("addTransferToAmount");

    InputElement inputToAmount = new InputElement(type: "number");
    inputToAmount.placeholder = "amount";
    toAmountCell.children.add(inputToAmount);

    // toCurrncy
    TableCellElement toCurrencyCell = row.addCell();
    toCurrencyCell.classes.add("addTransferToCurrency");

    _updateToCurrency(
      _getWalletFromToWalletSelect(coinData, optionElements, toWalletSelect),
      toCurrencyCell,
      coinData,
    );

    toWalletSelect.addEventListener("click", (_) {
      _updateToCurrency(
        _getWalletFromToWalletSelect(coinData, optionElements, toWalletSelect),
        toCurrencyCell,
        coinData,
      );
    });

    row = table.addRow();

    // confirmed
    TableCellElement confirmedCell = row.addCell();
    confirmedCell.classes.add("addTransferConfirmed");

    CheckboxInputElement confirmedCheckbox = new CheckboxInputElement();
    confirmedCheckbox.checked = true;
    SpanElement confirmedText = new SpanElement();
    confirmedText.innerHtml = "Confirmed";
    confirmedCell.children.add(confirmedCheckbox);
    confirmedCell.children.add(confirmedText);

    // submit
    TableCellElement submitCell = row.addCell();
    submitCell.classes.add("addTransgerSubmit");

    ButtonElement submitButton = new ButtonElement();
    submitButton.innerHtml = "Submit";
    submitButton.addEventListener("click", (_) {
      if (inputFromAmount.value == "") {
        window.alert("Please insert From Amount");
        return;
      }

      if (inputToAmount.value == "") {
        window.alert("Please insert To Amount");
        return;
      }

      Transfer transfer = new Transfer(
          id: coinData.generateNewTransferId(),
          timeStamp: new DateTime.now().millisecondsSinceEpoch,
          fromWalletId: currentWalletData.wallet.id,
          fromWalletAmount: double.parse(inputFromAmount.value),
          toWalletId: _getWalletFromToWalletSelect(
                  coinData, optionElements, toWalletSelect)
              .id,
          toWalletAmount: double.parse(inputToAmount.value),
          completed: confirmedCheckbox.checked);

      onConfirmed(transfer);
    });
    submitCell.children.add(submitButton);
  }

  void _updateToCurrency(
      Wallet wallet, TableCellElement toCurrencyCell, CoinData coinData) {
    toCurrencyCell.innerHtml =
        "${coinData.getCurrency(wallet.currencyId).name}";
  }

  Wallet _getWalletFromToWalletSelect(CoinData coinData,
      List<OptionElement> optionElements, SelectElement toWalletSelect) {
    int selectedIndex = toWalletSelect.selectedIndex;

    OptionElement optionElement = optionElements[selectedIndex];

    String walletIdString = optionElement.value;
    int walletId = int.parse(walletIdString);

    return coinData.getWallet(walletId);
  }
}
