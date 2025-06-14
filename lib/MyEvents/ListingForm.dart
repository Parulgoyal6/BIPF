

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Common/DatabaseHelper.dart';
import '../Models/adding_an_event.dart';
import 'AddEvent.dart';

class ListingForm extends StatefulWidget {
  final DateTime? selectedDate;

  // const ListingForm({Key? key, required this.selectedDate}) : super(key: key);
  ListingForm({this.selectedDate});


  @override
  State<ListingForm> createState() => _ListingFormState();
}

class _ListingFormState extends State<ListingForm> {
  String? selectedDistrict;
  String? selectedBlock;
  String? selectedVillage;
  String? selectedGP;

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

  final Map<String, List<String>> gpList = {
    'Village 1': ['GP 1', 'GP 2'],
    'Village 2': ['GP 3', 'Village 4'],
    'Village 3': ['GP 5', 'GP 6'],
    'Village 4': ['GP 7', 'GP 8'],
    'Village 5': ['GP 9', 'GP 10'],
    'Village 6': ['GP 11', 'GP 12'],
    'Village 7': ['GP 11', 'GP 12'],
    'Village 8': ['GP 11', 'GP 12'],
    'Village 9': ['GP 11', 'GP 12'],
    'Village 10': ['GP 11', 'GP 12'],
    'Village 11': ['GP 11', 'GP 12'],
    'Village 12': ['GP 11', 'GP 12'],
  };

  List<Map<String, dynamic>> form = [];     // filtered list
  List<Map<String, dynamic>> allForms = []; // original full list

  @override
  void initState() {
    super.initState();
    initializeRegistration();
  }

  void initializeRegistration() async {
    String query = "SELECT * FROM Event_Form ORDER BY local_id DESC";
    List<AddingAnEvent> data = await DatabaseHelper.instance.getAddingAnEvent(query);

    if (widget.selectedDate == null) {
      print('null');
      // Agar date select nahi ki hai, pura data dikhayen bina filter ke
      allForms = data.map((eventForm) {
        final parsedDate = DateTime.tryParse(eventForm.date ?? '');

        final formattedDate = parsedDate != null
            ? DateFormat('dd/MM/yyyy').format(parsedDate)
            : '';

        return {
          'name': eventForm.name_of_event,
          'Date': formattedDate,
          'village': eventForm.village,
          'total': eventForm.total_participants,
          'male': eventForm.men,
          'female': eventForm.women,
          'other': eventForm.other,
          'district': eventForm.district,
          'block': eventForm.block,
        };
      }).toList();
    } else {
      // Agar date select ki hai, tab filter lagayen
      allForms = data.map((eventForm) {
        final parsedDate = DateTime.tryParse(eventForm.date ?? '');
        print('parsedDate $parsedDate');
        final selectedDate = widget.selectedDate;
        print('selectedDate $selectedDate');
        final isSameDate = parsedDate != null &&
            selectedDate != null &&
            parsedDate.year == selectedDate.year &&
            parsedDate.month == selectedDate.month &&
            parsedDate.day == selectedDate.day;


        if (!isSameDate) {
          return null;
        }

        final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

        return {
          'name': eventForm.name_of_event,
          'Date': formattedDate,
          'village': eventForm.village,
          'total': eventForm.total_participants,
          'male': eventForm.men,
          'female': eventForm.women,
          'other': eventForm.other,
          'district': eventForm.district,
          'block': eventForm.block,
          'group': 'SHG'
        };
      }).where((element) => element != null).cast<Map<String, dynamic>>().toList();
    }

    form = List.from(allForms);
    print('datais $form');
    setState(() {});
  }

