import 'dart:async';
import 'dart:developer';

import 'package:dazzles/module/office/notification/data/models/notification_model.dart';
import 'package:dazzles/module/office/notification/data/repo/get_notifications_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationListController
    extends AsyncNotifier<List<NotificationModel>> {
  @override
  FutureOr<List<NotificationModel>> build() async {
    return await onFetchNotifications();
  }

  Future<List<NotificationModel>> onFetchNotifications() async {
    try {
      state = AsyncValue.loading();
      
      final response = await GetNotificationsRepo.getAllNotifications();
    
      if (response['error'] == false) {
        final list = response['data'] as List<NotificationModel>;
       
        state = AsyncValue.data(list);
        return list;
      } else {
        state = AsyncValue.error(response['data'], StackTrace.empty);
        return [];
      }
    } catch (e, f) {
      state = AsyncValue.error(e, f);
      log(e.toString());
      return [];
    }
  }
}

final notificationListControllerProvider =
    AsyncNotifierProvider<NotificationListController, List<NotificationModel>>(
  () => NotificationListController(),
);
