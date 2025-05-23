class EditFatoraModel {
  final int id;
  final int userId;
  final String categoryId;
  final String price;
  final String name;
  final String storeName;
  final String purchaseDate;
  final String fatoraNumber;
  final String image;
  final String daman;
  final String damanReminder;
  final String damanDate;
  final String notes;
  final String createdAt;
  final String updatedAt;

  EditFatoraModel({
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

  factory EditFatoraModel.fromJson(Map<String, dynamic> json) {
    return EditFatoraModel(
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
      damanReminder: json['daman_reminder'] ?? 0,
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
