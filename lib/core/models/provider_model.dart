class ProviderModel {
  final String providerId;
  final String username;
  final double rating;
  final double latitude;
  final double longitude;

  ProviderModel({
    required this.providerId,
    required this.username,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });


  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      providerId: json["providerId"],
      username: json["username"],
      rating: (json["rating"] as num).toDouble(),
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "providerId": providerId,
      "username": username,
      "rating": rating,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

}