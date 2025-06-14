class ServiceRequestModel {
  final int serviceRequestId;
  final String providerName;
  final String serviceName;
  final String status;
  final String dateRequested;
  final String notes;
  final String providerPhoneNumber;

  ServiceRequestModel(
      {required this.serviceRequestId,
      required this.providerName,
      required this.serviceName,
      required this.status,
      required this.dateRequested,
      required this.providerPhoneNumber,
      required this.notes});

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      serviceRequestId: json['serviceRequestId'],
      providerName: json['providerName'],
      serviceName: json['serviceName'],
      status: json['status'],
      dateRequested: json['dateRequested'],
      providerPhoneNumber: json['providerPhoneNumber'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceRequestId': serviceRequestId,
      'providerName': providerName,
      'serviceName': serviceName,
      'status': status,
      'dateRequested': dateRequested,
      'providerPhoneNumber': providerPhoneNumber,
      'notes': notes,
    };
  }
}
