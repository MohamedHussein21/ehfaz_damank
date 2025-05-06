class StatisticsModel {
  final String msg;
  final SpendingData data;

  StatisticsModel({required this.msg, required this.data});

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      msg: json['msg'],
      data: SpendingData.fromJson(json['data']),
    );
  }
}

class SpendingData {
  final List<Category> categories;
  final List<DailySpending> dailySpending;
  final List<MonthlySpending> monthlySpending;
  final List<YearlySpending> yearlySpending;

  SpendingData({
    required this.categories,
    required this.dailySpending,
    required this.monthlySpending,
    required this.yearlySpending,
  });

  factory SpendingData.fromJson(Map<String, dynamic> json) {
    return SpendingData(
      categories: List<Category>.from(
          json['categories'].map((x) => Category.fromJson(x))),
      dailySpending: List<DailySpending>.from(
          json['daily_spending'].map((x) => DailySpending.fromJson(x))),
      monthlySpending: List<MonthlySpending>.from(
          json['monthly_spending'].map((x) => MonthlySpending.fromJson(x))),
      yearlySpending: List<YearlySpending>.from(
          json['yearly_spending'].map((x) => YearlySpending.fromJson(x))),
    );
  }
}

class Category {
  final int categoryId;
  final String categoryName;
  final int orderCount;
  final double totalAmount;
  final double percentage;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.orderCount,
    required this.totalAmount,
    required this.percentage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      orderCount: json['order_count'],
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      percentage: json['percentage'].toDouble(),
    );
  }
}

class DailySpending {
  final String month;
  final int monthNum;
  final List<DaySpending> days;

  DailySpending(
      {required this.month, required this.monthNum, required this.days});

  factory DailySpending.fromJson(Map<String, dynamic> json) {
    return DailySpending(
      month: json['month'],
      monthNum: json['month_num'],
      days: List<DaySpending>.from(
          json['days'].map((x) => DaySpending.fromJson(x))),
    );
  }
}

class DaySpending {
  final int day;
  final double totalSpent;

  DaySpending({required this.day, required this.totalSpent});

  factory DaySpending.fromJson(Map<String, dynamic> json) {
    return DaySpending(
      day: json['day'],
      totalSpent: double.tryParse(json['total_spent'].toString()) ?? 0.0,
    );
  }
}

class MonthlySpending {
  final String month;
  final int monthNum;
  final double totalSpent;

  MonthlySpending(
      {required this.month, required this.monthNum, required this.totalSpent});

  factory MonthlySpending.fromJson(Map<String, dynamic> json) {
    return MonthlySpending(
      month: json['month'],
      monthNum: json['month_num'],
      totalSpent: double.tryParse(json['total_spent'].toString()) ??
          0.0, // json['total_spent'],
    );
  }
}

class YearlySpending {
  final int year;
  final double totalSpent;

  YearlySpending({required this.year, required this.totalSpent});

  factory YearlySpending.fromJson(Map<String, dynamic> json) {
    return YearlySpending(
      year: json['year'],
      totalSpent: double.tryParse(json['total_spent'].toString()) ??
          0.0, // json['total_spent'],
    );
  }
}
