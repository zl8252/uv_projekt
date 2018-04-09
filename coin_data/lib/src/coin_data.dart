import 'dart:async';
import 'package:meta/meta.dart';

import 'api_accessor/all.dart' as api_accessor;
import 'data/all.dart';
import 'authentication.dart';

@immutable
class CoinData {
  final Authentication authentication;

  final List<Currency> currencies = <Currency>[];

  final List<Deposit> deposits = <Deposit>[];

  final List<Transfer> transfers = <Transfer>[];

  final List<Wallet> wallets = <Wallet>[];

  final List<Withdrawal> withdrawals = <Withdrawal>[];

  CoinData.fromAuthentication({
    @required this.authentication,
  });

  factory CoinData({
    @required String apiKey,
  }) {
    return new CoinData.fromAuthentication(
      authentication: new Authentication(
        apiKey: apiKey,
      ),
    );
  }

  Future refreshAllData() async {
    await refreshCurrencies();
    await refreshDeposits();
    await refreshTransfers();
    await refreshWallets();
    await refreshWithdrawals();
  }

  Future refreshCurrencies() async {
    currencies.clear();

    currencies.addAll(
      await api_accessor.listCurrencies(
        authentication: authentication,
      ),
    );

    currencies.sort();
  }

  Future refreshDeposits() async {
    deposits.clear();

    deposits.addAll(
      await api_accessor.listDeposits(
        authentication: authentication,
      ),
    );

    deposits.sort();
  }

  Future refreshTransfers() async {
    transfers.clear();

    transfers.addAll(
      await api_accessor.listTransfers(
        authentication: authentication,
      ),
    );

    transfers.sort();
  }

  Future refreshWallets() async {
    wallets.clear();

    wallets.addAll(
      await api_accessor.listWallets(
        authentication: authentication,
      ),
    );

    wallets.sort();
  }

  Future refreshWithdrawals() async {
    withdrawals.clear();

    withdrawals.addAll(
      await api_accessor.listWithdrawals(
        authentication: authentication,
      ),
    );

    withdrawals.sort();
  }

  Future addCurrency(Currency currency) async {
    await api_accessor.createCurrency(
      authentication: authentication,
      currency: currency,
    );

    await refreshCurrencies();
  }

  Future updateCurrency(Currency currency) async {
    await api_accessor.updateCurrency(
      authentication: authentication,
      currency: currency,
    );

    await refreshCurrencies();
  }

  Future addDeposit(Deposit deposit) async {
    await api_accessor.createDeposit(
      authentication: authentication,
      deposit: deposit,
    );

    await refreshDeposits();
  }

  Future updateDeposit(Deposit deposit) async {
    await api_accessor.updateDeposit(
      authentication: authentication,
      deposit: deposit,
    );

    await refreshDeposits();
  }

  Future addTransfer(Transfer transfer) async {
    await api_accessor.createTransfer(
      authentication: authentication,
      transfer: transfer,
    );

    await refreshTransfers();
  }

  Future updateTransfer(Transfer transfer) async {
    await api_accessor.updateTransfer(
      authentication: authentication,
      transfer: transfer,
    );

    await refreshTransfers();
  }

  Future addWallet(Wallet wallet) async {
    await api_accessor.createWallet(
      authentication: authentication,
      wallet: wallet,
    );

    await refreshWallets();
  }

  Future updateWallet(Wallet wallet) async {
    await api_accessor.updateWallet(
      authentication: authentication,
      wallet: wallet,
    );

    await refreshWallets();
  }

  Future addWithdrawal(Withdrawal withdrawal) async {
    await api_accessor.createWithdrawal(
      authentication: authentication,
      withdrawal: withdrawal,
    );

    await refreshWallets();
  }

  Future updateWithdrawal(Withdrawal withdrawal) async {
    await api_accessor.updateWithdrawal(
      authentication: authentication,
      withdrawal: withdrawal,
    );

    await refreshWithdrawals();
  }

  Currency currency(int id) {
    return currencies.firstWhere(
      (currency) => currency.id == id,
      orElse: () => null,
    );
  }

  Deposit deposit(int id) {
    return deposits.firstWhere(
      (deposit) => deposit.id == id,
      orElse: () => null,
    );
  }

  Transfer transfer(int id) {
    return transfers.firstWhere(
      (transfer) => transfer.id == id,
      orElse: () => null,
    );
  }

  Wallet wallet(int id) {
    return wallets.firstWhere(
      (wallet) => wallet.id == id,
      orElse: () => null,
    );
  }

  Withdrawal withdrawal(int id) {
    return withdrawals.firstWhere(
      (withdrawal) => withdrawal.id == id,
      orElse: () => null,
    );
  }

  WalletData walletData(int walletId) {
    List<ITransaction> transactions = <ITransaction>[];

    transactions.addAll(
      deposits.where(
        (deposits) => deposits.toWalletId == walletId,
      ),
    );

    transactions.addAll(
      withdrawals.where(
        (withdrawal) => withdrawal.fromWalletId == walletId,
      ),
    );

    transactions.addAll(
      transfers.where(
        (transfer) => (transfer.toWalletId == walletId ||
            transfer.fromWalletId == walletId),
      ),
    );

    return new WalletData(
      wallet: wallet(walletId),
      transactions: transactions,
    );
  }
}
