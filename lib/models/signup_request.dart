enum SignupRequestStatus {
  pending,
  approved,
  rejected,
}

class SignupRequest {
  const SignupRequest({
    required this.id,
    required this.establishmentName,
    required this.ownerName,
    required this.phone,
    required this.address,
    required this.notes,
    required this.status,
  });

  final String id;
  final String establishmentName;
  final String ownerName;
  final String phone;
  final String address;
  final String notes;
  final SignupRequestStatus status;

  SignupRequest copyWith({
    String? id,
    String? establishmentName,
    String? ownerName,
    String? phone,
    String? address,
    String? notes,
    SignupRequestStatus? status,
  }) {
    return SignupRequest(
      id: id ?? this.id,
      establishmentName: establishmentName ?? this.establishmentName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}