  void filterForms() {
    setState(() {
      form = allForms.where((event) {
        final matchDistrict = selectedDistrict == null || event['district'] == selectedDistrict;
        final matchBlock = selectedBlock == null || event['block'] == selectedBlock;
        final matchVillage = selectedVillage == null || event['village'] == selectedVillage;
        return matchDistrict && matchBlock && matchVillage;
      }).toList();
    });
    print("Filtered count: ${form.length}");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.yellow[800],
      //   iconTheme: IconThemeData(
      //     color: Colors.white, // color of the back arrow
      //   ),
      //   // title: Text(
      //   //   'List the Activities',
      //   //   style: TextStyle(
      //   //     color: Colors.white, // color of the title text
      //   //   ),
      //   // ),
      // ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  decoration: const InputDecoration(
                    hintText: 'Select District',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                  ),
                  isDense: true,
                  items: districtList
                      .map((String value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDistrict = newValue;
                      selectedBlock = null;
                      selectedVillage = null;
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedBlock,
                  decoration: const InputDecoration(
                    hintText: 'Select Block',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  ),
                  items: selectedDistrict != null
                      ? blockList[selectedDistrict]!
                      .map((String value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                      .toList()
                      : [],
                  onChanged: selectedDistrict != null
                      ? (String? newValue) {
                    setState(() {
                      selectedBlock = newValue;
                      selectedVillage = null;
                    });
                  }
                      : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedVillage,
                  decoration: const InputDecoration(
                    hintText: 'Select Village',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  ),
                  items: selectedBlock != null
                      ? villageList[selectedBlock]!
                      .map((String value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                      .toList()
                      : [],
                  onChanged: selectedBlock != null
                      ? (String? newValue) {
                    setState(() {
                      selectedVillage = newValue;
                    });
                  }
                      : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedGP,
                  decoration: const InputDecoration(
                    hintText: 'Select GP',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  ),
                  items: selectedVillage != null
                      ? gpList[selectedVillage]!
                      .map((String value) =>
                      DropdownMenuItem(value: value, child: Text(value)))
                      .toList()
                      : [],
                  onChanged: selectedVillage != null
                      ? (String? newValue) {
                    setState(() {
                      selectedGP = newValue;
                    });
                  }
                      : null,
                ),


                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: filterForms,
                    child: Text('Go', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[800])
                  ),
                ),
                const SizedBox(height: 5),
                ...form.map((formData) {
                  return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   width: 120,
                                       Text(
                                        "Event Name : ",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),

                                        Text(
                                          '${formData["name"]}',
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
                                      "Group : ",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),

                                    Text(
                                      '${formData["group"]}',
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
                              ],
                            ),
                            const SizedBox(height: 8),
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
                                      '${formData["Date"]}',
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
                            const SizedBox(height: 8),
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
                                      '${formData["district"]}/ ${formData["block"]}/ ${formData["village"]}',
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
                            // const SizedBox(height: 8),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     // Container(
                            //     //   width: 120,
                            //       Text(
                            //         "Block : ",
                            //         style: const TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w600,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //    // ),
                            //     // const SizedBox(width: 20),
                            //     // const Text(":"),
                            //     // const SizedBox(width: 40),
                            //     // Expanded(
                            //     //   child: SingleChildScrollView(
                            //     //     scrollDirection: Axis.vertical,
                            //          Text(
                            //           '${formData["block"]}',
                            //           style: const TextStyle(
                            //             fontSize: 14,
                            //             fontWeight: FontWeight.w500,
                            //             color: Colors.black,
                            //           ),
                            //         ),
                            //     //   ),
                            //     // ),
                            //   ],
                            // ),
                            // const SizedBox(height: 8),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     // Container(
                            //     //   width: 120,
                            //      Text(
                            //         "Village : ",
                            //         style: const TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w600,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //   //  ),
                            //     // const SizedBox(width: 20),
                            //     // const Text(":"),
                            //     // const SizedBox(width: 40),
                            //     // Expanded(
                            //     //   child: SingleChildScrollView(
                            //     //     scrollDirection: Axis.vertical,
                            //          Text(
                            //           '${formData["village"]}',
                            //           style: const TextStyle(
                            //             fontSize: 14,
                            //             fontWeight: FontWeight.w500,
                            //             color: Colors.black,
                            //           ),
                            //         ),
                            //     //   ),
                            //     // ),
                            //   ],
                            // ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(
                                //   width: 120,
                                   Text(
                                    "Total Participants : ",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                              //  ),
                                // const SizedBox(width: 20),
                                // const Text(":"),
                                // const SizedBox(width: 40),
                                // Expanded(
                                //   child: SingleChildScrollView(
                                //     scrollDirection: Axis.vertical,
                                    Text(
                                      '${formData["total"]}',
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
                            const SizedBox(height: 16),
                            const Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => AddListBeneficiary()));
        },
        child: Text('Add'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

