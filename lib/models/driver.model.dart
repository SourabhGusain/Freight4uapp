import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/session.dart';

class DriverModel {
  final int id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String licenseNumber;
  final String vehicleNumber;
  final String password;
  final bool isActive;
  final String createdOn;
  final int user;
  final dynamic createdBy;
  final String token;

  DriverModel({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.licenseNumber,
    required this.vehicleNumber,
    required this.password,
    required this.isActive,
    required this.createdOn,
    required this.user,
    this.createdBy,
    required this.token,
  });

  DriverModel.empty()
      : id = 0,
        name = '',
        username = '',
        phone = '',
        email = '',
        licenseNumber = '',
        vehicleNumber = '',
        password = '',
        isActive = false,
        createdOn = '',
        user = 0,
        createdBy = null,
        token = '';

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      licenseNumber: json['license_number'] ?? '',
      vehicleNumber: json['vehicle_number'] ?? '',
      password: json['password'] ?? '',
      isActive: json['is_active'] ?? false,
      createdOn: json['created_on'] ?? '',
      user: json['user'] ?? 0,
      createdBy: json['created_by'],
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "username": username,
      "phone": phone,
      "email": email,
      "license_number": licenseNumber,
      "vehicle_number": vehicleNumber,
      "password": password,
      "is_active": isActive,
      "created_on": createdOn,
      "user": user,
      "created_by": createdBy,
      "token": token,
    };
  }

  @override
  String toString() {
    return 'DriverModel{id: $id, name: $name, username: $username, phone: $phone, email: $email, '
        'licenseNumber: $licenseNumber, vehicleNumber: $vehicleNumber, isActive: $isActive, '
        'createdOn: $createdOn, user: $user, createdBy: $createdBy, token: $token}';
  }

  static Future<DriverModel?> loginApi(String mobile, String password) async {
    final url = '$api_url/drivers/login/';
    print(url);

    Map<String, dynamic> loginData = {
      'mobile': mobile,
      'password': password,
    };

    print('Sending login request: $loginData');

    try {
      final Map response = await Api().postCalling(
        url,
        jsonEncode(loginData),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response['ok'] == 1 && response['data'] != null) {
        var data = response['data'];
        if (data is List && data.isNotEmpty) {
          data = data[0];
        }

        DriverModel driver = DriverModel.fromJson(data);
        print('Login successful, Driver data: ${driver.toString()}');

        Session session = Session();
        String driverJsonString = jsonEncode(driver.toJson());
        await session.setSession('loggedInUserKey', driverJsonString);

        return driver;
      } else {
        print(response);
        print('Login failed: ${response['error'] ?? "Unknown error"}');
        return null;
      }
    } catch (e) {
      print('Exception during login: $e');
      return null;
    }
  }
}
