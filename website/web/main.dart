import 'dart:html';

import 'package:meta/meta.dart';
import 'package:coin_data/coin_data.dart';


void main() {
  querySelector('#output').text = 'Your Dart app is running.';

  Wallet wallet = new Wallet(airtableId: "1", currencyId: 1, id: 1, name: "abc");

  print(wallet);

}
