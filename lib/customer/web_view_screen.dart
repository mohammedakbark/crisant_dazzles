// import 'package:dazzles/core/components/app_back_button.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewScreen extends StatefulWidget {
//   WebViewScreen({super.key});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController controller;
//   @override
//   initState() {
//     initWebView();
//     super.initState();
//   }

//   initWebView() {
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onHttpError: (HttpResponseError error) {},
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             // if (request.url.startsWith('https://www.youtube.com/')) {
//             //   return NavigationDecision.prevent;
//             // }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://dazzles.in'));
//   }

//   @override
//   void dispose() {
//     controller.clearCache();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             leading: AppBackButton(
//               goBack: () async {
//                 if (await controller.canGoBack()) {
//                   controller.goBack();
//                 } else {
//                   context.pop();
//                 }
//               },
//             ),
//           ),
//           body: WebViewWidget(controller: controller)),
//     );
//   }
// }
