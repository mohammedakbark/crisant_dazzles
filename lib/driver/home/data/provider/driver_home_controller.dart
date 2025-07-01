import 'package:dazzles/driver/home/data/repo/driver_qr_code_scan_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final qrCodeRedControllerProvider = FutureProvider.family.autoDispose(
  (ref, String qrCode) async {
    final response = await DriverQrCodeScanRepo.onScanQrCode(qrCode);
    if(response['error']==false){
      return response['data'];
    }else{
      return "";
    }
  },
);
