import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';

import '../authentication.dart';
import '../data/raw/currency.dart';

Future<List<Currency>> listCurrencies({
  @required BrowserClient browserClient,
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Currency";

  String body = (await browserClient.get(
    url,
    headers: authentication.header,
  ))
      .body;

  Map json = JSON.decode(body);
  List records = json["records"];

  return records
      .map(
        (record) => new Currency.fromJSON(record),
      )
      .toList();
}

Future<String> createCurrency({
  @required BrowserClient browserClient,
  @required Authentication authentication,
  @required Currency currency,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Currency";

  String body = JSON.encode({
    'fields': {
      'id': currency.id,
      'name': currency.name,
    }
  });

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateCurrency({
  @required BrowserClient browserClient,
  @required Authentication authentication,
  @required Currency currency,
}) async {
  String url =
      "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Currency/${currency.airtableId}";

  String body = JSON.encode({
    'fields': {
      'id': currency.id,
      'name': currency.name,
    }
  });

  return (await browserClient.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}
