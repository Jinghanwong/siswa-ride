import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EarningPage extends StatefulWidget {
  final String userName; // 添加 userName 参数
  const EarningPage({super.key, required this.userName});

  @override
  State<EarningPage> createState() => _EarningPageState();
}

class _EarningPageState extends State<EarningPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> earnings = [];
  double totalEarnings = 0;

  @override
  void initState() {
    super.initState();
    loadEarnings();
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE, d MMM yy');
    return formatter.format(now);
  }

  Future<void> loadEarnings() async {
    try {
      // 获取当前登录的driver ID
      final String? driverId = _auth.currentUser?.uid;
      if (driverId == null) return;

      // 获取所有bookings
      final DatabaseEvent event = await _database.child('bookings').once();

      if (event.snapshot.value == null) return;

      // 转换数据为Map
      final Map<dynamic, dynamic> bookingsData =
          event.snapshot.value as Map<dynamic, dynamic>;

      double total = 0;
      List<Map<String, dynamic>> earningsList = [];

      // 遍历所有用户的bookings
      bookingsData.forEach((userId, userBookings) {
        if (userBookings is Map) {
          // 遍历该用户的所有bookingId
          userBookings.forEach((bookingId, bookingData) {
            if (bookingData is Map &&
                bookingData['driverId'] == driverId &&
                bookingData['status'] == 'finished') {
              // 处理价格
              double price = 0.0;
              var rawPrice = bookingData['price'];
              if (rawPrice is String) {
                price = double.tryParse(rawPrice.replaceAll('RM', '').trim()) ??
                    0.0;
              } else if (rawPrice is num) {
                price = rawPrice.toDouble();
              }

              total += price;

              // 处理日期
              String dateStr = 'No date';
              if (bookingData['bookingDate'] != null) {
                try {
                  // 解析存储的日期字符串
                  final DateTime date = DateFormat('EEE, d MMM yy')
                      .parse(bookingData['bookingDate']);
                  // 格式化为需要显示的格式
                  dateStr = DateFormat('dd/MM/yy').format(date);
                } catch (e) {
                  print('Error parsing date: $e');
                }
              }

              earningsList.add({
                'userName': bookingData['userName'] ?? 'Unknown User',
                'price': price,
                //'location': bookingData['pickup'] ?? 'Unknown Location',
                'date': dateStr,
              });
            }
          });
        }
      });

      // 按日期排序（最新的在前）
      earningsList.sort((a, b) {
        return DateFormat('dd/MM/yy')
            .parse(b['date'])
            .compareTo(DateFormat('dd/MM/yy').parse(a['date']));
      });

      setState(() {
        earnings = earningsList;
        totalEarnings = total;
      });
    } catch (e) {
      print('Error loading earnings: $e');
    }
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
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      getCurrentDate(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "RM ${totalEarnings.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF2962FF),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                      ),
                      child: const Text(
                        "WITHDRAW",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: earnings.length,
                        itemBuilder: (context, index) {
                          final earning = earnings[index];
                          return ListTile(
                            leading: const Icon(Icons.arrow_upward),
                            title: Text(earning['userName']),
                            subtitle: Text(
                                "${earning['date']}"),
                            trailing: Text(
                              "+RM${earning['price'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
