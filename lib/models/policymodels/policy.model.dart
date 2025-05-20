import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class PolicyModel {
  final int id;
  final String name;
  final String subtext;
  final String content;
  final DateTime date;
  final bool isActive;
  final DateTime? createdOn;
  final int? createdBy;

  PolicyModel({
    required this.id,
    required this.name,
    required this.subtext,
    required this.content,
    required this.date,
    required this.isActive,
    this.createdOn,
    this.createdBy,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      subtext: json['subtext'] ?? '',
      content: json['content'] ?? '',
      date: DateTime.parse(json['date']),
      isActive: json['is_active'] ?? true,
      createdOn: json['created_on'] != null
          ? DateTime.parse(json['created_on'])
          : null,
      createdBy: json['created_by'],
    );
  }

  static List<PolicyModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => PolicyModel.fromJson(item)).toList();
  }
}

class PolicyService {
  final Api api = Api();

  Future<List<PolicyModel>> fetchPolicies() async {
    final response = await api.getCalling(
      "$api_url/policies/",
      (data) => PolicyModel.fromJsonList(data),
    );

    print(response);
    if (response['ok'] == 1) {
      return response['data'];
    } else {
      throw Exception(response['error'] ?? "Failed to load policies");
    }
  }
}
