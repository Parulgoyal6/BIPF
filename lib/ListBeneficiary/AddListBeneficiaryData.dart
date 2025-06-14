import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Common/DatabaseHelper.dart';
// import 'package:image_picker/image_picker.dart';


class AddListBeneficiary extends StatefulWidget {
  final Map<String, dynamic>? existingEvent;
  const AddListBeneficiary({super.key, this.existingEvent});

  @override
  State<AddListBeneficiary> createState() => _AddListBeneficiaryState();
}

class _AddListBeneficiaryState extends State<AddListBeneficiary> {
  String? disability_status; // Add this in your State class to hold selected value

  final TextEditingController dobController = TextEditingController();
  final TextEditingController idProofController = TextEditingController();
  final TextEditingController beneficiariesCountController = TextEditingController();
  final TextEditingController uniqueIdController = TextEditingController();

  final TextEditingController EventNameController = TextEditingController();
  final TextEditingController _maleController = TextEditingController();
  final TextEditingController _femaleController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _TotalController = TextEditingController();
  final TextEditingController _boysController = TextEditingController();
  final TextEditingController _girlsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final Map<String, String?> _errors = {};
  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null; // Reset end date if it's before start date
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate:
      _startDate ?? DateTime.now(), // Ensures end date is after start
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }
  DateTime? selectedDate;
  String? _selectedProject = "";
  String? selectedGP;
  String? selectedSHG;
  String? selectedVillage;
  String? _selectedBeneficiary = "";
  String? _selectedOption = "";

  File? _imageFile;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  void _calculateTotal() {
    int male = int.tryParse(_maleController.text) ?? 0;
    int female = int.tryParse(_femaleController.text) ?? 0;
    int other = int.tryParse(_otherController.text) ?? 0;
    int boys = int.tryParse(_boysController.text) ?? 0;
    int girls = int.tryParse(_girlsController.text) ?? 0;

    int total = female +
        male + boys+ girls +
        other ;
    setState(() {
      _TotalController.text = total.toString(); // Update total field
    }); // Update total field
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    // Add listeners to automatically update total
    _maleController.addListener(_calculateTotal);
    _femaleController.addListener(_calculateTotal);
    _otherController.addListener(_calculateTotal);
    _boysController.addListener(_calculateTotal);
    _girlsController.addListener(_calculateTotal);


    // if (widget.existingEvent != null) {
    //   EventNameController.text = widget.existingEvent!['name'] ?? '';
    //
    //   String? startTimeStr = widget.existingEvent!['start_time'];
    //   if (startTimeStr != null && startTimeStr.contains(':')) {
    //     final parts = startTimeStr.split(':');
    //     final hour = int.tryParse(parts[0]) ?? 0;
    //     final minute = int.tryParse(parts[1]) ?? 0;
    //     _startTime = TimeOfDay(hour: hour, minute: minute);
    //   }
    //   String? endTimeStr = widget.existingEvent!['end_time'];
    //   if (endTimeStr != null && endTimeStr.contains(':')) {
    //     final parts = endTimeStr.split(':');
    //     final hour = int.tryParse(parts[0]) ?? 0;
    //     final minute = int.tryParse(parts[1]) ?? 0;
    //     _endTime = TimeOfDay(hour: hour, minute: minute);
    //   }
    //   selectedDistrict = widget.existingEvent!['district'] ?? '';
    //   selectedVillage = widget.existingEvent!['village'] ?? '';
    //   selectedBlock = widget.existingEvent!['block'] ?? '';
    // }



  }

  final List<String> GPList = ['BKPadar', 'Kelliguda', 'Therubali',];

  final Map<String, List<String>> villageList = {
    'BKPadar': ['Arabi', 'Gadabasahi'],
    'Kelliguda': ['Pujariguda'],
    'Therubali': ['Rellibadigaon'],
  };
  final Map<String, List<String>> SHGList = {
    'Arabi': ['Maa Parbati Mahila Mandal', 'Shibasakti', 'Maa Santoshi'],
    'Gadabasahi': ['Hasena', 'Taneya','Jyoti', 'Veneketeswar'],
    'Pujariguda': ['Maa Tulasi', 'Sibasankar'],
    'Rellibadigaon': ['Maa Laxmi', 'Maa Majhigouri', 'Maa Pateleswari'],
  };

  final List<String> _casteOptions = ['ST', 'SC', 'OBC', 'Gen'];
  String? _selectedCaste;
  // Function to show the date picker and update selectedDate
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),   // You can adjust these limits
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }


  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }


  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        iconTheme: IconThemeData(
          color: Colors.white, // color of the back arrow
        ),
        title: Text(
         'Add Beneficiary',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24
            // color of the title text
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Unique ID",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: uniqueIdController,
                      decoration: InputDecoration(
                        hintText: "Enter Unique ID",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name of the Beneficiary',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: EventNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Beneficiary Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                  ],
                ),
              ),
            ),
            Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Location',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedGP,
                          //style: TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Select GP',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          ),
                          items: GPList
                              .map((String value) =>
                              DropdownMenuItem(value: value, child: Text(value)))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGP = newValue;
                              selectedVillage = null;
                              selectedSHG = null;
                            });
                          },
                        ),

                        const SizedBox(height: 5),

                        // Block Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedVillage,
                          decoration: const InputDecoration(
                            hintText: 'Select Village',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),
                          items: selectedGP != null
                              ? villageList[selectedGP]!
                              .map((String value) =>
                              DropdownMenuItem(value: value, child: Text(value)))
                              .toList()
                              : [],
                          onChanged: selectedGP != null
                              ? (String? newValue) {
                            setState(() {
                              selectedVillage = newValue;
                              selectedSHG = null;
                            });
                          }
                              : null,
                        ),
                        const SizedBox(height: 5),

                        // Village Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedSHG,
                          decoration: const InputDecoration(
                            hintText: 'Select SHG',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),
                          items: selectedVillage != null
                              ? SHGList[selectedVillage]!
                              .map((String value) =>
                              DropdownMenuItem(value: value, child: Text(value)))
                              .toList()
                              : [],
                          onChanged: selectedVillage != null
                              ? (String? newValue) {
                            setState(() {
                              selectedSHG = newValue;
                            });
                          }
                              : null,
                        ),
                      ],
                    ))),// You can add more form fields here...
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Number of Beneficiaries",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: beneficiariesCountController,
                      decoration: InputDecoration(
                        hintText: "Enter count",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ID Proof",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: idProofController,
                      decoration: InputDecoration(
                        hintText: "Enter ID Proof Type (Aadhaar, Voter ID, etc.)",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Date of Birth",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      controller: dobController,
                      decoration: InputDecoration(
                        hintText: "Select Date of Birth",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            dobController.text =
                            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Age',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      // controller: EventNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter age',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),

                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Membership Status',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      // controller: EventNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter status',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),

                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Father's Name",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      // controller: EventNameController,
                      decoration: InputDecoration(
                        hintText: "Enter Father's Name",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mother's Name",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      // controller: EventNameController,
                      decoration: InputDecoration(
                        hintText: "Enter Mother's Name",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Education Grade",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      // controller: EventNameController,
                      decoration: InputDecoration(
                        hintText: "Enter Grade",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                  ],
                ),
              ),
            ),


            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Caste'),
    DropdownButtonFormField<String>(
    decoration: InputDecoration(
    hintText: 'Caste',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    value: _selectedCaste,
    items: _casteOptions.map((String caste) {
    return DropdownMenuItem<String>(
    value: caste,
    child: Text(caste),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    _selectedCaste = newValue;
    });
    },
    validator: (value) => value == null ? 'Please select a caste' : null,
    ),
// Date of Birth


                  ],
                ),
              ),
            ),
            Card(
              elevation: 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Disability",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Yes'),
                            value: 'Yes',
                            groupValue: disability_status,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onChanged: (value) {
                              setState(() {
                                disability_status = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('No'),
                            value: 'No',
                            groupValue: disability_status,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onChanged: (value) {
                              setState(() {
                                disability_status = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),


// ID Proof


// Number of Beneficiaries


// Unique ID

            ElevatedButton(onPressed: (){
              _submit();
            }, child: const Text('Submit', style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, minimumSize: Size(double.infinity, 40),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),)
            ),),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
  Future<void> _submit() async {
    setState(() {
      _errors.clear();
    });

    try {
      final data = {
        // 'beneficiaryName': BeneficiaryNameController.text.trim(),
        // 'gp': selectedGP,
        // 'village': selectedVillage,
        // 'shg': selectedSHG,
        // 'age': int.tryParse(AgeController.text.trim()),
        // 'membershipStatus': selectedMembershipStatus,
        // 'fatherName': FatherNameController.text.trim(),
        // 'motherName': MotherNameController.text.trim(),
        // 'educationGrade': selectedEducationGrade,
        // 'caste': selectedCaste,
        // 'dateOfBirth': _selectedDOB?.toIso8601String(),
        // 'idProof': selectedIdProof,
        // 'numberOfBeneficiaries': int.tryParse(
        //     'NumberOfBeneficiariesController'.text.trim()),
        // 'uniqueId': UniqueIdController.text.trim(),
      };

      // ✅ Insert into DB using your helper
      // await DatabaseHelper.instance.AddingEventData(data, 'Beneficiary');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Inserted Successfully'),));
      Navigator.pop(context);

    } catch (e) {
      print('Insert Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }



  Widget _buildDropdownBeneficiary({
    required String label,
    required List<String> items,
    required String fieldKey,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  label,
                  // style: GoogleFonts.openSans(
                  //     fontSize: 16, fontWeight: FontWeight.normal),
                ),
                const SizedBox(width: 4),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: (selectedValue == null || selectedValue.isEmpty)
                  ? 'Select Beneficiary'
                  : selectedValue,
              isExpanded: true,
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, ),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBeneficiary =
                  (value == 'Select Beneficiary') ? '' : value;
                  onChanged(_selectedBeneficiary); // Debugging statement
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                //  errorText: _errors[fieldKey],
              ),
            ),
          ],
        ),
      ),

    );
  }
  Widget _buildDropdownUnplanned({
    required String label,
    required List<String> items,
    required String fieldKey,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  label,
                  // style: GoogleFonts.openSans(
                  //     fontSize: 16, fontWeight: FontWeight.normal),
                ),
                const SizedBox(width: 4),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: (selectedValue == null || selectedValue.isEmpty)
                  ? 'Select Option'
                  : selectedValue,
              isExpanded: true,
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, ),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOption =
                  (value == 'Select Option') ? '' : value;
                  onChanged(_selectedOption); // Debugging statement
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                //  errorText: _errors[fieldKey],
              ),
            ),
          ],
        ),
      ),

    );
  }


}
