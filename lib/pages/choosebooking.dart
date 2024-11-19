import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:siswa_ride/booking_details.dart';
import 'package:siswa_ride/booking_details_widget.dart';
import 'package:siswa_ride/pages/AcceptedBookingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChooseBookingPage extends StatefulWidget {
  const ChooseBookingPage({super.key});

  @override
  State<ChooseBookingPage> createState() => _ChooseBookingPageState();
}

class _ChooseBookingPageState extends State<ChooseBookingPage> {
  List<Map<String, dynamic>> bookingList = [];
  bool isLoading = true;
  String? currentDriverId; // 添加这个变量存储当前司机ID
  String? driverGender;

  @override
  void initState() {
    super.initState();
    fetchBookingDetails();
    currentDriverId = FirebaseAuth.instance.currentUser?.uid;
    fetchBookingDetails();
    fetchDriverGender();
  }

  // 获取当前司机的性别信息
  void fetchDriverGender() async {
    if (currentDriverId != null) {
      DatabaseReference driverRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentDriverId!);

      DataSnapshot snapshot = await driverRef.get();
      if (snapshot.value != null) {
        Map driverData = snapshot.value as Map;
        if (driverData["userType"] == "Driver") {
          setState(() {
            driverGender = driverData["gender"];
            print("Driver Gender: $driverGender"); // 调试输出司机性别
          });

          // 确保 driverGender 获取后再调用 fetchBookingDetails
          fetchBookingDetails();
        }
      }
    }
  }

  void fetchBookingDetails() {
    DatabaseReference bookingsRef =
        FirebaseDatabase.instance.ref().child("bookings");

    bookingsRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        List<Map<String, dynamic>> fetchedBookingList = [];
        Map<dynamic, dynamic>? usersBookingsMap =
            snapshot.value as Map<dynamic, dynamic>?;
            

        if (usersBookingsMap != null) {
          usersBookingsMap.forEach((userId, userBookings) {
            if (userBookings is Map<dynamic, dynamic>) {
              userBookings.forEach((bookingId, bookingData) {
                if (bookingId != 'messages' &&
                    bookingData is Map<dynamic, dynamic> &&
                    bookingData["status"] != "accepted") {
                  String genderPreference =
                      bookingData["genderPreference"]?.toString() ??
                          "No Preference";
                  print(
                      "Booking Gender Preference: $genderPreference"); // 打印调试信息

                  if ((genderPreference == "No Preference") ||
                      (genderPreference == "Male" && driverGender == "Male") ||
                      (genderPreference == "Female" &&
                          driverGender == "Female")) {
                    BookingDetails bookingDetails =
                        BookingDetails.fromMap(bookingData);
                    fetchedBookingList.add({
                      "bookingDetails": bookingDetails,
                      "userId": userId,
                      "bookingId": bookingId,
                    });
                  }
                }
              });
            }
          });
        }

        setState(() {
          bookingList = fetchedBookingList;
          isLoading = false;
        });
      } else {
        setState(() {
          bookingList = [];
          isLoading = false;
        });
      }
    }, onError: (Object error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bookings: $error')),
      );
    });
  }

  void onAcceptBooking(
      String userId, String bookingId, BookingDetails booking) {
    if (currentDriverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Driver not logged in')),
      );
      return;
    }

    DatabaseReference bookingRef = FirebaseDatabase.instance
        .ref()
        .child("bookings")
        .child(userId)
        .child(bookingId);

    bookingRef.update({
      "status": "accepted",
      "driverId": currentDriverId,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Accepted booking from ${booking.userName}')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcceptedBookingPage(
            userId: userId,
            bookingId: bookingId,
            bookingDetails: booking,
            bookingTimeInMinutes: 0,
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update booking status: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2962FF), Color(0xFF64B5F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: Center(
                child: Text(
                  'Choose Booking',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : bookingList.isNotEmpty
                      ? ListView.builder(
                          itemCount: bookingList.length,
                          itemBuilder: (context, index) {
                            var bookingInfo = bookingList[index];
                            BookingDetails booking =
                                bookingInfo["bookingDetails"];
                            String userId = bookingInfo["userId"];
                            String bookingId = bookingInfo["bookingId"];

                            return BookingDetailsWidget(
                              bookingDetails: booking,
                              onAccept: () =>
                                  onAcceptBooking(userId, bookingId, booking),
                              onDecline: () {
                                setState(() {
                                  bookingList.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Declined booking from ${booking.userName}')),
                                );
                              },
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No booking details available.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
