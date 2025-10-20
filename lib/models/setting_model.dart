import 'model.dart';

class Setting extends Model {
  String? appName;
  bool? enableStripe;
  String? defaultTax;
  String? defaultCurrency;
  String? fcmKey;
  bool? enablePaypal;
  String? defaultTheme;
  String? mainColor;
  String? mainDarkColor;
  String? secondColor;
  String? secondDarkColor;
  String? accentColor;
  String? accentDarkColor;
  String? scaffoldDarkColor;
  String? scaffoldColor;
  String? googleMapsKey;
  String? mobileLanguage;
  String? defaultCountryCode;
  String? appVersion;
  String? jitsiMeetLink;
  bool? enableVersion;
  bool? currencyRight;
  int? defaultCurrencyDecimalDigits;
  bool? enableRazorpay;
  String? distanceUnit;
  bool? enableOtp;
  List? modules;
  bool? enablePaymentBeforeAppointmentIsCompleted;

  Setting(
      {this.appName,
      this.enableStripe,
      this.defaultTax,
      this.defaultCurrency,
      this.fcmKey,
      this.enablePaypal,
      this.mainColor,
      this.mainDarkColor,
      this.secondColor,
      this.secondDarkColor,
      this.accentColor,
      this.accentDarkColor,
      this.scaffoldDarkColor,
      this.scaffoldColor,
      this.googleMapsKey,
      this.mobileLanguage,
      this.defaultCountryCode,
      this.appVersion,
      this.jitsiMeetLink,
      this.enableVersion,
      this.currencyRight,
      this.defaultCurrencyDecimalDigits,
      this.enableRazorpay,
      this.distanceUnit,
      this.enableOtp,
      this.modules,
      this.enablePaymentBeforeAppointmentIsCompleted
      });

  Setting.fromJson(Map<String, dynamic>? json) {
    appName = json?['app_name'];
    defaultTax = json?['default_tax'];
    defaultCurrency = json?['default_currency'];
    fcmKey = json?['fcm_key'];
    defaultTheme = json?['default_theme'];
    mainColor = json?['main_color'];
    mainDarkColor = json?['main_dark_color'];
    secondColor = json?['second_color'];
    secondDarkColor = json?['second_dark_color'];
    accentColor = json?['accent_color'];
    accentDarkColor = json?['accent_dark_color'];
    scaffoldDarkColor = json?['scaffold_dark_color'];
    scaffoldColor = json?['scaffold_color'];
    googleMapsKey = json?['google_maps_key'];
    mobileLanguage = json?['mobile_language'];
    defaultCountryCode = json?['default_country_code'];
    appVersion = json?['app_version'];
    jitsiMeetLink = stringFromJson(json,'jitsi_meet_link');
    enableVersion = boolFromJson(json, 'enable_version');
    currencyRight = boolFromJson(json, 'currency_right');
    enableRazorpay = boolFromJson(json, 'enable_razorpay');
    enableStripe = boolFromJson(json, 'enable_stripe');
    enablePaypal = boolFromJson(json, 'enable_paypal');
    defaultCurrencyDecimalDigits = int.tryParse(json?['default_currency_decimal_digits'] ?? '2') ?? 2;
    distanceUnit = stringFromJson(json, 'distance_unit');
    enableOtp = boolFromJson(json, 'enable_otp');
    enablePaymentBeforeAppointmentIsCompleted = boolFromJson(json, 'enable_payment_before_appointment_is_completed');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_name'] = appName;
    data['enable_stripe'] = enableStripe;
    data['default_tax'] = defaultTax;
    data['default_currency'] = defaultCurrency;
    data['fcm_key'] = fcmKey;
    data['enable_paypal'] = enablePaypal;
    data['main_color'] = mainColor;
    data['default_theme'] = defaultTheme;
    data['main_dark_color'] = mainDarkColor;
    data['second_color'] = secondColor;
    data['second_dark_color'] = secondDarkColor;
    data['accent_color'] = accentColor;
    data['accent_dark_color'] = accentDarkColor;
    data['scaffold_dark_color'] = scaffoldDarkColor;
    data['scaffold_color'] = scaffoldColor;
    data['google_maps_key'] = googleMapsKey;
    data['mobile_language'] = mobileLanguage;
    data['default_country_code'] = defaultCountryCode;
    data['app_version'] = appVersion;
    data['jitsi_meet_link'] = jitsiMeetLink;
    data['enable_version'] = enableVersion;
    data['currency_right'] = currencyRight;
    data['default_currency_decimal_digits'] = defaultCurrencyDecimalDigits;
    data['enable_razorpay'] = enableRazorpay;
    data['distance_unit'] = distanceUnit;
    data['enable_otp'] = enableOtp;
    data['enable_payment_before_appointment_is_completed'] = enablePaymentBeforeAppointmentIsCompleted;
    return data;
  }
}
