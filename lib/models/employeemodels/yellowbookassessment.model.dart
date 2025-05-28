import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class YellowBookAssessment {
  final String question1;
  final String name;
  final String date;
  final int createdBy;
  final bool isActive;

  YellowBookAssessment({
    required this.question1,
    required this.name,
    required this.date,
    required this.createdBy,
    this.isActive = true,
  });

  factory YellowBookAssessment.fromJson(Map<String, dynamic> json) {
    return YellowBookAssessment(
      question1: json['question_1'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      createdBy: json['created_by'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_1': question1,
      'name': name,
      'date': date,
      'created_by': createdBy,
      'is_active': isActive,
    };
  }

  static Future<bool> submit(YellowBookAssessment assessment) async {
    final url = '$api_url/yellowbookassessment/';
    print('API URL: $url');

    try {
      final response = await Api().postCalling(
        url,
        jsonEncode(assessment.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print('Response: $response');

      return response != null && response['ok'] == 1;
    } catch (e) {
      print('Submission error: $e');
      return false;
    }
  }
}
