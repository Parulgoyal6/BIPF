

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Common/DatabaseHelper.dart';
import '../Models/adding_an_event.dart';

import 'AddListBeneficiaryData.dart';
import 'BeneficiaryDetail.dart';
import 'ViewBeneficiary.dart';

class ListBeneficiary extends StatefulWidget {
  const ListBeneficiary({Key? key}) : super(key: key);

  @override
  ListBeneficiaryState createState() => ListBeneficiaryState();
}

class ListBeneficiaryState extends State<ListBeneficiary> {
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

  final List<Map<String, dynamic>> profile = [
    {
      "name": "Neha Sharma",
      "address": "J&K",
      "age": "32"
    },
    {
      "name": "Priya Goyal",
      "address": "Bsr",
      "age": "24"
    },
  ];


  List<Map<String, dynamic>> form = [];     // filtered list
  List<Map<String, dynamic>> allForms = []; // original full list

  @override
  void initState() {
    super.initState();
    initializeRegistration();
  }

  // void initializeRegistration() async {
  //   String query = "SELECT * FROM Event_Form ORDER BY local_id DESC";
  //   List<AddingAnEvent> data = await DatabaseHelper.instance.getAddingAnEvent(query);
  //
  //   print("Fetched data count: ${data.length}"); // Add this line to see result
  //
  //   allForms = data.map((eventForm) {
  //     return {
  //       'name': eventForm.name_of_event,
  //       'village': eventForm.village,
  //       'total': eventForm.total_participants,
  //       'male': eventForm.men,
  //       'female': eventForm.women,
  //       'other': eventForm.other,
  //       'district': eventForm.district,
  //       'block': eventForm.block,
  //       'beneficiary': 'Rahul Sharma'
  //     };
  //   }).toList();
  //
  //   form = List.from(allForms);
  //   print("Mapped data: $form"); // Add this too
  //   setState(() {});
  // }

