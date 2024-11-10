import 'package:flutter/material.dart';
import 'package:siswa_ride/booking_details.dart';
import 'dart:async';
import 'package:siswa_ride/pages/choosebooking.dart';

class AcceptedBookingPage extends StatefulWidget {
  final String bookingId;
  final String userId;
  final BookingDetails bookingDetails;

  const AcceptedBookingPage({
    super.key,
    required this.bookingId,
    required this.userId,
    required this.bookingDetails,
  });

  @override
  _AcceptedBookingPageState createState() => _AcceptedBookingPageState();
}

class _AcceptedBookingPageState extends State<AcceptedBookingPage> {
  Timer? _timer;
  int _timerCountdown = 300; // 5 minutes in seconds
  bool _arrivedPressed = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCountdown > 0 && !_arrivedPressed) {
        setState(() {
          _timerCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get formattedTimer {
    final minutes = (_timerCountdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerCountdown % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget buildInfoCard(String title, String value, {IconData? icon}) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: const Color(0xFF2962FF)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCancelRide() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChooseBookingPage()),
    );
  }

  void _onArrived() {
    setState(() {
      _arrivedPressed = true;
    });
    _timer?.cancel(); // Stop the timer when 'Arrived' is pressed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
        backgroundColor: const Color(0xFF2962FF),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF82B1FF), Color(0xFF2962FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Passenger info section
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/default_profile.png'), // Replace with a default image
                    radius: 30,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookingDetails.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow[700], size: 18),
                            const SizedBox(width: 5),
                            const Text(
                              "4.9",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'ABC 1234', // Placeholder car plate
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Perodua Myvi', // Placeholder car model
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildInfoCard('From', widget.bookingDetails.fromLocation, icon: Icons.my_location_outlined),
              buildInfoCard('To', widget.bookingDetails.toLocation, icon: Icons.location_on),
              buildInfoCard('Gender Preference', widget.bookingDetails.genderPreference),
              buildInfoCard('Additional Info', widget.bookingDetails.additionalInformation),
              buildInfoCard('Payment Option', widget.bookingDetails.paymentOption),
              Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'RM ${widget.bookingDetails.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2962FF),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Code to chat with customer
                    },
                    icon: const Icon(Icons.chat, color: Colors.black),
                    label: const Text("Chat with customer", style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _onArrived,
                    child: Text(
                      "Arrived ($formattedTimer)",
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _onCancelRide,
                child: const Text(
                  "Cancel Ride",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
