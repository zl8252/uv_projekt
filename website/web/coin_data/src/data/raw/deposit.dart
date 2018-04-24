import 'package:meta/meta.dart';

import 'i_transaction.dart';

@immutable
class Deposit extends ITransaction implements Comparable<Deposit> {
  final String airtableId;

  final int id;

  final int timeStamp;

  final int toWalletId;

  final double amount;

  final bool completed;

  Deposit({
    this.airtableId,
    @required this.id,
    @required this.timeStamp,
    @required this.toWalletId,
    @required this.amount,
    @required this.completed,
  });

  factory Deposit.fromJSON(Map json) {
    Map fields = json["fields"];

    num amount = fields["amount"];

    return new Deposit(
      airtableId: json["id"],
      id: fields["id"],
      timeStamp: fields["timestamp"],
      toWalletId: fields["to_wallet_id"],
      amount: amount.toDouble(),
      completed: fields["completed"],
    );
  }

  Deposit copyWith({
    int id,
    int timeStamp,
    int toWalletId,
    double amount,
    bool completed,
  }) {
    return new Deposit(
      airtableId: airtableId,
      id: id ?? this.id,
      timeStamp: timeStamp ?? this.timeStamp,
      toWalletId: toWalletId ?? this.toWalletId,
      amount: amount ?? this.amount,
      completed: completed ?? this.completed,
    );
  }

  @override
  int compareTo(Deposit other) {
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
    return 'Deposit{id: $id, timeStamp: $timeStamp, toWalletId: $toWalletId, amount: $amount, completed: $completed}';
  }
}
