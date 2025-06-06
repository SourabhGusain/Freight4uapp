import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Freight4u/models/documents.model.dart';

class DownloadDocumentsController {
  List<UploadDocument>? uploadDocuments;

  final Map<String, bool> isDownloadingMap = {};

  Future<void> loadUploadDocuments() async {
    uploadDocuments = await fetchUploadDocuments();

    if (uploadDocuments == null || uploadDocuments!.isEmpty) {
      print("No upload documents found or failed to load.");
      return;
    }

    print("Loaded ${uploadDocuments!.length} documents:");
    for (var doc in uploadDocuments!) {
      print(" - ${doc.name} : ${doc.documentUrl}");
    }
  }

  Future<void> downloadDocument(BuildContext context, String docUrl) async {
    if (isDownloadingMap[docUrl] == true) {
      _showSnackbar(context, "Already downloading this document");
      return;
    }

    try {
      isDownloadingMap[docUrl] = true;

      final dir = await getApplicationDocumentsDirectory();

      if (dir == null) {
        _showSnackbar(context, "Could not access storage directory");
        return;
      }

      final fileName = docUrl.split('/').last.isNotEmpty
          ? docUrl.split('/').last
          : 'downloaded_document.pdf';

      final path = '${dir.path}/$fileName';

      final dio = Dio();
      await dio.download(docUrl, path);

      _showSnackbar(context, "Downloaded to $path");
    } catch (e) {
      _showSnackbar(context, "Download failed: $e");
    } finally {
      isDownloadingMap[docUrl] = false;
    }
  }

  Future<void> viewDocument(BuildContext context, String docUrl) async {
    final uri = Uri.parse(docUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackbar(context, "Could not open document");
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
