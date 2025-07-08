import 'package:community_app/modules/customer/bottom_bar/bottom_bar_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_bottom_bar.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class CustomerBottomScreen extends StatelessWidget {
  final int? currentIndex;
  const CustomerBottomScreen({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomBarNotifier(currentIndex),
      child: Consumer<BottomBarNotifier>(
        builder: (context, bottomBarNotifier, child) {
          return buildBody(context, bottomBarNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, BottomBarNotifier bottomBarNotifier) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        bottomBarNotifier.changeTab(0);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(),
          drawer: CustomDrawer(),
          body: bottomBarNotifier.currentScreen,
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: bottomBarNotifier.currentIndex,
            onTap: bottomBarNotifier.changeTab,
          ),
        ),
      ),
    );
  }
}
