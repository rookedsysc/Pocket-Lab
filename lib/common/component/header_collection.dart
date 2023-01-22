import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

enum HeaderType {
  wallet,
  goal,
  total,
}

class HeaderCollection extends StatelessWidget {
  final HeaderType headerType;
  const HeaderCollection ({required this.headerType, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      _getHeaderName(headerType),
      style: Theme.of(context)
          .textTheme
          .bodyText1
          ?.copyWith(fontSize: 20.0, fontWeight: FontWeight.w900),
    );
  }

  String _getHeaderName(HeaderType headerType) {
    switch (headerType) {
      case HeaderType.wallet:
        return "Wallet List";
      case HeaderType.goal:
        return "Goal";
      case HeaderType.total:
        return "Total Balance";
    }
  }
}
