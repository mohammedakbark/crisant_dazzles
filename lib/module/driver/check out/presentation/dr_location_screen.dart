import 'dart:developer';

import 'package:dazzles/module/driver/home/data/model/dr_check_out_valet_info_model.dart';
import 'package:flutter/material.dart';

class DrLocationScreen extends StatefulWidget {
  final DrCheckOutValetInfoModel valetInfo;
  const DrLocationScreen({super.key, required this.valetInfo});

  @override
  State<DrLocationScreen> createState() => _DrLocationScreenState();
}

class _DrLocationScreenState extends State<DrLocationScreen> {
  @override
  void initState() {
    log("lat : ${widget.valetInfo.latt}");
    log("lon : ${widget.valetInfo.long}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
