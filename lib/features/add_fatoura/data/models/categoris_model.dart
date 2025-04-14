import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double totalOrdersAmount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.totalOrdersAmount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      totalOrdersAmount:
          double.tryParse(json['total_orders_amount'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_orders_amount': totalOrdersAmount,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, image, createdAt, updatedAt, totalOrdersAmount];
}
