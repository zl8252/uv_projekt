import 'dart:async';
import 'package:meta/meta.dart';
import 'package:http/browser_client.dart';

import 'api_accessor/all.dart' as api_accessor;
import 'data/all.dart';
import 'authentication.dart';

@immutable
class CoinData {
  final Authentication authentication;

  final BrowserClient browserClient;

  final List<Currency> currencies = <Currency>[];

  final List<Deposit> deposits = <Deposit>[];

  final List<Transfer> transfers = <Transfer>[];

  final List<Wallet> wallets = <Wallet>[];

  final List<Withdrawal> withdrawals = <Withdrawal>[];

  CoinData.fromAuthentication({
    @required this.browserClient,
    @required this.authentication,
  });

  factory CoinData({
    @required BrowserClient browserClient,
    @required String apiKey,
  }) {
    return new CoinData.fromAuthentication(
      browserClient: browserClient,
      authentication: new Authentication(
        apiKey: apiKey,
      ),
    );
  }

  Wallet getWallet(int walletId) {
    return wallets.firstWhere((wallet) => wallet.id == walletId,
        orElse: () => null);
  }

  Currency getCurrency(int currencyId) {
    return currencies.firstWhere((currency) => currency.id == currencyId,
        orElse: () => null);
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
        browserClient: browserClient,
        authentication: authentication,
      ),
    );

    currencies.sort();
  }

  Future refreshDeposits() async {
    deposits.clear();

    deposits.addAll(
      await api_accessor.listDeposits(
        browserClient: browserClient,
        authentication: authentication,
      ),
    );

    deposits.sort();
  }

  Future refreshTransfers() async {
    transfers.clear();

    transfers.addAll(
      await api_accessor.listTransfers(
        browserClient: browserClient,
        authentication: authentication,
      ),
    );

    transfers.sort();
  }

  Future refreshWallets() async {
    wallets.clear();

    wallets.addAll(
      await api_accessor.listWallets(
        browserClient: browserClient,
        authentication: authentication,
      ),
    );

    wallets.sort();
  }

  Future refreshWithdrawals() async {
    withdrawals.clear();

    withdrawals.addAll(
      await api_accessor.listWithdrawals(
        browserClient: browserClient,
        authentication: authentication,
      ),
    );

    withdrawals.sort();
  }

  Future addCurrency(Currency currency) async {
    await api_accessor.createCurrency(
      browserClient: browserClient,
      authentication: authentication,
      currency: currency,
    );

    await refreshCurrencies();
  }

  Future updateCurrency(Currency currency) async {
    await api_accessor.updateCurrency(
      browserClient: browserClient,
      authentication: authentication,
      currency: currency,
    );

    await refreshCurrencies();
  }

  Future addDeposit(Deposit deposit) async {
    await api_accessor.createDeposit(
      browserClient: browserClient,
      authentication: authentication,
      deposit: deposit,
    );

    await refreshDeposits();
  }

  Future updateDeposit(Deposit deposit) async {
    await api_accessor.updateDeposit(
      browserClient: browserClient,
      authentication: authentication,
      deposit: deposit,
    );

    await refreshDeposits();
  }

  Future deleteDeposit(Deposit deposit) async {
    await api_accessor.deleteDeposit(
      browserClient: browserClient,
      authentication: authentication,
      deposit: deposit,
    );
  }

  Future addTransfer(Transfer transfer) async {
    await api_accessor.createTransfer(
      browserClient: browserClient,
      authentication: authentication,
      transfer: transfer,
    );

    await refreshTransfers();
  }

  Future updateTransfer(Transfer transfer) async {
    await api_accessor.updateTransfer(
      browserClient: browserClient,
      authentication: authentication,
      transfer: transfer,
    );

    await refreshTransfers();
  }

  Future deleteTransfer(Transfer transfer) async {
    await api_accessor.deleteTransfer(
      browserClient: browserClient,
      authentication: authentication,
      transfer: transfer,
    );
  }

  Future addWallet(Wallet wallet) async {
    await api_accessor.createWallet(
      browserClient: browserClient,
      authentication: authentication,
      wallet: wallet,
    );

    await refreshWallets();
  }

  Future updateWallet(Wallet wallet) async {
    await api_accessor.updateWallet(
      browserClient: browserClient,
      authentication: authentication,
      wallet: wallet,
    );

    await refreshWallets();
  }

  Future addWithdrawal(Withdrawal withdrawal) async {
    await api_accessor.createWithdrawal(
      browserClient: browserClient,
      authentication: authentication,
      withdrawal: withdrawal,
    );

    await refreshWallets();
  }

  Future updateWithdrawal(Withdrawal withdrawal) async {
    await api_accessor.updateWithdrawal(
      browserClient: browserClient,
      authentication: authentication,
      withdrawal: withdrawal,
    );

    await refreshWithdrawals();
  }

  Future deleteWithdrawal(Withdrawal withdrawal) async {
    await api_accessor.deleteWithdrawal(
      browserClient: browserClient,
      authentication: authentication,
      withdrawal: withdrawal,
    );
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

  List<WalletData> get allWalletData {
    return wallets.map((wallet) => walletData(wallet.id)).toList();
  }

  WalletData walletData(int walletId) {
    Wallet wallet = getWallet(walletId);
    Currency currency = getCurrency(wallet.currencyId);
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
      wallet: wallet,
      currency: currency,
      transactions: transactions,
    );
  }

  int generateNewDepositId() {
    int maxId = -10;
    for (Deposit deposit in deposits) {
      if (deposit.id > maxId) {
        maxId = deposit.id;
      }
    }
    return maxId + 1;
  }

  int generateNewWithdrawalId() {
    int maxId = -10;
    for (Withdrawal withdrawal in withdrawals) {
      if (withdrawal.id > maxId) {
        maxId = withdrawal.id;
      }
    }
    return maxId + 1;
  }

  int generateNewTransferId() {
    int maxId = -10;
    for (Transfer transfer in transfers) {
      if (transfer.id > maxId) {
        maxId = transfer.id;
      }
    }
    return maxId + 1;
  }

  int generateNewCurrencyId(){
    int maxId = -10;
    for (Currency currency in currencies){
      if (currency.id > maxId){
        maxId = currency.id;
      }
    }

    return maxId +1;
  }

  int generateNewWalletId(){
    int maxId = -10;
    for (Wallet wallet in wallets){
      if (wallet.id > maxId){
        maxId = wallet.id;
      }
    }

    return maxId +1;
  }
}
