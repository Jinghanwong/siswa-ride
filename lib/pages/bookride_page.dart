import 'package:flutter/material.dart';
import 'package:siswa_ride/pages/bookride2_page.dart';

class BookridePage extends StatefulWidget {
  const BookridePage({super.key});

  @override
  State<BookridePage> createState() => _BookridePageState();
}

class _BookridePageState extends State<BookridePage> {
  String? fromLocation;
  String? toLocation;
  String? genderPreference;
  String? paymentOption;

  List<String> locations = [
    'Kolej Ibrahim Yaakub (KIY)',
    'Kolej Ungku Omar (KUO)',
    'Kolej Pendeta Zaba (KPZ)',
    'Kolej Aminuddin Baki (KAB)',
    'Kolej Dato\' Onn (KDO)',
    'Kolej Burhanuddin Helmi (KBH)',
    'Kolej Rahim Kajai (KRK)',
    'Kolej Ibu Zain (KIZ)',
    'Kolej Keris Mas (KKM)',
    'Kolej Tun Hussein Onn (KTHO)',
    'Fakulti Teknologi dan Sains Maklumat (FTSM)',
    'Fakulti Sains Sosial dan Kemanusiaan (FSSK)',
    'Fakulti Undang-Undang (FUU)',
    'Fakulti Kejuruteraan dan Alam Bina (FKAB)',
    'Fakulti Sains dan Teknologi (FST)',
    'Fakulti Pendidikan (FPEND)',
    'Fakulti Ekonomi dan Pengurusan (FEP)',
    'Fakulti Pengajian Islam (FPI)',
    'Pusat Pengajian Citra Universiti (PPCU)',
  ];

  List<String> paymentOptions = [
    'Cash',
    'E-Wallet',
    'Online Banking',
    'Card',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Ride'),
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF82B1FF), Color(0xFF2962FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.my_location_outlined,
                        color: Colors.white), // Symbol for location
                    SizedBox(width: 8),
                    Text(
                      'From',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: fromLocation,
                      hint: const Text('Select a location'),
                      isExpanded: true,
                      items: locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          fromLocation = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.location_on,
                        color: Colors.white), // Symbol for location
                    SizedBox(width: 8),
                    Text(
                      'To',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: toLocation,
                      hint: const Text('Select a location'),
                      isExpanded: true,
                      items: locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          toLocation = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.person,
                        color: Colors.white), // Symbol for person
                    SizedBox(width: 8),
                    Text(
                      'Driver Gender Preference',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Male'),
                        value: 'Male',
                        groupValue: genderPreference,
                        onChanged: (newValue) {
                          setState(() {
                            genderPreference = newValue;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Female'),
                        value: 'Female',
                        groupValue: genderPreference,
                        onChanged: (newValue) {
                          setState(() {
                            genderPreference = newValue;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('No Preference'),
                        value: 'No Preference',
                        groupValue: genderPreference,
                        onChanged: (newValue) {
                          setState(() {
                            genderPreference = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.payment,
                        color: Colors.white), // Symbol for payment
                    SizedBox(width: 8),
                    Text(
                      'Payment Option',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: paymentOption,
                      hint: const Text('Select a payment option'),
                      isExpanded: true,
                      items: paymentOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          paymentOption = newValue;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Bookride2Page(
                            fromLocation: fromLocation,
                            toLocation: toLocation,
                            genderPreference: genderPreference,
                            paymentOption: paymentOption,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 48, 98, 207),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
