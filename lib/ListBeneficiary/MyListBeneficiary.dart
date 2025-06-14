import 'package:flutter/material.dart';
import '../ListBeneficiary/AddListBeneficiaryData.dart';
import '../MyActivity/UnplannedActivitiyEvent.dart';
import 'BeneficiaryDetail.dart';
import 'DeleteBeneficiary.dart';
import 'ViewBeneficiary.dart';



class MyListBeneficiary extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = DateTime.now();
    final DateTime tomorrow = selectedDate.add(Duration(days: 1));

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Beneficiary',
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
                Tab(text: 'View'),
                Tab(text: 'Add'),
                Tab(text: 'Delete')
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // ViewBeneficiaries(),
                  // BeneficiaryProfileDetail(profile: formData),
                  AddListBeneficiary(),
                  DeleteBeneficiary(),
                  // DeleteData(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
