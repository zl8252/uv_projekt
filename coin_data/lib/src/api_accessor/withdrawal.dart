import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:coin_data/src/authentication.dart';
import 'package:coin_data/src/data/all.dart';

Future<List<Withdrawal>> listWithdrawals({
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Withdrawal_Log";

  String body = (await http.get(
    url,
    headers: authentication.header,
  ))
      .body;

  Map json = JSON.decode(body);
  List records = json["records"];

  return records
      .map(
        (record) => new Withdrawal.fromJSON(record),
      )
      .toList();
}

Future<String> createWithdrawal({
  @required Authentication authentication,
  @required Withdrawal withdrawal,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Withdrawal_Log";

  String body = JSON.encode({
    "fields": {
      "id": withdrawal.id,
      "timestamp": withdrawal.timeStamp,
      "from_wallet_id": withdrawal.fromWalletId,
      "amount": withdrawal.amount,
      "completed": withdrawal.completed,
    }
  });

  return (await http.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateWithdrawal({
  @required Authentication authentication,
  @required Withdrawal withdrawal,
}) async {
  String url =
      "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Withdrawal_Log/${withdrawal.airtableId}";

  String body = JSON.encode({
    "fields": {
      "id": withdrawal.id,
      "timestamp": withdrawal.timeStamp,
      "from_wallet_id": withdrawal.fromWalletId,
      "amount": withdrawal.amount,
      "completed": withdrawal.completed,
    }
  });

  return (await http.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}
