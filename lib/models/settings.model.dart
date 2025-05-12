import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';

class SettingsModel {
  final int ok;
  final List<Contract> contracts;
  final List<Shape> shapes;
  final List<Site> sites;
  final List<dynamic> depots;

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
      depots: json['depots'] ?? [],
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
  final dynamic createdBy;

  Site({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdOn,
    this.createdBy,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
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
    'https://freight4you.com.au/api/settings/all/',
    fromJson,
  );

  if (result['ok'] == 1) {
    return result['data'];
  } else {
    print("Failed to load settings: ${result['error']}");
    return null;
  }
}

void loadAndPrintSettings() async {
  SettingsModel? settings = await fetchSettingsData();

  if (settings != null) {
    print("== Contracts ==");
    for (var contract in settings.contracts) {
      print(
          "ID: ${contract.id}, Name: ${contract.name}, Active: ${contract.isActive}");
    }

    print("\n== Shapes ==");
    for (var shape in settings.shapes) {
      print("ID: ${shape.id}, Name: ${shape.name}, Active: ${shape.isActive}");
    }

    print("\n== Sites ==");
    for (var site in settings.sites) {
      print("ID: ${site.id}, Name: ${site.name}, Active: ${site.isActive}");
    }

    print("\n== Depots ==");
    for (var depot in settings.depots) {
      print(depot);
    }
  } else {
    print("Settings data is null.");
  }
}
