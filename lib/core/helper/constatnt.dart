import 'cash_helper.dart';

class Constant {
  static String? token = CashHelper.getData(key: 'api_token');
  static String? googleToken = CashHelper.getData(key: 'googleToken');
}
