import 'package:meta/meta.dart';

import 'raw/all.dart';

@immutable
class WalletData {
  WalletData({
    @required this.wallet,
    @required this.currency,
    @required this.transactions,
  });

  final Wallet wallet;
  final Currency currency;

  final List<ITransaction> transactions;

  List<Deposit> get deposits => transactions
      .where(
        (transactions) => transactions is Deposit,
      )
      .map(
        (transaction) => transaction as Deposit,
      )
      .toList();

  List<Transfer> get transfers => transactions
      .where(
        (transaction) => transaction is Transfer,
      )
      .map(
        (transaction) => transaction as Transfer,
      )
      .toList();

  List<Withdrawal> get withdrawals => transactions
      .where(
        (transaction) => transaction is Withdrawal,
      )
      .map(
        (transaction) => transaction as Withdrawal,
      )
      .toList();

  double get confirmedDeposited {
    double r = 0.0;

    for (Deposit deposit in deposits){
      if (deposit.completed){
        r += deposit.amount;
      }
    }

    return r;
  }

  double get confirmedWithdrawaled {
    double r = 0.0;

    for (Withdrawal withdrawal in withdrawals){
      if (withdrawal.completed){
        r += withdrawal.amount;
      }
    }

    return r;
  }

  double get confirmedBalance {
    double r = 0.0;

    for (Deposit deposit in deposits) {
      if (!deposit.completed) continue;
      r += deposit.amount;
    }

    for (Transfer transfer in transfers) {
      if (!transfer.completed) continue;
      if (transfer.fromWalletId == wallet.id) r -= transfer.fromWalletAmount;
      if (transfer.toWalletId == wallet.id) r += transfer.toWalletAmount;
    }

    for (Withdrawal withdrawal in withdrawals) {
      if (!withdrawal.completed) continue;
      r -= withdrawal.amount;
    }

    return r;
  }

  double get potentialBalance {
    double r = 0.0;

    for (Deposit deposit in deposits) {
      r += deposit.amount;
    }

    for (Transfer transfer in transfers) {
      if (transfer.fromWalletId == wallet.id) r -= transfer.fromWalletAmount;
      if (transfer.toWalletId == wallet.id) r += transfer.toWalletAmount;
    }

    for (Withdrawal withdrawal in withdrawals) {
      r -= withdrawal.amount;
    }

    return r;
  }
}
