import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';

import '../authentication.dart';
import '../data/raw/wallet.dart';

Future<List<Wallet>> listWallets({
  @required BrowserClient browserClient,
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Wallet";

  String body = (await browserClient.get(
    url,
    headers: authentication.header,
  ))
      .body;

  Map json = JSON.decode(body);
  List records = json["records"];

  return records
      .map(
        (record) => new Wallet.fromJSON(record),
      )
      .toList();
}

Future<String> createWallet({
  @required BrowserClient browserClient,
  @required Authentication authentication,
  @required Wallet wallet,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Wallet";

  String body = JSON.encode({
    'fields': {
      'id': wallet.id,
      "name": wallet.name,
      "currency_id": wallet.currencyId,
    }
  });

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateWallet({
  @required BrowserClient browserClient,
  @required Authentication authentication,
  @required Wallet wallet,
}) async {
  String url =
      "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Wallet/${wallet.airtableId}";

  String body = JSON.encode({
    'fields': {
      'id': wallet.id,
      "name": wallet.name,
      "currency_id": wallet.currencyId,
    }
  });

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}
