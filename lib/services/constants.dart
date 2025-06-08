import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PriceConverter {
  static convert(price) {
    return '₹ ${double.parse('$price').toStringAsFixed(2)}';
  }

  static convertRound(price) {
    return '₹ ${double.parse('$price').toInt()}';
  }

  static convertToNumberFormat(num price) {
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(price)}';
  }
}

void showCustomToast(msg, {color}) {
  Fluttertoast.showToast(
    msg: "$msg",
    backgroundColor: color,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    webPosition: "center",
    webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
  );
}

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}

class AppConstants {
  String get getBaseUrl => baseUrl;

  static bool isProductionMode = true;

  static String get baseUrl {
    if (!kDebugMode || isProductionMode) return 'https://appdid.in/';
    return 'http://192.168.1.26:8000/';
  }

  static String appName = '';
  static String packageName = '';
  static String version = '';
  static String buildNumber = '';

  static String googleMapApiKey = 'AIzaSyCPMgv3duvS967kagdXKvcn0eD72L3sdF4';

  static const String agoraAppId = 'c87b710048c049f59570bd1895b7e561';

  static const String loginUri = 'api/user/v1/auth/otp/send';
  static const String verifyOtp = 'api/user/v1/auth/otp/verify';

  static const String logOutUri = 'api/user/v1/auth/logout';
  static const String registerUri = 'api/user/v1/auth/register';
  static const String profileUri = 'api/user/v1/basic/profile';
  static const String banner = 'api/user/v1/basic/banners';

  static const String storegoodsbooking = 'api/user/v1/goods/bookings';
  static const String fetchvehicles = 'api/user/v1/basic/vehicles';
  static const String getgoodstype = 'api/user/v1/goods/types';
  static const String getbookings = 'api/user/v1/goods/bookings';
  // static const String getbookingsById = 'api/user/v1/goods/bookings';
  static const String businessSettings = 'api/v1/settings';
  static const String gethomeitems = 'api/v1/home-items';

  static const String storepackerandmoverbooking =
      'api/user/v1/packers-and-movers/bookings';
  static const String getlistpackerandmoversbookings =
      'api/user/v1/packers-and-movers/bookings';
  static const String getpackagestypes = 'api/user/v1/two-wheeler/package-type';
  static const String calculatetwowheelerdeliveryamount =
      'api/user/v1/two-wheeler/calculate-delivery-amount';
  static const String verifypromocode =
      'api/user/v1/two-wheeler/verify-promo-code';
  static const String storetwowheelerbookings =
      'api/user/v1/two-wheeler/bookings';

  static const String gettwowheelerbookings =
      'api/user/v1/two-wheeler/bookings';

  static const String cancelTwoWheelerOrder =
      'api/user/v1/two-wheeler/bookings/cancel';

  static const String gettempolist = "api/user/v1/two-wheeler/trucks";

  static const String faqs = "api/user/v1/basic/faqs";

  static const String states = 'api/v1/states';
  static const String extras = 'api/v1/extra';

  // Easebuzz
  static const String createpayment = 'api/user/v1/goods/easebuzz/create';
  static const String fetchpayment = 'api/user/v1/goods/easebuzz/fetch';

  // Two Wheeler Payment
  static const String createtwowheelerpayment =
      'api/user/v1/two-wheeler/easebuzz/create';
  static const String fetchtwowheelerpayment =
      'api/user/v1/two-wheeler/easebuzz/fetch';

  // car and bike

  static const String carandbikebooking = 'api/user/v1/car-and-bike/bookings';

  static const String fetchcarandbikebooking =
      'api/user/v1/car-and-bike/bookings';

  // edit profile
  static const String editprofile = 'api/user/v1/basic/update-profile';

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';

  static const String imagemap =
      "https://s3-alpha-sig.figma.com/img/8414/f553/d63d5bbb1407c481ba3903df9c12c80b?Expires=1743984000&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=hLUCpnYfVhw0UKdfWXi7axsterL6CZSbnxOuDg8Y7KuMVrjeHIk5ewCTN3XwyfA8SKvF8kS4Mj57UNy76GjJ93tY862svBpk59lhI0todsXQnPAWB854UTbucM-4sROiW1IG6XOM0L7Rt3TQ9zgr8qDj94oZmFaGLgj6BAtJWeFBklawRFv7o7FSaD3TydqXe~BqcFc2yb3BEXg3w4ZSqoqWVFJ7ttVH0SUEwK-2fYlDbY4Yg~OsKhWYXGYzd3tHB5prOzARC1mo1-4UCQBky8-mlvQTi0s~NNrxff4oyxhUpUXrkpp15dYovGdpmKh4e2kxCI2E7~L6UQO9X3gQsA__";
}
