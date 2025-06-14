
import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:analog_clock/analog_clock.dart';
import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Models/adding_an_activity.dart';
import '../Models/adding_an_event.dart';
import 'AddInitiativeActivity.dart';

class ListingFormActivity extends StatefulWidget {
   final DateTime selectedDate;
   final String mode;
  // ListingFormActivity({Key? key}) : super(key: key);
  // ListingFormActivity({Key? key, DateTime? selectedDate})
  //     : selectedDate = selectedDate ?? DateTime.now(),
  //       super(key: key);
   const ListingFormActivity({super.key, required this.selectedDate, required this.mode});
  @override
  State<ListingFormActivity> createState() => _ListingFormState();
}

class _ListingFormState extends State<ListingFormActivity> {
  String? selectedDistrict;
  String? selectedBlock;
  String? selectedVillage;

  List<Map<String, dynamic>> form = []; // filtered list
  List<Map<String, dynamic>> allForms = []; // original full list

  @override
  void initState() {
    super.initState();

    initializeRegistration();
  }
  bool isRescheduled = false;

  void initializeRegistration() async {
    String query = "SELECT * FROM Activity_Form ORDER BY local_id DESC";
    List<AddingAnActivity> data = await DatabaseHelper.instance.getAddingAnActivity(query);

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
        'name': eventForm.name_of_activity,
        'village': eventForm.village,
        'total': eventForm.total_participants,
        'male': eventForm.men,
        'female': eventForm.women,
        'other': eventForm.other,
        'district': eventForm.district,
        'block': eventForm.block,
        'beneficiary': eventForm.beneficiary,
        'date': formattedDate,
        'start_time': parseTime(eventForm.start_time),
        'end_time': parseTime(eventForm.end_time),
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

  // void initializeRegistration() {
  //     DateTime? parseTime(String? timeString) {
  //       if (timeString == null || timeString.isEmpty) return null;
  //       try {
  //         final parts = timeString.split(':');
  //         final now = DateTime.now();
  //         return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  //       } catch (e) {
  //         return null;
  //       }
  //     }
  //   // Static data of 5 users
  //   allForms = [
  //     {
  //       'name': 'Immunization VHSND',
  //       'date': '09/06/2025',
  //       'start_time':parseTime('11:00 Am'),
  //       'end_time': parseTime('1:00 Pm'),
  //       'district': 'Kelliguda',
  //       'block': 'Pujariguda',
  //       'village': 'Maa Tulasi',
  //     },
  //     {
  //
  //       'name': 'Career Counselling',
  //       'date': '09/06/2025',
  //       'start_time':parseTime('11:00 Am'),
  //       'end_time': parseTime('1:00 Pm'),
  //       'district': 'Kelliguda',
  //       'block': 'Pujariguda',
  //       'village': 'Maa Tulasi',
  //     },
  //     {
  //
  //       'name': 'Livelihood Data Collection/FU',
  //       'date': '10/06/2025',
  //       'start_time':parseTime('11:00 Am'),
  //       'end_time': parseTime('1:00 Pm'),
  //       'district': 'Kelliguda',
  //       'block': 'Pujariguda',
  //       'village': 'Maa Tulasi',
  //     },
  //     {
  //
  //       'name': 'Training Program',
  //       'date': '10/06/2025',
  //       'start_time':parseTime('11:00 Am'),
  //       'end_time': parseTime('1:00 Pm'),
  //       'district': 'Kelliguda',
  //       'block': 'Pujariguda',
  //       'village': 'Maa Tulasi',
  //     },
  //     {
  //       'name': 'Exposure Visit',
  //       'date': '11/06/2025',
  //       'start_time':parseTime('11:00 Am'),
  //       'end_time': parseTime('1:00 Pm'),
  //       'district': 'Kelliguda',
  //       'block': 'Pujariguda',
  //       'village': 'Maa Tulasi',
  //     },
  //   ];
  //     // final selectedDateStr = DateFormat('dd/MM/yyyy').format(widget.selectedDate);
  //     //
  //     // form = allForms.where((event) => event['date'] == selectedDateStr).toList();
  //   // Apply date filter if widget.selectedDate is set
  //   // if (widget.selectedDate != null) {
  //   //   final selectedDateStr = DateFormat('dd/MM/yyyy').format(
  //   //       widget.selectedDate!);
  //   //   form =
  //   //       allForms.where((event) => event['date'] == selectedDateStr).toList();
  //   // } else {
  //     //
  //       final selectedDateStr = DateFormat('dd/MM/yyyy').format(widget.selectedDate);
  //
  //       form = allForms.where((event) => event['date'] == selectedDateStr).toList();
  //
  //       setState(() {});
  //     // form = List.from(allForms);
  //   // }
  //
  //   // setState(() {});
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
  DateTime _selectedDate = DateTime.now();
  late String formattedDate;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.yellow[800],
      //   iconTheme: IconThemeData(
      //     color: Colors.white, // color of the back arrow
      //   ),
      //   title: Text(
      //     'Activities For Today ${DateFormat('dd-MMMM-yyyy').format(_selectedDate)}',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 18
      //       // color of the title text
      //     ),
      //   ),
      // ),
       body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: form.isEmpty
        ? Center(
        child: Text(
          "No activity found for the selected date.",
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : SingleChildScrollView(
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
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Activity Name: ${formData["name"]}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 14,),
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
                          Row(
                            children: [
                              Text(
                                "Clock: ",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,  // chhota size
                                    height: 40,
                                    child: AnalogClock(
                                      datetime: formData['start_time'] ?? DateTime.now(),
                                      showDigitalClock: false,
                                      isLive: false,
                                      width: 60,    // agar AnalogClock support karta hai
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2, color: Colors.blue),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: AnalogClock(
                                      datetime: formData['end_time'] ?? DateTime.now(),
                                      showDigitalClock: false,
                                      isLive: false,
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 2, color: Colors.red),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),


                          // Text(
                          //   "Time: ${formData["start_time"]} - ${formData["end_time"]}",
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.black,
                          //   ),
                          // ),
                          const SizedBox(height: 8),
                          Text(
                            "Location: ${formData["district"]}/ ${formData["block"]}/ ${formData["village"]}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),


                          // const SizedBox(height: 4),
                          // Text(
                          //   "Total Participants: ${formData["total"]}",
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w500,
                          //     color: Colors.black,
                          //   ),
                          // ),

                          //const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              ElevatedButton(
                                onPressed: () async {
                                  print('id ${formData['id']}');
                                   await SharedPreferHelper.setPrefString('id', formData['id'].toString());
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          AddInitiativeActivity(isInitiate: true,)));
                                  // Initiate logic here
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: Size(50, 26),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                child: const Text("Initiate", style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(

    onPressed: () async {
    bool? confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text('Confirm Edit'),
    content: Text('Do you want to Reschedule it?'),
    actions: [
    TextButton(
    onPressed: () {
    Navigator.of(context).pop(false); // No
    },
    child: Text('No'),
    ),
    TextButton(
    onPressed: () {
    Navigator.of(context).pop(true); // Yes
    },
    child: Text('Yes'),
    ),
    ],
    );
    },
    );

    if (confirm == true) {
      await SharedPreferHelper.setPrefString('id', formData['id'].toString());
    // Reschedule logic here
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => AddInitiativeActivity(isReschedule: true,
    )));
    }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  minimumSize: Size(80, 26),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                child: const Text("Reschedule",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // Cancel logic here
                                  _showCancelDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  minimumSize: Size(60, 26),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                child: const Text("Cancel", style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                              ),

                            ],
                          ),
                       //   const Divider(color: Colors.grey),
                        ],
                      ),

                    ),
