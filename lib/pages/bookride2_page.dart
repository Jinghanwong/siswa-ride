import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:siswa_ride/pages/bookride3_page.dart';
import 'package:siswa_ride/booking_details.dart';

class Bookride2Page extends StatefulWidget {
  final String? fromLocation;
  final String? toLocation;
  final String? genderPreference;
  final String? paymentOption;

  const Bookride2Page({
    super.key,
    this.fromLocation,
    this.toLocation,
    this.genderPreference,
    this.paymentOption,
  });

  @override
  State<Bookride2Page> createState() => _Bookride2PageState();
}

class _Bookride2PageState extends State<Bookride2Page> {
  late String additionalInformation;
  late String userName;
  late double price;

  @override
  void initState() {
    super.initState();
    additionalInformation = '';
    userName = '';
    price = calculatePrice(widget.fromLocation, widget.toLocation);
    fetchUserName();
  }

  void fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child("users").child(user.uid);
      try {
        DataSnapshot snapshot =
            await usersRef.once().then((DatabaseEvent event) => event.snapshot);
        if (snapshot.value != null) {
          dynamic data = snapshot.value;
          if (data is Map<dynamic, dynamic> && data.containsKey('name')) {
            setState(() {
              userName = data['name'];
            });
          }
        }
      } catch (error) {
        print('Error fetching user data: $error');
      }
    }
  }

  double calculatePrice(String? from, String? to) {
    final Map<String, double> priceMap = {
      'Kolej Ibrahim Yaakub (KIY)_Kolej Pendeta Zaba (KPZ)': 3.0,
      'Kolej Ibrahim Yaakub (KIY)_Kolej Ibu Zain (KIZ)': 5.0,
      'Kolej Ibrahim Yaakub (KIY)_Kolej Ungku Omar (KUO)': 2.0,
      'Kolej Ibrahim Yaakub (KIY)_Kolej Aminuddin Baki (KAB)': 5.0,
      'Kolej Ibrahim Yaakub (KIY)_Kolej Dato\' Onn (KDO)': 6.0,
      'Kolej Ibrahim Yaakub (KIY)_Kolej Rahim Kajai (KRK)': 6.0,
      'Kolej Ibrahim Yaakub (KIY)_Kolej Keris Mas (KKM)': 7.0,
      'Kolej Ibrahim Yaakub (KIY)_Kolej Tun Hussein Onn (KTHO)': 6.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          4.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          6.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Undang-Undang (FUU)': 5.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          4.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Sains dan Teknologi (FST)': 2.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Pendidikan (FPEND)': 3.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Ekonomi dan Pengurusan (FEP)': 6.0,
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Pengajian Islam (FPI)': 4.0,
      'Kolej Ibrahim Yaakub (KIY)_Pusat Pengajian Citra Universiti (PPCU)': 3.0,
      'Kolej Ungku Omar (KUO)_Kolej Pendeta Zaba (KPZ)': 4.0,
      'Kolej Ungku Omar (KUO)_Kolej Aminuddin Baki (KAB)': 5.0,
      'Kolej Ungku Omar (KUO)_Kolej Dato\' Onn (KDO)': 6.0,
      'Kolej Ungku Omar (KUO)_Kolej Burhanuddin Helmi (KBH)': 3.0,
      'Kolej Ungku Omar (KUO)_Kolej Rahim Kajai (KRK)': 6.0,
      'Kolej Ungku Omar (KUO)_Kolej Ibu Zain (KIZ)': 5.0,
      'Kolej Ungku Omar (KUO)_Kolej Keris Mas (KKM)': 7.0,
      'Kolej Ungku Omar (KUO)_Kolej Tun Hussein Onn (KTHO)': 6.0,
      'Kolej Ungku Omar (KUO)_Fakulti Teknologi dan Sains Maklumat (FTSM)': 5.0,
      'Kolej Ungku Omar (KUO)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)': 6.0,
      'Kolej Ungku Omar (KUO)_Fakulti Undang-Undang (FUU)': 6.0,
      'Kolej Ungku Omar (KUO)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': 3.0,
      'Kolej Ungku Omar (KUO)_Fakulti Sains dan Teknologi (FST)': 1.0,
      'Kolej Ungku Omar (KUO)_Fakulti Pendidikan (FPEND)': 3.0,
      'Kolej Ungku Omar (KUO)_Fakulti Ekonomi dan Pengurusan (FEP)': 6.0,
      'Kolej Ungku Omar (KUO)_Fakulti Pengajian Islam (FPI)': 4.0,
      'Kolej Ungku Omar (KUO)_Pusat Pengajian Citra Universiti (PPCU)': 3.0,
      'Kolej Pendeta Zaba (KPZ)_Kolej Aminuddin Baki (KAB)': 6.0,
      'Kolej Pendeta Zaba (KPZ)_Kolej Dato\' Onn (KDO)': 7.0,
      'Kolej Pendeta Zaba (KPZ)_Kolej Burhanuddin Helmi (KBH)': 4.0,
      'Kolej Pendeta Zaba (KPZ)_Kolej Rahim Kajai (KRK)': 7.0,
      'Kolej Pendeta Zaba (KPZ)_Kolej Ibu Zain (KIZ)': 7.0,
      'Kolej Pendeta Zaba (KPZ)_Kolej Keris Mas (KKM)': 8.0,
      'Kolej Pendeta Zaba (KPZ)_Kolej Tun Hussein Onn (KTHO)': 7.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          2.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          7.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Undang-Undang (FUU)': 4.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': 3.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Sains dan Teknologi (FST)': 5.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Pendidikan (FPEND)': 4.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Ekonomi dan Pengurusan (FEP)': 7.0,
      'Kolej Pendeta Zaba (KPZ)_Fakulti Pengajian Islam (FPI)': 5.0,
      'Kolej Pendeta Zaba (KPZ)_Pusat Pengajian Citra Universiti (PPCU)': 4.0,
      'Kolej Aminuddin Baki (KAB)_Kolej Dato\' Onn (KDO)': 8.0,
      'Kolej Aminuddin Baki (KAB)_Kolej Burhanuddin Helmi (KBH)': 4.0,
      'Kolej Aminuddin Baki (KAB)_Kolej Rahim Kajai (KRK)': 8.0,
      'Kolej Aminuddin Baki (KAB)_Kolej Ibu Zain (KIZ)': 7.0,
      'Kolej Aminuddin Baki (KAB)_Kolej Keris Mas (KKM)': 8.0,
      'Kolej Aminuddin Baki (KAB)_Kolej Tun Hussein Onn (KTHO)': 7.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          7.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          8.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Undang-Undang (FUU)': 8.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          6.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Sains dan Teknologi (FST)': 4.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Pendidikan (FPEND)': 6.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Ekonomi dan Pengurusan (FEP)': 2.0,
      'Kolej Aminuddin Baki (KAB)_Fakulti Pengajian Islam (FPI)': 5.0,
      'Kolej Aminuddin Baki (KAB)_Pusat Pengajian Citra Universiti (PPCU)': 6.0,
      'Kolej Dato\' Onn (KDO)_Kolej Burhanuddin Helmi (KBH)': 5.0,
      'Kolej Dato\' Onn (KDO)_Kolej Rahim Kajai (KRK)': 4.0,
      'Kolej Dato\' Onn (KDO)_Kolej Ibu Zain (KIZ)': 3.0,
      'Kolej Dato\' Onn (KDO)_Kolej Keris Mas (KKM)': 3.0,
      'Kolej Dato\' Onn (KDO)_Kolej Tun Hussein Onn (KTHO)': 2.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Teknologi dan Sains Maklumat (FTSM)': 7.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)': 5.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Undang-Undang (FUU)': 8.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': 6.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Sains dan Teknologi (FST)': 5.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Pendidikan (FPEND)': 5.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Ekonomi dan Pengurusan (FEP)': 4.0,
      'Kolej Dato\' Onn (KDO)_Fakulti Pengajian Islam (FPI)': 5.0,
      'Kolej Dato\' Onn (KDO)_Pusat Pengajian Citra Universiti (PPCU)': 5.0,
      'Kolej Burhanuddin Helmi (KBH)_Kolej Rahim Kajai (KRK)': 7.0,
      'Kolej Burhanuddin Helmi (KBH)_Kolej Ibu Zain (KIZ)': 8.0,
      'Kolej Burhanuddin Helmi (KBH)_Kolej Keris Mas (KKM)': 8.0,
      'Kolej Burhanuddin Helmi (KBH)_Kolej Tun Hussein Onn (KTHO)': 7.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          4.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          6.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Undang-Undang (FUU)': 6.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          3.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Sains dan Teknologi (FST)': 3.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Pendidikan (FPEND)': 3.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Ekonomi dan Pengurusan (FEP)': 7.0,
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Pengajian Islam (FPI)': 3.0,
      'Kolej Burhanuddin Helmi (KBH)_Pusat Pengajian Citra Universiti (PPCU)':
          2.0,
      'Kolej Rahim Kajai (KRK)_Kolej Ibu Zain (KIZ)': 3.0,
      'Kolej Rahim Kajai (KRK)_Kolej Keris Mas (KKM)': 3.0,
      'Kolej Rahim Kajai (KRK)_Kolej Tun Hussein Onn (KTHO)': 2.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          6.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          4.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Undang-Undang (FUU)': 8.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': 8.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Sains dan Teknologi (FST)': 5.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Pendidikan (FPEND)': 7.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Ekonomi dan Pengurusan (FEP)': 5.0,
      'Kolej Rahim Kajai (KRK)_Fakulti Pengajian Islam (FPI)': 6.0,
      'Kolej Rahim Kajai (KRK)_Pusat Pengajian Citra Universiti (PPCU)': 5.0,
      'Kolej Ibu Zain (KIZ)_Kolej Keris Mas (KKM)': 2.0,
      'Kolej Ibu Zain (KIZ)_Kolej Tun Hussein Onn (KTHO)': 2.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Teknologi dan Sains Maklumat (FTSM)': 6.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)': 5.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Undang-Undang (FUU)': 8.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': 7.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Sains dan Teknologi (FST)': 5.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Pendidikan (FPEND)': 6.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Ekonomi dan Pengurusan (FEP)': 6.0,
      'Kolej Ibu Zain (KIZ)_Fakulti Pengajian Islam (FPI)': 6.0,
      'Kolej Ibu Zain (KIZ)_Pusat Pengajian Citra Universiti (PPCU)': 6.0,
      'Kolej Keris Mas (KKM)_Kolej Tun Hussein Onn (KTHO)': 3.0,
      'Kolej Keris Mas (KKM)_Fakulti Teknologi dan Sains Maklumat (FTSM)': 8.0,
      'Kolej Keris Mas (KKM)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)': 6.0,
      'Kolej Keris Mas (KKM)_Fakulti Undang-Undang (FUU)': 9.0,
      'Kolej Keris Mas (KKM)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': 7.0,
      'Kolej Keris Mas (KKM)_Fakulti Sains dan Teknologi (FST)': 5.0,
      'Kolej Keris Mas (KKM)_Fakulti Pendidikan (FPEND)': 6.0,
      'Kolej Keris Mas (KKM)_Fakulti Ekonomi dan Pengurusan (FEP)': 5.0,
      'Kolej Keris Mas (KKM)_Fakulti Pengajian Islam (FPI)': 5.0,
      'Kolej Keris Mas (KKM)_Pusat Pengajian Citra Universiti (PPCU)': 6.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          7.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          5.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Undang-Undang (FUU)': 8.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          6.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Sains dan Teknologi (FST)': 5.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Pendidikan (FPEND)': 5.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Ekonomi dan Pengurusan (FEP)': 4.0,
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Pengajian Islam (FPI)': 5.0,
      'Kolej Tun Hussein Onn (KTHO)_Pusat Pengajian Citra Universiti (PPCU)':
          5.0,
    };
    String key = '${from}_$to';
    String reverseKey = '${to}_$from';
    if (priceMap.containsKey(key)) {
      return priceMap[key]!;
    } else if (priceMap.containsKey(reverseKey)) {
      return priceMap[reverseKey]!;
    } else {
      return 6.0; // Default price
    }
  }

  void saveBookingDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference bookingsRef =
          FirebaseDatabase.instance.ref().child("bookings").child(user.uid);

      BookingDetails bookingDetails = BookingDetails(
        fromLocation: widget.fromLocation!,
        toLocation: widget.toLocation!,
        genderPreference: widget.genderPreference!,
        additionalInformation: additionalInformation,
        userName: userName,
        price: price,
        paymentOption: widget.paymentOption!,
      );

      print('Saving booking details with userName: $userName');

      try {
        await bookingsRef.push().set(bookingDetails.toMap());
        print('Booking details saved successfully.');
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Bookride3Page(),
          ),
        );
      } catch (e) {
        print('Error saving booking details: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF82B1FF), Color(0xFF2962FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Increased vertical spacing
              Row(
                children: [
                  const Icon(Icons.my_location_outlined, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'From: ${widget.fromLocation}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Increased vertical spacing
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'To: ${widget.toLocation}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Increased vertical spacing
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Driver Gender Preference: ${widget.genderPreference}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Increased vertical spacing
              Row(
                children: [
                  const Icon(Icons.payment, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Option: ${widget.paymentOption}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Increased vertical spacing
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Additional information about your ride',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                ),
                onChanged: (value) {
                  setState(() {
                    additionalInformation = value;
                  });
                },
              ),
              const SizedBox(height: 120),
              Center(
                child: Text(
                  'RM $price',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print('Book Now button pressed');
                    saveBookingDetails();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Bookride3Page(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 98, 207),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
