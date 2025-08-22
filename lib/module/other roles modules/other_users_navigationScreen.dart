// import 'dart:developer';

// import 'package:dazzles/core/components/app_loading.dart';
// import 'package:dazzles/core/components/app_margin.dart';
// import 'package:dazzles/core/components/app_spacer.dart';
// import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
// import 'package:dazzles/core/shared/routes/const_routes.dart';
// import 'package:dazzles/core/shared/theme/app_colors.dart';
// import 'package:dazzles/core/shared/theme/styles/text_style.dart';
// import 'package:dazzles/core/utils/responsive_helper.dart';
// import 'package:dazzles/module/office/profile/presentation/profile_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:solar_icons/solar_icons.dart';

// class OtherUsersNaviagationScreen extends ConsumerWidget {
//   const OtherUsersNaviagationScreen({super.key});

//   @override
//   Widget build(BuildContext context, ref) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             alignment: Alignment.bottomCenter,
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 color: AppColors.kPrimaryColor,
//                 width: ResponsiveHelper.wp,
//                 height: ResponsiveHelper.hp * .3,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "DAZZLES",
//                       style: GoogleFonts.roboto(
//                         fontSize: ResponsiveHelper.wp * .15,
//                         fontWeight: FontWeight.w100,
//                         color: AppColors.kBgColor,
//                       ),
//                     ),
//                     Text(
//                       "MYSORE | BANGALORE",
//                       style: GoogleFonts.roboto(
//                           fontWeight: FontWeight.w100,
//                           color: AppColors.kBgColor,
//                           fontSize: ResponsiveHelper.wp * .04,
//                           letterSpacing: 3,
//                           height: -.2),
//                     ),
//                   ],
//                 ),
//               ),

//               Positioned(
//                 bottom: -60,
//                 child: FutureBuilder(
//                     future: LoginRefDataBase().getUserData,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return AppLoading();
//                       }
//                       final userModel = snapshot.data;
//                       return userModel == null
//                           ? SizedBox()
//                           : Container(
//                               padding: EdgeInsets.all(10),
//                               alignment: Alignment.center,
//                               width: ResponsiveHelper.wp * .5,
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                       color: AppColors.kWhite, width: 2),
//                                   shape: BoxShape.circle,
//                                   color: AppColors.kBgColor),
//                               child: Text(
//                                 userModel.userName![0].toUpperCase(),
//                                 style: AppStyle.largeStyle(fontSize: 70),
//                               ),
//                             );
//                     }),
//               ),
//               // Positioned(
//               //     bottom: -60,
//               //     child: BuildStateManageComponent(
//               //       stateController: profileController,
//               //       errorWidget: (p0, p1) => SizedBox(),
//               //       loadingWidget: () => SizedBox(),
//               //       successWidget: (data) {
//               //         final userProfileModel = data as UserProfileModel;
//               //         return
//               //       },
//               //     )),
//             ],
//           ),
//           Expanded(
//               child: FutureBuilder(
//                   future: LoginRefDataBase().getUserData,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return AppLoading();
//                     }
//                     final userModel = snapshot.data;
//                     return userModel == null
//                         ? SizedBox()
//                         : Column(children: [
//                             AppMargin(
//                               child: Column(
//                                 children: [
//                                   AppSpacer(
//                                     hp: .1,
//                                   ),
//                                   Container(
//                                       padding: EdgeInsets.all(15),
//                                       width: ResponsiveHelper.wp,
//                                       decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           color: AppColors.kTextPrimaryColor
//                                               .withAlpha(10)),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           _buildTile("User Name",
//                                               userModel.userName ?? 'N/A'),
//                                           _buildDevider(),
//                                           // _buildTile(
//                                           //     "Store", userModel.store),
//                                           // _buildDevider(),
//                                           _buildTile(
//                                               "Role", userModel.role ?? 'N/A')
//                                         ],
//                                       )),
//                                   AppSpacer(
//                                     hp: .05,
//                                   ),
//                                   _buildButton(
//                                     "Notification",
//                                     CupertinoIcons.arrow_right_circle,
//                                     () {
//                                       log(userModel.pushToken ?? '');
//                                       context.push(notificationScreen);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ]);
//                   })),
//           AppSpacer(
//             hp: .1,
//           ),
//           ProfilePage.buildActionButton(
//             icon: SolarIconsOutline.logout,
//             label: 'Logout',
//             onPressed: () {
//               HapticFeedback.mediumImpact();
//               ProfilePage.showLogoutConfirmation(context, ref);
//             },
//             isPrimary: false,
//             isDestructive: true,
//           ),
//           AppSpacer(
//             hp: .1,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildButton(String title, IconData icon, void Function()? onTap) =>
//       InkWell(
//         overlayColor: WidgetStatePropertyAll(Colors.transparent),
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.all(13),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15), color: AppColors.kWhite),
//           width: ResponsiveHelper.wp,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     CupertinoIcons.bell,
//                     color: AppColors.kBgColor,
//                   ),
//                   AppSpacer(
//                     wp: .02,
//                   ),
//                   Text(
//                     title,
//                     style: AppStyle.boldStyle(color: AppColors.kBgColor),
//                   )
//                 ],
//               ),
//               Icon(
//                 icon,
//                 color: AppColors.kBgColor,
//               )
//             ],
//           ),
//         ),
//       );

