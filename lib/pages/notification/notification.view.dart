import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/models/notification.model.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;
  bool isBackLoading = false;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final data = await fetchNotifications();
    setState(() {
      notifications = data;
      isLoading = false;
    });
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'warning':
        return Colors.red;
      case 'error':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'info':
      default:
        return Colors.blue;
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      isLoading = true;
    });
    await loadNotifications();
  }

  Future<void> _handleBack() async {
    setState(() {
      isBackLoading = true;
    });

    // Optional small delay so loading spinner is visible
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(context, "Notifications",
                  onBack: _handleBack),
            ),
            backgroundColor: whiteColor,
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : notifications.isEmpty
                    ? const Center(child: Text("No notifications available"))
                    : RefreshIndicator(
                        onRefresh: _refreshNotifications,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            final color = _getNotificationColor(
                                notification.notificationType);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: notification.isRead
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: color, width: 0.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      textH1(
                                        notification.title,
                                        color: blackColor,
                                        font_size: 15,
                                        font_weight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 5),
                                      const Divider(
                                        color: blackColor,
                                        thickness: 0.3,
                                      ),
                                      const SizedBox(height: 5),
                                      subtext(
                                        notification.message,
                                        font_size: 12,
                                      ),
                                      const SizedBox(height: 15),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: subtext(notification.createdOn,
                                            font_size: 9,
                                            font_weight: FontWeight.w700,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        );
      },
      onViewModelReady: (controller) {
        controller.init();
      },
    );
  }
}
