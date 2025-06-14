import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../Common/DatabaseHelper.dart';
// import 'package:image_picker/image_picker.dart';


class AddInitiativeEvent extends StatefulWidget {
  final Map<String, dynamic>? existingEvent;
  const AddInitiativeEvent({super.key, this.existingEvent});

  @override
  State<AddInitiativeEvent> createState() => _AddInitiativeEventState();
}

class _AddInitiativeEventState extends State<AddInitiativeEvent> {

  final TextEditingController EventNameController = TextEditingController();
  final TextEditingController _maleController = TextEditingController();
  final TextEditingController _femaleController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _TotalController = TextEditingController();
  final TextEditingController _boysController = TextEditingController();
  final TextEditingController _girlsController = TextEditingController();
  final TextEditingController TargetController = TextEditingController();
  final TextEditingController GuestNameController = TextEditingController();
  final TextEditingController GuestDesignationController = TextEditingController();
  final TextEditingController ResourceNameController = TextEditingController();
  final TextEditingController ResourceDesignationController = TextEditingController();
  final TextEditingController TopicNameController = TextEditingController();
  final TextEditingController ObservationController = TextEditingController();
  final TextEditingController ChapterController = TextEditingController();
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

  // List<File> images = [];
  //
  // Future<void> pickImageFromGallery() async {
  //   try {
  //     final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage(
  //       imageQuality: 85,
  //       maxWidth: 1024,
  //     );
  //
  //     if (pickedFiles == null || pickedFiles.isEmpty) return;
  //
  //     // Show loading
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(child: CircularProgressIndicator()),
  //     );
  //
  //     List<File> savedImages = [];
  //     for (var file in pickedFiles) {
  //       try {
  //         final savedImage = await _saveImage(file.path);
  //         savedImages.add(savedImage);
  //       } catch (e) {
  //         print('Error saving image: $e');
  //       }
  //     }
  //
  //     if (mounted) {
  //       Navigator.of(context).pop(); // Hide loading
  //       setState(() {
  //         images.addAll(savedImages);
  //       });
  //     }
  //   } on PlatformException catch (e) {
  //     print('Failed to pick images: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to pick images: ${e.message}')),
  //       );
  //     }
  //   }
  // }
  //
  // Future<File> _saveImage(String imagePath) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final timestamp = DateTime.now().millisecondsSinceEpoch;
  //   final name = path.basename(imagePath);
  //   final newPath = '${directory.path}/$timestamp-$name';
  //   return await File(imagePath).copy(newPath);
  // }

  DateTime? selectedDate;
  String? _selectedProject = "";
  String? selectedDistrict;
  String? selectedBlock;
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


