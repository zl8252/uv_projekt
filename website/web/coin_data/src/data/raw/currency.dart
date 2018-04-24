import 'package:meta/meta.dart';

@immutable
class Currency implements Comparable<Currency> {
  final String airtableId;

  final int id;

  final String name;

  Currency({
    this.airtableId,
    @required this.id,
    @required this.name,
  });

  factory Currency.fromJSON(Map json) {
    Map fields = json["fields"];

    return new Currency(
      airtableId: json["id"],
      id: fields["id"],
      name: fields["name"],
    );
  }

  Currency copyWith({
    int id,
    String name,
  }) {
    return new Currency(
      airtableId: this.airtableId,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  int compareTo(Currency other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return 'Currency{id: $id, name: $name}';
  }
}
