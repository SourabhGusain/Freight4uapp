import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class SettingsModel {
  final int ok;
  final List<Contract> contracts;
  final List<Shape> shapes;
  final List<Site> sites;
  final List<Depot> depots;

  SettingsModel({
    required this.ok,
    required this.contracts,
    required this.shapes,
    required this.sites,
    required this.depots,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      ok: json['ok'] ?? 0,
      contracts:
          (json['contracts'] as List).map((e) => Contract.fromJson(e)).toList(),
      shapes: (json['shapes'] as List).map((e) => Shape.fromJson(e)).toList(),
      sites: (json['sites'] as List).map((e) => Site.fromJson(e)).toList(),
      depots: (json['depots'] as List).map((e) => Depot.fromJson(e)).toList(),
    );
  }
}

class Contract {
  final int id;
  final String name;
  final bool isActive;
  final String createdOn;
  final dynamic createdBy;

  Contract({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      createdOn: json['created_on'],
      createdBy: json['created_by'],
    );
  }
}

class Shape {
  final int id;
  final String name;
  final bool isActive;
  final String createdOn;
  final dynamic createdBy;

  Shape({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  factory Shape.fromJson(Map<String, dynamic> json) {
    return Shape(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      createdOn: json['created_on'],
      createdBy: json['created_by'],
    );
  }
}

class Site {
  final int id;
  final String name;
  final bool isActive;
  final String createdOn;
  final bool enablePointCity;
  final bool enableWaitingTime;
  final dynamic createdBy;

  Site({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdOn,
    required this.enablePointCity,
    required this.enableWaitingTime,
    this.createdBy,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      createdOn: json['created_on'],
      enablePointCity: json['enable_point_city'] ?? false,
      enableWaitingTime: json['enable_waiting_time'] ?? false,
      createdBy: json['created_by'],
    );
  }
}

class Depot {
  final int id;
  final String name;
  final bool isActive;
  final String createdOn;
  final dynamic createdBy;

  Depot({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  factory Depot.fromJson(Map<String, dynamic> json) {
    return Depot(
      id: json['id'],
      name: json['name'],
      isActive: json['is_active'],
      createdOn: json['created_on'],
      createdBy: json['created_by'],
    );
  }
}

Future<SettingsModel?> fetchSettingsData() async {
  Api api = Api();

  SettingsModel fromJson(data) => SettingsModel.fromJson(data);

  final result = await api.getCalling(
    "$api_url/settings/all/",
    fromJson,
  );

  if (result['ok'] == 1) {
    return result['data'];
  } else {
    print("Failed to load settings: ${result['error']}");
    return null;
  }
}
