import 'dart:developer';

import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/app_bottom_sheet.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/core/utils/permission_hendle.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/driver/check%20in/data/provider/driver%20controller/driver_check_in_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverValetParkingCard extends ConsumerStatefulWidget {
  final DriverParkedCarModel valetData;

  DriverValetParkingCard({
    Key? key,
    required this.valetData,
  }) : super(key: key);

  @override
  ConsumerState<DriverValetParkingCard> createState() =>
      _DriverValetParkingCardState();
}

class _DriverValetParkingCardState
    extends ConsumerState<DriverValetParkingCard> {
  bool isLoading = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        if (widget.valetData.latitude == null ||
            widget.valetData.longitude == null) {
          showCustomBottomSheet(
            isLoading: isLoading,
            hideIcon: true,
            message: "Uploading initial video of this vehilce is pending.",
            subtitle: 'Make sure your location service is enabled',
            buttonText: "UPLOAD INITIAL VIDEO",
            onNext: () async {
              final hasPermission =
                  await AppPermissions.askLocationPermission();

              if (hasPermission) {
                // isLoading = true;
                // setState(() {});
                // await Future.delayed((Duration(seconds: 2)));
                await ref.watch(driverControllerProvider.notifier).onTakeVideo(
                    context, widget.valetData.valetId.toString(),
                    sheetButton: "DONE");
                // setState(() {});
                // isLoading = false;
              }
            },
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: _getStatusColor(widget.valetData.status).withAlpha(100),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _builTile(Icons.directions_car, widget.valetData.vehicleNumber,
                    '${widget.valetData.vehicleBrand} ${widget.valetData.vehicleModel}',
                    isIconLeft: true),
                SizedBox(
                  height: 50,
                  child: VerticalDivider(
                    thickness: 1,
                    color: AppColors.kOrange.withAlpha(50),
                  ),
                ),
                _builTile(Icons.person_outline, widget.valetData.customerName,
                    widget.valetData.customerNumber)
              ],
            ),

            const SizedBox(height: 8),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: AppColors.kDeepPurple),
            //   child: Text('QR: ${valetData.qrNumber}',
            //       style:
            //           AppStyle.boldStyle(fontSize: 10, color: AppColors.kWhite)),
            // ),
            // Customer Information

            Divider(
              color: AppColors.kOrange.withAlpha(50),
            ),
            // Bottom Row - Store and Timing
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store: ${widget.valetData.storeName}',
                      style: AppStyle.mediumStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Parked by: ${widget.valetData.parkedby}',
                      style: AppStyle.mediumStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      IntlC.convertToDateTime(widget.valetData.parkedAt),
                      style: AppStyle.mediumStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: ${widget.valetData.parkingTime}h',
                      style: AppStyle.mediumStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            if (widget.valetData.status.toLowerCase() == "parked")
              _buildParkedStatusBar(),
            if (widget.valetData.status.toLowerCase() == "delivered")
              _buildDeliveredStatusBar(),
            if (widget.valetData.status.toLowerCase() == "cancelled")
              _buildCancelledStatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _builTile(IconData icon, String title, String subttile,
      {bool? isIconLeft}) {
    return Expanded(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isIconLeft == true) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isIconLeft == null
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppStyle.boldStyle(color: AppColors.kBgColor)),
                const SizedBox(height: 2),
                Text(subttile,
                    style: AppStyle.mediumStyle(
                        color: AppColors.kTextPrimaryColor)),
              ],
            ),
          ),
          if (isIconLeft == null) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'parked':
        return AppColors.kTeal;
      case 'delivered':
        return AppColors.kDeepPurple;
      case "cancelled":
        {
          return AppColors.kErrorPrimary;
        }
      default:
        return Colors.white;
    }
  }

  Widget _buildStatusBar(String status, bool isCurrent) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: ResponsiveHelper.wp * .2,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: _getStatusColor(status),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.mediumStyle(
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        isCurrent
            ? Container(
                width: ResponsiveHelper.wp * .17,
                height: 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _getStatusColor(status)),
              )
            : SizedBox.shrink()
      ],
    );
  }

  Widget _buildParkedStatusBar() {
    return Row(
      children: [
        _buidlDevider(_getStatusColor(""), _getStatusColor("Parked")),
        _buildStatusBar("Parked", true),
      ],
    );
  }

  Widget _buildDeliveredStatusBar() {
    return Row(
      children: [
        _buildStatusBar("Parked", false),
        _buidlDevider(_getStatusColor("Parked"), _getStatusColor("Delivered")),
        _buildStatusBar("Delivered", true),
      ],
    );
  }

  Widget _buildCancelledStatusBar() {
    return Row(
      children: [
        _buildStatusBar("Parked", false),
        _buidlDevider(_getStatusColor("Parked"), _getStatusColor("Cancelled")),
        _buildStatusBar("Cancelled", true),
      ],
    );
  }

  Widget _buidlDevider(Color a, Color b) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [AppColors.kWhite, a, b])),
      ),
    );
  }
}