//                    ),

                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         Navigator.push(
    //             context, MaterialPageRoute(builder: (context) => AddActivity()));
    //       },
    //       child: Text('Add', style: TextStyle(color: Colors.white),),backgroundColor: Colors.orange,
    //     ),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
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
              child: Text("No",style: TextStyle(color: Colors.red),),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Yes",style: TextStyle(color: Colors.white),),
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
              child:  TextFormField(
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
                child: Text("Submit",style: TextStyle(color: Colors.white),),
              ),
            ],
          );
        },
      );
    }
  }
}


class SmallAnalogClock extends StatelessWidget {
  final DateTime time;
  final double size;

  const SmallAnalogClock({required this.time, this.size = 60, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ClockPainter(time),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final DateTime time;

  _ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paintHourHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final paintMinuteHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Draw clock face
    canvas.drawCircle(center, radius, paintCircle);
    canvas.drawCircle(center, radius, paintBorder);

    // Calculate angles
    double hourAngle = (time.hour % 12 + time.minute / 60) * 30 * pi / 180;
    double minuteAngle = time.minute * 6 * pi / 180;

    // Hour hand
    final hourHandLength = radius * 0.5;
    final hourHandEnd = Offset(
      center.dx + hourHandLength * sin(hourAngle),
      center.dy - hourHandLength * cos(hourAngle),
    );
    canvas.drawLine(center, hourHandEnd, paintHourHand);

    // Minute hand
    final minuteHandLength = radius * 0.7;
    final minuteHandEnd = Offset(
      center.dx + minuteHandLength * sin(minuteAngle),
      center.dy - minuteHandLength * cos(minuteAngle),
    );
    canvas.drawLine(center, minuteHandEnd, paintMinuteHand);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
