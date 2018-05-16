import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../authentication.dart';
import '../data/raw/transfer.dart';

Future<List<Transfer>> listTransfers({
  @required BrowserClient browserClient,
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Transfer_Log";

  String body = (await browserClient.get(
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
  @required BrowserClient browserClient,
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

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateTransfer({
  @required BrowserClient browserClient,
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

   Response response = await browserClient.put(
    url,
    headers: authentication.header,
    body: body,
  );

  return response.body;
}
