class FatoraModel {
  final int id;
  final int price;
  final int userId;
  final int categoryId;
  final String name;
  final String storeName;
  final String purchaseDate;
  final String fatoraNumber;
  final int daman;
  String? damanReminder;
  final String damanDate;
  final String notes;
  final String updatedAt;
  final String createdAt;

  FatoraModel({
    required this.id,
    required this.price,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.storeName,
    required this.purchaseDate,
    required this.fatoraNumber,
    required this.daman,
    required this.damanDate,
    this.damanReminder,
    required this.notes,
    required this.updatedAt,
    required this.createdAt,
  });

  factory FatoraModel.fromJson(Map<String, dynamic> json) {
    return FatoraModel(
      id: json['id'],
      price: int.tryParse(json['price'].toString()) ?? 0,
      userId: json['user_id'],
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      name: json['name'],
      storeName: json['store_name'],
      purchaseDate: json['purchase_date'],
      fatoraNumber: json['fatora_number'],
      daman: int.tryParse(json['daman'].toString()) ?? 0,
      damanDate: json['daman_date'],
      damanReminder: json['daman_reminder'] ?? '',
      notes: json['notes'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "category_id": categoryId.toString(),
      "name": name,
      "store_name": storeName,
      "purchase_date": purchaseDate,
      "fatora_number": fatoraNumber,
      "daman": daman.toString(),
      "daman_date": damanDate,
      "daman_reminder": damanReminder,
      "notes": notes,
      "price": price.toString(),
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  List<Object> get props => [
        id,
        userId,
        categoryId,
        name,
        storeName,
        purchaseDate,
        fatoraNumber,
        daman,
        damanDate,
        damanReminder ?? '',
        notes,
        price,
        createdAt,
        updatedAt,
      ];
}