  void initializeRegistration() {
    allForms = [
      {
        'beneficiary_name': 'Anjali Kumari',
        'father_name': 'Ramesh Kumar',
        'mother_name': 'Sita Devi',
        'age': 18,
        'number_of_beneficiaries': 1,
        'id_proof': 'Aadhar: XXXX-XXXX',
        'caste':'SC',
        'gender': 'Female',
        'marital_status':'Single',
        'phone': '9939132343',
        'education': 'B.COM',
        'disability_status':'No'
      },
      {
        'beneficiary_name': 'Pooja Sahu',
        'father_name': 'Mahesh Sahu',
        'mother_name': 'Geeta Sahu',
        'age': 17,
        'number_of_beneficiaries': 2,
        'id_proof': 'Aadhar: YYYY-YYYY',
        'caste':'OBC',
        'gender': 'Female',
        'marital_status':'Single',
        'phone': '9939132343',
        'education': 'B.COM',
        'disability_status':'No'

      },
      {
        'beneficiary_name': 'Ravi Patel',
        'father_name': 'Devendra Patel',
        'mother_name': 'Manju Patel',
        'age': 19,
        'number_of_beneficiaries': 1,
        'id_proof': 'Aadhar: ZZZZ-ZZZZ',
        'caste':'Gen',
        'gender': 'Male',
        'marital_status':'Single',
        'phone': '9939132343',
        'education': '12th',
        'disability_status':'No'

      },
      {
        'beneficiary_name': 'Susmita Patel',
        'father_name': 'Devendra Patel',
        'mother_name': 'Manju Patel',
        'age': 29,
        'number_of_beneficiaries': 1,
        'id_proof': 'Aadhar: ZZZZ-ZZZZ',
        'caste':'SC',
        'gender': 'Female',
        'marital_status':'Married',
        'phone': '9939132343',
        'education': 'M.Sc',
        'disability_status':'No'

      },
    ];

    form = List.from(allForms);

    setState(() {});
  }
// void initializeRegistration() {
//     // Static data of 5 users
//
//   DateTime? parseTime(String? timeString) {
//   if (timeString == null || timeString.isEmpty) return null;
//   try {
//   final parts = timeString.split(':');
//   final now = DateTime.now();
//   return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
//   } catch (e) {
//   return null;
//   }
//   }
//   // Static data of 5 users
//   allForms = [
//   {
//   'name': 'Immunization VHSND',
//   'date': '09/06/2025',
//   'start_time':parseTime('11:00 Am'),
//   'end_time': parseTime('1:00 Pm'),
//   'district': 'Kelliguda',
//   'block': 'Pujariguda',
//   'village': 'Maa Tulasi',
//   },
//   {
//
//   'name': 'Career Counselling',
//   'date': '09/06/2025',
//   'start_time':parseTime('11:00 Am'),
//   'end_time': parseTime('1:00 Pm'),
//   'district': 'Kelliguda',
//   'block': 'Pujariguda',
//   'village': 'Maa Tulasi',
//   },
//   {
//
//   'name': 'Livelihood Data Collection/FU',
//   'date': '10/06/2025',
//   'start_time':parseTime('11:00 Am'),
//   'end_time': parseTime('1:00 Pm'),
//   'district': 'Kelliguda',
//   'block': 'Pujariguda',
//   'village': 'Maa Tulasi',
//   },
//   {
//
//   'name': 'Training Program',
//   'date': '10/06/2025',
//   'start_time':parseTime('11:00 Am'),
//   'end_time': parseTime('1:00 Pm'),
//   'district': 'Kelliguda',
//   'block': 'Pujariguda',
//   'village': 'Maa Tulasi',
//   },
//   {
//   'name': 'Exposure Visit',
//   'date': '11/06/2025',
//   'start_time':parseTime('11:00 Am'),
//   'end_time': parseTime('1:00 Pm'),
//   'district': 'Kelliguda',
//   'block': 'Pujariguda',
//   'village': 'Maa Tulasi',
//   },
//     ];
//
//
//       form = List.from(allForms);
//
//     setState(() {});
//   }


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
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        iconTheme: IconThemeData(
          color: Colors.white, // color of the back arrow
        ),
        title: Text(
          'List the Beneficiary',
          style: TextStyle(
            color: Colors.white, // color of the title text
          ),
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ...form.map((formData) {
                    return Container(
                      width: double.infinity,
                      child: Card(
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

                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              Text(
                                "Name: ${formData["beneficiary_name"] ?? "-"}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text("Father Name: ${formData["father_name"] ?? "-"}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 8),
                              Text(
                                "Mother Name: ${formData["mother_name"] ?? "-"}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 8),
                              Text("No. of Beneficiaries: ${formData["number_of_beneficiaries"]?.toString() ?? "-"}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),   const SizedBox(height: 8),
                              Text("Age: ${formData["age"]?.toString() ?? "-"}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async{
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewBeneficiaries(profile: formData)));
                                    },


                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize: Size(50, 26),
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    child: const Text("View", style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                  ),
                                  SizedBox(width: 10,),
                                  ElevatedButton(
                                    onPressed: () async{
                                      _showDeleteDialog(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: Size(50, 26),
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                    child: const Text("Delete", style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                  ),
                                ],
                              ),

                              //   const Divider(color: Colors.grey),
                            ],
                          ),

                        ),
                        //                    ),

                      ),
                    );
                  }).toList(),
                  SizedBox(height: 40,)
                ],
              ),
            ),
          ),
                ),
        ),
      ]),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8.0), // move FAB up and left
        child: SizedBox(
          height: 45,
          width: 45,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddListBeneficiary()),
              );
            },
            backgroundColor: Colors.orangeAccent,
            child: const Icon(Icons.add, size: 24, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  Future<void> _showDeleteDialog(BuildContext context) async {
    TextEditingController reasonController = TextEditingController();

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete Confirmation", style: TextStyle(fontSize: 15),),
            ],
          ),
          content: Text("Do you really want to Delete?"),
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
            title: Text("Reason for Deletion", style: TextStyle(fontSize: 15),),
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
