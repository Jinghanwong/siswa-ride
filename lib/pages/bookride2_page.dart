import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:siswa_ride/pages/bookride3_page.dart';
import 'package:siswa_ride/booking_details.dart';

class Bookride2Page extends StatefulWidget {
  final String? fromLocation;
  final String? toLocation;
  final String? genderPreference;
  final String? paymentOption;

  const Bookride2Page({
    Key? key,
    this.fromLocation,
    this.toLocation,
    this.genderPreference,
    this.paymentOption,
  }) : super(key: key);

  @override
  State<Bookride2Page> createState() => _Bookride2PageState();
}

class _Bookride2PageState extends State<Bookride2Page> {
  late String additionalInformation;
  late String userName;
  //late double price;
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    additionalInformation = '';
    userName = '';
    calculatePrice(widget.fromLocation, widget.toLocation);
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

  void calculatePrice(String? from, String? to) {
    final Map<String, String> distanceMap = {
      'Kolej Ibrahim Yaakub (KIY)_Kolej Pendeta Zaba (KPZ)': '1.5 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Ibu Zain (KIZ)': '2.7 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Ungku Omar (KUO)': '0.3 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Aminuddin Baki (KAB)': '2.2 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Dato\' Onn (KDO)': '1.9 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Rahim Kajai (KRK)': '2.1 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Keris Mas (KKM)': '3.2 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Tun Hussein Onn (KTHO)': '1.7 km',
      'Kolej Ibrahim Yaakub (KIY)_Kolej Burhanuddin Helmi (KBH)': '0.7 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '1.5 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '1.5 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Undang-Undang (FUU)': '2.3 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '1.4 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Sains dan Teknologi (FST)': '0.5 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Pendidikan (FPEND)': '1.4 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '2.0 km',
      'Kolej Ibrahim Yaakub (KIY)_Fakulti Pengajian Islam (FPI)': '1.0 km',
      'Kolej Ibrahim Yaakub (KIY)_Pusat Pengajian Citra Universiti (PPCU)':
          '0.9 km',
      'Kolej Ungku Omar (KUO)_Kolej Pendeta Zaba (KPZ)': '1.4 km',
      'Kolej Ungku Omar (KUO)_Kolej Aminuddin Baki (KAB)': '1.8 km',
      'Kolej Ungku Omar (KUO)_Kolej Dato\' Onn (KDO)': '1.5 km',
      'Kolej Ungku Omar (KUO)_Kolej Burhanuddin Helmi (KBH)': '0.5 km',
      'Kolej Ungku Omar (KUO)_Kolej Rahim Kajai (KRK)': '1.8 km',
      'Kolej Ungku Omar (KUO)_Kolej Ibu Zain (KIZ)': '2.4 km',
      'Kolej Ungku Omar (KUO)_Kolej Keris Mas (KKM)': '2.9 km',
      'Kolej Ungku Omar (KUO)_Kolej Tun Hussein Onn (KTHO)': '1.4 km',
      'Kolej Ungku Omar (KUO)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '1.3 km',
      'Kolej Ungku Omar (KUO)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '1.3 km',
      'Kolej Ungku Omar (KUO)_Fakulti Undang-Undang (FUU)': '2.7 km',
      'Kolej Ungku Omar (KUO)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '1.2 km',
      'Kolej Ungku Omar (KUO)_Fakulti Sains dan Teknologi (FST)': '0.3 km',
      'Kolej Ungku Omar (KUO)_Fakulti Pendidikan (FPEND)': '1.1 km',
      'Kolej Ungku Omar (KUO)_Fakulti Ekonomi dan Pengurusan (FEP)': '1.8 km',
      'Kolej Ungku Omar (KUO)_Fakulti Pengajian Islam (FPI)': '0.9 km',
      'Kolej Ungku Omar (KUO)_Pusat Pengajian Citra Universiti (PPCU)':
          '0.6 km',
      'Kolej Pendeta Zaba (KPZ)_Kolej Aminuddin Baki (KAB)': '3.2 km',
      'Kolej Pendeta Zaba (KPZ)_Kolej Dato\' Onn (KDO)': '2.9 km',
      'Kolej Pendeta Zaba (KPZ)_Kolej Burhanuddin Helmi (KBH)': '1.8 km',
      'Kolej Pendeta Zaba (KPZ)_Kolej Rahim Kajai (KRK)': '3.2 km',
      'Kolej Pendeta Zaba (KPZ)_Kolej Ibu Zain (KIZ)': '3.8 km',
      'Kolej Pendeta Zaba (KPZ)_Kolej Keris Mas (KKM)': '4.3 km',
      'Kolej Pendeta Zaba (KPZ)_Kolej Tun Hussein Onn (KTHO)': '2.8 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '2.7 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '2.7 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Undang-Undang (FUU)': '1.6 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '1.0 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Sains dan Teknologi (FST)': '1.3 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Pendidikan (FPEND)': '1.6 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Ekonomi dan Pengurusan (FEP)': '3.1 km',
      'Kolej Pendeta Zaba (KPZ)_Fakulti Pengajian Islam (FPI)': '2.0 km',
      'Kolej Pendeta Zaba (KPZ)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.6 km',
      'Kolej Aminuddin Baki (KAB)_Kolej Dato\' Onn (KDO)': '2.4 km',
      'Kolej Aminuddin Baki (KAB)_Kolej Burhanuddin Helmi (KBH)': '1.3 km',
      'Kolej Aminuddin Baki (KAB)_Kolej Rahim Kajai (KRK)': '2.6 km',
      'Kolej Aminuddin Baki (KAB)_Kolej Ibu Zain (KIZ)': '3.3 km',
      'Kolej Aminuddin Baki (KAB)_Kolej Keris Mas (KKM)': '3.8 km',
      'Kolej Aminuddin Baki (KAB)_Kolej Tun Hussein Onn (KTHO)': '2.3 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '2.1 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '2.1 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Undang-Undang (FUU)': '3.0 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '2.0 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Sains dan Teknologi (FST)': '0.8 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Pendidikan (FPEND)': '2.0 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '0.2 km',
      'Kolej Aminuddin Baki (KAB)_Fakulti Pengajian Islam (FPI)': '1.4 km',
      'Kolej Aminuddin Baki (KAB)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.4 km',
      'Kolej Dato\' Onn (KDO)_Kolej Burhanuddin Helmi (KBH)': '1.3 km',
      'Kolej Dato\' Onn (KDO)_Kolej Rahim Kajai (KRK)': '0.6 km',
      'Kolej Dato\' Onn (KDO)_Kolej Ibu Zain (KIZ)': '1.2 km',
      'Kolej Dato\' Onn (KDO)_Kolej Keris Mas (KKM)': '1.7 km',
      'Kolej Dato\' Onn (KDO)_Kolej Tun Hussein Onn (KTHO)': '0.5 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '0.6 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '0.6 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Undang-Undang (FUU)': '3.2 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '1.7 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Sains dan Teknologi (FST)': '1.8 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Pendidikan (FPEND)': '1.7 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Ekonomi dan Pengurusan (FEP)': '1.0 km',
      'Kolej Dato\' Onn (KDO)_Fakulti Pengajian Islam (FPI)': '2.4 km',
      'Kolej Dato\' Onn (KDO)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.1 km',
      'Kolej Burhanuddin Helmi (KBH)_Kolej Rahim Kajai (KRK)': '1.6 km',
      'Kolej Burhanuddin Helmi (KBH)_Kolej Ibu Zain (KIZ)': '2.3 km',
      'Kolej Burhanuddin Helmi (KBH)_Kolej Keris Mas (KKM)': '2.8 km',
      'Kolej Burhanuddin Helmi (KBH)_Kolej Tun Hussein Onn (KTHO)': '1.3 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '1.1 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '1.1 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Undang-Undang (FUU)': '2.5 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '1.0 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Sains dan Teknologi (FST)':
          '0.8 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Pendidikan (FPEND)': '1.0 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '1.6 km',
      'Kolej Burhanuddin Helmi (KBH)_Fakulti Pengajian Islam (FPI)': '1.4 km',
      'Kolej Burhanuddin Helmi (KBH)_Pusat Pengajian Citra Universiti (PPCU)':
          '0.5 km',
      'Kolej Rahim Kajai (KRK)_Kolej Ibu Zain (KIZ)': '1.0 km',
      'Kolej Rahim Kajai (KRK)_Kolej Keris Mas (KKM)': '1.5 km',
      'Kolej Rahim Kajai (KRK)_Kolej Tun Hussein Onn (KTHO)': '0.7 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '0.9 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '0.9 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Undang-Undang (FUU)': '3.8 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '2.3 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Sains dan Teknologi (FST)': '1.9 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Pendidikan (FPEND)': '2.3 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Ekonomi dan Pengurusan (FEP)': '1.3 km',
      'Kolej Rahim Kajai (KRK)_Fakulti Pengajian Islam (FPI)': '2.6 km',
      'Kolej Rahim Kajai (KRK)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.7 km',
      'Kolej Ibu Zain (KIZ)_Kolej Keris Mas (KKM)': '1.4 km',
      'Kolej Ibu Zain (KIZ)_Kolej Tun Hussein Onn (KTHO)': '1.3 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '1.5 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '1.5 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Undang-Undang (FUU)': '4.4 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '2.9 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Sains dan Teknologi (FST)': '2.6 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Pendidikan (FPEND)': '2.9 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Ekonomi dan Pengurusan (FEP)': '1.9 km',
      'Kolej Ibu Zain (KIZ)_Fakulti Pengajian Islam (FPI)': '3.2 km',
      'Kolej Ibu Zain (KIZ)_Pusat Pengajian Citra Universiti (PPCU)': '2.3 km',
      'Kolej Keris Mas (KKM)_Kolej Tun Hussein Onn (KTHO)': '1.6 km',
      'Kolej Keris Mas (KKM)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '1.8 km',
      'Kolej Keris Mas (KKM)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '1.8 km',
      'Kolej Keris Mas (KKM)_Fakulti Undang-Undang (FUU)': '4.7 km',
      'Kolej Keris Mas (KKM)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '3.2 km',
      'Kolej Keris Mas (KKM)_Fakulti Sains dan Teknologi (FST)': '2.9 km',
      'Kolej Keris Mas (KKM)_Fakulti Pendidikan (FPEND)': '3.2 km',
      'Kolej Keris Mas (KKM)_Fakulti Ekonomi dan Pengurusan (FEP)': '2.2 km',
      'Kolej Keris Mas (KKM)_Fakulti Pengajian Islam (FPI)': '3.5 km',
      'Kolej Keris Mas (KKM)_Pusat Pengajian Citra Universiti (PPCU)': '2.6 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
          '0.5 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '0.5 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Undang-Undang (FUU)': '3.7 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '2.2 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Sains dan Teknologi (FST)':
          '1.6 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Pendidikan (FPEND)': '2.1 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '1.0 km',
      'Kolej Tun Hussein Onn (KTHO)_Fakulti Pengajian Islam (FPI)': '2.2 km',
      'Kolej Tun Hussein Onn (KTHO)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.6 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
          '2.3 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Fakulti Undang-Undang (FUU)':
          '1.4 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '0.8 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Fakulti Sains dan Teknologi (FST)':
          '1.7 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Fakulti Pendidikan (FPEND)':
          '1.5 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '2.8 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Fakulti Pengajian Islam (FPI)':
          '2.4 km',
      'Fakulti Teknologi dan Sains Maklumat (FTSM)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.4 km',
      'Fakulti Sains Sosial dan Kemanusiaan (FSSK)_Fakulti Undang-Undang (FUU)':
          '3.4 km',
      'Fakulti Sains Sosial dan Kemanusiaan (FSSK)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '2.4 km',
      'Fakulti Sains Sosial dan Kemanusiaan (FSSK)_Fakulti Sains dan Teknologi (FST)':
          '1.1 km',
      'Fakulti Sains Sosial dan Kemanusiaan (FSSK)_Fakulti Pendidikan (FPEND)':
          '2.3 km',
      'Fakulti Sains Sosial dan Kemanusiaan (FSSK)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '0.5 km',
      'Fakulti Sains Sosial dan Kemanusiaan (FSSK)_Fakulti Pengajian Islam (FPI)':
          '1.8 km',
      'Fakulti Sains Sosial dan Kemanusiaan (FSSK)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.8 km',
      'Fakulti Undang-Undang (FUU)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
          '1.8 km',
      'Fakulti Undang-Undang (FUU)_Fakulti  Sains dan Teknologi (FST)':
          '2.7 km',
      'Fakulti Undang-Undang (FUU)_Fakulti  Pendidikan (FPEND)': '2.5 km',
      'Fakulti Undang-Undang (FUU)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '3.8 km',
      'Fakulti Undang-Undang (FUU)_Fakulti Pengajian Islam (FPI)': '3.4 km',
      'Fakulti Undang-Undang (FUU)_Pusat Pengajian Citra Universiti (PPCU)':
          '2.4 km',
      'Fakulti Kejuruteraan dan Alam Bina (FKAB)_Fakulti Sains dan Teknologi (FST)':
          '2.0 km',
      'Fakulti Kejuruteraan dan Alam Bina (FKAB)_Fakulti Pendidikan (FPEND)':
          '1.3 km',
      'Fakulti Kejuruteraan dan Alam Bina (FKAB)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '2.6 km',
      'Fakulti Kejuruteraan dan Alam Bina (FKAB)_Fakulti Pengajian Islam (FPI)':
          '2.6 km',
      'Fakulti Kejuruteraan dan Alam Bina (FKAB)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.2 km',
      'Fakulti Sains dan Teknologi (FST)_Fakulti Pendidikan (FPEND)': '1.4 km',
      'Fakulti Sains dan Teknologi (FST)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '2.1 km',
      'Fakulti Sains dan Teknologi (FST)_Fakulti Pengajian Islam (FPI)':
          '0.9 km',
      'Fakulti Sains dan Teknologi (FST)_Pusat Pengajian Citra Universiti (PPCU)':
          '0.9 km',
      'Fakulti Pendidikan (FPEND)_Fakulti Ekonomi dan Pengurusan (FEP)':
          '2.0 km',
      'Fakulti Pendidikan (FPEND)_Fakulti Pengajian Islam (FPI)': '2.0 km',
      'Fakulti Pendidikan (FPEND)_Pusat Pengajian Citra Universiti (PPCU)':
          '0.7 km',
      'Fakulti Ekonomi dan Pengurusan (FEP)_Fakulti Pengajian Islam (FPI)':
          '1.3 km',
      'Fakulti Ekonomi dan Pengurusan (FEP)_Pusat Pengajian Citra Universiti (PPCU)':
          '1.3 km',
      'Fakulti Pengajian Islam (FPI)_Pusat Pengajian Citra Universiti (PPCU)':
          '0.6 km',
    };

    String routeKey = '${from}_${to}';
    String reverseRouteKey = '${to}_${from}';
    String? distanceStr = distanceMap[routeKey] ?? distanceMap[reverseRouteKey];

    if (distanceStr != null) {
      double distanceKm = double.parse(distanceStr.split(' ')[0]);
      setState(() {
        price = 1.5 * distanceKm;
      });
    } else {
      print('Route not found');
    }
  }

