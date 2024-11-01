import 'package:flutter/material.dart';

class ViewRoutePage extends StatefulWidget {
  const ViewRoutePage({super.key});

  @override
  State<ViewRoutePage> createState() => _ViewRoutePageState();
}

class _ViewRoutePageState extends State<ViewRoutePage> {
  String? fromLocation;
  String? toLocation;
  String distance = '';
  String price = '';

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

  final Map<String, String> distanceMap = {
    'Kolej Ibrahim Yaakub (KIY)_Kolej Pendeta Zaba (KPZ)': '1.5 km',
    'Kolej Ibrahim Yaakub (KIY)_Kolej Ibu Zain (KIZ)': '2.7 km',
    'Kolej Ibrahim Yaakub (KIY)_Kolej Ungku Omar (KUO)': '0.3 km',
    'Kolej Ibrahim Yaakub (KIY)_Kolej Aminuddin Baki (KAB)': '2.2 km',
    'Kolej Ibrahim Yaakub (KIY)_Kolej Dato\' Onn (KDO)': '1.9 km',
    'Kolej Ibrahim Yaakub (KIY)_Kolej Rahim Kajai (KRK)': '2.1 km',
    'Kolej Ibrahim Yaakub (KIY)_Kolej Keris Mas (KKM)': '3.2 km',
    'Kolej Ibrahim Yaakub (KIY)_Kolej Tun Hussein Onn (KTHO)': '1.7 km',
    'Kolej Ibrahim Yaakub (KIY)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
        '1.5 km',
    'Kolej Ibrahim Yaakub (KIY)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
        '1.5 km',
    'Kolej Ibrahim Yaakub (KIY)_Fakulti Undang-Undang (FUU)': '2.3 km',
    'Kolej Ibrahim Yaakub (KIY)_Fakulti Kejuruteraan dan Alam Bina (FKAB)':
        '1.4 km',
    'Kolej Ibrahim Yaakub (KIY)_Fakulti Sains dan Teknologi (FST)': '0.5 km',
    'Kolej Ibrahim Yaakub (KIY)_Fakulti Pendidikan (FPEND)': '1.4 km',
    'Kolej Ibrahim Yaakub (KIY)_Fakulti Ekonomi dan Pengurusan (FEP)': '2.0 km',
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
    'Kolej Ungku Omar (KUO)_Pusat Pengajian Citra Universiti (PPCU)': '0.6 km',
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
    'Kolej Aminuddin Baki (KAB)_Fakulti Ekonomi dan Pengurusan (FEP)': '0.2 km',
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
    'Kolej Dato\' Onn (KDO)_Pusat Pengajian Citra Universiti (PPCU)': '1.1 km',
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
    'Kolej Burhanuddin Helmi (KBH)_Fakulti Sains dan Teknologi (FST)': '0.8 km',
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
    'Kolej Rahim Kajai (KRK)_Pusat Pengajian Citra Universiti (PPCU)': '1.7 km',
    'Kolej Ibu Zain (KIZ)_Kolej Keris Mas (KKM)': '1.4 km',
    'Kolej Ibu Zain (KIZ)_Kolej Tun Hussein Onn (KTHO)': '1.3 km',
    'Kolej Ibu Zain (KIZ)_Fakulti Teknologi dan Sains Maklumat (FTSM)':
        '1.5 km',
    'Kolej Ibu Zain (KIZ)_Fakulti Sains Sosial dan Kemanusiaan (FSSK)':
        '1.5 km',
    'Kolej Ibu Zain (KIZ)_Fakulti Undang-Undang (FUU)': '4.4 km',
    'Kolej Ibu Zain (KIZ)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': '2.9 km',
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
    'Kolej Keris Mas (KKM)_Fakulti Kejuruteraan dan Alam Bina (FKAB)': '3.2 km',
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
    'Kolej Tun Hussein Onn (KTHO)_Fakulti Sains dan Teknologi (FST)': '1.6 km',
    'Kolej Tun Hussein Onn (KTHO)_Fakulti Pendidikan (FPEND)': '2.1 km',
    'Kolej Tun Hussein Onn (KTHO)_Fakulti Ekonomi dan Pengurusan (FEP)':
        '1.0 km',
    'Kolej Tun Hussein Onn (KTHO)_Fakulti Pengajian Islam (FPI)': '2.2 km',
    'Kolej Tun Hussein Onn (KTHO)_Pusat Pengajian Citra Universiti (PPCU)':
        '1.6 km',
  };

  void calculateDistanceAndPrice() {
  if (fromLocation != null && toLocation != null) {
    String routeKey = '${fromLocation}_$toLocation';
    String? routeDistance = distanceMap[routeKey];

    // Try the reverse route if forward route is not found
    if (routeDistance == null) {
      routeKey = '${toLocation}_$fromLocation';
      routeDistance = distanceMap[routeKey];
    }

    if (routeDistance != null) {
      // Remove ' km' and convert to double
      double distanceInKm = double.parse(routeDistance.replaceAll(' km', ''));

      setState(() {
        distance = '$distanceInKm km';
        price = 'RM ${(1.5 * distanceInKm).toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        distance = 'Route not found';
        price = '';
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Route'),
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
                    Icon(Icons.my_location_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildDropdown(
                  value: fromLocation,
                  onChanged: (newValue) {
                    setState(() {
                      fromLocation = newValue;
                    });
                  },
                  hintText: 'Select a location',
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'To',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildDropdown(
                  value: toLocation,
                  onChanged: (newValue) {
                    setState(() {
                      toLocation = newValue;
                    });
                  },
                  hintText: 'Select a location',
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: calculateDistanceAndPrice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 48, 98, 207),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "Calculate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  icon: Icons.map,
                  label: 'Distance',
                  value: distance,
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  icon: Icons.attach_money,
                  label: 'Price',
                  value: price,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required void Function(String?) onChanged,
    required String hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hintText),
          isExpanded: true,
          items: locations.map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

