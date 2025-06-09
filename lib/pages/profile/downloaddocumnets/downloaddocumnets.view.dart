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
          IconButton(
            icon: isDownloading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download, color: primaryColor),
            tooltip: isDownloading ? "Downloading..." : "Download PDF",
            onPressed: isDownloading
                ? null
                : () async {
                    await controller.downloadDocument(context, url);
                    setState(() {});
                  },
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
    const guideUrl =
        "https://www.ntc.gov.au/sites/default/files/assets/files/Load-Restraint-Guide-2018.pdf";

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
                  textH1("Review & Download Documents Here:"),
                  const SizedBox(height: 15),
                  textH3("Load Restraint Guide Document:",
                      font_size: 14, font_weight: FontWeight.w500),
                  const SizedBox(height: 5),
                  buildDocumentTile("Load Restraint Guide", guideUrl),
                  const SizedBox(height: 5),
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
                            const SizedBox(height: 5),
                            buildDocumentTile(doc.name, fullUrl),
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
