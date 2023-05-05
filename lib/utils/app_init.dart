import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/util/daily_budget.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

class AppInit {
  WidgetRef ref;
  AppInit(this.ref);

  Future<void> main() async {
    await walletInit();
    await syncIsarWithLocalGoalList();
    await categoryInit();
    await DailyBudget().add(ref);
  }

  Future<void> walletInit() async {
    final walletCount =
        await ref.read(walletRepositoryProvider.notifier).getWalletCount();

    if (walletCount == 0) {
      await ref.read(walletRepositoryProvider.notifier).configWallet(
          Wallet(name: "Default", isSelected: true, budget: BudgetModel()));
      Wallet _wallet = await ref
          .read(walletRepositoryProvider.notifier)
          .getIsSelectedWallet();
      debugPrint("wallet id: ${_wallet.id}");
    }
  }

  Future<void> categoryInit() async {
    final categoryRepository = ref.read(categoryRepositoryProvider.notifier);
    List<TransactionCategory> categories =
        await categoryRepository.getAllCategories();
    if (categories.isEmpty) {
      await categoryRepository.configCategory(
          TransactionCategory(name: "For Chart", color: "FFFFFF")); //: 갈색
      await categoryRepository.configCategory(
          TransactionCategory(name: "No Element", color: "000000")); //: 갈색
      await categoryRepository.configCategory(
          TransactionCategory(name: "Living Expense", color: "964B00")); //: 갈색
      await categoryRepository.configCategory(
          TransactionCategory(name: "Food Expense", color: "0067A3")); //: 파랑
      await categoryRepository.configCategory(
          TransactionCategory(name: "Hobby", color: "ff0000")); //: 빨간색
      await categoryRepository.configCategory(
          TransactionCategory(name: "Etc", color: "808080")); //: 빨간색
    }
    ref.read(categoryRepositoryProvider.notifier).syncCategoryCache();
  }

  //: 처음에 시작할 때 db에 있는 목표 목록 불러오기
  Future<void> syncIsarWithLocalGoalList() async {
    final _goalRepositoryProvider =
        await ref.read(goalRepositoryProvider.future);
    List<Goal> goals = await _goalRepositoryProvider.getAllGoalsFuture();
    ref.refresh(goalLocalListProvider.notifier).addGoals(goals);
  }
}
