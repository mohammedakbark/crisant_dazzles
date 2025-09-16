// lib/core/app_permission/app_permission_extension.dart
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

enum AppPermission {
  valet,
  updateImage,
  scanProduct,
  pushNotification,
  purchaseOrderList,
  productDashboard,
  editPrice,
}

extension AppPermissionExt on AppPermission {
  // Icon for each permission
  IconData get icon {
    switch (this) {
      case AppPermission.valet:
        return Icons.local_parking;
      case AppPermission.updateImage:
        return Icons.image;
      case AppPermission.scanProduct:
        return SolarIconsOutline.qrCode;
      case AppPermission.pushNotification:
        return Icons.notifications_active;
      case AppPermission.purchaseOrderList:
        return CupertinoIcons.cube_box;
      case AppPermission.productDashboard:
        return Icons.dashboard;
      case AppPermission.editPrice:
        return Icons.attach_money;
    }
  }

  // Color for each permission
  Color get color {
    switch (this) {
      case AppPermission.valet:
        return Colors.cyan;
      case AppPermission.updateImage:
        return Colors.redAccent;
      case AppPermission.scanProduct:
        return Colors.teal;
      case AppPermission.pushNotification:
        return Colors.purple;
      case AppPermission.purchaseOrderList:
        return Colors.lightBlue;
      case AppPermission.productDashboard:
        return Colors.green;
      case AppPermission.editPrice:
        return Colors.amber;
    }
  }

  // Human readable title
  String get title {
    switch (this) {
      case AppPermission.valet:
        return 'Valet';
      case AppPermission.updateImage:
        return 'Update Image';
      case AppPermission.scanProduct:
        return 'Scan Product';
      case AppPermission.pushNotification:
        return 'Notifications';
      case AppPermission.purchaseOrderList:
        return 'Purchase Orders';
      case AppPermission.productDashboard:
        return 'Product Dashboard';
      case AppPermission.editPrice:
        return 'Edit Price';
    }
  }

  // Canonical key used for persistence / remote (uppercase snake style)
  String toKey() {
    switch (this) {
      case AppPermission.valet:
        return 'valey';
      case AppPermission.updateImage:
        return 'update image';
      case AppPermission.scanProduct:
        return 'scan product';
      case AppPermission.pushNotification:
        return 'push notification';
      case AppPermission.purchaseOrderList:
        return 'purchase order list';
      case AppPermission.productDashboard:
        return 'product dashboard';
      case AppPermission.editPrice:
        return 'edit price';
    }
  }

  // Short name (enum.name)
  // String toShortString() => name;

  // Example onTap handler — replace with real logic (navigation / actions)
  void onTap(BuildContext context) {
    switch (this) {
      case AppPermission.valet:
        context.push(drNavScreen);
        break;
      case AppPermission.updateImage:
        // TODO: open update image
        break;
      case AppPermission.scanProduct:
        // TODO: open scanner
        break;
      case AppPermission.pushNotification:
        context.push(notificationScreen);
        break;
      case AppPermission.purchaseOrderList:
        // TODO: open purchase orders
        break;
      case AppPermission.productDashboard:
        // TODO: open dashboard
        break;
      case AppPermission.editPrice:
        // TODO: open price editor
        break;
    }
  }

  // -----------------------
  // Static helpers for parsing string keys (from DB / remote)
  // -----------------------

  /// Try to parse a DB/remote key into a permission. Returns `null` if unknown.
  static AppPermission? tryFromKey(String? key) {
    if (key == null) return null;
    // final normalized = key.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final normalized = key.trim().toLowerCase();

    switch (normalized) {
      case 'valey':
        return AppPermission.valet;

      case 'update image':
        return AppPermission.updateImage;

      case 'scan product':
        return AppPermission.scanProduct;

      case 'push notification':
        return AppPermission.pushNotification;

      case 'purchase order list':
        return AppPermission.purchaseOrderList;

      case 'product dashboard':
        return AppPermission.productDashboard;

      case 'edit price':
        return AppPermission.editPrice;

      default:
        return null;
    }
  }

  /// Convert an iterable of string keys (from DB) into a Set<AppPermission> — unknown keys are ignored.
  static Set<AppPermission> fromKeySet(Iterable<String>? keys) {
    if (keys == null) return <AppPermission>{};
    return keys
        .map((k) => AppPermissionExt.tryFromKey(k))
        .whereType<AppPermission>()
        .toSet();
  }
}