//   Widget _buildDevider() => Divider(
//         color: AppColors.kBgColor,
//         thickness: 2,
//       );

//   Widget _buildTile(String title, String data) => Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: ResponsiveHelper.wp * .25,
//             child: Text(
//               "${title}",
//               style: AppStyle.mediumStyle(fontSize: 15),
//             ),
//           ),
//           Text(
//             ":  ",
//             style: AppStyle.mediumStyle(fontSize: 15),
//           ),
//           Flexible(
//             child: Text(
//               "${data}",
//               style: AppStyle.boldStyle(fontSize: 15),
//             ),
//           )
//         ],
//       );
// }

// import 'dart:developer';

// import 'package:dazzles/core/components/app_loading.dart';
// import 'package:dazzles/core/components/app_margin.dart';
// import 'package:dazzles/core/components/app_spacer.dart';
// import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
// import 'package:dazzles/core/shared/routes/const_routes.dart';
// import 'package:dazzles/core/shared/theme/app_colors.dart';
// import 'package:dazzles/core/shared/theme/styles/text_style.dart';
// import 'package:dazzles/core/utils/responsive_helper.dart';
// import 'package:dazzles/module/office/profile/presentation/profile_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:solar_icons/solar_icons.dart';

// class DriverProfile extends ConsumerStatefulWidget {
//   const DriverProfile({super.key});

//   @override
//   ConsumerState<DriverProfile> createState() => _DriverProfileState();
// }

