import 'package:flutter/material.dart';

import 'AddActivity.dart';
import 'ListingActivity.dart';

class MyActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Activity',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.yellow[800],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.yellow,
              tabs: [
                Tab(text: 'Today Plan'),
                Tab(text: 'Future Plan'),
                Tab(text: 'Plan Activity')
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Show only today's activities
                  ListingFormActivity(
                    selectedDate: today,
                    mode: 'today',
                  ),
                  // Show all activities after today
                  ListingFormActivity(
                    selectedDate: today,
                    mode: 'future',
                  ),
                  AddActivity(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
