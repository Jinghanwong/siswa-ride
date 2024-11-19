import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siswa_ride/driver_info.dart';
import 'package:siswa_ride/pages/bookride4_page.dart';

class Bookride3Page extends StatefulWidget {
  const Bookride3Page({super.key});

  @override
  State<Bookride3Page> createState() => _Bookride3PageState();
}

class _Bookride3PageState extends State<Bookride3Page> {
  StreamSubscription<DatabaseEvent>? _bookingSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSubscription;
  String? _userId;

   @override
  void initState() {
    super.initState();
    _listenToBookingStatus();
  }

  void _listenToBookingStatus() {
    _getUserId().then((_) {
      if (_userId != null) {
        _listenToBookings();
      }
    });
  }

  Future<void> _getUserId() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      _listenToUserData();
    }
  }

  void _listenToBookings() {
  if (_userId == null) return;

  DatabaseReference bookingsRef = FirebaseDatabase.instance
      .ref()
      .child("bookings")
      .child(_userId!);

  _bookingSubscription = bookingsRef.limitToLast(1).onValue.listen((event) {
    if (!mounted) return;

    final data = event.snapshot.value as Map<dynamic, dynamic>?;
    if (data == null) return;

    final bookingEntry = data.entries.first;
    final bookingId = bookingEntry.key;
    final bookingData = bookingEntry.value as Map<dynamic, dynamic>;

    if (bookingData['status'] == 'accepted' && bookingData['driverId'] != null) {
      _fetchDriverInfoAndNavigate(
        driverId: bookingData['driverId'],
        bookingId: bookingId,
      );
    }
  });
}

  void _listenToUserData() {
    final userRef = FirebaseFirestore.instance.collection('users').doc(_userId);
    _userSubscription = userRef.snapshots().listen((snapshot) {
      if (!mounted) return;
      if (snapshot.data() != null) {
        // Use the user data as needed
        _fetchDriverInfoAndNavigate(
          driverId: snapshot.data()!['driverId'],
          bookingId: snapshot.data()!['bookingId'],
        );
      }
    });
  }

  void _fetchDriverInfoAndNavigate({
    required String driverId,
    required String bookingId,
  }) async {
    final driverSnapshot = await FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(driverId)
        .get();

    if (!mounted) return;

    if (driverSnapshot.value != null) {
      final driverData = driverSnapshot.value as Map<dynamic, dynamic>;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Bookride4Page(
            driverInfo: DriverInfo(
              name: driverData['name'] ?? '',
              driverPhotoUrl: driverData['driverphotoUrl'] ?? '',
              carType: driverData['carType'] ?? '',
              carColour: driverData['carColour'] ?? '',
              carPlateNumber: driverData['carPlateNumber'] ?? '',
              bookingId: bookingId,
              driverId: driverId,
            ),
            bookingId: bookingId,
            userId: _userId!,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _bookingSubscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting for Driver'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Looking for a driver...'),
          ],
        ),
      ),
    );
  }
}

