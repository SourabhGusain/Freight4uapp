import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class Driver {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String? licenseNumber;
  final String? vehicleNumber;
  final String? password;
  final int? user;
  final bool isActive;
  final String? createdOn;
  final int? createdBy;

  Driver({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.licenseNumber,
    this.vehicleNumber,
    this.password,
    this.user,
    this.isActive = true,
    this.createdOn,
    this.createdBy,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      licenseNumber: json['license_number'],
      vehicleNumber: json['vehicle_number'],
      password: json['password'],
      user: json['user'],
      isActive: json['is_active'] ?? true,
      createdOn: json['created_on'],
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'license_number': licenseNumber,
      'vehicle_number': vehicleNumber,
      'password': password,
      'user': user,
      'is_active': isActive,
      'created_on': createdOn,
      'created_by': createdBy,
    };
  }
}

Future<Driver> registerDriver(Driver driver) async {
  final api = Api();
  String url = '$api_url/drivers/signup/';
  print(url);

  Map response = await api.postCalling(
    url,
    driver.toJson(),
  );

  if (response['ok'] == 1) {
    return Driver.fromJson(response['data']);
  } else {
    throw Exception(response['error'] ?? 'Failed to register driver');
  }
}
