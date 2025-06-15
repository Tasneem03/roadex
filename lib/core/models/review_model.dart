class ReviewModel {
  final int id;
  final int rating;
  final String? comment;
  final String createdAt;
  final String customerName;
  final String name;

  ReviewModel({
    required this.id,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.customerName,
    required this.name,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      customerName: json['customerName'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
      'customerName': customerName,
      'name': name,
    };
  }
}