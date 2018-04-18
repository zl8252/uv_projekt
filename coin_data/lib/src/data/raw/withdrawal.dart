import 'package:meta/meta.dart';

import 'i_transaction.dart';

@immutable
class Withdrawal extends ITransaction implements Comparable<Withdrawal> {
  final String airtableId;

  final int id;

  final int timeStamp;

  final int fromWalletId;

  final double amount;

  final bool completed;

  Withdrawal({
    this.airtableId,
    @required this.id,
    @required this.timeStamp,
    @required this.fromWalletId,
    @required this.amount,
    @required this.completed,
  });

  factory Withdrawal.fromJSON(Map json) {
    Map fields = json["fields"];

    num amount = fields["amount"];

    return new Withdrawal(
      airtableId: json["id"],
      id: fields["id"],
      timeStamp: fields["timestamp"],
      fromWalletId: fields["from_wallet_id"],
      amount: amount.toDouble(),
      completed: fields["completed"],
    );
  }

  Withdrawal copyWith({
    int id,
    int timeStamp,
    int fromWalletId,
    double amount,
    bool complete,
  }) {
    return new Withdrawal(
      airtableId: this.airtableId,
      id: id ?? this.id,
      timeStamp: timeStamp ?? this.timeStamp,
      fromWalletId: fromWalletId ?? this.fromWalletId,
      amount: amount ?? this.amount,
      completed: complete ?? this.completed,
    );
  }

  @override
  int compareTo(Withdrawal other) {
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
    return 'Withdrawal{id: $id, timeStamp: $timeStamp, fromWalletId: $fromWalletId, amount: $amount, completed: $completed}';
  }
}
