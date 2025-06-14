import 'package:flutter/material.dart';
import '../ListBeneficiary/AddListBeneficiaryData.dart';
import '../MyActivity/UnplannedActivitiyEvent.dart';
import 'AddEvent.dart';
import 'ListingForm.dart';


class MyEventsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = DateTime.now();
    final DateTime tomorrow = selectedDate.add(Duration(days: 1));
    final DateTime today = DateTime.now();
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Events',
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
                Tab(text: 'Plan Event')
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // Show only today's activities
                  PlannedActivity(selectedDate: today,  mode: 'today',),
                  // Show all activities after today
                  PlannedActivity(
                    selectedDate: today,
                    mode: 'future',
                  ),
                  AddEvent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
