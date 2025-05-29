import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:intl/intl.dart';

class YellowBookAssessment {
  final String question1;
  final String name;
  final String date; // YYYY-MM-DD string
  final String createdOn; // YYYY-MM-DD string
  final int createdBy;
  final bool isActive;

  YellowBookAssessment({
    required this.question1,
    required this.name,
    required this.date,
    required this.createdOn,
    required this.createdBy,
    this.isActive = true,
  });

  /// Factory to build from DateTime objects with correct formatting
  factory YellowBookAssessment.fromDateTime({
    required String question1,
    required String name,
    required DateTime date,
    required DateTime createdOn,
    required int createdBy,
    bool isActive = true,
  }) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return YellowBookAssessment(
      question1: question1,
      name: name,
      date: dateFormat.format(date),
      createdOn: dateFormat.format(createdOn),
      createdBy: createdBy,
      isActive: isActive,
    );
  }

  factory YellowBookAssessment.fromJson(Map<String, dynamic> json) {
    return YellowBookAssessment(
      question1: json['question_1'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      createdOn: json['created_on'] ?? '',
      createdBy: json['created_by'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_1': question1,
      'name': name,
      'date': date,
      'created_on': createdOn,
      'created_by': createdBy,
      'is_active': isActive,
    };
  }

  static Future<bool> submit(YellowBookAssessment assessment) async {
    final url = '$api_url/employee/yellow-book-assessment/';
    final payload = assessment.toJson();

    print('📡 API URL: $url');
    print('📝 Payload: $payload');

    try {
      final response = await Api().postCalling(
        url,
        jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('✅ Response: $response');

      return response != null && response['ok'] == 1;
    } catch (e) {
      print('❌ Submission error: $e');
      return false;
    }
  }
}
