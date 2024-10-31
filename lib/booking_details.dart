// booking_details.dart
class BookingDetails {
  final String fromLocation;
  final String toLocation;
  final String genderPreference;
  final String additionalInformation;
  final String userName;
  final double price;
  final String paymentOption;

  BookingDetails({
    required this.fromLocation,
    required this.toLocation,
    required this.genderPreference,
    required this.additionalInformation,
    required this.userName,
    required this.price,
    required this.paymentOption,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'genderPreference': genderPreference,
      'additionalInformation': additionalInformation,
      'userName': userName,
      'price': price,
      'paymentOption': paymentOption,
    };
  }

  factory BookingDetails.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return BookingDetails(
        fromLocation: '',
        toLocation: '',
        genderPreference: '',
        additionalInformation: '',
        userName: '',
        price: 0.0,
        paymentOption: '',
      );
    }

    return BookingDetails(
      fromLocation: map['fromLocation'] ?? '',
      toLocation: map['toLocation'] ?? '',
      genderPreference: map['genderPreference'] ?? '',
      additionalInformation: map['additionalInformation'] ?? '',
      userName: map['userName'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      paymentOption: map['paymentOption'] ?? '',
    );
  }
}
