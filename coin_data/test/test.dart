import 'dart:async';

import 'package:coin_data/coin_data.dart';

import 'authentication.dart';

Future main() async {
  List l = await listDeposits(authentication: authentication);
  l.sort();

  Deposit d = l[0];

  d = d.copyWith(amount: 150.0);

  String s = await updateDeposit(authentication: authentication, deposit: d);

  int a = 1;
}
