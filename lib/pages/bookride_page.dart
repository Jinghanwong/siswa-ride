import 'dart:ui';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Book a Ride',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2962FF).withOpacity(0.8),
              const Color(0xFF82B1FF).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildLocationSection(
                    icon: Icons.my_location_outlined,
                    title: 'From',
                    value: fromLocation,
                    onChanged: (newValue) {
                      setState(() => fromLocation = newValue);
                    },
                    locations: locations,
                  ),
                  const SizedBox(height: 20),
                  _buildLocationSection(
                    icon: Icons.location_on,
                    title: 'To',
                    value: toLocation,
                    onChanged: (newValue) {
                      setState(() => toLocation = newValue);
                    },
                    locations: locations,
                  ),
                  const SizedBox(height: 30),
                  _buildGenderPreferenceSection(),
                  const SizedBox(height: 30),
                  _buildPaymentSection(),
                  const SizedBox(height: 40),
                  _buildNextButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection({
    required IconData icon,
    required String title,
    required String? value,
    required Function(String?) onChanged,
    required List<String> locations,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  hint: Text(
                    'Select a location',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.black.withOpacity(0.8),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  items: locations.map((String location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderPreferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.person, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Driver Gender Preference',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Column(
                children: [
                  _buildRadioTile('Male'),
                  Divider(color: Colors.white.withOpacity(0.1), height: 1),
                  _buildRadioTile('Female'),
                  Divider(color: Colors.white.withOpacity(0.1), height: 1),
                  _buildRadioTile('No Preference'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioTile(String value) {
    return RadioListTile<String>(
      title: Text(
        value,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      value: value,
      groupValue: genderPreference,
      activeColor: Colors.white,
      onChanged: (newValue) {
        setState(() => genderPreference = newValue);
      },
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.payment, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              'Payment Option',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: paymentOption,
                  hint: Text(
                    'Select a payment option',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  isExpanded: true,
                  dropdownColor: Colors.black.withOpacity(0.8),
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  items: paymentOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() => paymentOption = newValue);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF2962FF), Color(0xFF82B1FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2962FF).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
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
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text(
            "Next",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
