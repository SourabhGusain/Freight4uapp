import 'dart:io';
import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class UploadDocument {
  final int? id;
  final String name;
  final String? documentUrl;
  final bool isActive;
  final String createdOn;

  UploadDocument({
    this.id,
    required this.name,
    this.documentUrl,
    required this.isActive,
    required this.createdOn,
  });

  factory UploadDocument.fromJson(Map<String, dynamic> json) {
    return UploadDocument(
      id: json['id'],
      name: json['name'],
      documentUrl: json['document'],
      isActive: json['is_active'],
      createdOn: json['created_on'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'document': documentUrl,
      'is_active': isActive,
      'created_on': createdOn,
    };
  }

  @override
  String toString() {
    return 'UploadDocument{id: $id, name: $name, documentUrl: $documentUrl, isActive: $isActive, createdOn: $createdOn}';
  }
}

class UploadDocumentsResponse {
  final int ok;
  final List<UploadDocument> data;

  UploadDocumentsResponse({
    required this.ok,
    required this.data,
  });

  factory UploadDocumentsResponse.fromJson(Map<String, dynamic> json) {
    return UploadDocumentsResponse(
      ok: json['ok'] ?? 0,
      data: (json['data'] as List)
          .map((e) => UploadDocument.fromJson(e))
          .toList(),
    );
  }
}

Future<List<UploadDocument>?> fetchUploadDocuments() async {
  Api api = Api();
  final url = "$api_url/settings/uploaded-documents/";

  try {
    final result = await api.getCalling(
      url,
      (data) => UploadDocumentsResponse.fromJson({"ok": 1, "data": data}),
    );

    print("Fetch Upload Documents Result: $result");

    if (result["ok"] == 1) {
      final UploadDocumentsResponse response = result["data"];
      return response.data;
    } else {
      print("Failed to load upload documents: ${result['error']}");
      return null;
    }
  } catch (e) {
    print("Exception while loading upload documents: $e");
    return null;
  }
}
