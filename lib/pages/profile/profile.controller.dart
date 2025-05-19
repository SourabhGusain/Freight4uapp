import 'dart:convert';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:Freight4u/models/driver.model.dart';

class FormatController extends BaseViewModel {
  final Session session;

  FormatController(this.session);

  DriverModel _driver = DriverModel.empty();

  // Getters to expose driver info safely
  String get name => _driver.name.isNotEmpty ? _driver.name : "Unknown User";
  String get email => _driver.email.isNotEmpty ? _driver.email : "No Email";
  String get phone => _driver.phone.isNotEmpty ? _driver.phone : "No Phone";
  String get licenseNumber =>
      _driver.licenseNumber.isNotEmpty ? _driver.licenseNumber : "N/A";
  String get vehicleNumber =>
      _driver.vehicleNumber.isNotEmpty ? _driver.vehicleNumber : "N/A";
  String get userId => _driver.id != 0 ? _driver.id.toString() : "N/A";

  Future<void> init() async {
    setBusy(true);

    try {
      final userJson = await session.getSession('loggedInUser');
      if (userJson != null && userJson.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        _driver = DriverModel.fromJson(userMap);
      } else {
        _driver = DriverModel.empty();
      }
    } catch (e) {
      print('Failed to load user from session: $e');
      _driver = DriverModel.empty();
    }

    setBusy(false);
    notifyListeners();
  }
}
