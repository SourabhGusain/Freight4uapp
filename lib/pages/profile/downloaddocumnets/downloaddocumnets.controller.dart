import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Freight4u/models/documents.model.dart';

class DownloadDocumentsController {
  List<UploadDocument>? uploadDocuments;

  // Tracks downloading state per document URL
  final Map<String, bool> isDownloadingMap = {};

  Future<void> loadUploadDocuments() async {
    try {
      uploadDocuments = await fetchUploadDocuments();

      if (uploadDocuments == null || uploadDocuments!.isEmpty) {
        print("No documents found or failed to load.");
      } else {
        print("Fetched ${uploadDocuments!.length} documents:");
        for (var doc in uploadDocuments!) {
          print(" - ${doc.name}: ${doc.documentUrl}");
        }
      }
    } catch (e) {
      print("Error loading documents: $e");
      uploadDocuments = [];
    }
  }

  Future<void> downloadDocument(BuildContext context, String docUrl) async {
    if (isDownloadingMap[docUrl] == true) {
      _showSnackbar(context, "Already downloading this document.");
      return;
    }

    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        print("Storage permission status: $status");
        if (!status.isGranted) {
          _showSnackbar(context, "Storage permission is required to download.");
          return;
        }
      }

      final selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        _showSnackbar(context, "No folder selected.");
        return;
      }

      isDownloadingMap[docUrl] = true;

      final fileName = _getFileNameFromUrl(docUrl);
      final filePath = '$selectedDirectory/$fileName';

      final dio = Dio();
      await dio.download(docUrl, filePath);

      _showSnackbar(context, "Downloaded to $filePath");
    } catch (e) {
      _showSnackbar(context, "Download failed: $e");
    } finally {
      isDownloadingMap[docUrl] = false;
    }
  }

  Future<void> viewDocument(BuildContext context, String docUrl) async {
    final uri = Uri.parse(docUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackbar(context, "Could not open document.");
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _getFileNameFromUrl(String url) {
    final parts = url.split('/');
    final name = parts.isNotEmpty ? parts.last : '';
    return name.isNotEmpty ? name : 'downloaded_document.pdf';
  }
}
