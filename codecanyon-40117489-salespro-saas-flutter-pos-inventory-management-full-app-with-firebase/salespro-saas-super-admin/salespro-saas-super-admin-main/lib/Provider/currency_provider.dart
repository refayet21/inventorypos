import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repo/currency_repo.dart';
import '../model/currency_model.dart';

CurrencyRepo currencyRepo = CurrencyRepo();
final currencyProvider = FutureProvider<List<CurrencyModel>>((ref) => currencyRepo.getAllCurrency());
