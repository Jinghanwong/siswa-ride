import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:siswa_ride/booking_details.dart';
import 'package:siswa_ride/pages/AcceptedBookingPage.dart'; // Ensure this is the path to your accepted booking page
import 'package:siswa_ride/pages/cancellationbookingdetails_page.dart';

class CancellationBookingPage extends StatefulWidget {
  final String bookingId;
  final String userId;
  final BookingDetails bookingDetails;
  final int bookingTimeInMinutes;
 

  const CancellationBookingPage({
    super.key,
    required this.bookingId,
    required this.userId,
    required this.bookingDetails,
    required this.bookingTimeInMinutes,
  
  });

  @override
  _CancellationBookingPageState createState() => _CancellationBookingPageState();
}

class _CancellationBookingPageState extends State<CancellationBookingPage> {

//cancel button done

  void _confirmCancellation() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => CancellationBookingDetailsPage(
      userId: widget.userId,
      bookingId: widget.bookingId,
      bookingDetails: widget.bookingDetails,
      bookingTimeInMinutes: widget.bookingTimeInMinutes,
    ),//cancel ni masuk kat cancellation list sebelah scammer list ke
  )
  );
}


//call button done
  void _callDriver() async {
  try {
    // Reference to the driver’s phone number in Firebase
    DatabaseReference phoneRef = FirebaseDatabase.instance.ref().child('users/${widget.userId}/phone');
    
    // Retrieve the driver’s phone number
    DatabaseEvent event = await phoneRef.once();
    String driverPhoneNumber = event.snapshot.value as String;

    // Add functionality to call the driver here (e.g., using url_launcher package)
    print('Calling driver at $driverPhoneNumber');
  } catch (e) {
    print('Error retrieving driver phone number: $e');
  }
}

//cancelandreturn button done
  void _cancelAndReturn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptedBookingPage(
          bookingId: widget.bookingId,
          userId: widget.userId,
          bookingDetails: widget.bookingDetails, 
         bookingTimeInMinutes: widget.bookingTimeInMinutes,
        ),
      ),
    );
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Ride?'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                 'Cancel your ride with driver', // Use driverName directly
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),
                  Text ('Your driver is already on the way.',
                  style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Want to change pickup location?',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    // Implement change pickup location functionality
                  },
                  child: const Text(
                    'Edit Pickup',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 24),
            //done but dk want rec or circ
            Row(
              //done
              children: [
                Expanded(
                child: ElevatedButton(
                onPressed: _confirmCancellation,
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1), // Change 'primary' to 'backgroundColor'
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Yes, Cancel',
                style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600,),//TextStyle
    ),
  ),
),

                const SizedBox(width: 8),
                Expanded(
                child: ElevatedButton(
                onPressed: _callDriver,
                style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0039CB), // Corrected to backgroundColor
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: const Text('Call Driver',
                style: TextStyle(fontSize: 16, color: Colors.white),
    ),
  ),
),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                  onPressed: _cancelAndReturn,
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300], // Corrected to backgroundColor
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('No',
                style: TextStyle(fontSize: 16, color: Colors.white),
    ),
  ),
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
