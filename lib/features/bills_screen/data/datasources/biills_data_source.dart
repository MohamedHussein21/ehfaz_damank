import 'package:ahfaz_damanak/features/bills_screen/data/models/edit_fatora.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/server_excption.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/error_model.dart';
import '../../../../core/utils/constant.dart';
import '../models/bills_model.dart';
import '../models/del_model.dart';

abstract class BillsDataSource {
  Future<List<Bill>> getMyFatoras();
  Future<DeleteModel> deleteBill(String billId);
  Future<EditFatoraModel> editFatoura(
    int categoryId,
    int price,
    String name,
    String storeName,
    String purchaseDate,
    String fatoraNumber,
    XFile image,
    int daman,
    int damanReminder,
    String damanDate,
    String notes,
    int orderId,
  );
  Future<List<Bill>> getFilter(
    int? categoryId,
    String? orderBy,
    String? damanOrder,
  );
}

class BillsDataSourceImpl implements BillsDataSource {
  final Dio dio;
  BillsDataSourceImpl(this.dio);
  @override
  Future<List<Bill>> getMyFatoras() async {
    try {
      final response = await dio.get(
        ApiConstant.myFatora,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return List<Bill>.from(data.map((json) => Bill.fromJson(json)));
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    }
  }

  @override
  Future<DeleteModel> deleteBill(String billId) async {
    final response = await dio.post(
      ApiConstant.delFatora,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {"order_id": billId},
    );

    if (response.statusCode == 200) {
      return DeleteModel.fromJson(response.data);
    } else {
      Constants.showToast(
          text: response.data['message'], state: ToastStates.error);
      throw ServerException(errorModel: ErrorModel.fromJson(response.data));
    }
  }

  @override
  Future<EditFatoraModel> editFatoura(
      int categoryId,
      int price,
      String name,
      String storeName,
      String purchaseDate,
      String fatoraNumber,
      XFile image,
      int daman,
      int damanReminder,
      String damanDate,
      String notes,
      int orderId) async {
    try {
      final response = await dio.post(
        ApiConstant.editFatora,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return EditFatoraModel.fromJson(data);
      } else {
        Constants.showToast(
            text: response.data['msg'], state: ToastStates.error);
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      Constants.showToast(
          text: e.response!.data['msg'], state: ToastStates.error);
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    }
  }

  @override
  Future<List<Bill>> getFilter(
      int? categoryId, String? orderBy, String? damanOrder) async {
    final response = await dio.post(
      ApiConstant.filter,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      data: {
        "category_id": categoryId,
        "order_by": orderBy,
        "daman_order": damanOrder
      },
    );

    if (response.statusCode == 200) {
      return List<Bill>.from(
          response.data['data'].map((json) => Bill.fromJson(json)));
    } else {
      Constants.showToast(
          text: response.data['message'], state: ToastStates.error);
      throw ServerException(errorModel: ErrorModel.fromJson(response.data));
    }
  }
}
