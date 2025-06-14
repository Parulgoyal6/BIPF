


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Models/adding_an_event.dart';
import '../MyEvents/AddEvent.dart';
import 'AddInitiativeActivity.dart';
import 'UnplannedActivitiyEvent.dart';


class PlannedActivity extends StatefulWidget {
  final DateTime selectedDate;
  final String mode;
  // const ListingForm({Key? key, required this.selectedDate}) : super(key: key);
  // PlannedActivity({this.selectedDate});
  // PlannedActivity({Key? key, DateTime? selectedDate})
  //     : selectedDate = selectedDate ?? DateTime.now(),
  //       super(key: key);


  const PlannedActivity({super.key, required this.selectedDate, required this.mode});

  @override
  State<PlannedActivity> createState() => _ListingFormState();
}

class _ListingFormState extends State<PlannedActivity> {
  bool isRescheduled = false;
  String? selectedDistrict;
  String? selectedBlock;
  String? selectedVillage;

  final List<String> districtList = ['District 1', 'District 2', 'District 3'];
  final Map<String, List<String>> blockList = {
    'District 1': ['Block A', 'Block B'],
    'District 2': ['Block C', 'Block D'],
    'District 3': ['Block E', 'Block F'],
  };
  final Map<String, List<String>> villageList = {
    'Block A': ['Village 1', 'Village 2'],
    'Block B': ['Village 3', 'Village 4'],
    'Block C': ['Village 5', 'Village 6'],
    'Block D': ['Village 7', 'Village 8'],
    'Block E': ['Village 9', 'Village 10'],
    'Block F': ['Village 11', 'Village 12'],
  };

  List<Map<String, dynamic>> form = []; // filtered list
  List<Map<String, dynamic>> allForms = []; // original full list

  @override
  void initState() {
    super.initState();
    initializeRegistration();
  }

  // void initializeRegistration() {
  //   // Static data of 5 users
  //   allForms = [
  //     {
  //       'id': '1',
  //       'name': 'Event A',
  //       'Date': '01/06/2025',
  //       'start_time':'11:00 Am',
  //       'end_time': '1:00 Pm',
  //       'district': 'District 1',
  //       'block': 'Block A',
  //       'village': 'Village 1',
  //       'total': 25,
  //       'male': 12,
  //       'female': 10,
  //       'other': 3,
  //       'group': 'SGC',
  //       'topic_name': 'AMA KATHA-1',
  //       'chapter_name':'Aama Gaan'
  //     },
  //     {
  //       'id': '2',
  //       'name': 'Event B',
  //       'Date': '02/06/2025',
  //       'start_time':'12:00 Pm',
  //       'end_time': '1:00 Pm',
  //       'district': 'District 2',
  //       'block': 'Block C',
  //       'village': 'Village 5',
  //       'total': 30,
  //       'male': 15,
  //       'female': 13,
  //       'other': 2,
  //       'group': 'SGC',
  //       'topic_name': 'AMA KATHA-2',
  //       'chapter_name':'Pathe Pathe Shubhe'
  //     },
  //     {
  //       'id': '3',
  //       'name': 'Event C',
  //       'Date': '03/06/2025',
  //       'start_time':'10:00 Am',
  //       'end_time': '1:00 Pm',
  //       'district': 'District 3',
  //       'block': 'Block E',
  //       'village': 'Village 9',
  //       'total': 20,
  //       'male': 10,
  //       'female': 9,
  //       'other': 1,
  //       'group': 'SGC',
  //       'topic_name': 'AMA KATHA-3',
  //       'chapter_name':'Kasta Kale Krushna Mille'
  //     },
  //     {
  //       'id': '4',
  //       'name': 'Event D',
  //       'Date': '05/06/2025',
  //       'start_time':'11:00 Am',
  //       'end_time': '1:00 Pm',
  //       'district': 'District 1',
  //       'block': 'Block B',
  //       'village': 'Village 3',
  //       'total': 40,
  //       'male': 20,
  //       'female': 17,
  //       'other': 3,
  //       'group': 'SGC',
  //       'topic_name': 'Digital Literacy',
  //       'chapter_name':'Use of internet Browsing'
  //     },
  //     {
  //       'id': '5',
  //       'name': 'Event E',
  //       'Date': '05/06/2025',
  //       'start_time':'9:00 Am',
  //       'end_time': '1:00 Pm',
  //       'district': 'District 2',
  //       'block': 'Block D',
  //       'village': 'Village 8',
  //       'total': 35,
  //       'male': 18,
  //       'female': 15,
  //       'other': 2,
  //       'group': 'SGC',
  //       'topic_name': 'Financial Literacy',
  //       'chapter_name':'Aarthika Sakhyarata'
  //     },
  //   ];
  //
  //   // Apply date filter if widget.selectedDate is set
  //   if (widget.selectedDate != null) {
  //     final selectedDateStr = DateFormat('dd/MM/yyyy').format(
  //         widget.selectedDate!);
  //     form =
  //         allForms.where((event) => event['Date'] == selectedDateStr).toList();
  //   } else {
  //     form = List.from(allForms);
  //   }
  //
  //   setState(() {});
  // }
  void initializeRegistration() async {
    String query = "SELECT * FROM Event_Form ORDER BY local_id DESC";
    List<AddingAnEvent> data = await DatabaseHelper.instance.getAddingAnEvent(query);

    DateTime? parseTime(String? timeString) {
      if (timeString == null || timeString.isEmpty) return null;
      try {
        final parts = timeString.split(':');
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      } catch (e) {
        return null;
      }
    }

    allForms = data.map((eventForm) {
      final formattedDate = eventForm.date != null
          ? DateFormat('dd/MM/yyyy').format(DateTime.parse(eventForm.date!))
          : '';

      return {
        'id': eventForm.local_id,
        'name': eventForm.name_of_event,
        'village': eventForm.village,
        'total': eventForm.total_participants,
        'male': eventForm.men,
        'female': eventForm.women,
        'other': eventForm.other,
        'district': eventForm.district,
        'block': eventForm.block,
        'beneficiary': eventForm.beneficiary,
        'date': formattedDate,
        'start_time': eventForm.start_time,
        'end_time': eventForm.end_time,
        'topic_name': eventForm.topic_name,
        'chapter_name': eventForm.chapter_name
      };
    }).toList();

    // final selectedDateStr = DateFormat('dd/MM/yyyy').format(widget.selectedDate);
    //
    // form = allForms.where((event) => event['date'] == selectedDateStr).toList();
    final today = DateTime(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);

    form = allForms.where((event) {
      final dateStr = event['date'];
      if (dateStr == null || dateStr.isEmpty) return false;

      try {
        final parsedDate = DateFormat('dd/MM/yyyy').parse(dateStr);

        if (widget.mode == 'today') {
          return parsedDate.year == today.year &&
              parsedDate.month == today.month &&
              parsedDate.day == today.day;
        } else if (widget.mode == 'future') {
          return parsedDate.isAfter(today);
        }
      } catch (e) {
        return false;
      }

      return false;
    }).toList();

    setState(() {});
  }



