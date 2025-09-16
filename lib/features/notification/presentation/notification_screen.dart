import 'dart:async';

import 'package:dazzles/core/components/app_back_button.dart';
import 'package:dazzles/core/components/build_state_manage_button.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/features/notification/data/models/notification_model.dart';
import 'package:dazzles/features/notification/data/providers/notification_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    Future.microtask(() {
      ref.invalidate(notificationListControllerProvider);
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: isDark ? Colors.black : Colors.grey[50],
      // appBar: AppBar(
      //   elevation: 0,
      //   // backgroundColor: isDark ? Colors.black : Colors.white,
      //   surfaceTintColor: Colors.transparent,
      //   leading: const AppBackButton(),
      //   title: Text(
      //     "Notifications",
      //     style: AppStyle.boldStyle().copyWith(
      //       fontSize: 20,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      // ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            final completer = Completer<void>();
            ref.refresh(notificationListControllerProvider);
            Future.delayed(const Duration(milliseconds: 500), () {
              completer.complete();
            });
            return completer.future;
          },
          child: BuildStateManageComponent(
            stateController: ref.watch(notificationListControllerProvider),
            errorWidget: (error, stackTrace) =>
                _buildErrorState(error.toString()),
            successWidget: (data) {
              final list = data as List<NotificationModel>;
              return list.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(list);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutCubic,
          child: _buildNotificationTile(notifications[index], index),
        );
      },
    );
  }

  Widget _buildNotificationTile(NotificationModel model, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isUnread = model.isRead == 0; // Assuming 0 means unread

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // onTap: () => _handleNotificationTap(model),
          // onLongPress: () => _showNotificationOptions(model),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? (isUnread ? Colors.grey[850] : Colors.grey[900])
                  : (isUnread ? Colors.blue[50] : Colors.white),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUnread
                    ? (isDark ? Colors.blue[800]! : Colors.blue[200]!)
                    : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNotificationIcon(isUnread),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Notification",
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildTimeChip(model.createdAt),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            model.notification,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[700],
                              height: 1.4,
                            ),
                            maxLines: model.notificationImage != null ? 2 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isUnread) _buildUnreadIndicator(),
                  ],
                ),
                if (model.notificationImage != null &&
                    model.notificationImage!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildNotificationImage(model.notificationImage!),
                ],
                // const SizedBox(height: 12),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     // _buildNotificationCategory(isUnread),
                //     // _buildActionButtons(model),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(bool isUnread) {
    final theme = Theme.of(context);
    final iconColor = isUnread ? Colors.blue : theme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isUnread ? CupertinoIcons.bell_solid : CupertinoIcons.bell,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildTimeChip(DateTime createdAt) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getRelativeTime(createdAt),
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 11,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  // Widget _buildNotificationCategory(bool isUnread) {
  //   final theme = Theme.of(context);
  //   final color = isUnread ? Colors.blue : theme.primaryColor;

  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //     decoration: BoxDecoration(
  //       color: color.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Text(
  //       isUnread ? "New" : "Read",
  //       style: theme.textTheme.bodySmall?.copyWith(
  //         color: color,
  //         fontSize: 10,
  //         fontWeight: FontWeight.w500,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNotificationImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image_outlined,
                size: 32,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                "Image not available",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildActionButtons(NotificationModel model) {
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       if (model.notificationImage != null && model.notificationImage!.isNotEmpty)
  //         IconButton(
  //           onPressed: () => _showImagePreview(model.notificationImage!),
  //           icon: const Icon(Icons.fullscreen_outlined),
  //           iconSize: 16,
  //           visualDensity: VisualDensity.compact,
  //           tooltip: 'View image',
  //         ),
  //       IconButton(
  //         onPressed: () => _shareNotification(model.notification),
  //         icon: const Icon(Icons.share_outlined),
  //         iconSize: 16,
  //         visualDensity: VisualDensity.compact,
  //         tooltip: 'Share',
  //       ),
  //       if (model.isRead == 0) // If unread
  //         IconButton(
  //           onPressed: () => _markAsRead(model),
  //           icon: const Icon(Icons.mark_email_read_outlined),
  //           iconSize: 16,
  //           visualDensity: VisualDensity.compact,
  //           tooltip: 'Mark as read',
  //         ),
  //     ],
  //   );
  // }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No notifications yet",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You're all caught up! We'll notify you\nwhen something new happens.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () {
              return ref.refresh(notificationListControllerProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We couldn't load your notifications.\nPlease try again.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              return ref.refresh(notificationListControllerProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return IntlC.convertToDateTime(dateTime);
    }
  }

  // void _handleNotificationTap(NotificationModel model) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Notification #${model.notificationId}"),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(model.notification),
  //           const SizedBox(height: 8),
  //           Text(
  //             "Created: ${IntlC.convertToDateTime(model.createdAt)}",
  //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //               color: Colors.grey[600],
  //             ),
  //           ),
  //           if (model.notificationImage != null && model.notificationImage!.isNotEmpty) ...[
  //             const SizedBox(height: 16),
  //             _buildNotificationImage(model.notificationImage!),
  //           ],
  //         ],
  //       ),
  //       actions: [
  //         if (model.isRead == 0)
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               _markAsRead(model);
  //             },
  //             child: const Text("Mark as Read"),
  //           ),
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Close"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showNotificationOptions(NotificationModel model) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           if (model.isRead == 0)
  //             ListTile(
  //               leading: const Icon(Icons.mark_email_read_rounded),
  //               title: const Text("Mark as read"),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _markAsRead(model);
  //               },
  //             ),
  //           ListTile(
  //             leading: const Icon(Icons.share_outlined),
  //             title: const Text("Share"),
  //             onTap: () {
  //               Navigator.pop(context);
  //               _shareNotification(model.notification);
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.delete_outline_rounded),
  //             title: const Text("Delete"),
  //             onTap: () {
  //               Navigator.pop(context);
  //               _deleteNotification(model);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _showImagePreview(String imageUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       backgroundColor: Colors.transparent,
  //       child: Stack(
  //         children: [
  //           Center(
  //             child: Image.network(
  //               imageUrl,
  //               fit: BoxFit.contain,
  //               loadingBuilder: (context, child, loadingProgress) {
  //                 if (loadingProgress == null) return child;
  //                 return const CircularProgressIndicator();
  //               },
  //               errorBuilder: (context, error, stackTrace) => const Icon(
  //                 Icons.error_outline,
  //                 color: Colors.white,
  //                 size: 64,
  //               ),
  //             ),
  //           ),
  //           Positioned(
  //             top: 16,
  //             right: 16,
  //             child: IconButton(
  //               onPressed: () => Navigator.pop(context),
  //               icon: const Icon(
  //                 Icons.close,
  //                 color: Colors.white,
  //                 size: 32,
  //               ),
  //               style: IconButton.styleFrom(
  //                 backgroundColor: Colors.black54,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _shareNotification(String notification) {
  //   // Add share functionality using share_plus package
  //   // Share.share(notification);
  // }

  // void _markAsRead(NotificationModel model) {
  //   // Add your mark as read logic here
  //   // This would typically call an API or update local state
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Notification #${model.notificationId} marked as read"),
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  // void _deleteNotification(NotificationModel model) {
  //   // Add your delete logic here
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text("Notification #${model.notificationId} deleted"),
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  // void _showMarkAllAsReadDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text("Mark all as read"),
  //       content: const Text("Are you sure you want to mark all notifications as read?"),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //         FilledButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             // Add mark all as read logic
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Text("All notifications marked as read"),
  //                 duration: Duration(seconds: 2),
  //               ),
  //             );
  //           },
  //           child: const Text("Mark All"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
