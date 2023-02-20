import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/calendar/view/calendar_screen.dart';
import 'package:pocket_lab/common/util/get_daily_budget.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:pocket_lab/home/view/home_screen.dart';
import 'package:pocket_lab/diary/view/diary_screen.dart';
import 'package:pocket_lab/chart/view/chart_screen.dart';
import 'package:sheet/route.dart';
class RootTab extends ConsumerStatefulWidget {
  static const routeName = 'root_tab';
  const RootTab({super.key});

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int index = 1;

  @override
  void initState() {
    super.initState();

    //TODO: length: 2 -> 2개의 탭.
    _tabController = TabController(initialIndex: 1,length: 4, vsync: this);
    _tabController.addListener(tabListner);
  }

  @override
  void didChangeDependencies() {
    debugPrint("root_tab : GetDailyBudget 호출");
    GetDailyBudget(ref).main();
    super.didChangeDependencies();
  }

  void tabListner() {
    setState(() {
      //: 컨트롤러의 인덱스를 현재 인덱스에 넣어주겠다.
      index = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: _tabBarView(),
    );
  }

  Widget _bottomNavigationBar() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(index == 0
                ? Icons.stacked_bar_chart_sharp
                : Icons.stacked_bar_chart_outlined),
            label: 'Chart',
          ),
          //TODO: jtab 추가시 수정
          BottomNavigationBarItem(
            icon: Icon(index == 1 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(index == 2
                ? Icons.calendar_month
                : Icons.calendar_month_outlined),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(index == 3
                ? Icons.account_balance_wallet
                : Icons.account_balance_wallet_outlined),
            label: 'Diary',
          ),
        ],

        //: 탭을 눌렀을 때
        onTap: (int index) {
          //: TabBarView의 해당하는 인덱스로 움직여라
          _tabController.animateTo(index);
        },
        currentIndex: index,

        //: 탭 색상
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorLight,

        selectedLabelStyle: TextStyle(fontFamily: "Dongle"),
        unselectedLabelStyle: TextStyle(fontFamily: "Dongle"),
      );

  Widget _tabBarView() {
    return TabBarView(
      children: [
        //TODO: tab 추가시 수정
        ChartScreen(), CupertinoScaffold(body: DrawerScreen()),
        CalendarScreen(), DiaryScreen()
      ],
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
    );
  }
}
