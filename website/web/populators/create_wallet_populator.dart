import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

import 'callbacks.dart';

class CreateWalletPopulator {
  CreateWalletPopulator({
    @required this.createWalletDiv,
  });

  final DivElement createWalletDiv;

  void clear() {
    createWalletDiv.innerHtml = "Create Wallet";
  }

  void populate({
    @required CoinData coinData,
    @required VoidCallback onRefresh,
  }) {
    createWalletDiv.innerHtml = "";

    TableElement createWalletTable = new TableElement();
    createWalletTable.classes.add("createCurrencyTable");
    createWalletDiv.children.add(createWalletTable);

    createWalletTable.addRow().addCell()
      ..colSpan = 2
      ..innerHtml = "<h3>Create Wallet</h3>";

    TableRowElement nameRow = createWalletTable.addRow();
    nameRow.addCell().innerHtml = "Name:";

    InputElement nameInput = new InputElement(type: "text");
    nameRow.addCell().children.add(nameInput);

    TableRowElement currencyRow = createWalletTable.addRow();
    currencyRow.addCell().innerHtml = "Currency:";

    SelectElement currencySelect = new SelectElement();
    List<OptionElement> optionElements = <OptionElement>[];
    for (Currency currency in coinData.currencies) {
      OptionElement optionElement = new OptionElement(
        value: "${currency.id}",
      );
      optionElement.text = currency.name;

      optionElements.add(optionElement);
    }
    currencySelect.children.addAll(optionElements);

    currencyRow.addCell().children.add(currencySelect);

    ButtonElement submitButton = new ButtonElement();
    createWalletTable.addRow().addCell()
      ..colSpan = 2
      ..children.add(submitButton);

    submitButton.innerHtml = "Submit";
    submitButton.addEventListener(
      "click",
      (_) {
        if (nameInput.value == "") {
          window.alert("Please provide a Wallet name");
          return;
        }

        Wallet newWallet = new Wallet(
          id: coinData.generateNewWalletId(),
          name: nameInput.value,
          currencyId:
              int.parse(optionElements[currencySelect.selectedIndex].value),
        );

        coinData.addWallet(newWallet).then((_){
          onRefresh();
        });
      },
    );
  }
}
