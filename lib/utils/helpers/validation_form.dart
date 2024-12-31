import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:regexpattern/regexpattern.dart';

class ValidationForm {
  static String? dateValidator(value) {
    if (value.isEmpty) {
      return "برجاء ادخال التاريخ";
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    //validation for egypt phone
    bool isValid =
        RegExp(r"^(\+201|1|01|00201)[0-2,5]{1}[0-9]{8}").hasMatch(value!);

    if (value.isEmpty) {
      return AppStrings.pleaseEnterPhoneNumber;
    } else if (value.length < 10 || !isValid) {
      return AppStrings.pleaseEnterValidPhoneNumber;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!);
    if (!emailValid) {
      return AppStrings.pleaseEnterValidEmail;
    }
    return null;
  }

  static String? websiteValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    // Add further validation for proper link format if necessary
    final urlPattern = r'^(http|https):\/\/[^\s$.?#].[^\s]*$';
    final result = RegExp(urlPattern, caseSensitive: false).hasMatch(value);
    if (!result) {
      return 'Please enter a valid link';
    }
    return null;
  }

  static String? passwordValidator(String? v) {
    if (v?.isEmpty ?? true) {
      return "[TYPE YOUR TEXT]";
    } else if (v!.length <= 5) {
      return "[TYPE YOUR TEXT]";
    } else {
      return null;
    }
  }

  static String? confirmPasswordValidator(
    String v,
    String text,
  ) {
    if (v.isEmpty) {
      return "[TYPE YOUR TEXT]";
    } else if (text != v) {
      return "[TYPE YOUR TEXT]";
    } else {
      return null;
    }
  }

  static String? firstNameValidator(String? v) {
    if ((v?.isEmpty ?? true)) {
      return AppStrings.pleaseEnterName;
    } else {
      return null;
    }
  }

  static String? detailsValidator(String? v) {
    if ((v?.isEmpty ?? true)) {
      return AppStrings.pleaseEnterDetails;
    } else {
      return null;
    }
  }

  static String? lastNameValidator(String? v) {
    bool isValid = RegVal.hasMatch(v, RegexPattern.noWhitespace);

    if ((v?.isEmpty ?? true)) {
      return "[TYPE YOUR TEXT]";
    } else if (!isValid) {
      return "[TYPE YOUR TEXT]";
    } else {
      return null;
    }
  }

  static String? codeValidator(String? v) {
    bool isValid = RegVal.hasMatch(v, RegexPattern.noWhitespace);

    if ((v!.isEmpty || v.length < 6)) {
      return AppStrings.pleaseEnterValidCode;
    } else if (!isValid) {
      return AppStrings.pleaseEnterValidCode;
    } else {
      return null;
    }
  }

  static String? userNameValidator(String? v, [isUserNameTaken = false]) {
    bool isValid = v?.isUsernameInstagram() ?? false;

    if ((v?.isEmpty ?? true)) {
      return "[TYPE YOUR TEXT]";
    } else if (!isValid) {
      return "[TYPE YOUR TEXT]";
    } else if (isUserNameTaken) {
      return "[TYPE YOUR TEXT]";
    } else {
      return null;
    }
  }
}
