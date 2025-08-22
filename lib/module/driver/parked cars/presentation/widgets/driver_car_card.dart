// import 'dart:developer';

// import 'package:dazzles/core/shared/routes/const_routes.dart';
// import 'package:dazzles/core/shared/theme/app_colors.dart';
// import 'package:dazzles/core/shared/theme/styles/text_style.dart';
// import 'package:dazzles/core/utils/app_bottom_sheet.dart';
// import 'package:dazzles/core/utils/intl_c.dart';
// import 'package:dazzles/core/utils/permission_hendle.dart';
// import 'package:dazzles/core/utils/responsive_helper.dart';
// import 'package:dazzles/module/driver/check%20in/data/provider/driver%20controller/driver_check_in_controller.dart';
// import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';
// import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/driver_my_parked_car_controller.dart';
// import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/driver_parked_car_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// final isUploadingInitialVideoProvider = StateProvider<bool>((ref) => false);

// class DriverValetParkingCard extends ConsumerStatefulWidget {
//   final DriverParkedCarModel valetData;

//   DriverValetParkingCard({
//     Key? key,
//     required this.valetData,
//   }) : super(key: key);

//   @override
//   ConsumerState<DriverValetParkingCard> createState() =>
//       _DriverValetParkingCardState();
// }

// class _DriverValetParkingCardState
//     extends ConsumerState<DriverValetParkingCard> {
//   bool isLoading = false;

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return InkWell(
//       onTap: () {
//         final lat = widget.valetData.latitude;
//         final lon = widget.valetData.longitude;
//         final finalVideo = widget.valetData.finalVideo;
//         if (lat == null || lon == null) {
//           showCustomBottomSheet(
//             isLoading: isLoading,
//             hideIcon: true,
//             message: "Initial video upload pending for this vehicle.",
//             subtitle: "Please enable your location services to continue.",
//             buttonText: "UPLOAD INITIAL VIDEO",
//             onNext: () async {
//               final hasPermission =
//                   await AppPermissions.askLocationPermission();
//               if (hasPermission) {
//                 ref.read(isUploadingInitialVideoProvider.notifier).state = true;
//                 await ref.watch(driverControllerProvider.notifier).onTakeVideo(
//                     context, widget.valetData.valetId.toString(),
//                     sheetButton: "DONE");
//                 ref.invalidate(drGetParkedCarListControllerProvider);
//                 ref.invalidate(drGetMyParkedCarListControllerProvider);
//                 ref.read(isUploadingInitialVideoProvider.notifier).state =
//                     false;
//               }
//             },
//           );
//         }

//         if ((lat != null && lon != null) && finalVideo == null) {
//           showCustomBottomSheet(
//             hideIcon: true,
//             message: "This vehicle is parked and ready for pickup or delivery.",
//             subtitle: "Scan the customer's QR code to locate and proceed.",
//             buttonText: "SCAN QR CODE",
//             onNext: () async {
//               context.push(drQrScannerScreen, extra: {"scanFor": "checkOut"});
//             },
//           );
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: _getStatusColor(widget.valetData.status).withAlpha(100),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Text(
//             //   widget.valetData.qrNumber.toString(),
//             //   style: AppStyle.boldStyle(color: AppColors.kBgColor),
//             // ),
//             Row(
//               // mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _builTile(Icons.directions_car, widget.valetData.vehicleNumber,
//                     '${widget.valetData.vehicleBrand} ${widget.valetData.vehicleModel}',
//                     isIconLeft: true),
//                 SizedBox(
//                   height: 50,
//                   child: VerticalDivider(
//                     thickness: 1,
//                     color: AppColors.kOrange.withAlpha(50),
//                   ),
//                 ),
//                 _builTile(Icons.person_outline, widget.valetData.customerName,
//                     widget.valetData.customerNumber)
//               ],
//             ),

//             const SizedBox(height: 8),
//             // Container(
//             //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//             //   decoration: BoxDecoration(
//             //       borderRadius: BorderRadius.circular(10),
//             //       color: AppColors.kDeepPurple),
//             //   child: Text('QR: ${valetData.qrNumber}',
//             //       style:
//             //           AppStyle.boldStyle(fontSize: 10, color: AppColors.kWhite)),
//             // ),
//             // Customer Information

//             Divider(
//               color: AppColors.kOrange.withAlpha(50),
//             ),
//             // Bottom Row - Store and Timing
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Store: ${widget.valetData.storeName}',
//                       style: AppStyle.mediumStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Parked by: ${widget.valetData.parkedby}',
//                       style: AppStyle.mediumStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       IntlC.convertToDateTime(widget.valetData.parkedAt),
//                       style: AppStyle.mediumStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Duration: ${widget.valetData.parkingTime}h',
//                       style: AppStyle.mediumStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             if (widget.valetData.status.toLowerCase() == "parked")
//               _buildParkedStatusBar(),
//             if (widget.valetData.status.toLowerCase() == "delivered")
//               _buildDeliveredStatusBar(),
//             if (widget.valetData.status.toLowerCase() == "cancelled")
//               _buildCancelledStatusBar(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _builTile(IconData icon, String title, String subttile,
//       {bool? isIconLeft}) {
//     return Expanded(
//       child: Row(
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (isIconLeft == true) ...[
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.grey.shade600,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//           ],
//           Expanded(
//             child: Column(
//               crossAxisAlignment: isIconLeft == null
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: AppStyle.boldStyle(color: AppColors.kBgColor)),
//                 const SizedBox(height: 2),
//                 Text(subttile,
//                     style: AppStyle.mediumStyle(
//                         color: AppColors.kTextPrimaryColor)),
//               ],
//             ),
//           ),
//           if (isIconLeft == null) ...[
//             const SizedBox(width: 12),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.grey.shade600,
//                 size: 20,
//               ),
//             ),
//           ]
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'parked':
//         return AppColors.kTeal;
//       case 'delivered':
//         return AppColors.kDeepPurple;
//       case "cancelled":
//         {
//           return AppColors.kErrorPrimary;
//         }
//       default:
//         return Colors.white;
//     }
//   }

//   Widget _buildStatusBar(String status, bool isCurrent) {
//     return Column(
//       children: [
//         Container(
//           alignment: Alignment.center,
//           width: ResponsiveHelper.wp * .2,
//           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//           decoration: BoxDecoration(
//             color: _getStatusColor(status),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             status,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: AppStyle.mediumStyle(
//               fontSize: 12,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 2,
//         ),
//         isCurrent
//             ? Container(
//                 width: ResponsiveHelper.wp * .17,
//                 height: 2,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: _getStatusColor(status)),
//               )
//             : SizedBox.shrink()
//       ],
//     );
//   }

//   Widget _buildParkedStatusBar() {
//     return Row(
//       children: [
//         _buidlDevider(_getStatusColor(""), _getStatusColor("Parked")),
//         _buildStatusBar("Parked", true),
//       ],
//     );
//   }

//   Widget _buildDeliveredStatusBar() {
//     return Row(
//       children: [
//         _buildStatusBar("Parked", false),
//         _buidlDevider(_getStatusColor("Parked"), _getStatusColor("Delivered")),
//         _buildStatusBar("Delivered", true),
//       ],
//     );
//   }

//   Widget _buildCancelledStatusBar() {
//     return Row(
//       children: [
//         _buildStatusBar("Parked", false),
//         _buidlDevider(_getStatusColor("Parked"), _getStatusColor("Cancelled")),
//         _buildStatusBar("Cancelled", true),
//       ],
//     );
//   }

//   Widget _buidlDevider(Color a, Color b) {
//     return Flexible(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 10),
//         height: 1,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             gradient: LinearGradient(colors: [AppColors.kWhite, a, b])),
//       ),
//     );
//   }
// }

import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/app_bottom_sheet.dart';
import 'package:dazzles/core/utils/intl_c.dart';
import 'package:dazzles/core/utils/permission_hendle.dart';
import 'package:dazzles/module/driver/check%20in/data/provider/driver%20controller/driver_check_in_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/model/driver_parked_car_model.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/my%20parked%20cars%20controller/driver_my_parked_car_controller.dart';
import 'package:dazzles/module/driver/parked%20cars/data/provider/parked%20car%20controller/driver_parked_car_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final isUploadingInitialVideoProvider = StateProvider<bool>((ref) => false);

class DriverValetParkingCard extends ConsumerStatefulWidget {
  final DriverParkedCarModel valetData;

  const DriverValetParkingCard({
    Key? key,
    required this.valetData,
  }) : super(key: key);

  @override
  ConsumerState<DriverValetParkingCard> createState() =>
      _DriverValetParkingCardState();
}

class _DriverValetParkingCardState extends ConsumerState<DriverValetParkingCard>
    with TickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.valetData.status.toLowerCase() == "parked") {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _animationController.forward(),
            onTapUp: (_) => _animationController.reverse(),
            onTapCancel: () => _animationController.reverse(),
            onTap: _handleCardTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: _getCardGradient(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor(widget.valetData.status)
                        .withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    _buildBackgroundPattern(),
                    _buildCardContent(),
                    _buildStatusIndicator(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned(
      right: -50,
      top: -50,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildHeader(),
          // const SizedBox(height: 20),
          _buildMainInfo(),
          const SizedBox(height: 5),
          _buildDivider(),
          const SizedBox(height: 5),
          _buildFooterInfo(),
          const SizedBox(height: 10),
          _buildStatusProgress(),
        ],
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //         decoration: BoxDecoration(
  //           color: Colors.white.withOpacity(0.2),
  //           borderRadius: BorderRadius.circular(20),
  //           border: Border.all(color: Colors.white.withOpacity(0.3)),
  //         ),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               Icons.qr_code_2,
  //               size: 16,
  //               color: Colors.white.withOpacity(0.9),
  //             ),
  //             const SizedBox(width: 6),
  //             Text(
  //               'QR: ${widget.valetData.qrNumber}',
  //               style: AppStyle.mediumStyle(
  //                 fontSize: 12,
  //                 color: Colors.white.withOpacity(0.9),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       _buildActionButton(),
  //     ],
  //   );
  // }

  // Widget _buildActionButton() {
  //   final lat = widget.valetData.latitude;
  //   final lon = widget.valetData.longitude;
  //   final finalVideo = widget.valetData.finalVideo;

  //   IconData icon;
  //   Color color;

  //   if (lat == null || lon == null) {
  //     icon = Icons.videocam;
  //     color = Colors.grey;
  //   } else if ((lat != null && lon != null) && finalVideo == null) {
  //     icon = Icons.qr_code_scanner;
  //     color = Colors.white;
  //   } else {
  //     icon = Icons.check_circle;
  //     color = Colors.green;
  //   }

  //   return AnimatedBuilder(
  //     animation: _pulseAnimation,
  //     builder: (context, child) {
  //       return Transform.scale(
  //         scale: (lat == null || lon == null) ? _pulseAnimation.value : 1.0,
  //         child: Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: color.withOpacity(0.2),
  //             shape: BoxShape.circle,
  //             border: Border.all(color: color.withOpacity(0.5)),
  //           ),
  //           child: Icon(
  //             icon,
  //             color: color,
  //             size: 20,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildMainInfo() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoTile(
            icon: Icons.directions_car,
            title: widget.valetData.vehicleNumber,
            subtitle:
                '${widget.valetData.vehicleBrand} ${widget.valetData.vehicleModel}',
            iconColor: Colors.white.withOpacity(0.9),
          ),
        ),
        Container(
          width: 1,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Expanded(
          child: _buildInfoTile(
            icon: Icons.person_outline,
            title: widget.valetData.customerName,
            subtitle: widget.valetData.customerNumber,
            iconColor: Colors.white.withOpacity(0.9),
            isReversed: true,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    bool isReversed = false,
  }) {
    return Row(
      textDirection: isReversed ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isReversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyle.boldStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppStyle.mediumStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                icon: Icons.store_outlined,
                text: widget.valetData.storeName,
                label: 'Store',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.person_pin_circle_outlined,
                text: widget.valetData.parkedby,
                label: 'Parked by',
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildInfoRow(
                icon: Icons.access_time,
                text: IntlC.convertToDateTime(widget.valetData.parkedAt),
                label: 'Parked at',
                isReversed: true,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.timer_outlined,
                text: '${widget.valetData.parkingTime} min',
                label: 'Duration',
                isReversed: true,
                isHighlighted: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required String label,
    bool isReversed = false,
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: isReversed ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withOpacity(0.7),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment:
                isReversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyle.mediumStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                text,
                style: AppStyle.mediumStyle(
                  fontSize: 12,
                  color: isHighlighted
                      ? Colors.white
                      : Colors.white.withOpacity(0.9),
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusProgress() {
    final status = widget.valetData.status.toLowerCase();
    switch (status) {
      case "parked":
        return _buildParkedStatusBar();
      case "delivered":
        return _buildDeliveredStatusBar();
      case "cancelled":
        return _buildCancelledStatusBar();
      default:
        return _buildParkedStatusBar();
    }
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _getStatusColor(widget.valetData.status),
          border: BoxBorder.fromLTRB(
              bottom: BorderSide(color: AppColors.kBorderColor)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: _getStatusColor(widget.valetData.status).withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          widget.valetData.status.toUpperCase(),
          style: AppStyle.boldStyle(
            color: Colors.white,
            fontSize: 12,
            spacing: 0.8,
          ),
        ),
      ),
    );
  }

  LinearGradient _getCardGradient() {
    final color = _getStatusColor(widget.valetData.status);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.8),
        color.withOpacity(0.9),
        color,
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'parked':
        return const Color(0xFF6366F1); // Teal
      case 'delivered':
        return Color(0xFF6B7280); // Indigo
      case "cancelled":
        return const Color(0xFFEF4444); // Red
      default:
        return Colors.white; // Gray
    }
  }

  Widget _buildStatusBar(String status, bool isCurrent,
      {bool showConnector = false}) {
    final isActive = isCurrent;
    final color = _getStatusColor(status);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? color : Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            status.toUpperCase(),
            style: AppStyle.boldStyle(
              fontSize: 10,
              color: isActive ? color : Colors.white.withOpacity(0.7),
              spacing: 0.5,
            ),
          ),
        ),
        if (isActive) ...[
          const SizedBox(height: 6),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConnector(Color startColor, Color endColor) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          gradient: LinearGradient(
            colors: [startColor.withOpacity(0.3), endColor.withOpacity(0.3)],
          ),
        ),
      ),
    );
  }

  Widget _buildParkedStatusBar() {
    return Row(
      children: [
        const SizedBox(width: 8),
        _buildStatusBar("Parked", true),
        _buildConnector(Colors.white, Colors.white.withOpacity(0.3)),
        _buildStatusBar("Delivered", false),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDeliveredStatusBar() {
    return Row(
      children: [
        const SizedBox(width: 8),
        _buildStatusBar("Parked", false),
        _buildConnector(_getStatusColor("Delivered"), _getStatusColor("")),
        _buildStatusBar("Delivered", true),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCancelledStatusBar() {
    return Row(
      children: [
        const SizedBox(width: 8),
        _buildStatusBar("Parked", false),
        _buildConnector(
            _getStatusColor("Parked"), _getStatusColor("Cancelled")),
        _buildStatusBar("Cancelled", true),
        const SizedBox(width: 8),
      ],
    );
  }

  void _handleCardTap() {
    final lat = widget.valetData.latitude;
    final lon = widget.valetData.longitude;
    final finalVideo = widget.valetData.finalVideo;

    if (lat == null || lon == null) {
      showCustomBottomSheet(
        isLoading: isLoading,
        hideIcon: true,
        message: "Initial video upload pending for this vehicle.",
        subtitle: "Please enable your location services to continue.",
        buttonText: "UPLOAD INITIAL VIDEO",
        onNext: () async {
          final hasPermission = await AppPermissions.askLocationPermission();
          if (hasPermission) {
            ref.read(isUploadingInitialVideoProvider.notifier).state = true;
            await ref.watch(driverControllerProvider.notifier).onTakeVideo(
                context, widget.valetData.valetId.toString(),
                sheetButton: "DONE");
            ref.invalidate(drGetParkedCarListControllerProvider);
            ref.invalidate(drGetMyParkedCarListControllerProvider);
            ref.read(isUploadingInitialVideoProvider.notifier).state = false;
          }
        },
      );
    }

    if ((lat != null && lon != null) && finalVideo == null) {
      showCustomBottomSheet(
        hideIcon: true,
        message: "This vehicle is parked and ready for pickup or delivery.",
        subtitle: "Scan the customer's QR code to locate and proceed.",
        buttonText: "SCAN QR CODE",
        onNext: () async {
          context.push(drQrScannerScreen, extra: {"scanFor": "checkOut"});
        },
      );
    }
  }
}
