import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../model/paypal_info_model.dart';

class PaypalInfoRepo {
  Future<PaypalInfoModel> getPaypalInfo() async {
    DatabaseReference paypalRef = FirebaseDatabase.instance.ref('Admin Panel/Paypal Info');
    final paypalData = await paypalRef.get();
    PaypalInfoModel paypalInfoModel = PaypalInfoModel.fromJson(jsonDecode(jsonEncode(paypalData.value)));

    return paypalInfoModel;
  }
}
