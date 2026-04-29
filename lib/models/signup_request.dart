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
    required this.whatsapp,
    required this.beachName,
    required this.operationType,
    required this.approximateSets,
    required this.address,
    required this.openingHours,
    required this.hasDigitalMenu,
    required this.wantsFutureCashback,
    required this.wantsFutureReservations,
    required this.notes,
    required this.status,
  });

  final String id;
  final String establishmentName;
  final String ownerName;
  final String whatsapp;
  final String beachName;
  final String operationType;
  final int approximateSets;
  final String address;
  final String openingHours;
  final bool hasDigitalMenu;
  final bool wantsFutureCashback;
  final bool wantsFutureReservations;
  final String notes;
  final SignupRequestStatus status;

  SignupRequest copyWith({
    String? id,
    String? establishmentName,
    String? ownerName,
    String? whatsapp,
    String? beachName,
    String? operationType,
    int? approximateSets,
    String? address,
    String? openingHours,
    bool? hasDigitalMenu,
    bool? wantsFutureCashback,
    bool? wantsFutureReservations,
    String? notes,
    SignupRequestStatus? status,
  }) {
    return SignupRequest(
      id: id ?? this.id,
      establishmentName: establishmentName ?? this.establishmentName,
      ownerName: ownerName ?? this.ownerName,
      whatsapp: whatsapp ?? this.whatsapp,
      beachName: beachName ?? this.beachName,
      operationType: operationType ?? this.operationType,
      approximateSets: approximateSets ?? this.approximateSets,
      address: address ?? this.address,
      openingHours: openingHours ?? this.openingHours,
      hasDigitalMenu: hasDigitalMenu ?? this.hasDigitalMenu,
      wantsFutureCashback: wantsFutureCashback ?? this.wantsFutureCashback,
      wantsFutureReservations:
          wantsFutureReservations ?? this.wantsFutureReservations,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}
