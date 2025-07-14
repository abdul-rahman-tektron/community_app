import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/remote/services/auth_repository.dart';
import 'package:flutter/material.dart';

class DeleteAccountNotifier extends BaseChangeNotifier {
  final TextEditingController emailAddressController = TextEditingController();

  final formKey = GlobalKey<FormState>();


  //Delete Account Api call
  Future apiDeleteAccount(BuildContext context) async {
    // await AuthRepository().apiDeleteAccount(ForgetPasswordRequest(sEmail: emailAddressController.text), context);
  }

}