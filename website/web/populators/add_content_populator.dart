import 'dart:html';

import '../coin_data/coin_data.dart';

void populateAddContentDeposit(Element contentArea, WalletData walletData){
  TableElement tableElement = new TableElement();
  TableRowElement row = tableElement.addRow();
  
  TableCellElement addAmountCell = row.addCell();
  TableCellElement addCurrencyCell = row.addCell();
  TableCellElement addCompletedCell = row.addCell();
  TableCellElement addSubmitCell = row.addCell();

  // add amount
  addAmountCell.classes.add("addAmount");
  addAmountCell.innerHtml = '<input type="text" name="FirstName" value="Mickey">';


}