// class _DriverProfileState extends ConsumerState<DriverProfile>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     ));

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: Column(
//             children: [
//               Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     color: AppColors.kPrimaryColor,
//                     width: ResponsiveHelper.wp,
//                     height: ResponsiveHelper.hp * .3,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "DAZZLES",
//                           style: GoogleFonts.roboto(
//                             fontSize: ResponsiveHelper.wp * .15,
//                             fontWeight: FontWeight.w100,
//                             color: AppColors.kBgColor,
//                           ),
//                         ),
//                         Text(
//                           "MYSORE | BANGALORE",
//                           style: GoogleFonts.roboto(
//                               fontWeight: FontWeight.w100,
//                               color: AppColors.kBgColor,
//                               fontSize: ResponsiveHelper.wp * .04,
//                               letterSpacing: 3,
//                               height: -.2),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Positioned(
//                     bottom: -60,
//                     child: FutureBuilder(
//                         future: LoginRefDataBase().getUserData,
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return AppLoading();
//                           }
//                           final userModel = snapshot.data;
//                           return userModel == null
//                               ? SizedBox()
//                               : Container(
//                                   padding: EdgeInsets.all(10),
//                                   alignment: Alignment.center,
//                                   width: ResponsiveHelper.wp * .5,
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: AppColors.kWhite, width: 2),
//                                       shape: BoxShape.circle,
//                                       color: AppColors.kBgColor),
//                                   child: Text(
//                                     userModel.userName![0].toUpperCase(),
//                                     style: AppStyle.largeStyle(fontSize: 70),
//                                   ),
//                                 );
//                         }),
//                   ),
//                   // Positioned(
//                   //     bottom: -60,
//                   //     child: BuildStateManageComponent(
//                   //       stateController: profileController,
//                   //       errorWidget: (p0, p1) => SizedBox(),
//                   //       loadingWidget: () => SizedBox(),
//                   //       successWidget: (data) {
//                   //         final userProfileModel = data as UserProfileModel;
//                   //         return
//                   //       },
//                   //     )),
//                 ],
//               ),
//               Expanded(
//                   child: FutureBuilder(
//                       future: LoginRefDataBase().getUserData,
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return AppLoading();
//                         }
//                         final userModel = snapshot.data;
//                         return userModel == null
//                             ? SizedBox()
//                             : Column(children: [
//                                 AppMargin(
//                                   child: Column(
//                                     children: [
//                                       AppSpacer(
//                                         hp: .1,
//                                       ),
//                                       Container(
//                                           padding: EdgeInsets.all(15),
//                                           width: ResponsiveHelper.wp,
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                               color: AppColors.kTextPrimaryColor
//                                                   .withAlpha(10)),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               _buildTile("User Name",
//                                                   userModel.userName ?? 'N/A'),
//                                               _buildDevider(),
//                                               // _buildTile(
//                                               //     "Store", userModel.store),
//                                               // _buildDevider(),
//                                               _buildTile("Role",
//                                                   userModel.role ?? 'N/A')
//                                             ],
//                                           )),
//                                       AppSpacer(
//                                         hp: .05,
//                                       ),
//                                       _buildButton(
//                                         "Notification",
//                                         CupertinoIcons.arrow_right_circle,
//                                         () {
//                                           log(userModel.pushToken ?? '');
//                                           context.push(notificationScreen);
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ]);
//                       })),
//               AppSpacer(
//                 hp: .1,
//               ),
//               ProfilePage.buildActionButton(
//                 icon: SolarIconsOutline.logout,
//                 label: 'Logout',
//                 onPressed: () {
//                   HapticFeedback.mediumImpact();
//                   ProfilePage.showLogoutConfirmation(context, ref);
//                 },
//                 isPrimary: false,
//                 isDestructive: true,
//               ),
//               AppSpacer(
//                 hp: .1,
//               ),
//             ],
//           ),
//         ));
//   }

//   Widget _buildButton(String title, IconData icon, void Function()? onTap) =>
//       InkWell(
//         overlayColor: WidgetStatePropertyAll(Colors.transparent),
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.all(13),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15), color: AppColors.kWhite),
//           width: ResponsiveHelper.wp,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     CupertinoIcons.bell,
//                     color: AppColors.kBgColor,
//                   ),
//                   AppSpacer(
//                     wp: .02,
//                   ),
//                   Text(
//                     title,
//                     style: AppStyle.boldStyle(color: AppColors.kBgColor),
//                   )
//                 ],
//               ),
//               Icon(
//                 icon,
//                 color: AppColors.kBgColor,
//               )
//             ],
//           ),
//         ),
//       );

//   Widget _buildDevider() => Divider(
//         color: AppColors.kBgColor,
//         thickness: 2,
//       );

//   Widget _buildTile(String title, String data) => Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: ResponsiveHelper.wp * .25,
//             child: Text(
//               "${title}",
//               style: AppStyle.mediumStyle(fontSize: 15),
//             ),
//           ),
//           Text(
//             ":  ",
//             style: AppStyle.mediumStyle(fontSize: 15),
//           ),
//           Flexible(
//             child: Text(
//               "${data}",
//               style: AppStyle.boldStyle(fontSize: 15),
//             ),
//           )
//         ],
//       );
// }

