class Bill {
  int? id;
  int? userId;
  int? categoryId;
  double? price;
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
      price: (json['price'] as num?)?.toDouble(),
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
}

class OrdersResponse {
  final String msg;
  final List<Bill> orders;
  final List<Bill> expireOrders;
  final String pricesInMonth;
  final int countOrders;
  final int expireOrdersInMonth;

  OrdersResponse({
    required this.msg,
    required this.orders,
    required this.expireOrders,
    required this.pricesInMonth,
    required this.countOrders,
    required this.expireOrdersInMonth,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      msg: json['msg'] ?? '',
      orders: (json['data']['orders'] as List)
          .map((e) => Bill.fromJson(e as Map<String, dynamic>))
          .toList(),
      expireOrders: (json['data']['expire_orders'] as List)
          .map((e) => Bill.fromJson(e as Map<String, dynamic>))
          .toList(),
      pricesInMonth: json['data']['prices_in_month'],
      countOrders: json['data']['count_orders'] ?? 0,
      expireOrdersInMonth: json['data']['expire_orders_in_month'] ?? 0,
    );
  }
}
