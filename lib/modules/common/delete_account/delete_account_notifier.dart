import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/delete_account/delete_Account_request.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_auth_repository.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/storage/hive_storage.dart';
import 'package:Xception/utils/storage/secure_storage.dart';
import 'package:flutter/material.dart';

class DeleteAccountNotifier extends BaseChangeNotifier {
  final TextEditingController emailAddressController = TextEditingController();

  DeleteAccountNotifier() {
    init();
  }

  void init() async {
    await loadUserData();
  }

  final formKey = GlobalKey<FormState>();


  //Delete Account Api call
  Future apiDeleteAccount(BuildContext context) async {
    final result = await CustomerAuthRepository.instance.apiDeleteCustomer(
      DeleteAccountRequest(customerId: userData?.customerId ?? 0, modifiedBy: userData?.name ?? ""),
    );

    if (result is CommonResponse && result.success == true) {
      ToastHelper.showSuccess('Account deleted successfully.');
      await SecureStorageService.clearData();
      await HiveStorageService.clearOnLogout();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    }
  }
}