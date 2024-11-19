import 'package:flutter/material.dart';
import 'package:siswa_ride/booking_details.dart';
import 'package:siswa_ride/pages/AcceptedBookingPage.dart';

class CancellationBookingDetailsPage extends StatefulWidget  {
  final String bookingId;
  final String userId;
  final BookingDetails bookingDetails;
  final int bookingTimeInMinutes; // The time in minutes from booking

  const CancellationBookingDetailsPage({
    super.key,
    required this.bookingId,
    required this.userId,
    required this.bookingDetails,
    required this.bookingTimeInMinutes,
  });

  @override
  _CancellationBookingDetailsPageState createState() =>
      _CancellationBookingDetailsPageState();
}

class _CancellationBookingDetailsPageState extends State<CancellationBookingDetailsPage> {
  String? _selectedReason;
  bool _driverArrived = false;
  bool _driverWrongSide = false;

  void _onReasonSelected(String reason) { //method selek
    setState(() {
      _selectedReason = reason;
    });
  }

  bool get canCancelForFree {
    // Free cancellation if booking was made less than 5 minutes ago
    return widget.bookingTimeInMinutes < 5;
  }

  bool get canCancelWithDriverIssues {
    // Allow cancellation with driver-related reasons only if driver has arrived
    return _driverArrived || _driverWrongSide;
  }

 void _onCancel() {
    if (canCancelForFree ||
        (canCancelWithDriverIssues && (_driverArrived || _driverWrongSide))) {
      // Proceed with cancellation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your ride has been canceled.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'You are not eligible for a free cancellation. Please check the rules.')),
      );
    }
  }
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Ride?'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Title and reason selection
            Text( 'Why do you want to cancel your ride?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
         Expanded(
            child: ListView(
              shrinkWrap: true,
                children: [

                  _buildCancellationOption(
                    'Driver didn’t answer phone',
                    Icons.phone,
                    'driver_no_answer',
                  ),

                  _buildCancellationOption(
                    'Driver not at pickup location',
                    Icons.location_on,
                    'driver_not_at_pickup',
                  ), 
                  
                  _buildCancellationOption(
                    'Driver asked me to cancel',
                    Icons.cancel,
                    'driver_asked_to_cancel',
                  ),
                  
                  _buildCancellationOption(
                    'Driver on the wrong side of the street',
                    Icons.directions_car,
                    'driver_wrong_side',
                  ),

                  _buildCancellationOption(
                    'Driver arrived early',
                    Icons.timer,
                    'driver_arrived_early',
                  ),
                  
                  _buildCancellationOption(
                    'Other',
                    Icons.more_horiz,
                    'other',
                  ),
                ],
              ),
             ),
            
            // Show confirmation and action buttons
            if (_selectedReason != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  if (_selectedReason == 'driver_arrived_early' ||_selectedReason == 'driver_wrong_side')
                    SwitchListTile(
                      title: const Text(
                          'I agree that the driver has arrived or is on the wrong side of the street'),
                      value: _driverArrived || _driverWrongSide,
                      onChanged: (bool value) {

                        setState(() {
                          if (_selectedReason == 'driver_arrived_early') {
                            _driverArrived = value;
                          } else {
                            _driverWrongSide = value;
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: _onCancel,
                      child: const Text('Cancel Ride'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,  // Replaced 'primary' with 'backgroundColor'
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                   ],
              )
            
            // Show 'Keep my ride' button if no reason selected
            ,if (_selectedReason == null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
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
                },
               child: const Text('Keep my ride'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,  // Replaced 'primary' with 'backgroundColor'
                  padding: const EdgeInsets.symmetric(vertical: 15),
                   ),
                ),
              ),
            ],
          ),
        ),
      );
    }


Widget _buildCancellationOption(
      String text, IconData icon, String reason) {
    return GestureDetector(
      onTap: () {
        if (_selectedReason != reason) {
          _onReasonSelected(reason);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children:[
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _selectedReason == reason
                      ? Colors.blue
                      : Colors.black,
                ),
              ),
            ),
            if (_selectedReason == reason)
              const Icon(
                Icons.check,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
 }
