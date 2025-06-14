import 'package:flutter/material.dart';

class DeleteBeneficiary extends StatefulWidget {
  const DeleteBeneficiary({super.key});

  @override
  _DeleteBeneficiaryState createState() => _DeleteBeneficiaryState();
}

class _DeleteBeneficiaryState extends State<DeleteBeneficiary> {
  List<Map<String, dynamic>> beneficiaries = [
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
  ];

  void deleteBeneficiary(int index) {
    setState(() {
      beneficiaries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: beneficiaries.isEmpty
            ? Center(
          child: Text(
            "No beneficiary data available.",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        )
            : SingleChildScrollView(
          child: Column(
            children: beneficiaries.asMap().entries.map((entry) {
              int index = entry.key;
              var formData = entry.value;

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Card(
                  elevation: 3,
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${formData["beneficiaryName"] ?? "-"}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Father Name: ${formData["fatherName"] ?? "-"}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mother Name: ${formData["motherName"] ?? "-"}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "No. of Beneficiaries: ${formData["numberOfBeneficiaries"] ?? "-"}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Age: ${formData["age"] ?? "-"}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "ID Proof: ${formData["idProof"] ?? "-"}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Delete Beneficiary"),
                                  content: Text(
                                      "Are you sure you want to delete ${formData["beneficiaryName"]}?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteBeneficiary(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
