// accepted_booking_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:siswa_ride/booking_details.dart';

class AcceptedBookingPage extends StatefulWidget {
  final String bookingId;
  final String userId;

  const AcceptedBookingPage({
    super.key,
    required this.bookingId,
    required this.userId,
  });

  @override
  State<AcceptedBookingPage> createState() => _AcceptedBookingPageState();
}

class _AcceptedBookingPageState extends State<AcceptedBookingPage> {
  BookingDetails? bookingDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
  }

  void fetchBookingDetails() {
    DatabaseReference bookingRef = FirebaseDatabase.instance
        .ref()
        .child("bookings")
        .child(widget.userId)
        .child(widget.bookingId);

    bookingRef.get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          bookingDetails =
              BookingDetails.fromMap(snapshot.value as Map<dynamic, dynamic>);
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking details not found')),
        );
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving booking details: $error')),
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
        backgroundColor: const Color(0xFF2962FF),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingDetails != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Passenger: ${bookingDetails!.userName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.my_location, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'From: ${bookingDetails!.fromLocation}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'To: ${bookingDetails!.toLocation}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gender Preference: ${bookingDetails!.genderPreference}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Additional Info: ${bookingDetails!.additionalInformation}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: RM ${bookingDetails!.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Payment Option: ${bookingDetails!.paymentOption}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text('No details available'),
                ),
    );
  }
}
