import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/constant/daily_budget.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';

final transactionRepositoryProvider = StateNotifierProvider<TransactionRepositoryNotifier, Transaction>((ref) {
  return TransactionRepositoryNotifier(ref);
});

class TransactionRepositoryNotifier extends StateNotifier<Transaction> {
  final Ref ref;
  TransactionRepositoryNotifier(this.ref): super(Transaction(transactionType: TransactionType.expenditure, category: 0, amount: 0, date: DateTime.now(), title: "", walletId: 0));

  //# Transaction 추가
  Future<void> configTransaction(Transaction transaction) async {
    state = transaction; 
    final Isar isar = await ref.read(isarProvieder.future);

    await isar.writeTxn(() async {
      await isar.transactions.put(transaction);
    });
  }
  
  ///# 이번달 지출만 Stream으로 가져오기 
  Stream<List<Transaction>> getLast30DaysExpenditure(int? walletId) async* {

    final Isar isar = await ref.read(isarProvieder.future);

    //: 특정 wallet을 지정해주면 해당 id의 지출만 가져오기
    if(walletId != null) {
      yield* isar.transactions
        .filter()
        .walletIdEqualTo(walletId)
        .transactionTypeEqualTo(TransactionType.expenditure)
        .dateGreaterThan(DateTime.now().subtract(Duration(days: 31)))
        .watch(fireImmediately: true)
        .asBroadcastStream();
    }

    yield* isar.transactions
        .filter()
        .transactionTypeEqualTo(TransactionType.expenditure)
        .dateGreaterThan(DateTime.now().subtract(Duration(days: 31)))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  Stream<List<Transaction>> getThisMonthExpenditure(DateTime date) async* {
    final Isar isar = await ref.read(isarProvieder.future);

    yield* isar.transactions
        .filter()
        .transactionTypeEqualTo(TransactionType.expenditure)
        .dateGreaterThan(DateTime(date.year, date.month, 1))
        .dateLessThan(DateTime(date.year, date.month + 1, 1))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  ///# 해당 Wallet의 마지막 Daily Budget 가져오기
  Future<Transaction?> getLastDailyBudgetByWalletId(Wallet wallet) async {
    final Isar isar = await ref.read(isarProvieder.future);
    //: 해당 Wallet의 마지막 Daily Budget 가져오기
    final Transaction? lastDailyTransactions = await isar.transactions
        .filter()
        .walletIdEqualTo(wallet.id)
        .titleEqualTo(dailyBudget).sortByDateDesc().findFirst();

    return lastDailyTransactions;
  }
}
