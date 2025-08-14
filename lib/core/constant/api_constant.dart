class ApiConstants {
  static const String baseUrl = "https://bill.dazzles.in/Api/api/mobile/";
  static const localHostBaseURL = "http://192.168.1.29:5173/api/mobile/";

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

//PO

  static const String allPurchases = "purchase";
  static const String getPurshaseOrderProducts = "purchase/order";

  // Other Module

  static const String loginWithMobile = "mobilelogin";
  static const String verifyMobileOTP = "verifyotp";

  static const String userRoles = 'roles';

  static const String setTokenURL = "notification/token";
  static const String getNotificationsURL = "notification";

  // DRIVER MODULE
  static const drDashboardData = "valet/dailyvalet";
// check in
  static const String drCheckInScanQrCode = "valet/scan/qrcode";
  static const String drSuggestCustomer = "valet/customernumber";
  static const String drSuggestCustomerVehicles = "valet/carsuggestion";
  static const String drSubmitVehicle = "valet/check-in";
  static const String drUploadInitialVideo = "valet/checkin-video";

  // check out

  static const drCheckOutQrScan = "valet/parklocation";
  static const String drUploadLastVideo = "valet/checkout-video";

  static const String drGetAllParkedCarList = "valet/valetlist";
  static const String drGetMyParkedCarList = "valet/valetlist";
  static const getAllStoresList = "valet/storelist";
}