    if (widget.existingEvent != null) {
      EventNameController.text = widget.existingEvent!['name'] ?? '';

      String? startTimeStr = widget.existingEvent!['start_time'];
      if (startTimeStr != null && startTimeStr.contains(':')) {
        final parts = startTimeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        _startTime = TimeOfDay(hour: hour, minute: minute);
      }
      String? endTimeStr = widget.existingEvent!['end_time'];
      if (endTimeStr != null && endTimeStr.contains(':')) {
        final parts = endTimeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        _endTime = TimeOfDay(hour: hour, minute: minute);
      }

      selectedDistrict = widget.existingEvent!['district'] ?? '';
      selectedVillage = widget.existingEvent!['village'] ?? '';
      selectedBlock = widget.existingEvent!['block'] ?? '';
    }



  }

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
          'Initiate Activity',
          style: TextStyle(
            color: Colors.white, // color of the title text
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
                      'Name of the Event',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: EventNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Event Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Start Time Label
                    Row(
                      children: [
                        Text('Start Time:'),
                        SizedBox(width: 4),
                      ],
                    ),
                    TextFormField(
                      controller: TextEditingController(
                        text: _startTime != null
                            ? _startTime!.format(context)
                            : '',
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Select Time",
                        suffixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectStartTime(context),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // End Time Label
                    Row(
                      children: [
                        Text('End Time:'),
                        SizedBox(width: 4),
                      ],
                    ),
                    TextFormField(
                      controller: TextEditingController(
                        text: _endTime != null ? _endTime!.format(context) : '',
                      ),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Select Time",
                        suffixIcon: Icon(Icons.access_time),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectEndTime(context),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            _buildDropdownUnplanned(
              label:
              'Unplanned/Planned',
              items: [
                'Select Option',
                'Planned',
                'Unplanned',
              ],
              fieldKey: 'planned',
              selectedValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  //_selectedLibraryPeriod = value;
                  _selectedOption =
                  (value == 'Select Option') ? '' : value;
                });
              },
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
                          value: selectedDistrict,
                          //style: TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Select District',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                          ),
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

                        const SizedBox(height: 5),

                        // Block Dropdown
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
                        const SizedBox(height: 5),

                        // Village Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedVillage,
                          decoration: const InputDecoration(
                            hintText: 'Select Village',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                      'Participants Count',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(
                            width: 70,
                            child: Text('Men :')),
                        Expanded(
                            child: TextFormField(
                              controller: _maleController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Men',
                                border: OutlineInputBorder(),
                                contentPadding:
                                EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              ),)
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                            width:70,
                            child: Text('Women :')),
                        Expanded(child:
                        TextField(
                          controller: _femaleController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Women',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                            width: 70,
                            child: Text('Boys :')),
                        Expanded(child:
                        TextField(
                          controller: _boysController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Boys',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),)
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                            width: 70,
                            child: Text('Girls :')),
                        Expanded(child:
                        TextField(
                          controller: _girlsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Girls',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),
                        ),)
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                            width:70,
                            child: Text('Other :')),
                        Expanded(child:
                        TextField(
                          controller: _otherController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Other',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          ),
                        ),)
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                            width: 70,
                            child: Text('Total :')),
                        Expanded(child:
                        TextFormField(
                          readOnly: true,
                          controller: _TotalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Total Participants',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // Show a dialog or snackbar when icon is tapped
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Hint'),
                                    content: Text(
                                        'Enter the number of participants attending the event.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(Icons.info_outline),
                            ),
                          ),
                        ),)
                      ],
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
                      'Target Number of Population',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                       controller: TargetController,
                      decoration: InputDecoration(
                        hintText: 'Enter target Number of population',
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
                      'Guest Name',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                       controller: GuestNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Guest Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Guest Designation',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                       controller: GuestDesignationController,
                      decoration: InputDecoration(
                        hintText: 'Enter Guest Designation',
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
                      'Resource Person Name',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: ResourceNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter Resource Person Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Resource Person Designation',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                       controller: ResourceDesignationController,
                      decoration: InputDecoration(
                        hintText: 'Enter Resource Person Designation',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.95,
              child: Card(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Photo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Upload Button Container (Square)
                          Container(
                            width: 120,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.yellow.shade50,
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                 // pickImageFromGallery();
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text(
                                'Upload\nPhoto',
                                textAlign: TextAlign.center,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(150, 150),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Image Preview Container (Square)
                          Container(
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[100],
                            ),
                            child: _imageFile != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _imageFile!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                                : const Center(
                              child: Text("No image"),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),

            _buildDropdownBeneficiary(
              label:
              'Beneficiary',
              items: [
                'Select Beneficiary',
                'Rahul Sharma',
                'Ravi Ranjan',
                'Gunjan Tripathi',
                'Kaviya',
                'Prerna Chaudhary',
                'Mukesh Goyal',
                'Sunita Tripathi'
              ],
              fieldKey: 'beneficairy',
              selectedValue: _selectedBeneficiary,
              onChanged: (value) {
                setState(() {
                  //_selectedLibraryPeriod = value;
                  _selectedBeneficiary =
                  (value == 'Select Beneficiary') ? '' : value;
                });
              },
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
                      'Observation',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                       controller: ObservationController,
                      decoration: InputDecoration(
                        hintText: 'Enter Observation',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
                      ),

                    ),

                  ],
                ),
              ),
            ),


            // Card(
            //   elevation: 3,
            //   color: Colors.white,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           'Topic Name',
            //           style: TextStyle(fontSize: 14),
            //         ),
            //         const SizedBox(height: 8),
            //         TextFormField(
            //            controller: TopicNameController,
            //           decoration: InputDecoration(
            //             hintText: 'Enter topic',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
            //           ),
            //
            //         ),
            //
            //       ],
            //     ),
            //   ),
            // ),
            //
            // Card(
            //   elevation: 3,
            //   color: Colors.white,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           'Chapter Name',
            //           style: TextStyle(fontSize: 14),
            //         ),
            //         const SizedBox(height: 8),
            //         TextFormField(
            //           controller: ChapterController,
            //           decoration: InputDecoration(
            //             hintText: 'Enter chapter',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
            //           ),
            //
            //         ),
            //
            //       ],
            //     ),
            //   ),
            // ),
            ElevatedButton(onPressed: (){
              _submit();
            }, child: const Text('Submit', style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, minimumSize: Size(double.infinity, 40),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),)
            ),)
          ],
        ),
      ),
    );
  }
  Future<void> _submit() async {

    setState(() {
      _errors.clear();
    });
    final String formattedStartTime = _startTime != null
        ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
        : '';

    final String formattedEndTime = _endTime != null
        ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
        : '';

    try{
      final data = {
        'name_of_event':EventNameController.text.trim().toString(),
        'start_time': formattedStartTime ?? '',
        'end_time': formattedEndTime ?? '',
        'date': DateTime.now().toIso8601String(),
        'district': selectedDistrict.toString(),
        'block': selectedBlock.toString(),
        'village': selectedVillage.toString(),
        'total_participants': _TotalController.text.toString(),
        'men': _maleController.text.toString(),
        'women': _femaleController.text.toString(),
        'girls': _girlsController.text.toString(),
        'boys': _boysController.text.toString(),
        'other': _otherController.text.toString(),
        'image': _imageFile.toString(),
        'unplanned': _selectedOption.toString(),
        'target_number_of_population': TargetController.text.toString(),
        'guest_name': GuestNameController.text.toString(),
        'beneficiary': _selectedBeneficiary.toString(),
        'observation': ObservationController.text.toString(),
        'guest_designation': GuestDesignationController.text.toString(),
        'resource_person_name': ResourceNameController.text.toString(),
        'resource_person_designation': ResourceDesignationController.text.toString(),
        'topic_name': TopicNameController.text.toString(),
        'chapter_name': ChapterController.text.toString(),
      };

      await DatabaseHelper.instance.AddingEventData(data, 'Event_Form');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Inserted Successfully'),));
      Navigator.pop(context);
    }catch(e){
      print(e);
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
