import 'dart:io';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Freight4u/models/documents.model.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class DownloadButton extends StatefulWidget {
  final String fileUrl;
  Color color;
  String text;
  IconData icon;
  DownloadButton(
      {required this.fileUrl,
      this.color = primaryColor,
      this.icon = Icons.download,
      this.text = "Download"});

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool _downloading = false;

  Future<String?> getDownloadPath() async {
    Directory? directory;
    String? path;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        path = directory.path;
      } else {
        // directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        // if (!await directory.exists()) {

        // } else {
        //   path = directory.path;
        // }

        // String? selectedDirectory =
        //     await FilePicker.platform.getDirectoryPath();

        // // directory = await getExternalStorageDirectory();
        // if (selectedDirectory != null) {
        //   path = selectedDirectory;
        // } else {

        // }

        directory = await getExternalStorageDirectory();
        // directory = await getApplicationDocumentsDirectory();
        path = directory!.path;
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return path;
  }

  Future<void> _downloadFile(String url) async {
    try {
      setState(() {
        _downloading = true;
      });

      final response = await http.get(Uri.parse(url));

      print(response.statusCode);

      String fileName = p.basename(url);
      print(fileName);

      final directory = await getDownloadPath();
      print(directory);

      String _path = '${directory}/$fileName';
      print(_path);

      final saveFile = File('${directory}/$fileName');
      if (await saveFile.exists()) {
        await OpenFile.open(_path);
      } else {
        await saveFile.writeAsBytes(response.bodyBytes);

        await OpenFile.open(_path);
      }
      setState(() {
        _downloading = false;
      });
    } catch (err) {
      print(err);
      Get.viewMessage(context, err.toString());
      setState(() {
        _downloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buttonIconText(
        _downloading ? Get.loading() : textH3(widget.text, color: widget.color),
        icon: widget.icon, onPressed: () {
      _downloadFile(widget.fileUrl);
    }, primary: widget.color);
  }
}

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
