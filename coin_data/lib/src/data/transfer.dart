import 'package:meta/meta.dart';

@immutable
class Transfer implements Comparable<Transfer> {
  final String airtableId;

  final int id;

  final int timeStamp;

  final int fromWalletId;

  final double fromWalletAmount;

  final int toWalletId;

  final double toWalletAmount;

  final bool completed;

  Transfer({
    this.airtableId,
    @required this.id,
    @required this.timeStamp,
    @required this.fromWalletId,
    @required this.fromWalletAmount,
    @required this.toWalletId,
    @required this.toWalletAmount,
    @required this.completed,
  });

  factory Transfer.fromJSON(Map json) {
    Map fields = json["fields"];

    num fromWalletAmount = fields["from_wallet_amount"];
    num toWalletAmount = fields["to_wallet_amount"];

    return new Transfer(
      airtableId: json["id"],
      id: fields["id"],
      timeStamp: fields["timestamp"],
      fromWalletId: fields["from_wallet_id"],
      fromWalletAmount: fromWalletAmount,
      toWalletId: fields["to_wallet_id"],
      toWalletAmount: toWalletAmount,
      completed: fields["completed"],
    );
  }

  Transfer copyWith({
    int id,
    int timeStamp,
    int fromWalletId,
    double fromWalletAmount,
    int toWalletId,
    double toWalletAmount,
    bool completed,
  }) {
    return new Transfer(
      airtableId: this.airtableId,
      id: id ?? this.id,
      timeStamp: timeStamp ?? this.timeStamp,
      fromWalletId: fromWalletId ?? this.fromWalletId,
      fromWalletAmount: fromWalletAmount ?? this.fromWalletAmount,
      toWalletId: toWalletId ?? this.toWalletId,
      toWalletAmount: toWalletAmount ?? this.toWalletAmount,
      completed: completed ?? this.completed,
    );
  }

  @override
  int compareTo(Transfer other) {
    if (this.completed == other.completed) {
      return this.timeStamp.compareTo(other.timeStamp);
    }
    if (this.completed) {
      return -1;
    } else {
      return 1;
    }
  }

  @override
  String toString() {
    return 'Transfer{id: $id, timeStamp: $timeStamp, fromWalletId: $fromWalletId, fromWalletAmount: $fromWalletAmount, toWalletId: $toWalletId, toWalletAmount: $toWalletAmount, completed: $completed}';
  }
}
