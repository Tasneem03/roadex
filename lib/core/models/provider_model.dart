
class Provider {
  final String providerId;
  final String username;
  final double rating;
  final double latitude;
  final double longitude;

  Provider({
    required this.providerId,
    required this.username,
    required this.rating,
    required this.latitude,
    required this.longitude,
  });


  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
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
