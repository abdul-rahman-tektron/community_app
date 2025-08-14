import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_auth_repository.dart';
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
      userData?.customerId.toString() ?? "0",
    );

    print("result of Delete");
    print(result);
  }
}