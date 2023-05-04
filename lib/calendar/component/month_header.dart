import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/chart/component/category_chart.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class MonthHeader extends ConsumerStatefulWidget {
  const MonthHeader({super.key});

  @override
  ConsumerState<MonthHeader> createState() => _MonthHeaderState();
}

class _MonthHeaderState extends ConsumerState<MonthHeader> {
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  @override
  Widget build(BuildContext context) {
    DateTime _focusedDate = ref.watch(calendarProvider).focusedDay;
    return StreamBuilder<List<Transaction>>(
        stream: ref
            .watch(transactionRepositoryProvider.notifier)
            .getSelectMonthTransactions(_focusedDate),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          setData(snapshot.data!);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_totalIncome != 0)
                        Text(
                          "+ ${CustomNumberUtils.formatCurrency(_totalIncome)}",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      if (_totalExpense != 0)
                        Text(
                          "- ${CustomNumberUtils.formatCurrency(_totalExpense)}",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.red),
                        ),
                    ],
                  ),
                ),
                //: 카테고리별 간략한 통계
                Container(
                  width: 100.0,
                  height: 100.0,
                  child: CategoryChart(isHome: false),
                ),
              ],
            ),
          );
        });
  }

  void setData(List<Transaction> transactions) {
    _totalExpense = 0;
    _totalIncome = 0;
    for (Transaction event in transactions) {
      if (event.transactionType == TransactionType.income) {
        _totalIncome += event.amount;
      } else if (event.transactionType == TransactionType.expenditure) {
        _totalExpense += event.amount;
      }
    }
  }
}