import 'dart:developer';

import 'package:dazzles/core/components/app_loading.dart';
import 'package:dazzles/core/components/app_margin.dart';
import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/local/shared%20preference/login_red_database.dart';
import 'package:dazzles/core/shared/routes/const_routes.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/shared/theme/styles/text_style.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:dazzles/module/office/profile/presentation/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

class OtherUsersNaviagationScreen extends ConsumerStatefulWidget {
  const OtherUsersNaviagationScreen({super.key});

  @override
  ConsumerState<OtherUsersNaviagationScreen> createState() =>
      _DriverProfileState();
}

class _DriverProfileState extends ConsumerState<OtherUsersNaviagationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _profilePulseController;
  late Animation<double> _profilePulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _profilePulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _profilePulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profilePulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _profilePulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderSection(),
                  FutureBuilder(
                    future: LoginRefDataBase().getUserData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: AppLoading());
                      }
                      final userModel = snapshot.data;
                      return userModel == null
                          ? const SizedBox()
                          : _buildProfileContent(userModel);
                    },
                  ),
                  _buildLogoutSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Header background with gradient
        Container(
          alignment: Alignment.center,
          width: ResponsiveHelper.wp,
          height: ResponsiveHelper.hp * .35,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.kPrimaryColor,
                const Color(0xFFE5B9B5),
                const Color.fromARGB(255, 247, 230, 230)
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Company info
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "DAZZLES",
                      style: GoogleFonts.roboto(
                        fontSize: ResponsiveHelper.wp * .12,
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        letterSpacing: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "MYSORE | BANGALORE",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          fontSize: ResponsiveHelper.wp * .035,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Profile avatar
        Positioned(
          bottom: -70,
          child: FutureBuilder(
            future: LoginRefDataBase().getUserData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: const Center(child: AppLoading()),
                );
              }
              final userModel = snapshot.data;
              return userModel == null
                  ? const SizedBox()
                  : AnimatedBuilder(
                      animation: _profilePulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _profilePulseAnimation.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  // AppColors.kPrimaryColor,
                                  // const Color(0xFF6366f1),
                                  AppColors.kPrimaryColor,
                                  const Color.fromARGB(255, 251, 233, 233)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: AppColors.kPrimaryColor.withOpacity(0.4),
                              //     blurRadius: 20,
                              //     offset: const Offset(0, 10),
                              //   ),
                              // ],
                            ),
                            child: Center(
                              child: Text(
                                userModel.userName![0].toUpperCase(),
                                style: AppStyle.largeStyle(
                                  fontSize: 60,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent(dynamic userModel) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: AppMargin(
        child: Column(
          children: [
            AppSpacer(hp: .12),
            _buildProfileInfoCard(userModel),
            AppSpacer(hp: .04),
            _buildNotificationButton(userModel),
            AppSpacer(hp: .03),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(dynamic userModel) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: ResponsiveHelper.wp,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background decoration
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kPrimaryColor.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      color: AppColors.kPrimaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Profile Information",
                      style: AppStyle.boldStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildEnhancedTile("User Name", userModel.userName ?? 'N/A'),
                _buildEnhancedDivider(),
                _buildEnhancedTile("Role", userModel.role ?? 'N/A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(dynamic userModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            log(userModel.pushToken ?? '');
            context.push(notificationScreen);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    CupertinoIcons.bell_fill,
                    color: AppColors.kPrimaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Notifications",
                    style: AppStyle.boldStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.arrow_right,
                    color: Colors.white70,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFef4444),
              Color(0xFFdc2626),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFef4444).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              ProfilePageNew.showLogoutConfirmation(context, ref);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    SolarIconsOutline.logout,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Logout",
                    style: AppStyle.boldStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTile(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.wp * .25,
            child: Text(
              title,
              style: AppStyle.mediumStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
          Text(
            ": ",
            style: AppStyle.mediumStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: AppStyle.boldStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
}
