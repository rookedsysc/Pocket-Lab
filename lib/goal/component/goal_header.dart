import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';

class GoalHeader extends ConsumerStatefulWidget {
  const GoalHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalHeaderState();
}

class _GoalHeaderState extends ConsumerState<GoalHeader> {
  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);

    //: 목표가 없을 때
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeaderCollection(headerType: HeaderType.goal),
        const SizedBox(
          height: 8.0,),
        //# 목표가 있을 때 / 목표가 없을 때 => _goalContainer
        goals.isEmpty
            ? GestureDetector(
                onTap: () => _showCupertinoModalBottomSheet(context),
                //# header Design
                child: _goalContainer(
                  _isEmptyContainer(context),
                ),
              )
            : ListView.builder(
                itemBuilder: ((context, index) => GestureDetector(
                      onTap: () => showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return GoalScreen();
                          }),
                      child: _isNotEmptyContainer(goals, index),
                    )),
                itemCount: goals.length,
                shrinkWrap: true),
      ],
    );
  }

  //# 있을 때나 없을 때나 같은 디자인
  Widget _goalContainer(Widget child) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor
      ),
      child: child,
    );
  }

  Center _isEmptyContainer(BuildContext context) {
    return Center(
      child: Text(
        "목표를 설정해주세요.",
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _isNotEmptyContainer(List<Goal> goals, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        //: 테두리
        border: Border.all(color: Colors.green, width: 4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(goals[index].name),
          // 5000원 > 5,000원
          Text("${goals[index].amount.toStringAsFixed(0)}원"),
        ],
      ),
    );
  }

  

  Future<dynamic> _showCupertinoModalBottomSheet(BuildContext context) {
    return showCupertinoModalBottomSheet(
        context: context,
        builder: (_) {
          return GoalScreen();
        });
  }
}
