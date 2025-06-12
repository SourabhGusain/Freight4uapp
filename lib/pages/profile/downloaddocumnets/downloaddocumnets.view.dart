import 'package:flutter/material.dart';
import 'downloaddocumnets.controller.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/helpers/session.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadDocumentsPage extends StatefulWidget {
  final Session session;
  const DownloadDocumentsPage({super.key, required this.session});

  @override
  State<DownloadDocumentsPage> createState() => _DownloadDocumentsPageState();
}

class _DownloadDocumentsPageState extends State<DownloadDocumentsPage> {
  late final DownloadDocumentsController controller;

  @override
  void initState() {
    super.initState();
    controller = DownloadDocumentsController();
    _initDocuments();
  }

  Future<void> _initDocuments() async {
    await controller.loadUploadDocuments();
    setState(() {});
  }

  Future<void> _refreshDocuments() async {
    await _initDocuments();
  }

  Widget buildDocumentTile(String name, String url) {
    final isDownloading = controller.isDownloadingMap[url] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: blackColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse(url);
                try {
                  final launched = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!launched) {
                    _showSnack("Failed to open document.");
                  }
                } catch (e) {
                  _showSnack("Error opening document: $e");
                }
              },
              child: textH3(
                "Download and review the $name PDF.",
                color: primaryColor,
                font_weight: FontWeight.w500,
              ),
            ),
          ),
          DownloadButton(
            fileUrl: url,
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 253, 255),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: secondaryNavBar(
            context,
            "Download Documents",
            onBack: () => Navigator.of(context).pop(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshDocuments,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: primaryColor,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 20,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: textH2(
                            "Review & Download Documents Here",
                            font_size: 15,
                            font_weight: FontWeight.w600,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (controller.uploadDocuments == null)
                    const Center(child: CircularProgressIndicator())
                  else if (controller.uploadDocuments!.isEmpty)
                    const Center(child: Text("No documents found."))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.uploadDocuments!.length,
                      itemBuilder: (context, index) {
                        final doc = controller.uploadDocuments![index];
                        final fullUrl =
                            'https://freight4you.com.au${doc.documentUrl}';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textH3("${doc.name} Document:",
                                font_size: 14, font_weight: FontWeight.w500),
                            buildDocumentTile(doc.name, fullUrl),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
