import 'dart:convert';

class Bill {
  int? id;
  int? userId;
  int? categoryId;
  int? price;
  String? name;
  String? storeName;
  String? purchaseDate;
  String? fatoraNumber;
  String? image;
  int? daman;
  int? damanReminder;
  String? damanDate;
  String? notes;
  String? createdAt;
  String? updatedAt;

  Bill({
    this.id,
    this.userId,
    this.categoryId,
    this.price,
    this.name,
    this.storeName,
    this.purchaseDate,
    this.fatoraNumber,
    this.image,
    this.daman,
    this.damanReminder,
    this.damanDate,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      price: json['price'],
      name: json['name'],
      storeName: json['store_name'],
      purchaseDate: json['purchase_date'],
      fatoraNumber: json['fatora_number'],
      image: json['image'],
      daman: json['daman'],
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
      'category_id': categoryId,
      'price': price,
      'name': name,
      'store_name': storeName,
      'purchase_date': purchaseDate,
      'fatora_number': fatoraNumber,
      'image': image,
      'daman': daman,
      'daman_reminder': damanReminder,
      'daman_date': damanDate,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class BillsResponse {
  final String msg;
  final List<Bill> data;

  BillsResponse({required this.msg, required this.data});

  factory BillsResponse.fromJson(String source) {
    final Map<String, dynamic> json = jsonDecode(source);
    return BillsResponse(
      msg: json['msg'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Bill.fromJson(e)).toList()
          : [],
    );
  }
}
