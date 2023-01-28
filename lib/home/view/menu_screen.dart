import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/component/menu_screen/wallet_tile.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/home/view/menu_screen/icon_select_screen.dart';
import 'package:pocket_lab/home/view/menu_screen/wallet_config_screen.dart';
import 'package:sheet/route.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(walletRepositoryProvider).maybeWhen(data: (walletRepository) {
      return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _walletHeader(walletRepository, context),
            _walletListStreamBuilder(walletRepository)
            ],
          ),
        ),
      );
    }, orElse: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  StreamBuilder<List<Wallet>> _walletListStreamBuilder(WalletRepository walletRepository) {
    return StreamBuilder<List<Wallet>>(
                stream: walletRepository.getAllWallets(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final wallets = snapshot.data!;
                  return Expanded(
                      child: ListView.builder(
                          itemBuilder: ((context, index) =>
                              WalletTile(wallet: wallets[index])),
                          itemCount: wallets.length));
                });
  }

  Row _walletHeader(WalletRepository walletRepository, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HeaderCollection(
          headerType: HeaderType.wallet,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).push(CupertinoSheetRoute<void>(
              initialStop: 0.7,
              stops: <double>[0, 0.7, 1],
              //: Screen은 이동할 스크린
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              builder: (BuildContext context) => WalletConfigScreen(),
            ));
          },
          icon: Icon(
            Icons.add,
          ),
        )
      ],
    );
  }
}
