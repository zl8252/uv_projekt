import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../authentication.dart';
import '../data/raw/currency.dart';

Future<List<Currency>> listCurrencies({
  @required Authentication authentication,
}) async {
  const url = "https://api.airtable.com/v0/appDbu7XVhfQDRmIH/Currency";

  String body = (await http.get(
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

  return (await http.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}

Future<String> updateCurrency({
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

  return (await http.post(
    url,
    headers: authentication.header,
    body: body,
  ))
      .body;
}
