// ignore_for_file: unused_result

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/currency_provider.dart';
import '../../model/currency_model.dart';
import '../Widgets/Constant Data/constant.dart';
import '../Widgets/Sidebar/sidebar_widget.dart';
import '../Widgets/Topbar/topbar.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  static const String route = '/currency';

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  void newCurrencyAdd({required WidgetRef ref, required List<CurrencyModel> list}) {
    CurrencyModel currencyModel = CurrencyModel(name: '', symbol: '');
    List<String> listOfOldCurrency = [];
    for (var element in list) {
      listOfOldCurrency.add(element.name.toLowerCase().trim());
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              currencyModel.name = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Currency Name',
                              hintText: 'Enter Currency Name',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            onChanged: (value) {
                              currencyModel.symbol = value;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Symbol',
                              hintText: 'Enter Currency Symbol',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (() => Navigator.pop(context)),
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
                            if (currencyModel.name != '' && currencyModel.symbol != '' && (!listOfOldCurrency.contains(currencyModel.name.toLowerCase().trim()))) {
                              EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                              final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Currency');
                              await adRef.push().set(currencyModel.toJson());
                              EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));

                              ///____provider_refresh____________________________________________
                              ref.refresh(currencyProvider);

                              Future.delayed(const Duration(milliseconds: 100), () {
                                Navigator.pop(context);
                              });
                            } else {
                              EasyLoading.showError('Please Enter name and symbol');
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
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<void> deleteCurrency({required WidgetRef updateRef, required String name}) async {
    EasyLoading.show(status: 'Deleting..');
    String imageKey = '';
    await FirebaseDatabase.instance.ref().child('Admin Panel').child('Currency').orderByKey().get().then((value) async {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['name'].toString() == name) {
          imageKey = element.key.toString();
        }
      }
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref("Admin Panel/Currency/$imageKey");
    await ref.remove();
    updateRef.refresh(currencyProvider);

    EasyLoading.showSuccess('Done');
  }

  void editCurrency({required WidgetRef updateRef, required CurrencyModel currencyModel}) {
    TextEditingController name = TextEditingController(text: currencyModel.name);
    TextEditingController symbol = TextEditingController(text: currencyModel.symbol);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Currency Name',
                              hintText: 'Enter Currency Name',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: symbol,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Symbol',
                              hintText: 'Enter Currency Symbol',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (() => Navigator.pop(context)),
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
                            if (name.text != '' && symbol.text != '') {
                              EasyLoading.show(status: 'Editing');
                              String currencyKey = '';
                              await FirebaseDatabase.instance.ref().child('Admin Panel').child('Currency').orderByKey().get().then((value) async {
                                for (var element in value.children) {
                                  var data = jsonDecode(jsonEncode(element.value));
                                  if (data['name'].toString() == currencyModel.name) {
                                    currencyKey = element.key.toString();
                                  }
                                }
                              });
                              DatabaseReference ref = FirebaseDatabase.instance.ref("Admin Panel/Currency/$currencyKey");
                              await ref.update({
                                'name': name.text,
                                'symbol': symbol.text,
                              });
                              EasyLoading.showSuccess('Added Successfully!');
                              updateRef.refresh(currencyProvider);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } else {
                              EasyLoading.showError('Please Enter Currency');
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
                  ],
                ),
              ),
            ));
      },
    );
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Consumer(
        builder: (_, ref, watch) {
          final data = ref.watch(currencyProvider);
          return data.when(data: (currency) {
            if (currency.isNotEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: SideBarWidget(
                      index: 8,
                      isTab: false,
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///__________title & buttons__________________________________________________________
                                    Row(
                                      children: [
                                        Text(
                                          'Currency',
                                          style: kTextStyle.copyWith(color: kTitleColor, fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: (() => newCurrencyAdd(ref: ref, list: currency)),
                                              child: Container(
                                                padding: const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: kBlueTextColor),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Add New Currency',
                                                      style: kTextStyle.copyWith(color: kWhiteTextColor),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 10.0),
                                    const Divider(height: 1, color: Colors.black12),

                                    const SizedBox(height: 10.0),

                                    Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: currency.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('${index + 1}.'),
                                                Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Text(
                                                      '${currency[index].name} - ${currency[index].symbol}',
                                                      style: const TextStyle(fontSize: 20),
                                                    )),
                                                Visibility(
                                                  visible: currency.length > 1,
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.edit,
                                                        ),
                                                        onPressed: () {
                                                          editCurrency(
                                                            currencyModel: currency[index],
                                                            updateRef: ref,
                                                          );
                                                        },
                                                      ),
                                                      const SizedBox(width: 10),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                              barrierDismissible: false,
                                                              context: context,
                                                              builder: (BuildContext dialogContext) {
                                                                return Center(
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
                                                                      color: Colors.white,
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(15),
                                                                      ),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(20.0),
                                                                      child: Column(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          const Text(
                                                                            'Are you want to delete this Currency?',
                                                                            style: TextStyle(fontSize: 22),
                                                                          ),
                                                                          const SizedBox(height: 30),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              GestureDetector(
                                                                                child: Container(
                                                                                  width: 130,
                                                                                  height: 50,
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Colors.green,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(15),
                                                                                    ),
                                                                                  ),
                                                                                  child: const Center(
                                                                                    child: Text(
                                                                                      'Cancel',
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  Navigator.pop(dialogContext);
                                                                                },
                                                                              ),
                                                                              const SizedBox(width: 30),
                                                                              GestureDetector(
                                                                                child: Container(
                                                                                  width: 130,
                                                                                  height: 50,
                                                                                  decoration: const BoxDecoration(
                                                                                    color: Colors.red,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(15),
                                                                                    ),
                                                                                  ),
                                                                                  child: const Center(
                                                                                    child: Text(
                                                                                      'Delete',
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  deleteCurrency(updateRef: ref, name: currency[index].name);
                                                                                  Navigator.pop(dialogContext);
                                                                                },
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
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
            } else {
              counter == 0 ? postDefCurrency(ref: ref) : null;
              counter++;
              return Container();
            }
          }, error: (e, stack) {
            return Center(
              child: Text(e.toString()),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        },
      ),
    );
  }

  void postDefCurrency({required WidgetRef ref}) async {
    CurrencyModel currencyModel = CurrencyModel(name: 'Dollar', symbol: '\$');
    final DatabaseReference adRef = FirebaseDatabase.instance.ref().child('Admin Panel').child('Currency');
    await adRef.push().set(currencyModel.toJson());

    ///____provider_refresh____________________________________________
    ref.refresh(currencyProvider);
  }
}
