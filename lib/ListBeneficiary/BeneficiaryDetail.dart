import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';

class BeneficiaryProfileDetail extends StatelessWidget {
  final Map<String, dynamic> profile;

  const BeneficiaryProfileDetail({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Dummy list of events with image paths (replace with network URLs or asset paths)
    final List<Map<String, String>> events = [
      {
        "event": "Health Camp",
        "date": "12 Mar 2024",
        "image": "https://via.placeholder.com/300x200?text=Health+Camp"
      },
      {
        "event": "Awareness Drive",
        "date": "5 Feb 2024",
        "image": "https://via.placeholder.com/300x200?text=Awareness+Drive"
      },
      {
        "event": "Nutrition Workshop",
        "date": "20 Jan 2024",
        "image": "https://via.placeholder.com/300x200?text=Nutrition+Workshop"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        iconTheme: IconThemeData(
          color: Colors.white, // color of the back arrow
        ),
        title: Text(
          'Beneficiary Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24
            // color of the title text
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: screenWidth * 0.96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   width: 120,
                                  Text(
                                    "Name : ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${profile["name"]}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  //   ),
                                  // ),
                                ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   width: 120,
                                  Text(
                                    "Location : ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${profile["district"]}/ ${profile["block"]}/ ${profile["village"]}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  //   ),
                                  // ),
                                ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   width: 120,
                                  Text(
                                    "Date : ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '${profile["date"]}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  //   ),
                                  // ),
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
                                          datetime: profile['start_time'] ?? DateTime.now(),
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
                                          datetime: profile['end_time'] ?? DateTime.now(),
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

                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     // Container(
                              //     //   width: 120,
                              //     Text(
                              //       "Total Participants : ",
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //     Text(
                              //       '${profile["participants"]}',
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //     //   ),
                              //     // ),
                              //   ],
                              // ),
                              //
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     // Container(
                              //     //   width: 120,
                              //     Text(
                              //       "Topic Name : ",
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //     Text(
                              //       '${profile["topic"]}',
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //     //   ),
                              //     // ),
                              //   ],
                              // ),
                              //
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     // Container(
                              //     //   width: 120,
                              //     Text(
                              //       "Chapter Name : ",
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w600,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //     Text(
                              //       '${profile["chapter"]}',
                              //       style: const TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //         color: Colors.black,
                              //       ),
                              //     ),
                              //     //   ),
                              //     // ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Participated Events:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 12),

                // Event Cards
                Column(
                  children: events.map((event) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event["event"]!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text("Date: ${event["date"]}"),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(event["event"]!),
                                      content: Image.network(
                                        event["image"]!,
                                        fit: BoxFit.cover,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Close"),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.visibility),
                                label: const Text("View Photo"),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
