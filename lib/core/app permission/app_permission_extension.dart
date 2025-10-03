import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';

enum AppPermission {
  // dashboard qucik actions
  dashboardinsight,
  productlist,
  updateproduct,
  scanproduct,
  purchaseorderlist,
  valey,
  recentlyupdated,
  operationaction,

  // Operation
  createoperationtask,
  myoperationtasklist,
  todooperationtasklist,
  operationrequestlist,
  operationdashboard,
  operationreport,

  // other FEATURES
  purchasePriceVisibility,
  salesPriceVisibility,
  stockquantityvisibility,
  soldquantityvisibility,
  editprice,
}

extension AppPermissionExt on AppPermission {
  /// Try to parse a DB/remote key into a permission. Returns `null` if unknown.
  static AppPermission? tryFromKey(String? key) {
    if (key == null) return null;
    // final normalized = key.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final normalized = key.trim().toLowerCase();

    switch (normalized) {
      // Qucik Actions
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
      case "operationaction":
        return AppPermission.operationaction;

      // operation permission

      case "createoperationtask":
        return AppPermission.createoperationtask;
      case "myoperationtasklist":
        return AppPermission.myoperationtasklist;
      case "todooperationtasklist":
        return AppPermission.todooperationtasklist;
      case "operationrequestlist":
        return AppPermission.operationrequestlist;
      case "operationdashboard":
        return AppPermission.operationdashboard;
      case "operationreport":
        return AppPermission.operationreport;

      // Other Functions
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

  // Icon for each permission
  IconData get icon {
    switch (this) {
      // Dashboard Qucik Actions
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
      case AppPermission.operationaction:
        return SolarIconsOutline.notificationUnreadLines;
// Operation Actions
      case AppPermission.todooperationtasklist:
        return Icons.view_list_rounded;
      case AppPermission.myoperationtasklist:
        return Icons.list_alt;
      case AppPermission.createoperationtask:
        return Icons.add;
      case AppPermission.operationrequestlist:
        return Icons.edit_notifications_outlined;

      default:
        return Icons.add_box;
    }
  }

  // Color for each permission
  Color get color {
    switch (this) {
      // Dashboard Qucik Actions
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
      case AppPermission.operationaction:
        return Colors.red;

      // Operation Actions

      case AppPermission.todooperationtasklist:
        return Colors.blueGrey;
      case AppPermission.myoperationtasklist:
        return const Color.fromARGB(255, 48, 112, 202);
      case AppPermission.createoperationtask:
        return const Color.fromARGB(255, 30, 175, 197);
      case AppPermission.operationrequestlist:
        return const Color.fromARGB(255, 189, 72, 252);
      default:
        return Colors.grey;
    }
  }

  // Human readable title
  String get title {
    switch (this) {
      // Dashboard Qucik Actions
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
      case AppPermission.operationaction:
        return "Operations";

      // Operation Actions

      case AppPermission.todooperationtasklist:
        return "To Do";
      case AppPermission.myoperationtasklist:
        return "My Task";
      case AppPermission.createoperationtask:
        return "Create Task";
      case AppPermission.operationrequestlist:
        return "Requests";
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
      // Dashboard Qucik Actions
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
      case AppPermission.operationaction:
        context.push(operationDashboardScreen);
        break;

      case AppPermission.createoperationtask:
        context.push(creatNewOperationTaskScreen);
        break;
      case AppPermission.myoperationtasklist:
        context.push(myOperationtaskScreen);
        break;
      case AppPermission.todooperationtasklist:
        context.push(todoOperationTaskScreen);
        break;
      case AppPermission.operationrequestlist:
        context.push(operationReuqestScreen);
        break;

      // Operation Actions
      default:
        break;
    }
  }
}