  void saveBookingDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference bookingsRef =
          FirebaseDatabase.instance.ref().child("bookings").child(user.uid);

      String currentDate = getCurrentDate(); // 获取当前日期

      BookingDetails bookingDetails = BookingDetails(
        userId: user.uid, // 传递 userId
        fromLocation: widget.fromLocation!,
        toLocation: widget.toLocation!,
        genderPreference: widget.genderPreference!,
        additionalInformation: additionalInformation,
        userName: userName,
        price: price,
        paymentOption: widget.paymentOption!,
        bookingDate: currentDate,
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

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE, d MMM yy');
    return formatter.format(now); // 返回格式化后的日期
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: const Color.fromARGB(255, 48, 98, 207),
        elevation: 0, // 去除阴影
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
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
              const SizedBox(height: 20),
              Card(
                elevation: 4, // 增加阴影
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // 圆角
                ),
                child: ListTile(
                  leading: const Icon(Icons.my_location_outlined,
                      color: Colors.blue),
                  title: Text(
                    'From: ${widget.fromLocation}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.blue),
                  title: Text(
                    'To: ${widget.toLocation}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(
                    'Driver Gender Preference: ${widget.genderPreference}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.payment, color: Colors.blue),
                  title: Text(
                    'Payment Option: ${widget.paymentOption}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Additional information about your ride',
                      hintStyle: const TextStyle(color: Colors.black),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
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
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'RM ${price.toStringAsFixed(2)}',
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 圆角
                    ),
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


