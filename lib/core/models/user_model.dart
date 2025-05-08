class UserModel {
  final String username;
  final String email;
  final String phoneNumber;
  final double longitude;
  final double latitude;

  UserModel({required this.username, required this.email, required this.phoneNumber, required this.longitude, required this.latitude, });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'latitude' : latitude,
      'longitude' : longitude,
    };
  }


}