  // void initializeRegistration() async {
  //   String query = "SELECT * FROM Event_Form ORDER BY local_id DESC";
  //   List<AddingAnEvent> data = await DatabaseHelper.instance.getAddingAnEvent(query);
  //
  //   print("Fetched data count: ${data.length}"); // Add this line to see result
  //
  //   allForms = data.map((eventForm) {
  //     final String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(eventForm.date!));
  //     print(formattedDate);
  //     return {
  //
  //       'id': eventForm.local_id,
  //       'name': eventForm.name_of_event,
  //       'village': eventForm.village,
  //       'total': eventForm.total_participants,
  //       'male': eventForm.men,
  //       'female': eventForm.women,
  //       'other': eventForm.other,
  //       'district': eventForm.district,
  //       'block': eventForm.block,
  //       'beneficiary': eventForm.beneficiary,
  //       'date': formattedDate,
  //       'start_time': eventForm.start_time,
  //       'end_time': eventForm.end_time,
  //       'topic_name': eventForm.topic_name,
  //       'chapter_name': eventForm.chapter_name
  //     };
  //   }).toList();
  //
  //   form = List.from(allForms);
  //   print("Mapped data: $form"); // Add this too
  //   setState(() {});
  // }

  void filterForms() {
    setState(() {
      form = allForms.where((event) {
        final matchDistrict = selectedDistrict == null ||
            event['district'] == selectedDistrict;
        final matchBlock = selectedBlock == null ||
            event['block'] == selectedBlock;
        final matchVillage = selectedVillage == null ||
            event['village'] == selectedVillage;
        return matchDistrict && matchBlock && matchVillage;
      }).toList();
    });
    print("Filtered count: ${form.length}");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  ...form.map((formData) {
          return Card(
          elevation: 3,
          color: Colors.grey[200],
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(
          "Event Name: ${formData["name"]}",
          style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          ),
          ),
          Text(
          "Group: ${formData["group"] ?? 'SHG'}",
          style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          ),
          ),
          ],
          ),
          // const SizedBox(height: 8),
          // const Text(
          // "Sub-Activity: Reading Session",
          // style: TextStyle(
          // fontSize: 14,
          // fontWeight: FontWeight.w500,
          // color: Colors.black,
          // ),
          // ),
          // const SizedBox(height: 8),
          // Text(
          // "Date: ${formData["date"]}",
          // style: const TextStyle(
          // fontSize: 14,
          // fontWeight: FontWeight.w500,
          // color: Colors.black,
          // ),
          // ),
          const SizedBox(height: 4),
          Text(
          "Time: ${formData["start_time"]} - ${formData["end_time"]}",
          style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          ),
          ),
          const SizedBox(height: 4),
          Text(
          "Location: ${formData["district"]}/ ${formData["block"]}/ ${formData["village"]}",
          style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          ),
          ),
          const SizedBox(height: 4),
          Text(
          "Total Participants: ${formData["total"]}",
          style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          ),
          ),
          // const SizedBox(height: 4),
          // Text(
          // "Topic Name: ${formData["topic_name"]}",
          // style: const TextStyle(
          // fontSize: 14,
          // fontWeight: FontWeight.w500,
          // color: Colors.black,
          // ),
          // ),
          // const SizedBox(height: 4),
          // Text(
          // "Chapter Name: ${formData["chapter_name"]}",
          // style: const TextStyle(
          // fontSize: 14,
          // fontWeight: FontWeight.w500,
          // color: Colors.black,
          // ),
          // ),
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          ElevatedButton(
          onPressed: () async{
            await SharedPreferHelper.setPrefString('id', formData['id'].toString());
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => AddEvent(isInitiate: true,),
          ),
          );
          },
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(50, 26),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          child: const Text(
          "Initiate",
          style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          ),
          const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Edit'),
                      content: const Text('Do you want to Reschedule it?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false), // No
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true), // Yes
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  // Reason dialog
                  String? reason = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController reasonController = TextEditingController();

                      return AlertDialog(
                        title: const Text('Reason for Rescheduling',style: TextStyle(fontSize: 16),),
                        content: TextField(
                        controller: reasonController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // ONLY allows letters and space
                        ],
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "Please provide a reason...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(null), // Cancel
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (reasonController.text.trim().isNotEmpty) {
                                Navigator.of(context).pop(reasonController.text.trim());
                              } else {
                                // Optionally show a validation message here or just do nothing
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      );
                    },
                  );

                  if (reason != null && reason.isNotEmpty) {
                    print('Reason: $reason');
                    print('form_id ${formData['id']}');
                    await SharedPreferHelper.setPrefString('id', formData['id'].toString());
                    await SharedPreferHelper.setPrefString('reason', reason);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEvent(isReschedule: true),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(80, 26),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: const Text(
                "Reschedule",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),

            const SizedBox(width: 8),
          ElevatedButton(
          onPressed: () {
          _showCancelDialog(context, formData['id']);
          },
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size(60, 26),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          child: const Text(
          "Cancel",
          style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          ),
          ],
          ),
          ],
          ),
          ),
          );
          }).toList(),
        ]),
      ),
    ),
    ),

    //   floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //           context, MaterialPageRoute(builder: (context) => AddListBeneficiary()));
      //     },
      //     child: Text('Add'),
      //   ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showCancelDialog(BuildContext context , deleteId) async {
    TextEditingController reasonController = TextEditingController();

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 10),
              Text("Cancel Confirmation", style: TextStyle(fontSize: 15),),
            ],
          ),
          content: Text("Do you really want to cancel"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No", style: TextStyle(color: Colors.red),),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Yes", style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );

    if (shouldCancel == true) {
      // Show input dialog for reason
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Reason for Cancellation", style: TextStyle(fontSize: 15),),
            content: SizedBox(
              height: 70,
              child: TextField(
                controller: reasonController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // ONLY allows letters and space
                ],
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Please provide a reason...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Back",style: TextStyle(color: Colors.red),),
              ),
              ElevatedButton(
                onPressed: () {
                  String reason = reasonController.text.trim();
                  if (reason.isNotEmpty) {
                    print("Cancelled' for reason: $reason");
                    // TODO: Call your cancel API / update database here
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Activity cancelled.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Submit", style: TextStyle(color: Colors.white),),
              ),
            ],
          );
        },
      );
    }
  }
}

