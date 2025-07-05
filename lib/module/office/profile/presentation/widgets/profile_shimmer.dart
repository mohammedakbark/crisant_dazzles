import 'package:dazzles/core/components/app_spacer.dart';
import 'package:dazzles/core/shared/theme/app_colors.dart';
import 'package:dazzles/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';

class AnimatedProfileShimmer extends StatefulWidget {
  const AnimatedProfileShimmer({super.key});

  @override
  State<AnimatedProfileShimmer> createState() => _AnimatedProfileShimmerState();
}

class _AnimatedProfileShimmerState extends State<AnimatedProfileShimmer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            // Avatar with pulsing animation
            Stack(
              children: [
                Container(
                  width: ResponsiveHelper.wp * .7,
                  height: ResponsiveHelper.hp * .2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(_animation.value * 0.4),
                        Colors.white.withOpacity(_animation.value * 0.2),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),

                // Animated status indicator
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_animation.value * 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ],
            ),

            AppSpacer(hp: .03),

            // Animated username bar
            Container(
              height: 28,
              width: ResponsiveHelper.wp * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withOpacity(_animation.value * 0.3),
                    Colors.white.withOpacity(_animation.value * 0.5),
                    Colors.white.withOpacity(_animation.value * 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            AppSpacer(hp: .015),

            // Animated role badge
            Container(
              height: 28,
              width: ResponsiveHelper.wp * 0.25,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.kPrimaryColor.withOpacity(_animation.value * 0.3),
                    AppColors.kPrimaryColor.withOpacity(_animation.value * 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.kPrimaryColor
                      .withOpacity(_animation.value * 0.2),
                ),
              ),
            ),

            AppSpacer(hp: .03),

            // Animated store info
            Container(
              height: 44,
              width: ResponsiveHelper.wp * 0.35,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_animation.value * 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(_animation.value * 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_animation.value * 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 16,
                    width: ResponsiveHelper.wp * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_animation.value * 0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}




// // import 'package:dazzles/core/components/app_spacer.dart';
// // import 'package:dazzles/core/components/shimmer_effect.dart';
// // import 'package:dazzles/core/utils/responsive_helper.dart';
// // import 'package:flutter/material.dart';

// // class ProfileShimmer extends StatelessWidget {
// //   const ProfileShimmer({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ShimmerEffect(
// //       child: Column(
// //         children: [
// //           Row(
// //             children: [
// //               CircleAvatar(radius: 70),
// //               AppSpacer(wp: .05),
// //               Flexible(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     ShimmerEffect.placeHolder(
// //                       height: 12,
// //                       width: ResponsiveHelper.wp * .23,
// //                     ),
// //                     AppSpacer(hp: .01),
// //                    ShimmerEffect.placeHolder(
// //                       height: 7,
// //                       width: ResponsiveHelper.wp * .45,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           AppSpacer(hp: .05),
// //           ShimmerEffect.placeHolder(
// //             height: 10,
// //             width: ResponsiveHelper.wp * .7,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:dazzles/core/components/app_spacer.dart';
// import 'package:dazzles/core/utils/responsive_helper.dart';
// import 'package:dazzles/core/shared/theme/app_colors.dart';

// class EnhancedProfileShimmer extends StatelessWidget {
//   const EnhancedProfileShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.white.withOpacity(0.1),
//       highlightColor: Colors.white.withOpacity(0.3),
//       period: const Duration(milliseconds: 1500),
//       child: Column(
//         children: [
//           // Avatar Shimmer with gradient background
//           Stack(
//             children: [
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.white.withOpacity(0.2),
//                       Colors.white.withOpacity(0.1),
//                     ],
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Status indicator shimmer
//               Positioned(
//                 bottom: 8,
//                 right: 8,
//                 child: Container(
//                   width: 20,
//                   height: 20,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 3),
//                   ),
//                 ),
//               ),
//             ],
//           ),
          
//           AppSpacer(hp: .03),
          
//           // Username Shimmer
//           Container(
//             height: 28,
//             width: ResponsiveHelper.wp * 0.4,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
          
//           AppSpacer(hp: .015),
          
//           // Role Badge Shimmer
//           Container(
//             height: 28,
//             width: ResponsiveHelper.wp * 0.25,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.1),
//               ),
//             ),
//           ),
          
//           AppSpacer(hp: .03),
          
//           // Store Info Shimmer
//           Container(
//             height: 44,
//             width: ResponsiveHelper.wp * 0.35,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.05),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 18,
//                   height: 18,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   height: 16,
//                   width: ResponsiveHelper.wp * 0.2,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Alternative animated shimmer without shimmer package dependency
// class AnimatedProfileShimmer extends StatefulWidget {
//   const AnimatedProfileShimmer({super.key});

//   @override
//   State<AnimatedProfileShimmer> createState() => _AnimatedProfileShimmerState();
// }

// class _AnimatedProfileShimmerState extends State<AnimatedProfileShimmer>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _animation = Tween<double>(
//       begin: 0.3,
//       end: 0.7,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//     _controller.repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Column(
//           children: [
//             // Avatar with pulsing animation
//             Stack(
//               children: [
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Colors.white.withOpacity(_animation.value * 0.4),
//                         Colors.white.withOpacity(_animation.value * 0.2),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 // Animated status indicator
//                 Positioned(
//                   bottom: 8,
//                   right: 8,
//                   child: Container(
//                     width: 20,
//                     height: 20,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(_animation.value * 0.6),
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 3),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
            
//             AppSpacer(hp: .03),
            
//             // Animated username bar
//             Container(
//               height: 28,
//               width: ResponsiveHelper.wp * 0.4,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                   colors: [
//                     Colors.white.withOpacity(_animation.value * 0.3),
//                     Colors.white.withOpacity(_animation.value * 0.5),
//                     Colors.white.withOpacity(_animation.value * 0.3),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
            
//             AppSpacer(hp: .015),
            
//             // Animated role badge
//             Container(
//               height: 28,
//               width: ResponsiveHelper.wp * 0.25,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.kPrimaryColor.withOpacity(_animation.value * 0.3),
//                     AppColors.kPrimaryColor.withOpacity(_animation.value * 0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: AppColors.kPrimaryColor.withOpacity(_animation.value * 0.2),
//                 ),
//               ),
//             ),
            
//             AppSpacer(hp: .03),
            
//             // Animated store info
//             Container(
//               height: 44,
//               width: ResponsiveHelper.wp * 0.35,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(_animation.value * 0.15),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(_animation.value * 0.1),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: 18,
//                     height: 18,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(_animation.value * 0.4),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     height: 16,
//                     width: ResponsiveHelper.wp * 0.2,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(_animation.value * 0.4),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// // Skeleton shimmer with wave effect
// class WaveShimmerProfile extends StatefulWidget {
//   const WaveShimmerProfile({super.key});

//   @override
//   State<WaveShimmerProfile> createState() => _WaveShimmerProfileState();
// }

// class _WaveShimmerProfileState extends State<WaveShimmerProfile>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Column(
//           children: [
//             // Avatar with wave shimmer
//             _buildShimmerContainer(
//               width: 120,
//               height: 120,
//               borderRadius: 60,
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 8,
//                     right: 8,
//                     child: _buildShimmerContainer(
//                       width: 20,
//                       height: 20,
//                       borderRadius: 10,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             AppSpacer(hp: .03),
            
//             // Username shimmer
//             _buildShimmerContainer(
//               height: 28,
//               width: ResponsiveHelper.wp * 0.4,
//               borderRadius: 14,
//             ),
            
//             AppSpacer(hp: .015),
            
//             // Role badge shimmer
//             _buildShimmerContainer(
//               height: 28,
//               width: ResponsiveHelper.wp * 0.25,
//               borderRadius: 20,
//             ),
            
//             AppSpacer(hp: .03),
            
//             // Store info shimmer
//             _buildShimmerContainer(
//               height: 44,
//               width: ResponsiveHelper.wp * 0.35,
//               borderRadius: 16,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildShimmerContainer({
//     required double width,
//     required double height,
//     required double borderRadius,
//     Widget? child,
//   }) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(borderRadius),
//         gradient: LinearGradient(
//           begin: Alignment(_animation.value - 1, 0),
//           end: Alignment(_animation.value, 0),
//           colors: [
//             Colors.white.withOpacity(0.1),
//             Colors.white.withOpacity(0.3),
//             Colors.white.withOpacity(0.1),
//           ],
//           stops: const [0.0, 0.5, 1.0],
//         ),
//       ),
//       child: child,
//     );
//   }
// }

// // Simple but elegant shimmer
// class ProfileShimmer extends StatelessWidget {
//   const ProfileShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Use the animated version for best UX
//     return const AnimatedProfileShimmer();
//   }
// }



