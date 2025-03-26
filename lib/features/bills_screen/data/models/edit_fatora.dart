class EditFatouraResponseModel {
  final String msg;
  final Bills data;

  EditFatouraResponseModel({required this.msg, required this.data});

  factory EditFatouraResponseModel.fromJson(Map<String, dynamic> json) {
    return EditFatouraResponseModel(
      msg: json['msg'] ?? '',
      data: Bills.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'data': data.toJson(),
    };
  }
}

class Bills {
  final int id;
  final int userId;
  final int categoryId;
  final int price;
  final String name;
  final String storeName;
  final String purchaseDate;
  final String fatoraNumber;
  final String image;
  final int daman;
  final int damanReminder;
  final String damanDate;
  final String notes;
  final String createdAt;
  final String updatedAt;

  Bills({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.price,
    required this.name,
    required this.storeName,
    required this.purchaseDate,
    required this.fatoraNumber,
    required this.image,
    required this.daman,
    required this.damanReminder,
    required this.damanDate,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bills.fromJson(Map<String, dynamic> json) {
    return Bills(
      id: json['id'],
      userId: json['user_id'],
      categoryId: int.parse(json['category_id']),
      price: int.parse(json['price']),
      name: json['name'],
      storeName: json['store_name'],
      purchaseDate: json['purchase_date'],
      fatoraNumber: json['fatora_number'],
      image: json['image'],
      daman: int.parse(json['daman']),
      damanReminder: json['daman_reminder'],
      damanDate: json['daman_date'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId.toString(),
      'price': price.toString(),
      'name': name,
      'store_name': storeName,
      'purchase_date': purchaseDate,
      'fatora_number': fatoraNumber,
      'image': image,
      'daman': daman.toString(),
      'daman_reminder': damanReminder,
      'daman_date': damanDate,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
