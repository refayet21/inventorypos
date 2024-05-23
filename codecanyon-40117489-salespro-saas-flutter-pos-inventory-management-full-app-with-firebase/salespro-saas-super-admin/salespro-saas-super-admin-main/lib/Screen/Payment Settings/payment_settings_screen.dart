// ignore_for_file: unused_result

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_saas_admin/Provider/paypal_info_provider.dart';
import 'package:salespro_saas_admin/model/paypal_info_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Pop Up/Reports/view_reports.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/Topbar/topbar.dart';

class PaymentSettings extends StatefulWidget {
  const PaymentSettings({Key? key}) : super(key: key);

  static const String route = '/payment_settings';

  @override
  State<PaymentSettings> createState() => _PaymentSettingsState();
}

class _PaymentSettingsState extends State<PaymentSettings> {
  void showViewReportPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const ViewReport(),
        );
      },
    );
  }

  void postDataIfNoData({required WidgetRef ref}) async {
    PaypalInfoModel paypalInfoModel = PaypalInfoModel(paypalClientId: 'paypalClientId', paypalClientSecret: 'paypalClientSecret', isLive: true);
    final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Paypal Info');
    adRef.set(paypalInfoModel.toJson());

    ///____provider_refresh____________________________________________
    ref.refresh(paypalInfoProvider);
  }

  bool isLive = false;
  String id = '';
  String secret = '';

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Consumer(
        builder: (_, ref, watch) {
          final reports = ref.watch(paypalInfoProvider);

          return reports.when(
            data: (reports) {
              i == 0 ? isLive = reports.isLive : null;
              i == 0 ? id = reports.paypalClientId : null;
              i == 0 ? secret = reports.paypalClientSecret : null;
              i++;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: SideBarWidget(
                      index: 5,
                      isTab: false,
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6.0),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: kWhiteTextColor,
                              ),
                              child: const TopBar(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Payment Settings',
                                      style: kTextStyle.copyWith(color: kTitleColor, fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10.0),
                                    const Divider(
                                      height: 1,
                                      color: Colors.black12,
                                    ),
                                    const SizedBox(height: 10.0),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          const Text('PayPal:', style: TextStyle(fontSize: 16)),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 130,
                                                height: 50,
                                                alignment: Alignment.centerLeft,
                                                child: const Text('Is Live'),
                                              ),
                                              const SizedBox(width: 20),
                                              CupertinoSwitch(
                                                trackColor: Colors.red,
                                                value: isLive,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isLive = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 130,
                                                height: 50,
                                                alignment: Alignment.centerLeft,
                                                child: const Text('PayPal Clint Id'),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 500,
                                                child: TextFormField(
                                                  initialValue: reports.paypalClientId,
                                                  onChanged: (value) {
                                                    id = value;
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 130,
                                                height: 50,
                                                alignment: Alignment.centerLeft,
                                                child: const Text('PayPal Clint Secret'),
                                              ),
                                              const SizedBox(width: 20),
                                              SizedBox(
                                                width: 500,
                                                child: TextFormField(
                                                  initialValue: reports.paypalClientSecret,
                                                  onChanged: (value) {
                                                    secret = value;
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: 650,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: (() {
                                                    Navigator.pop(context);
                                                    const PaymentSettings().launch(context);
                                                  }),
                                                  child: Container(
                                                    width: 100,
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: Colors.red),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Cancel',
                                                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (reports.isLive != isLive || reports.paypalClientId != id || reports.paypalClientSecret != secret) {
                                                      EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                                                      final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Paypal Info');
                                                      await adRef.update({
                                                        'isLive': isLive,
                                                        'paypalClientId': id,
                                                        'paypalClientSecret': secret,
                                                      });
                                                      EasyLoading.showSuccess('Added Successfully');

                                                      ///____provider_refresh____________________________________________
                                                      ref.refresh(paypalInfoProvider);
                                                    } else {
                                                      EasyLoading.showError('No change found!');
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          'Save',
                                                          style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              );
            },
            error: (e, stack) {
              if (e.toString() == "Expected a value of type 'Map<dynamic, dynamic>', but got one of type 'Null'") {
                postDataIfNoData(ref: ref);
              }
              return Center(
                child: Text(e.toString()),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
