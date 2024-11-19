class BookingDetails {
  final String fromLocation;
  final String toLocation;
  final String genderPreference;
  final String additionalInformation;
  final String userName;
  final double price;
  final String paymentOption;
  final String userId; // 保留 userId 字段
  final String bookingDate;

  BookingDetails({
    required this.fromLocation,
    required this.toLocation,
    required this.genderPreference,
    required this.additionalInformation,
    required this.userName,
    required this.price,
    required this.paymentOption,
    required this.userId, // 保留 userId 参数
    required this.bookingDate,
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
      // 排除 userId 字段
      'bookingDate': bookingDate,
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
        userId: '', // 初始化 userId
        bookingDate: '',
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
      userId: map['userId'] ?? '', // 从 map 中获取 userId
      bookingDate: map['bookingDate'] ?? '',
    );
  }

  get status => null;

  get driverId => null;

}
