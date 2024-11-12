import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:siswa_ride/driver_info.dart';

class Bookride4Page extends StatefulWidget {
  final DriverInfo driverInfo;
  final String bookingId;

  const Bookride4Page({
    super.key,
    required this.driverInfo,
    required this.bookingId,
  });

  @override
  State<Bookride4Page> createState() => _Bookride4PageState();
}

class _Bookride4PageState extends State<Bookride4Page> with SingleTickerProviderStateMixin {
  String? _driverPhotoUrl;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadDriverPhoto();
    _listenForArrivalNotification();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadDriverPhoto() async {
    try {
      DatabaseEvent event = await dbRef
          .child('users')
          .child(widget.driverInfo.driverId)
          .once();
      
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> rawData = snapshot.value as Map<dynamic, dynamic>;
        
        setState(() {
          _driverPhotoUrl = rawData['driverPhotoUrl']?.toString();
        });
      }
    } catch (e) {
      print('Error loading driver photo: $e');
    }
  }

  void _listenForArrivalNotification() {
    dbRef.child('notifications').child(widget.bookingId).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> notification = snapshot.value as Map<dynamic, dynamic>;
        if (notification['type'] == 'driver_arrived') {
          _showArrivedMessage(notification['message']);
        }
      }
    });
  }

  void _showArrivedMessage(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              const SizedBox(width: 12),
              const Text('Driver Has Arrived'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Color(0xFF0039CB))),
            ),
          ],
        );
      },
    );
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

  Widget _buildDriverHeader() {
    return FadeTransition(
      opacity: _animation,
      child: _buildGlassCard(
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Hero(
                tag: 'driver_${widget.driverInfo.driverId}',
                child: Container(
                  width: 100,
                  height: 100,
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
                    backgroundImage: _driverPhotoUrl != null
                        ? NetworkImage(_driverPhotoUrl!)
                        : null,
                    child: _driverPhotoUrl == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.driverInfo.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0039CB),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      "4.8",
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
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

  Widget _buildVehicleInfo() {
    return _buildGlassCard(
      Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0039CB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    color: Color(0xFF0039CB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Vehicle Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0039CB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildVehicleDetailRow(
              Icons.car_repair,
              'Car Type',
              widget.driverInfo.carType,
            ),
            const SizedBox(height: 12),
            _buildVehicleDetailRow(
              Icons.palette,
              'Color',
              widget.driverInfo.carColour,
            ),
            const SizedBox(height: 12),
            _buildVehicleDetailRow(
              Icons.pin,
              'Plate Number',
              widget.driverInfo.carPlateNumber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Chat functionality
          },
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          label: const Text(
            "Chat with Driver",
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
              child: TextButton(
                onPressed: () {
                  // Cancel ride functionality
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Cancel Ride",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Finish ride functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Finish Ride",
                  style: TextStyle(
                    color: Colors.white,
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
                'Your Driver',
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
                  colors: [Color(0xFF536DFE), Color(0xFF0039CB)],
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
                    _buildDriverHeader(),
                    const SizedBox(height: 20),
                    _buildVehicleInfo(),
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
