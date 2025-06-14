import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewBeneficiaries extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ViewBeneficiaries({super.key, required this.profile});
  @override
  State<ViewBeneficiaries> createState() => _ViewBeneficiariesState();
}

class _ViewBeneficiariesState extends State<ViewBeneficiaries> {
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


  void initializeRegistration() {
    allForms = [
  {
    'beneficiaryName': 'Anjali Kumari',
    'fatherName': 'Ramesh Kumar',
    'motherName': 'Sita Devi',
    'age': 18,
    'numberOfBeneficiaries': 1,
    'idProof': 'Aadhar: XXXX-XXXX',
  },
  {
    'beneficiaryName': 'Pooja Sahu',
    'fatherName': 'Mahesh Sahu',
    'motherName': 'Geeta Sahu',
    'age': 17,
    'numberOfBeneficiaries': 2,
    'idProof': 'Aadhar: YYYY-YYYY',
  },
  {
    'beneficiaryName': 'Ravi Patel',
    'fatherName': 'Devendra Patel',
    'motherName': 'Manju Patel',
    'age': 19,
    'numberOfBeneficiaries': 1,
    'idProof': 'Aadhar: ZZZZ-ZZZZ',
  },
      {
        'beneficiaryName': 'Susmita Patel',
        'fatherName': 'Devendra Patel',
        'motherName': 'Manju Patel',
        'age': 29,
        'numberOfBeneficiaries': 1,
        'idProof': 'Aadhar: ZZZZ-ZZZZ',
      },
    ];

      form = List.from(allForms);

    setState(() {});
  }

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
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        iconTheme: IconThemeData(
          color: Colors.white, // color of the back arrow
        ),
        title: Text(
        'View Beneficiary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
            // color of the title text
          ),
        ),
      ),
      backgroundColor: Colors.white,
      // body: Container(
      //   color: Colors.white,
      //   child: Padding(
      //     padding: const EdgeInsets.all(15.0),
      //     child: form.isEmpty
      //         ? Center(
      //       child: Text(
      //         "No activity found for the selected date.",
      //         style: TextStyle(fontSize: 18, color: Colors.grey[600]),
      //       ),
      //     )
      //         : SingleChildScrollView(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           ...form.map((formData) {
      //             return Card(
      //                 elevation: 3,
      //                 margin: const EdgeInsets.symmetric(vertical: 6),
      //                 color: Colors.grey[200],
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(10.0),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         "Name: ${formData["beneficiaryName"] ?? "-"}",
      //                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //                       ),
      //                       const SizedBox(height: 6),
      //

      //
      //                     ],
      //                   ),
      //                 ),
      //
      //             );
      //           }).toList(),
      //
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

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
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  buildDetailRow("Name ", widget.profile["beneficiary_name"]),
                                  buildDetailRow("Father's Name ", widget.profile["father_name"]),
                                  buildDetailRow("Mother's Name ", widget.profile["mother_name"]),
                                  buildDetailRow("Gender ", widget.profile["gender"]),
                                  buildDetailRow("Age ", widget.profile["age"]),
                                  buildDetailRow("Marital Status ", widget.profile["marital_status"]),
                                  buildDetailRow("Phone ", widget.profile["phone"]),
                                  buildDetailRow("Education ", widget.profile["education"]),
                                  // buildDetailRow("Occupation ", widget.profile["occupation"]),
                                  buildDetailRow("Number of Beneficiaries ", widget.profile["number_of_beneficiaries"]),
                                  // buildDetailRow("Location ", "${widget.profile["gp"]}/ ${widget.profile["village"]}/ ${widget.profile["shg"]}"),
                                  // buildDetailRow("Membership Status ", widget.profile["membership_status"]),
                                  buildDetailRow("Caste ", widget.profile["caste"]),
                                  buildDetailRow("Disability ", widget.profile["disability_status"]),
                                   buildDetailRow("ID Proof ", widget.profile["id_proof"]),
                                  // buildDetailRow("SHG Code ", widget.profile["shg_code"]),
                                  // buildDetailRow("Bank A/C No ", widget.profile["bank_account"]),
                                  // buildDetailRow("IFSC Code ", widget.profile["ifsc"]),
                                  // buildDetailRow("Health Issues ", widget.profile["health_issues"]),
                                  // buildDetailRow("Skills ", widget.profile["skills"]),
                                  // buildDetailRow("Training ", widget.profile["training_received"]),
                                  // buildDetailRow("Remarks ", widget.profile["remarks"]),
                                ],
                              )


                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }

  Widget buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value != null && value.toString().isNotEmpty ? value.toString() : "-",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }


}



