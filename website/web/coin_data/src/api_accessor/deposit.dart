import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';

import '../authentication.dart';
import '../data/raw/deposit.dart';

Future<List<Deposit>> listDeposits({
  @required BrowserClient browserClient,
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Deposit_Log";

  String body = (await browserClient.get(
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
  @required BrowserClient browserClient,
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

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateDeposit({
  @required BrowserClient browserClient,
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

  return (await browserClient.put(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> deleteDeposit({
  @required BrowserClient browserClient,
  @required Authentication authentication,
  @required Deposit deposit,
}) async {
  String url =
      "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Deposit_Log/${deposit.airtableId}";

  return (await browserClient.delete(
    url,
    headers: authentication.header,
  ))
      .body;
}
