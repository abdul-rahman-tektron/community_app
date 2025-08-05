import 'package:community_app/modules/customer/bottom_bar/bottom_bar_notifier.dart';
import 'package:community_app/modules/vendor/bottom_bar/bottom_bar_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/widgets/custom_app_bar.dart';
import 'package:community_app/utils/widgets/custom_bottom_bar.dart';
import 'package:community_app/utils/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class VendorBottomScreen extends StatelessWidget {
  final int? currentIndex;
  final int? subCurrentIndex;
  const VendorBottomScreen({super.key, this.currentIndex = 0, this.subCurrentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VendorBottomBarNotifier(currentIndex, subCurrentIndex),
      child: Consumer<VendorBottomBarNotifier>(
        builder: (context, vendorBottomBarNotifier, child) {
          return buildBody(context, vendorBottomBarNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, VendorBottomBarNotifier vendorBottomBarNotifier) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        vendorBottomBarNotifier.changeTab(0);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(showDrawer: true),
          drawer: CustomDrawer(),
          body: vendorBottomBarNotifier.currentScreen,
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: vendorBottomBarNotifier.currentIndex,
            userRole: vendorBottomBarNotifier.userRole.toUserRole(),
            onTap: vendorBottomBarNotifier.changeTab,
          ),
        ),
      ),
    );
  }
}
