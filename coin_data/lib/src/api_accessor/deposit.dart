import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../authentication.dart';
import '../data/raw/deposit.dart';

Future<List<Deposit>> listDeposits({
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Deposit_Log";

  String body = (await http.get(
    url,
    headers: authentication.header,
  ))
      .body;

  Map json = JSON.decode(body);
  List records = json["records"];

  return records
      .map(
        (record) => new Deposit.fromJSON(record),
      )
      .toList();
}

Future<String> createDeposit({
  @required Authentication authentication,
  @required Deposit deposit,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Deposit_Log";

  String body = JSON.encode({
    "fields": {
      "id": deposit.id,
      "timestamp": deposit.timeStamp,
      "to_wallet_id": deposit.toWalletId,
      "amount": deposit.amount,
      "completed": deposit.completed,
    }
  });

  return (await http.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateDeposit({
  @required Authentication authentication,
  @required Deposit deposit,
}) async {
  String url =
      "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Deposit_Log/${deposit.airtableId}";

  String body = JSON.encode({
    "fields": {
      "id": deposit.id,
      "timestamp": deposit.timeStamp,
      "to_wallet_id": deposit.toWalletId,
      "amount": deposit.amount,
      "completed": deposit.completed,
    }
  });

  return (await http.put(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}
