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
  Future<DeleteModel> deleteBill(int billId);
  Future<EditFatouraResponseModel> editFatoura(
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
  Future<DeleteModel> deleteBill(int billId) async {
    try {
      final response = await dio.delete(
        ApiConstant.delFatora,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: {"order_id": billId},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return DeleteModel.fromJson(data);
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    }
  }

  Future<EditFatouraResponseModel> editFatoura(
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
      final response = await dio.get(
        ApiConstant.editFatora,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return EditFatouraResponseModel.fromJson(data);
      } else {
        throw ServerException(errorModel: ErrorModel.fromJson(response.data));
      }
    } on DioException catch (e) {
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    }
  }
}
