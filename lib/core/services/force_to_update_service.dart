import 'dart:io';

import 'package:dazzles/core/config/api_config.dart';
import 'package:dazzles/core/constant/api_constant.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateService {
  static Future<Map<String, dynamic>> getRemoteConfig() async {
    final response = await ApiConfig.getRequest(
      endpoint: ApiConstants.remoteConfigURL,
      header: {
        "Content-Type": "application/json",
      },
    );

    if (response.status == 200) {
      final data = response.data as List;
      return {
        "error": false,
        "data": data.first['version'].toString(),
      };
    } else {
      return {"error": true, "data": response.message};
    }
  }

  static Future<bool> isUpdateRequired() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      Map<String, dynamic> remoteConfig = await getRemoteConfig();
      if (remoteConfig['error'] == false) {
        String latestversion = remoteConfig['data'];
        if (_isVersionLower(currentVersion, latestversion)) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error checking update: $e');
      return false;
    }
  }

  static bool _isVersionLower(String currentVersion, String minimumVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> minimum = minimumVersion.split('.').map(int.parse).toList();

    // Pad with zeros if needed
    while (current.length < 3) current.add(0);
    while (minimum.length < 3) minimum.add(0);

    for (int i = 0; i < 3; i++) {
      if (current[i] < minimum[i]) return true;
      if (current[i] > minimum[i]) return false;
    }

    return false;
  }

  static Future<void> launchStore() async {
    String url;
    if (Platform.isIOS) {
      // Replace YOUR_APP_ID with your actual App Store ID
      url = 'https://apps.apple.com/app/id/6746066647';
    } else {
      url = 'https://play.google.com/store/apps/details?id=com.dazzles.app';
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}

// UI COMPONENET

class UpdateDialog {
  static void showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: AppColors.kWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   width: 60,
                //   height: 60,
                //   decoration: BoxDecoration(
                //     color: Colors.orange.withOpacity(0.2),
                //     shape: BoxShape.circle,
                //   ),
                //   child: Icon(
                //     Icons.system_update,
                //     color: Colors.orange,
                //     size: 30,
                //   ),
                // ),
                // SizedBox(height: 20),
                Text(
                  'Update Available',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kBgColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'A new version is available with enhanced features and important security updates.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.1),
                        Colors.purple.withOpacity(0.1)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'What\'s New',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.kBgColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Improved performance\n• Bug fixes and stability improvements\n• Enhanced user experience',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ForceUpdateService.launchStore();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kTeal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download_rounded, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'Update Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
