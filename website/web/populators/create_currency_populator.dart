import 'dart:html';

import 'package:meta/meta.dart';

import '../coin_data/coin_data.dart';

import 'callbacks.dart';

class CreateCurrencyPopulator {
  CreateCurrencyPopulator({
    @required this.createCurrencyDiv,
  });

  final DivElement createCurrencyDiv;

  void clear() {
    createCurrencyDiv.innerHtml = "Create Currency";
  }

  void populate({
    @required CoinData coinData,
    @required VoidCallback onRefresh,
  }) {
    createCurrencyDiv.innerHtml = "";

    DivElement title = new DivElement();
    title.innerHtml = "<h1>Currencies</h1>";
    createCurrencyDiv.children.add(title);

    TableElement currenciesTable = new TableElement();
    createCurrencyDiv.children.add(currenciesTable);
    currenciesTable.classes.add("currenciesTable");

    for (Currency currency in coinData.currencies) {
      TableRowElement currencyRow = currenciesTable.addRow();
      TableCellElement currencyCell = currencyRow.addCell();

      currencyCell.innerHtml = "${currency.name}";
    }

    TableElement createTable = new TableElement();
    createCurrencyDiv.children.add(createTable);
    createTable.classes.add("createCurrencyTable");
    createTable.addRow().addCell()
      ..colSpan = 2
      ..innerHtml = "<h3>Create Currency</h3>";
    TableRowElement row = createTable.addRow();
    row.addCell().innerHtml = "Name:";

    InputElement inputElement = new InputElement(type: "text");
    ButtonElement confirmButton = new ButtonElement();

    row.addCell().children.add(inputElement);
    row = createTable.addRow();
    row.addCell()
      ..colSpan = 2
      ..children.add(confirmButton);

    confirmButton.innerHtml = "Submit";
    confirmButton.addEventListener("click", (_) {
      if (inputElement.value == "") {
        window.alert("Please provide a Currency Name");
        return;
      }

      Currency newCurrency = new Currency(
        id: coinData.generateNewCurrencyId(),
        name: inputElement.value,
      );

      coinData.addCurrency(newCurrency).then((_){
        onRefresh();
      });
    });
  }
}
