import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';

import '../authentication.dart';
import '../data/raw/withdrawal.dart';

Future<List<Withdrawal>> listWithdrawals({
  @required BrowserClient browserClient,
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Withdrawal_Log";

  String body = (await browserClient.get(
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
  @required BrowserClient browserClient,
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

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateWithdrawal({
  @required BrowserClient browserClient,
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

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> deleteWithdrawal({
  @required BrowserClient browserClient,
  @required Authentication authentication,
  @required Withdrawal withdrawal,
}) async {
  String url =
      "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Withdrawal_Log/${withdrawal.airtableId}";

  return (await browserClient.delete(
    url,
    headers: authentication.header,
  ))
      .body;
}
