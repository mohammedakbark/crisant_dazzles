class ApiConstants {
  static const String baseUrl = "https://bill.dazzles.in/Api/api/mobile/";
  static const localHostBaseURL = "http://192.168.31.79:5173/api/";

  //  "https://api.dazzles.in/api/mobile/";
  //  "https://test.dazzles.in/";
  static const String imageBaseUrl = "https://bill.dazzles.in/";
  static const String login = "login";
  static const String profile = "profile";
  static const String dashboard = "dashboard";
  static const String dashboardRecentlyCaptured = "dashboard/recentCaptured";

  static const String allProduct = "product";
  static const String productData = "product/view";
  static const String pendingProduct = "product/pending";
  static const String searchProduct = "dashboard/search";
  static const String updateImage = "product";

  static const String searchProductById = "upload/";

  // Other Module

  static const String loginWithMobile = "mobilelogin";
  static const String verifyMobileOTP = "verifyotp";

  static const String userRoles = 'roles';

  static const String setTokenURL = "notification/token";
  static const String getNotificationsURL = "notification";

  // Driver Module

  static const String drScanQrCode = "valetparking/scan/qrcode";
  static const String drSearchCustomer = "valetparking/customernumber";
  // static const String drRegisterCustomer = "valetparking/customer";
  static const receiveVehicle = "valetparking";
}
