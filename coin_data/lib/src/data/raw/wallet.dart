import 'package:meta/meta.dart';

@immutable
class Wallet implements Comparable<Wallet> {
  final String airtableId;

  final int id;

  final String name;

  final int currencyId;

  Wallet({
    this.airtableId,
    @required this.id,
    @required this.name,
    @required this.currencyId,
  });

  factory Wallet.fromJSON(Map json) {
    Map fields = json["fields"];

    return new Wallet(
      airtableId: json["id"],
      id: fields["id"],
      name: fields["name"],
      currencyId: fields["currency_id"],
    );
  }

  Wallet copyWith({
    int id,
    String name,
    int currencyId,
  }) {
    return new Wallet(
      airtableId: this.airtableId,
      id: id ?? this.id,
      name: name ?? this.name,
      currencyId: currencyId ?? this.currencyId,
    );
  }

  @override
  int compareTo(Wallet other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return 'Wallet{id: $id, name: $name, currencyId: $currencyId}';
  }
}
