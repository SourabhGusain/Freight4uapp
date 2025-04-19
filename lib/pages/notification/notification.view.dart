import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/get.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/pages/login/login.view.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample dummy notification data
  final List<Map<String, String>> notifications = [
    {
      'title': 'Driver History Renewal Due!',
      'message':
          'Your driver history needs to be renewed to maintain compliance. Please complete and submit the updated form before the due date.',
      'date': '25/08/2025',
    },
    {
      'title': 'Shipment Delivered',
      'message': 'Your shipment #FX123457 has been delivered successfully.',
      'date': '26/08/2025',
    },
    {
      'title': 'New Offer',
      'message': 'Get 20% off on your next shipment booked before 30th August!',
      'date': '27/08/2025',
    },
    {
      'title': 'Account Verification',
      'message': 'Your account has been successfully verified.',
      'date': '28/08/2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(
                context,
                "Notifications",
              ),
            ),
            backgroundColor: whiteColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: List.generate(notifications.length, (index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textH1(
                                notification['title'] ?? '',
                                color: blackColor,
                                font_size: 16,
                                font_weight: FontWeight.bold,
                              ),
                              const Divider(
                                color: primaryColor,
                                thickness: 0.5,
                              ),
                              const SizedBox(height: 5),
                              subtext(notification['message'] ?? ''),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: subtext(notification['date'] ?? '',
                                    font_size: 10,
                                    font_weight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
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
