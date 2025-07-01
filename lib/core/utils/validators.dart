class AppValidator {
  static String? mobileNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Mobile number is required";
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Mobile number must be exactly 10 digits";
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter the OTP";
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return "OTP must be exactly 6 digits";
    }
    return null;
  }

  // Validators
  static String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "This field is required";
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value))
      return "Enter a valid email";
    return null;
  }

  static String? vehicleNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Reg. No. is required";
    if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z]{1,2}\d{4}$').hasMatch(value)) {
      return "Enter the valid Reg. No.";
    }

    return null;
  }
}
