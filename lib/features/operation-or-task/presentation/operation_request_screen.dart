import 'package:dazzles/core/components/app_back_button.dart';
import 'package:flutter/material.dart';

class OperationRequestScreen extends StatelessWidget {
  const OperationRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: AppBarText(title: "Operation Requests"),
      ),
    );
  }
}
