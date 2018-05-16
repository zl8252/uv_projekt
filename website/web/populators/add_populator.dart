import 'dart:html';
import 'package:meta/meta.dart';

import 'callbacks.dart';

import '../coin_data/coin_data.dart';

class AddPopulator {
  DivElement addDivNavigation;
  DivElement addDivContent;

  AddPopulator({
    @required this.addDivNavigation,
    @required this.addDivContent,
  });

  void clear() {
    addDivContent.innerHtml = "";
    addDivContent.innerHtml = "";
  }

  void populate({
    @required CoinData coinData,
    @required WalletData currentWalletData,
    @required VoidCallback onRefresh,
  }) {
    print("Populating Add");

    TableElement addTable = _createTableAdd(
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
  }) {
    TableElement r = new TableElement();
    r.id = "tableAdd";

    TableRowElement navigationRow = r.addRow();
    navigationRow.classes.add("addNavigation");

    // addNavigationDeposit
    TableCellElement deposit = navigationRow.addCell();
    deposit.id = "addNavigationDeposit";
    deposit.innerHtml = "Deposit";
    deposit.addEventListener("click", (_) {
      onDeposit();
    });

    // addNavigationWithdrawal
    TableCellElement withdrawal = navigationRow.addCell();
    withdrawal.id = "addNavigationWithdrawal";
    withdrawal.innerHtml = "Withdrawal";
    withdrawal.addEventListener("click", (_) {
      onWithdrawal();
    });

    // addNavigationTransfer
    TableCellElement transfer = navigationRow.addCell();
    transfer.id = "addNavigationTransfer";
    transfer.innerHtml = "Transfer";
    transfer.addEventListener("click", (_) {
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

    // asText
    TableCellElement asTextCell = row.addCell();
    asTextCell.classes.add("addTransferToText");

    asTextCell.innerHtml = "as";

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
