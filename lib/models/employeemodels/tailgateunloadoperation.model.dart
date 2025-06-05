import 'dart:io';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class TailgateUnloadOperationModel {
  final String question1;
  final String question2;
  final String question3;
  final String question4;
  final String question5;
  final String question6;
  final String question7;
  final String question8;
  final String question9;
  final String question10;

  final String name;
  final DateTime date;
  final File? signature;
  final bool isActive;
  final DateTime createdOn;
  final int? createdBy;

  TailgateUnloadOperationModel({
    required this.question1,
    required this.question2,
    required this.question3,
    required this.question4,
    required this.question5,
    required this.question6,
    required this.question7,
    required this.question8,
    required this.question9,
    required this.question10,
    required this.name,
    required this.date,
    this.signature,
    this.isActive = true,
    required this.createdOn,
    this.createdBy,
  });

  Map<String, dynamic> toMultipartFields() {
    final fields = <String, dynamic>{
      "question_1": question1,
      "question_2": question2,
      "question_3": question3,
      "question_4": question4,
      "question_5": question5,
      "question_6": question6,
      "question_7": question7,
      "question_8": question8,
      "question_9": question9,
      "question_10": question10,
      "name": name,
      "date": date.toIso8601String().split('T').first,
      "is_active": isActive.toString(),
      "created_on": createdOn.toIso8601String().split('T').first,
    };

    if (signature != null) fields["signature"] = signature;
    if (createdBy != null) fields["created_by"] = createdBy.toString();

    return fields;
  }

  factory TailgateUnloadOperationModel.fromJson(Map<String, dynamic> json) {
    return TailgateUnloadOperationModel(
      question1: json['question_1'] ?? '',
      question2: json['question_2'] ?? '',
      question3: json['question_3'] ?? '',
      question4: json['question_4'] ?? '',
      question5: json['question_5'] ?? '',
      question6: json['question_6'] ?? '',
      question7: json['question_7'] ?? '',
      question8: json['question_8'] ?? '',
      question9: json['question_9'] ?? '',
      question10: json['question_10'] ?? '',
      name: json['name'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      signature: null, // Signature is upload-only
      isActive: json['is_active'] ?? false,
      createdOn: DateTime.tryParse(json['created_on'] ?? '') ?? DateTime.now(),
      createdBy: json['created_by'],
    );
  }

  static Future<bool> submitTailgateUnloadOperationForm(
      TailgateUnloadOperationModel model) async {
    final url = "$api_url/employee/tailgate-unload/";
    print('Submitting to $url');
    final api = Api();

    final fields = model.toMultipartFields();

    final result = await api.multipartOrJsonPostCall(
      url,
      fields,
      isMultipart: model.signature != null,
    );

    if (result["ok"] == 1) {
      print("Tailgate Unload Operation form submitted successfully.");
      return true;
    } else {
      print(
          "Failed to submit Tailgate Unload Operation form: ${result["error"]}");
      return false;
    }
  }

  @override
  String toString() {
    return 'TailgateUnloadOperationModel {name: $name, date: $date, isActive: $isActive, createdOn: $createdOn, createdBy: $createdBy}';
  }
}
