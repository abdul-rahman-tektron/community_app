import 'package:community_app/core/base/base_notifier.dart';
import 'package:flutter/material.dart';

class EditProfileNotifier extends BaseChangeNotifier {


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();


  //Functions
  EditProfileNotifier(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    runWithLoadingVoid(() async {
      await _fetchProfileAndNationality(context);
      _initializeData(context);
    },);
  }

  Future<void> _fetchProfileAndNationality(BuildContext context) async {
    // try {
    //   final profileResult = await AuthRepository().apiGetProfile({}, context);
    //   final countryList = await AuthRepository().apiCountryList({}, context);
    //
    //   _getProfileData = profileResult as GetProfileResult;
    //   _nationalityMenu = List<CountryData>.from(countryList as List<CountryData>);
    //   notifyListeners();
    // } catch (e) {
    //   // handle error
    // }
  }

  void _initializeData(BuildContext context) {

  }

  Future<void> saveData(BuildContext context) async {
    runWithLoadingVoid(() => saveApiCall(context));
  }

  Future<void> saveApiCall(BuildContext context) async {
    String? iqama;
    String? eidNumber;
    String? passportNumber;
    String? othersDoc;
    String? othersValue;

    //
    //
    // final updateProfileRequest = UpdateProfileRequest(
    //   sFullName: fullNameController.text,
    //   sEmail: emailAddressController.text,
    //   sMobileNumber: mobileNumberController.text,
    //   sUserName: emailAddressController.text,
    //   sCompanyName: visitorCompanyController.text,
    //   iso3: _selectedNationality,
    //   nDocumentType: int.tryParse(_selectedIdValue ?? "") ?? 0,
    //   sIqama: iqama,
    //   eidNumber: eidNumber,
    //   passportNumber: passportNumber,
    //   sOthersDoc: othersDoc,
    //   sOthersValue: othersValue,
    // );
    //
    // await AuthRepository().apiUpdateProfile(updateProfileRequest, context);
  }


  //Getter And Setter


  @override
  void dispose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    emailAddressController.dispose();
    super.dispose();
  }
}