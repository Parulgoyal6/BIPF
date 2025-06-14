import 'package:flutter/material.dart';

class MyResourcesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> resources = [
    {'title': 'Digital Literacy', 'icon': Icons.computer, 'color': Colors.blue},
    {'title': 'Livelihood', 'icon': Icons.work, 'color': Colors.green},
    {'title': 'Financial Literacy', 'icon': Icons.account_balance_wallet, 'color': Colors.purple},
    {'title': 'Health & Wellness', 'icon': Icons.health_and_safety, 'color': Colors.redAccent},
    {'title': 'Water & Sanitation', 'icon': Icons.water_drop, 'color': Colors.teal},
    {'title': 'Education', 'icon': Icons.school, 'color': Colors.deepOrange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Resources'),
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final resource = resources[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    resource['color'].withOpacity(0.9),
                    resource['color'].withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: resource['color'].withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: Icon(resource['icon'], size: 28, color: Colors.white),
                title: Text(
                  resource['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening ${resource['title']}')),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
