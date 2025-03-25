import 'package:equatable/equatable.dart';

class FatoraModel extends Equatable {
  final int id;
  final int userId;
  final int categoryId;
  final String name;
  final String storeName;
  final String purchaseDate;
  final String fatoraNumber;
  final int daman;
  final String damanDate;
  final String notes;
  final String image;
  final int price;
  final String createdAt;
  final String updatedAt;

  const FatoraModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.storeName,
    required this.purchaseDate,
    required this.fatoraNumber,
    required this.daman,
    required this.damanDate,
    required this.notes,
    required this.image,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FatoraModel.fromJson(Map<String, dynamic> json) {
    return FatoraModel(
      id: json["id"],
      userId: json["user_id"],
      categoryId: int.parse(json["category_id"]),
      name: json["name"],
      storeName: json["store_name"],
      purchaseDate: json["purchase_date"],
      fatoraNumber: json["fatora_number"],
      daman: int.parse(json["daman"]),
      damanDate: json["daman_date"],
      notes: json["notes"],
      image: json["image"],
      price: int.parse(json["price"]),
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
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
      "notes": notes,
      "image": image,
      "price": price.toString(),
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  @override
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
        notes,
        image,
        price,
        createdAt,
        updatedAt,
      ];
}
