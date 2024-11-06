import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF82B1FF), Color(0xFF2962FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: const Text(
                "Activity",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
              labelColor: Colors.white,
              indicatorColor: Colors.white,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCompletedTab(),
                  _buildCancelledTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTab() {
    return ListView(
      children: [
        _buildActivityItem('Successful', 'Kolej Ibrahim Yaakob (KIY), UKM', '20/5/2024'),
        _buildActivityItem('Successful', 'Fakulti Teknologi dan Sains Maklumat (FTSM), UKM', '25/5/2024'),
      ],
    );
  }

  Widget _buildCancelledTab() {
    return const Center(
      child: Text('No cancelled activities', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildActivityItem(String status, String location, String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.directions_car,
                color: status == 'Successful' ? Colors.blue : Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis, // Prevents overflow
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Add Feedback'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ActivityPage(),
  ));
}

void main() {
  runApp(const MaterialApp(
    home: ActivityPage(),
  ));
}
