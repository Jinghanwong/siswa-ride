// booking_details_page.dart
import 'package:flutter/material.dart';
import 'booking_details.dart';
import 'fetch_booking_details.dart';
import 'booking_details_widget.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late Future<BookingDetails> bookingDetails;

  @override
  void initState() {
    super.initState();
    bookingDetails = fetchBookingDetails(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Details"),
      ),
      body: FutureBuilder<BookingDetails>(
        future: bookingDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return BookingDetailsWidget(
              bookingDetails: snapshot.data!,
              onAccept: () {
                print("Booking accepted");
              },
              onDecline: () {
                print("Booking declined");
              },
            );
          } else {
            return const Center(child: Text("Booking not found"));
          }
        },
      ),
    );
  }
}
