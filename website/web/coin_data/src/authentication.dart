import 'package:meta/meta.dart';

@immutable
class Authentication {
  final String apiKey;

  Authentication({
    @required this.apiKey,
  });

  Map<String, String> get header => <String, String>{
        headerKey: headerValue,
        "Content-Type": "application/json",
      };

  String get headerKey => "Authorization";

  String get headerValue => "Bearer $apiKey";
}
