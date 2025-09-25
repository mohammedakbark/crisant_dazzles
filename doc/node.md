# 📒 Dazzles App – Notes

## 📌 Overview

Dazzles is a **textiles company internal application**, built exclusively for staff.
The app is developed using **Flutter (iOS + Android)** with a **Node.js backend**, and uses **Firebase** for push notifications.

It provides complete insights into **products, stock, staff check-in/out, valet support for drivers, and scanning-based product lookup**.

---

## ✅ Current Features

### 🔹 Product Management

* View products in stock / out of stock.
* Track purchased products.
* Update product images.
* Scan product barcode/QR to view:

  * Availability by store.
  * Quantity in each store.
  * Available colors and sizes.

### 🔹 Staff Utilities

* Staff check-in and check-out functionality.
* Valet support for drivers (easy car parking assignment).

### 🔹 Notifications

* Push notifications powered by **Firebase Messaging**.
* Local notifications supported.

### 🔹 Media & File Handling

* Product image capture, cropping, and compression.
* Video playback support.

### 🔹 Location & Maps

* Geolocation services for tracking.
* Google Maps integration.

---

## ⚙️ Tech Stack

* **Frontend:** Flutter (Dart 3.x)
* **Backend:** Node.js
* **Notifications:** Firebase Cloud Messaging (FCM)
* **Database (Local):** Hive for lightweight storage
* **State Management:** Riverpod

---

## 📦 Dependencies (Major)

* **UI/UX:**

  * `go_router`, `google_fonts`, `solar_icons`, `badges`, `animated_text_kit`, `shimmer`, `animate_do`, `flutter_staggered_animations`
* **Networking & Data:**

  * `dio`, `shared_preferences`, `hive`, `hive_flutter`
* **Media & Files:**

  * `cached_network_image`, `image_picker`, `photo_view`, `image_cropper`, `flutter_image_compress`, `video_player`, `camera`
* **Utilities:**

  * `flutter_local_notifications`, `firebase_messaging`, `geolocator`, `google_maps_flutter`, `url_launcher`, `flutter_dotenv`, `upgrader`

*(See `pubspec.yaml` for the complete list.)*

---

## 🚀 Future Improvements / To-Do

1. **Inventory Enhancements**

   * Low-stock alerts.
   * Automated reorder suggestions.
   * Analytics dashboards for product trends.

2. **Staff & Operations**

   * Role-based access control (Admin, Manager, Staff, Driver).
   * Shift scheduling & attendance reports.
   * Valet real-time parking slot management.

3. **Product Scanning & Insights**

   * Multi-scan mode (batch scanning).
   * Offline scanning support with sync.

4. **Notifications**

   * Topic-based notifications (per store/department).
   * Rich media notifications (images, action buttons).

5. **User Experience**

   * Dark mode.
   * Multi-language support (starting with English + local language).
   * Enhanced search & filter for products.

6. **Integration**

   * ERP system sync (for real-time stock updates).
   * Payment gateway (if staff purchases are allowed).

7. **Security**

   * Two-factor authentication (2FA).
   * Biometric login (Face ID / Fingerprint).
   * Secure API token refresh mechanism.

---

## 📂 Project Info

* **App Name:** Dazzles
* **Current Version:** `3.4.0+23P`
* **Supported Platforms:** iOS, Android
* **Status:** In development, internal staff-only release.
