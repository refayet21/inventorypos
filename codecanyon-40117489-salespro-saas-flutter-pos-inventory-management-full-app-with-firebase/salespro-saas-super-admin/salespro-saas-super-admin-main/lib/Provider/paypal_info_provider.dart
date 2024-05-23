import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_saas_admin/Repo/paypal_info_repo.dart';
import 'package:salespro_saas_admin/model/paypal_info_model.dart';

PaypalInfoRepo paypalRepo = PaypalInfoRepo();
final paypalInfoProvider = FutureProvider<PaypalInfoModel>((ref) => paypalRepo.getPaypalInfo());
