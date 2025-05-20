import 'dart:convert';
import 'package:Freight4u/helpers/api.dart';
import 'package:Freight4u/helpers/values.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String notificationType;
  final bool isRead;
  final bool isActive;
  final String createdOn;
  final String? username;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.isRead,
    required this.isActive,
    required this.createdOn,
    this.username,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      notificationType: json['notification_type'] ?? 'info',
      isRead: json['is_read'] ?? false,
      isActive: json['is_active'] ?? true,
      createdOn: json['created_on'] ?? '',
      username: json['user'] is Map ? json['user']['username'] : null,
    );
  }

  static List<NotificationModel> fromJsonList(List data) {
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }
}

Future<List<NotificationModel>> fetchNotifications() async {
  final api = Api();
  final response = await api.getCalling(
    "$api_url/settings/notifications/",
    NotificationModel.fromJsonList,
  );

  if (response["ok"] == 1) {
    return response["data"] as List<NotificationModel>;
  } else {
    print("Error fetching notifications: ${response['error']}");
    return [];
  }
}
