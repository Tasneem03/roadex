class CarModel{
  final int id;
  final String model;
  final int year;
  final String make;
  final String licensePlate;

  CarModel({required this.id, required this.model, required this.year, required this.make, required this.licensePlate});


  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(id: json['id'], model: json['model'], year: json['year'], make: json['make'], licensePlate: json['licensePlate']);

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'year': year,
      'make' : make,
      'licensePlate' : licensePlate,
    };
  }
}