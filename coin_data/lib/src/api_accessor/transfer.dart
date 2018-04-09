import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:coin_data/src/authentication.dart';
import 'package:coin_data/src/data/raw/all.dart';

Future<List<Transfer>> listTransfers({
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Transfer_Log";

  String body = (await http.get(
    url,
    headers: authentication.header,
  ))
      .body;

  Map json = JSON.decode(body);
  List records = json["records"];

  return records
      .map(
        (record) => new Transfer.fromJSON(record),
      )
      .toList();
}

Future<String> createTransfer({
  @required Authentication authentication,
  @required Transfer transfer,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Transfer_Log";

  String body = JSON.encode({
    'fields': {
      'id': transfer.id,
      "timestamp": transfer.timeStamp,
      "from_wallet_id": transfer.fromWalletId,
      "from_wallet_amount": transfer.fromWalletAmount,
      "to_wallet_id": transfer.toWalletId,
      "to_wallet_amount": transfer.toWalletAmount,
      "completed": transfer.completed,
    }
  });

  return (await http.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateTransfer({
  @required Authentication authentication,
  @required Transfer transfer,
}) async {
  String url =
      "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Transfer_Log/${transfer.airtableId}";

  String body = JSON.encode({
    'fields': {
      'id': transfer.id,
      "timestamp": transfer.timeStamp,
      "from_wallet_id": transfer.fromWalletId,
      "from_wallet_amount": transfer.fromWalletAmount,
      "to_wallet_id": transfer.toWalletId,
      "to_wallet_amount": transfer.toWalletAmount,
      "completed": transfer.completed,
    }
  });

  return (await http.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}
