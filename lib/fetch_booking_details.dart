// fetch_booking_details.dart
import 'package:firebase_database/firebase_database.dart';
import 'booking_details.dart';

Future<BookingDetails> fetchBookingDetails(String bookingId) async {
  final DatabaseReference ref =
      FirebaseDatabase.instance.ref("bookings/$bookingId");
  final DataSnapshot snapshot = await ref.get();

  if (snapshot.exists) {
    return BookingDetails.fromMap(snapshot.value as Map<dynamic, dynamic>);
  } else {
    throw Exception("Booking not found");
  }
}
