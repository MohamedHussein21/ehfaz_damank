class Profile {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String? emailVerifiedAt;
  final String googleToken;
  final String type;
  final int confirmed;
  final String image;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.emailVerifiedAt,
    required this.googleToken,
    required this.type,
    required this.confirmed,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      emailVerifiedAt: json['email_verified_at'],
      googleToken: json['google_token'],
      type: json['type'],
      confirmed: json['confirmed'],
      image: json['image'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Card {
  final int id;
  final int userId;
  final String name;
  final String cardNumber;
  final String date;
  final DateTime createdAt;
  final DateTime updatedAt;

  Card({
    required this.id,
    required this.userId,
    required this.name,
    required this.cardNumber,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      cardNumber: json['card_number'],
      date: json['date'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
