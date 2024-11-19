import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:siswa_ride/booking_details.dart';
import 'package:siswa_ride/pages/cancellationbooking_page.dart';
import 'package:siswa_ride/pages/chat_page.dart';
import 'dart:async';

import 'package:siswa_ride/pages/choosebooking.dart';

class AcceptedBookingPage extends StatefulWidget {
  final String bookingId;
  final String userId;
  final BookingDetails bookingDetails;
  final int bookingTimeInMinutes;

  const AcceptedBookingPage({
    super.key,
    required this.bookingId,
    required this.userId,
    required this.bookingDetails, 
    required this.bookingTimeInMinutes,
  });

  @override
  _AcceptedBookingPageState createState() => _AcceptedBookingPageState();
}

class _AcceptedBookingPageState extends State<AcceptedBookingPage> with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _timerCountdown = 300;
  bool _arrivedPressed = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _customerPhotoUrl;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  late StreamSubscription<DatabaseEvent> _finishRequestSubscription;

  @override
  void initState() {
    super.initState();
    _loadCustomerPhoto();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _setupFinishRequestListener();
  }

  Future<void> _loadCustomerPhoto() async {
    try {
      DatabaseEvent event = await dbRef.child('users').child(widget.userId).once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> rawData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _customerPhotoUrl = rawData['customerPhotoUrl']?.toString();
        });
      }
    } catch (e) {
      print('Error loading customer photo: $e');
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerCountdown > 0) {
        setState(() {
          _timerCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _setupFinishRequestListener() {
    DatabaseReference bookingRef = FirebaseDatabase.instance
        .ref()
        .child("bookings")
        .child(widget.userId)
        .child(widget.bookingId);

    _finishRequestSubscription = bookingRef
        .child('finish_requested')
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value == true) {
        // Show confirmation dialog
        _showFinishConfirmationDialog();
        // Reset the finish_requested flag
        bookingRef.child('finish_requested').set(false);
      }
    });
  }

  void _showFinishConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finish Ride'),
          content: const Text('This ride has finished. Do you confirm?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _confirmFinishRide();
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _confirmFinishRide() {
    DatabaseReference bookingRef = FirebaseDatabase.instance
        .ref()
        .child("bookings")
        .child(widget.userId)
        .child(widget.bookingId);

    bookingRef.update({
      "status": "finished",
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ride completed successfully')),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseBookingPage(),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update ride status: $error')),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _finishRequestSubscription.cancel();
    super.dispose();
  }

  String get formattedTimer {
    final minutes = (_timerCountdown ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerCountdown % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildGlassCard(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLocationCard(String title, String location, IconData icon, bool isStart) {
    return _buildGlassCard(
      Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isStart ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isStart ? Colors.green : Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0039CB),
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

  Widget _buildUserHeader() {
    return FadeTransition(
      opacity: _animation,
      child: _buildGlassCard(
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Hero(
                tag: 'profile_${widget.userId}',
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: _customerPhotoUrl != null
                        ? NetworkImage(_customerPhotoUrl!)
                        : null,
                    child: _customerPhotoUrl == null
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bookingDetails.userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0039CB),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.bookingDetails.genderPreference,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return _buildGlassCard(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Text(
              'Trip Fare',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'RM ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0039CB),
                  ),
                ),
                Text(
                  widget.bookingDetails.price.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0039CB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.bookingDetails.paymentOption,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChatWithCustomer() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatPage(
        bookingId: widget.bookingId,
        senderId: widget.userId,
        receiverId: widget.bookingDetails.userId,
      ),
    ),
  );
}

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _onChatWithCustomer,
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          label: const Text(
            "Chat with Customer",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0039CB),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _arrivedPressed ? null : _onArrived,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _arrivedPressed ? Colors.grey[300] : Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _arrivedPressed ? formattedTimer : "Arrived",
                  style: TextStyle(
                    color: _arrivedPressed ? Colors.grey[600] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextButton(
                onPressed: _onCancelRide,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onArrived() {
    setState(() {
      _arrivedPressed = true;
      startTimer();
    });

    dbRef.child('notifications').child(widget.bookingId).set({
      'type': 'driver_arrived',
      'message': 'Driver has arrived at the pickup point. Please board within 5 minutes.',
    });
  }

  void _onCancelRide() {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
      builder: (context) => CancellationBookingPage(
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0039CB),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Booking Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF536DFE), Color(0xFF0039CB)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2962FF), Color(0xFF64B5F6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildUserHeader(),
                    const SizedBox(height: 20),
                    _buildLocationCard(
                      'PICKUP LOCATION',
                      widget.bookingDetails.fromLocation,
                      Icons.my_location_outlined,
                      true,
                    ),
                    _buildLocationCard(
                      'DROP-OFF LOCATION',
                      widget.bookingDetails.toLocation,
                      Icons.location_on,
                      false,
                    ),
                    const SizedBox(height: 20),
                    if (widget.bookingDetails.additionalInformation.isNotEmpty)
                      _buildGlassCard(
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Additional Information',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.bookingDetails.additionalInformation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _buildPriceCard(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
