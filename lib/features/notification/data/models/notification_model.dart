class NotificationModel {
  final int id;
  final String title;
  final String body;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderModel? order;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.order,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      order: json['order'] != null ? OrderModel.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (order != null) 'order': order!.toJson(),
    };
  }
}

class OrderModel {
  final int id;
  final int userId;
  final int categoryId;
  final double price;
  final String name;
  final String storeName;
  final String purchaseDate;
  final String fatoraNumber;
  final String? image;
  final int daman;
  final int? damanReminder;
  final String damanDate;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.price,
    required this.name,
    required this.storeName,
    required this.purchaseDate,
    required this.fatoraNumber,
    this.image,
    required this.daman,
    this.damanReminder,
    required this.damanDate,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      price: json['price'].toDouble(),
      name: json['name'],
      storeName: json['store_name'],
      purchaseDate: json['purchase_date'],
      fatoraNumber: json['fatora_number'],
      image: json['image'],
      daman: json['daman'],
      damanReminder: json['daman_reminder'],
      damanDate: json['daman_date'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
