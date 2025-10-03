import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

enum AppPermission {
  dashboardinsight,
  productlist,
  updateproduct,
  scanproduct,
  purchaseorderlist,
  valey,
  recentlyupdated,
  operationtask,
  // FEATURES
  purchasePriceVisibility,
  salesPriceVisibility,
  stockquantityvisibility,
  soldquantityvisibility,
  editprice,
  createoperationtask,
}

extension AppPermissionExt on AppPermission {
  // Icon for each permission
  IconData get icon {
    switch (this) {
      case AppPermission.valey:
        return Icons.local_parking;
      case AppPermission.updateproduct:
        return CupertinoIcons.camera;
      case AppPermission.scanproduct:
        return CupertinoIcons.qrcode;
      case AppPermission.purchaseorderlist:
        return CupertinoIcons.cube_box;
      case AppPermission.dashboardinsight:
        return Icons.dashboard;
      case AppPermission.productlist:
        return Icons.widgets;
      case AppPermission.recentlyupdated:
        return Icons.list;
      case AppPermission.operationtask:
        return SolarIconsOutline.notificationUnreadLines;
      default:
        return Icons.add_box;
    }
  }

  // Color for each permission
  Color get color {
    switch (this) {
      case AppPermission.valey:
        return Colors.cyan;
      case AppPermission.updateproduct:
        return Colors.purple;

      case AppPermission.scanproduct:
        return Colors.teal;

      case AppPermission.purchaseorderlist:
        return Colors.lightBlue;
      case AppPermission.dashboardinsight:
        return Colors.green;
      case AppPermission.productlist:
        return Colors.amber;
      case AppPermission.recentlyupdated:
        return Colors.deepPurple;
      case AppPermission.operationtask:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Human readable title
  String get title {
    switch (this) {
      case AppPermission.valey:
        return 'Valey';
      case AppPermission.productlist:
        return 'Products';
      case AppPermission.scanproduct:
        return 'Scan Product';
      case AppPermission.purchaseorderlist:
        return 'Purchase Orders';
      case AppPermission.dashboardinsight:
        return 'Product Dashboard';
      case AppPermission.updateproduct:
        return 'Update Image';
      case AppPermission.recentlyupdated:
        return "Recently Updated";
      case AppPermission.operationtask:
        return "Operations";
      default:
        return this.name;
    }
  }

  // Canonical key used for persistence / remote (uppercase snake style)
  String toKey() {
    // switch (this) {
    //   case AppPermission.valey:
    //     return 'valey';
    //   case AppPermission.updateproduct:
    //     return 'updateproduct';
    //   case AppPermission.scanproduct:
    //     return 'scanproduct';
    //   case AppPermission.purchaseorderlist:
    //     return 'purchaseorderlist';
    //   case AppPermission.dashboardinsight:
    //     return 'dashboardinsight';
    //   case AppPermission.productlist:
    //     return 'productlist';
    //   case AppPermission.recentlyupdated:
    //     return "recentlyupdated";
    //   default:
    //     return
    // }

    return this.name;
  }

  // Short name (enum.name)
  // String toShortString() => name;

  // Example onTap handler — replace with real logic (navigation / actions)
  void onTap(BuildContext context) {
    switch (this) {
      case AppPermission.valey:
        context.push(drNavScreen);
        break;
      case AppPermission.productlist:
        context.push(productslist);
        break;
      case AppPermission.scanproduct:
        context.push(qrScanScreen);
        break;
      case AppPermission.purchaseorderlist:
        context.push(packageSuppliers);
        break;
      case AppPermission.updateproduct:
        context.push(cameraScreen);
        break;
      case AppPermission.recentlyupdated:
        context.push(recentlyCaptured);
        break;
      case AppPermission.operationtask:
        context.push(operationTaskViewScreen);
        break;
      default:
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
        return AppPermission.valey;

      case 'productlist':
        return AppPermission.productlist;

      case 'scanproduct':
        return AppPermission.scanproduct;

      case 'updateproduct':
        return AppPermission.updateproduct;

      case 'purchaseorderlist':
        return AppPermission.purchaseorderlist;

      case 'dashboardinsight':
        return AppPermission.dashboardinsight;
      case "recentlyupdated":
        return AppPermission.recentlyupdated;
      case "purchasepricevisibility":
        return AppPermission.purchasePriceVisibility;
      case "salespricevisibility":
        return AppPermission.salesPriceVisibility;
      case "stockquantityvisibility":
        return AppPermission.stockquantityvisibility;
      case "soldquantityvisibility":
        return AppPermission.soldquantityvisibility;
      case "editprice":
        return AppPermission.editprice;
      case "operationtask":
        return AppPermission.operationtask;
      case "createoperationtask":
        return AppPermission.createoperationtask;
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
