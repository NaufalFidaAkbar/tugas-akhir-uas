import 'dart:developer';
import '../../../models/coupon.dart';
import '../../login_screen/provider/user_provider.dart';
import '../../../services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';
import 'dart:convert'; // Pastikan untuk mengimpor package `dart:convert`

class CartProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final box = GetStorage();
  Razorpay razorpay = Razorpay();
  final UserProvider _userProvider;
  var flutterCart = FlutterCart();
  List<CartModel> myCartItems = [];

  final GlobalKey<FormState> buyNowFormKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  bool isExpanded = false;

  Coupon? couponApplied;
  double couponCodeDiscount = 0;
  String selectedPaymentOption = 'prepaid';

  CartProvider(this._userProvider);

  clearCouponDiscount() {
    couponApplied = null;
    couponCodeDiscount = 0;
    couponController.text = '';
    notifyListeners();
  }

  void retrieveSavedAddress() {
    phoneController.text = box.read(PHONE_KEY) ?? '';
    streetController.text = box.read(STREET_KEY) ?? '';
    cityController.text = box.read(CITY_KEY) ?? '';
    stateController.text = box.read(STATE_KEY) ?? '';
    postalCodeController.text = box.read(POSTAL_CODE_KEY) ?? '';
    countryController.text = box.read(COUNTRY_KEY) ?? '';
  }

  // Menggunakan method postRequest
  Future<void> stripePayment({required void Function() operation}) async {
    try {
      Map<String, dynamic> paymentData = {
        // "email": _userProvider.getLoginUsr()?.username,
        // "name": _userProvider.getLoginUsr()?.username,
        "address": {
          "line1": streetController.text,
          "city": cityController.text,
          "state": stateController.text,
          "postal_code": postalCodeController.text,
          "country": "US"
        },
        "amount": 100, //TODO: Update dengan grand total cart
        "currency": "usd",
        "description": "Your transaction description"
      };

      // Menggunakan postRequest
      final response = await service.postRequest(
        endpoint:
            '/api/stripe-payment', // Sesuaikan dengan endpoint backend Stripe kamu
        headers: {'Content-Type': 'application/json'},
        body: paymentData,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Perbaikan di sini
        final paymentIntent = data['paymentIntent'];
        final ephemeralKey = data['ephemeralKey'];
        final customer = data['customer'];
        final publishableKey = data['publishableKey'];

        Stripe.publishableKey = publishableKey;
        BillingDetails billingDetails = BillingDetails(
          // email: _userProvider.getLoginUsr()?.username,
          phone: '85369708079',
          // name: _userProvider.getLoginUsr()?.username,
          address: Address(
              country: 'INA',
              city: cityController.text,
              line1: streetController.text,
              line2: stateController.text,
              postalCode: postalCodeController.text,
              state: stateController.text),
        );

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            customFlow: false,
            merchantDisplayName: 'MOBIZATE',
            paymentIntentClientSecret: paymentIntent,
            customerEphemeralKeySecret: ephemeralKey,
            customerId: customer,
            style: ThemeMode.light,
            billingDetails: billingDetails,
          ),
        );

        await Stripe.instance.presentPaymentSheet().then((value) {
          log('payment success');
          //? Do the success operation
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text('Payment Success')),
          );
          operation();
        }).onError((error, stackTrace) {
          if (error is StripeException) {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('${error.error.localizedMessage}')),
            );
          } else {
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text('Stripe Error: $error')),
            );
          }
        });
      } else {
        // Jika tidak status 200, error handling
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Payment failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  // Menggunakan method postRequest
  Future<void> razorpayPayment({required void Function() operation}) async {
    try {
      final response = await service.postRequest(
        endpoint:
            '/api/razorpay-payment', // Sesuaikan dengan endpoint backend Razorpay kamu
        headers: {'Content-Type': 'application/json'},
        body: {}, // Tambahkan data jika perlu
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Perbaikan di sini
        String? razorpayKey = data['key'];
        if (razorpayKey != null && razorpayKey != '') {
          var options = {
            'key': razorpayKey,
            'amount': 100, //TODO: Update dengan grand total cart
            'name': "user",
            "currency": 'INR',
            'description': 'Your transaction description',
            'send_sms_hash': true,
            "prefill": {
              // "email": _userProvider.getLoginUsr()?.username,
              "contact": ''
            },
            "theme": {'color': '#FFE64A'},
            "image":
                'https://store.rapidflutter.com/digitalAssetUpload/rapidlogo.png',
          };
          razorpay.open(options);
          razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
              (PaymentSuccessResponse response) {
            operation();
            return;
          });
          razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
              (PaymentFailureResponse response) {
            SnackBarHelper.showErrorSnackBar('Error ${response.message}');
            return;
          });
        }
      } else {
        // Error handling jika status bukan 200
        SnackBarHelper.showErrorSnackBar('Payment failed: ${response.body}');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('Error $e');
      return;
    }
  }

  void updateUI() {
    notifyListeners();
  }
}
