class ServiceModel {
  final int id;
  final String name;
  final String description;
  final String imagePath;

  ServiceModel(
      {required this.id, required this.name, required this.description})
      : imagePath = _getImageForService(name);

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  static String _getImageForService(String serviceName) {
    const Map<String, String> serviceImages = {
      "Car Wash": "assets/images/services/car_wash.jpg",
      "Oil Change": "assets/images/services/oil_change.jpg",
      "Tire Replacement & Repair": "assets/images/services/tire_replacement.jpg",
      "Battery Replacement": "assets/images/services/battery_replacement.jpg",
      "Roadside Assistance": "assets/images/services/roadside_assistance.jpg",
      "Brake Inspection & Repair": "assets/images/services/brake_inspection.jpg",
      "Car Diagnostic Service": "assets/images/services/car_diagnostic.jpg",
      "Air Conditioning Repair & Recharge": "assets/images/services/ac_repair.jpg",
      "Engine Tune-Up": "assets/images/services/engine_tuneup.jpg",
      "Windshield Repair & Replacement": "assets/images/services/windshield_repair.jpg",
      "Tow Truck Service": "assets/images/services/tow_truck.jpg",
    };

    return serviceImages[serviceName] ?? "assets/images/services/placeholder-image.webp";
  }
}
