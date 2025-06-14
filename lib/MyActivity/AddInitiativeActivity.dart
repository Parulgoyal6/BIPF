import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Models/adding_an_activity.dart';
import '../Models/adding_an_event.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddInitiativeActivity extends StatefulWidget {
  // final Map<String, dynamic>? existingEvent;
  final bool isReschedule;
  final bool isInitiate;
  const AddInitiativeActivity(
      {super.key, this.isReschedule = false, this.isInitiate = false});

  @override
  State<AddInitiativeActivity> createState() => _AddListBeneficiaryState();
}

class _AddListBeneficiaryState extends State<AddInitiativeActivity> {
  final TextEditingController ActivityNameController = TextEditingController();
  final TextEditingController _maleController = TextEditingController();
  final TextEditingController _femaleController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _TotalController = TextEditingController();
  final TextEditingController _boysController = TextEditingController();
  final TextEditingController _girlsController = TextEditingController();
  final TextEditingController TargetController = TextEditingController();
  final TextEditingController GuestNameController = TextEditingController();
  final TextEditingController GuestDesignationController =
      TextEditingController();
  final TextEditingController ResourceNameController = TextEditingController();
  final TextEditingController ResourceDesignationController =
      TextEditingController();
  final TextEditingController TopicNameController = TextEditingController();
  final TextEditingController ObservationController = TextEditingController();
  final TextEditingController ChapterController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final Map<String, String?> _errors = {};
  List<String> _beneficiaryOptions = [
    'Rahul Sharma',
    'Ravi Ranjan',
    'Gunjan Tripathi',
    'Kaviya',
    'Prerna Chaudhary',
    'Mukesh Goyal',
    'Sunita Tripathi'
  ];
  List<String> _selectedBeneficiaries = [];
  bool _isDropdownOpen = false;
  String? _selectedActivity = "";
  int wordCount = 0;
  void _countWords() {
    final words = ObservationController.text.trim().split(RegExp(r'\s+'));
    setState(() {
      wordCount = words
          .where((word) =>
              word.isNotEmpty && RegExp(r'^[a-zA-Z]+$').hasMatch(word))
          .length;
    });

    if (wordCount > 100) {
      final limitedWords = words.take(100).join(' ');
      ObservationController.text = limitedWords;
      ObservationController.selection = TextSelection.fromPosition(
        TextPosition(offset: ObservationController.text.length),
      );
    }
  }

  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  String id = "";
  RxList<AddingAnActivity> list_data = <AddingAnActivity>[].obs;
  Future<void> getData() async {
    id = await SharedPreferHelper.getPrefString('id', "");
    list_data.assignAll(await DatabaseHelper.instance.getAddingAnActivity(
        "Select * from Activity_Form where local_id = '${id}'"));
    if (list_data.length > 0) {
      // ActivityNameController.text = list_data[0].name_of_activity.toString();
      _selectedActivity = list_data[0].name_of_activity.toString();
      String? startTimeStr = list_data[0].start_time;
      if (startTimeStr != null && startTimeStr.contains(':')) {
        final parts = startTimeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        _startTime = TimeOfDay(hour: hour, minute: minute);
      }
      String? endTimeStr = list_data[0].end_time;
      if (endTimeStr != null && endTimeStr.contains(':')) {
        final parts = endTimeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        _endTime = TimeOfDay(hour: hour, minute: minute);
      }

      _selectedDate =
          list_data[0].date != null ? DateTime.parse(list_data[0].date!) : null;

      selectedGP = list_data[0].district.toString() ?? '';
      selectedVillage = list_data[0].village.toString() ?? '';
      selectedSHG = list_data[0].block.toString() ?? '';
      _selectedOption = list_data[0].unplanned.toString();
      _maleController.text = list_data[0].men.toString();
      _femaleController.text = list_data[0].women.toString();
      _girlsController.text = list_data[0].girls.toString();
      _boysController.text = list_data[0].boys.toString();
      _otherController.text = list_data[0].other.toString();
      _TotalController.text = list_data[0].total_participants.toString();
      TargetController.text =
          list_data[0].target_number_of_population.toString();
      GuestNameController.text = list_data[0].guest_name.toString();
      GuestDesignationController.text =
          list_data[0].guest_designation.toString();
      ResourceNameController.text =
          list_data[0].resource_person_name.toString();
      ResourceDesignationController.text =
          list_data[0].resource_person_designation.toString();
      _selectedBeneficiary = list_data[0].beneficiary.toString();
      //ObservationController.text = list_data[0].observation.toString();
      TopicNameController.text = list_data[0].topic_name.toString();
      ChapterController.text = list_data[0].chapter_name.toString();
    }
    setState(() {});
  }

  Future<void> getDataReschedule() async {
    id = await SharedPreferHelper.getPrefString('id', "");
    list_data.assignAll(await DatabaseHelper.instance.getAddingAnActivity(
        "Select * from Activity_Form where local_id = '${id}'"));
    if (list_data.length > 0) {
      // ActivityNameController.text = list_data[0].name_of_activity.toString();
      _selectedActivity = list_data[0].name_of_activity.toString();
      String? startTimeStr = list_data[0].start_time;
      if (startTimeStr != null && startTimeStr.contains(':')) {
        final parts = startTimeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        _startTime = TimeOfDay(hour: hour, minute: minute);
      }
      String? endTimeStr = list_data[0].end_time;
      if (endTimeStr != null && endTimeStr.contains(':')) {
        final parts = endTimeStr.split(':');
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        _endTime = TimeOfDay(hour: hour, minute: minute);
      }

      _selectedDate =
          list_data[0].date != null ? DateTime.parse(list_data[0].date!) : null;

      selectedGP = list_data[0].district.toString();
      selectedVillage = list_data[0].village.toString();
      selectedSHG = list_data[0].block.toString();
      _selectedOption = list_data[0].unplanned.toString();
      _maleController.text = list_data[0].men.toString();
      _femaleController.text = list_data[0].women.toString();
      _girlsController.text = list_data[0].girls.toString();
      _boysController.text = list_data[0].boys.toString();
      _otherController.text = list_data[0].other.toString();
      _TotalController.text = list_data[0].total_participants.toString();
      TargetController.text =
          list_data[0].target_number_of_population.toString();
      GuestNameController.text = list_data[0].guest_name.toString();
      GuestDesignationController.text =
          list_data[0].guest_designation.toString();
      ResourceNameController.text =
          list_data[0].resource_person_name.toString();
      ResourceDesignationController.text =
          list_data[0].resource_person_designation.toString();
      _selectedBeneficiary = list_data[0].beneficiary.toString();
      ObservationController.text = list_data[0].observation.toString();
      TopicNameController.text = list_data[0].topic_name.toString();
      ChapterController.text = list_data[0].chapter_name.toString();
    }
    setState(() {});
  }

  DateTime? selectedDate;
  String? _selectedProject = "";
  String? selectedGP;
  String? selectedSHG;
  String? selectedVillage;
  String? _selectedBeneficiary = "";
  String? _selectedOption = "";

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  void _calculateTotal() {
    int male = int.tryParse(_maleController.text) ?? 0;
    int female = int.tryParse(_femaleController.text) ?? 0;
    int other = int.tryParse(_otherController.text) ?? 0;
    int boys = int.tryParse(_boysController.text) ?? 0;
    int girls = int.tryParse(_girlsController.text) ?? 0;

    int total = female + male + boys + girls + other;
    setState(() {
      _TotalController.text = total.toString(); // Update total field
    }); // Update total field
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    ObservationController.addListener(_countWords);
    // Add listeners to automatically update total
    _maleController.addListener(_calculateTotal);
    _femaleController.addListener(_calculateTotal);
    _otherController.addListener(_calculateTotal);
    _boysController.addListener(_calculateTotal);
    _girlsController.addListener(_calculateTotal);
    if (widget.isReschedule) {
      getDataReschedule();
    } else {
      getData();
    }
  }

  final List<String> GPList = [
    'BKPadar',
    'Kelliguda',
    'Therubali',
  ];

  final Map<String, List<String>> villageList = {
    'BKPadar': ['Arabi', 'Gadabasahi'],
    'Kelliguda': ['Pujariguda'],
    'Therubali': ['Rellibadigaon'],
  };
  final Map<String, List<String>> SHGList = {
    'Arabi': ['Maa Parbati Mahila Mandal', 'Shibasakti', 'Maa Santoshi'],
    'Gadabasahi': ['Hasena', 'Taneya', 'Jyoti', 'Veneketeswar'],
    'Pujariguda': ['Maa Tulasi', 'Sibasankar'],
    'Rellibadigaon': ['Maa Laxmi', 'Maa Majhigouri', 'Maa Pateleswari'],
  };
  // Function to show the date picker and update selectedDate
  Future<void> _selectTimeRange(BuildContext context) async {
    // Pick Start Time
    final TimeOfDay? pickedStart = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (pickedStart != null) {
      // Pick End Time after picking Start Time
      final TimeOfDay? pickedEnd = await showTimePicker(
        context: context,
        initialTime: pickedStart,
      );

      if (pickedEnd != null) {
        setState(() {
          _startTime = pickedStart;
          _endTime = pickedEnd;
        });
      }
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

  // When loading time string from DB

// When displaying time on UI
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: widget.isReschedule
          ? AppBar(
              backgroundColor: Colors.yellow[800],
              iconTheme: const IconThemeData(
                color: Colors.white, // color of the back arrow
              ),
              title: const Text(
                'Reschedule Activity',
                style: TextStyle(
                  color: Colors.white, // color of the title text
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.yellow[800],
              iconTheme: const IconThemeData(
                color: Colors.white, // color of the back arrow
              ),
              title: const Text(
                'Initiate Activity',
                style: TextStyle(
                  color: Colors.white, // color of the title text
                ),
              ),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isReschedule) ...[
              _buildDropdownActivity(
                label: 'Name Of Activity',
                items: [
                  'Select Activity',
                  'Immunization VHSND',
                  'Career Counselling',
                  'Livelihood Data Collection/FU',
                  'Training Program',
                  'Exposure Visit',
                  'Awareness Program',
                  'CLC visit/FU',
                  'DLC visit/FU',
                  'Other Activities (if any)'
                ],
                fieldKey: 'activity',
                selectedValue: _selectedActivity,
                onChanged: (value) {
                  setState(() {
                    //_selectedLibraryPeriod = value;
                    _selectedActivity =
                        (value == 'Select Activity') ? '' : value;
                  });
                },
                // ),
                // ),

                //   ],
                // ),
                // ),
              ),
              Card(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text('Date:'),
                          SizedBox(width: 4),
                        ],
                      ),
                      TextFormField(
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                              : '',
                        ),
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: "Select Date",
                          suffixIcon: Icon(Icons.calendar_month),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () =>
                            _selectDate(context), // call date picker here
                      ),
                      const SizedBox(height: 20),
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
                        Text('Select Time:'),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        GestureDetector(
                          onTap: () => _selectTimeRange(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                // labelText: 'Time Range',
                                hintText: 'Select Start and End Time',
                                suffixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: (_startTime != null && _endTime != null)
                                    ? '${_startTime!.format(context)} - ${_endTime!.format(context)}'
                                    : '',
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ] else if (widget.isInitiate) ...[
              // _buildDropdownUnplanned(
              //   label:
              //   'Unplanned/Planned',
              //   items: [
              //     'Select Option',
              //     'Planned',
              //     'Unplanned',
              //   ],
              //   fieldKey: 'planned',
              //   selectedValue: _selectedOption,
              //   onChanged: (value) {
              //     setState(() {
              //       //_selectedLibraryPeriod = value;
              //       _selectedOption =
              //       (value == 'Select Option') ? '' : value;
              //     });
              //   },
              // ),

              // Card(
              //   elevation: 3,
              //   color: Colors.white,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Name of the Activity',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //           controller: ActivityNameController,
              //           decoration: InputDecoration(
              //             hintText: 'Enter Activity Name',
              //             border: OutlineInputBorder(),
              //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
              //           ),
              //
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              _buildDropdownActivity(
                label: 'Name Of Activity',
                items: [
                  'Select Activity',
                  'Immunization VHSND',
                  'Career Counselling',
                  'Livelihood Data Collection/FU',
                  'Training Program',
                  'Exposure Visit',
                  'Awareness Program',
                  'CLC visit/FU',
                  'DLC visit/FU',
                  'Other Activities (if any)'
                ],
                fieldKey: 'activity',
                selectedValue: _selectedActivity,
                onChanged: (value) {
                  setState(() {
                    //_selectedLibraryPeriod = value;
                    _selectedActivity =
                        (value == 'Select Activity') ? '' : value;
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedGP,
                            //style: TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: 'Select GP',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 8),
                            ),
                            items: GPList.map((String value) =>
                                DropdownMenuItem(
                                    value: value, child: Text(value))).toList(),
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
                            value: selectedSHG,
                            decoration: const InputDecoration(
                              hintText: 'Select Village',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                            items: selectedGP != null
                                ? villageList[selectedGP]!
                                    .map((String value) => DropdownMenuItem(
                                        value: value, child: Text(value)))
                                    .toList()
                                : [],
                            onChanged: selectedGP != null
                                ? (String? newValue) {
                                    setState(() {
                                      selectedSHG = newValue;
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
                              hintText: 'Select SHG',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                            items: selectedSHG != null
                                ? SHGList[selectedSHG]!
                                    .map((String value) => DropdownMenuItem(
                                        value: value, child: Text(value)))
                                    .toList()
                                : [],
                            onChanged: selectedSHG != null
                                ? (String? newValue) {
                                    setState(() {
                                      selectedVillage = newValue;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ))),
              Card(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text('Date:'),
                          SizedBox(width: 4),
                        ],
                      ),
                      TextFormField(
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
                              : '',
                        ),
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: "Select Date",
                          suffixIcon: Icon(Icons.calendar_month),
                          border: OutlineInputBorder(),
                        ),
                        onTap: () =>
                            _selectDate(context), // call date picker here
                      ),
                      const SizedBox(height: 20),
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
                        Text('Select Time:'),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        GestureDetector(
                          onTap: () => _selectTimeRange(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                // labelText: 'Time Range',
                                hintText: 'Select Start and End Time',
                                suffixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: (_startTime != null && _endTime != null)
                                    ? '${_startTime!.format(context)} - ${_endTime!.format(context)}'
                                    : '',
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              // You can add more form fields here...

              Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Participants Count: ${TargetController.text} (Target participants)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(width: 70, child: Text('Men :')),
                          Expanded(
                              child: TextFormField(
                            controller: _maleController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Men',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 70, child: Text('Women :')),
                          Expanded(
                              child: TextField(
                            controller: _femaleController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Women',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 70, child: Text('Boys :')),
                          Expanded(
                              child: TextField(
                            controller: _boysController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Boys',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 70, child: Text('Girls :')),
                          Expanded(
                            child: TextField(
                              controller: _girlsController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Girls',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 70, child: Text('Other :')),
                          Expanded(
                            child: TextField(
                              controller: _otherController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Other',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 70, child: Text('Total :')),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: _TotalController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Total Participants',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
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
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.info_outline),
                                ),
                              ),
                            ),
                          )
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8), // yahan vertical padding kam karo
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
              //           'Guest Name',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //            controller: GuestNameController,
              //           decoration: InputDecoration(
              //             hintText: 'Enter Guest Name',
              //             border: OutlineInputBorder(),
              //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
              //           ),
              //
              //         ),
              //         const SizedBox(height: 10),
              //         const Text(
              //           'Guest Designation',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //            controller: GuestDesignationController,
              //           decoration: InputDecoration(
              //             hintText: 'Enter Guest Designation',
              //             border: OutlineInputBorder(),
              //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
              //           ),
              //
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Card(
              //   elevation: 3,
              //   color: Colors.white,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Resource Person Name',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //           controller: ResourceNameController,
              //           decoration: InputDecoration(
              //             hintText: 'Enter Resource Person Name',
              //             border: OutlineInputBorder(),
              //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
              //           ),
              //
              //         ),
              //         const SizedBox(height: 10),
              //         const Text(
              //           'Resource Person Designation',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //            controller: ResourceDesignationController,
              //           decoration: InputDecoration(
              //             hintText: 'Enter Resource Person Designation',
              //             border: OutlineInputBorder(),
              //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
              //           ),
              //
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                width: screenWidth * 0.95,
                child: Card(
                  elevation: 3,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Photo',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Upload Button
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
                                  pickImageFromGallery();
                                },
                                icon: const Icon(Icons.camera_alt),
                                label: const Text(
                                  'Upload\nPhoto',
                                  textAlign: TextAlign.center,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(100, 100),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Image Preview (Single Correct Container)
                            Container(
                              width: 120,
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
                                        width: 120,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Center(child: Text("No image")),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // _buildDropdownBeneficiary(
              //   label: 'Beneficiary',
              //   items: [
              //     'Select Beneficiary',
              //     'Rahul Sharma',
              //     'Ravi Ranjan',
              //     'Gunjan Tripathi',
              //     'Kaviya',
              //     'Prerna Chaudhary',
              //     'Mukesh Goyal',
              //     'Sunita Tripathi'
              //   ],
              //   fieldKey: 'beneficairy',
              //   selectedValue: _selectedBeneficiary,
              //   onChanged: (value) {
              //     setState(() {
              //       //_selectedLibraryPeriod = value;
              //       _selectedBeneficiary =
              //           (value == 'Select Beneficiary') ? '' : value;
              //     });
              //   },
              // ),

              Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Beneficiary',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDropdownOpen = !_isDropdownOpen;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedBeneficiaries.isEmpty
                                      ? 'Select Beneficiary'
                                      : _selectedBeneficiaries.join(', '),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Icon(
                                _isDropdownOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                              ),

                            ],

                          ),

                        ),
                      ),
                      if (_isDropdownOpen)
                        ListView(
                          shrinkWrap: true,
                          children: _beneficiaryOptions.map((name) {
                            return CheckboxListTile(
                              title: Text(name),
                              value: _selectedBeneficiaries.contains(name),
                              controlAffinity:
                              ListTileControlAffinity.leading,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedBeneficiaries.add(name);
                                  } else {
                                    _selectedBeneficiaries.remove(name);
                                  }
                                });
                              },
                            );
                          }).toList(),
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
                        'Observation',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: ObservationController,
                        maxLines: null,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z\s]')), // ONLY allows letters and space
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter Observation',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$wordCount / 100 words',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
              //           controller: TopicNameController,
              //           inputFormatters: [
              //             FilteringTextInputFormatter.allow(RegExp(
              //                 r'[a-zA-Z\s]')), // ONLY allows letters and space
              //           ],
              //           decoration: InputDecoration(
              //             hintText: 'Enter topic',
              //             border: OutlineInputBorder(),
              //             contentPadding: EdgeInsets.symmetric(
              //                 vertical: 4,
              //                 horizontal: 8), // yahan vertical padding kam karo
              //           ),
              //         ),
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
              //           inputFormatters: [
              //             FilteringTextInputFormatter.allow(RegExp(
              //                 r'[a-zA-Z\s]')), // ONLY allows letters and space
              //           ],
              //           decoration: InputDecoration(
              //             hintText: 'Enter chapter',
              //             border: OutlineInputBorder(),
              //             contentPadding: EdgeInsets.symmetric(
              //                 vertical: 4,
              //                 horizontal: 8), // yahan vertical padding kam karo
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
            ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: Text(
                widget.isReschedule ? 'Update' : 'Submit',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownActivity({
    required String label,
    required List<String> items,
    required String fieldKey,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
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
                    // const SizedBox(width: 4),
                  )
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: (selectedValue == null || selectedValue.isEmpty)
                    ? 'Select Activity'
                    : selectedValue,
                isExpanded: true,
                items: items
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedActivity =
                        (value == 'Select Activity') ? '' : value;
                    onChanged(_selectedActivity); // Debugging statement
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  //  errorText: _errors[fieldKey],
                ),
              ),
            ],
          ),
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

    try {
      final data = {
        'name_of_activity': _selectedActivity.toString(),
        'start_time': formattedStartTime ?? '',
        'end_time': formattedEndTime ?? '',
        'date': DateTime.now().toIso8601String(),
        'district': selectedGP.toString(),
        'block': selectedSHG.toString(),
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
        'resource_person_designation':
            ResourceDesignationController.text.toString(),
        'topic_name': TopicNameController.text.toString(),
        'chapter_name': ChapterController.text.toString(),
      };

      await DatabaseHelper.instance.AddingEventData(data, 'Event_Form');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Inserted Successfully'),
      ));
      Navigator.pop(context);
    } catch (e) {
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
                        child: Text(
                          item,
                        ),
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                        child: Text(
                          item,
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOption = (value == 'Select Option') ? '' : value;
                  onChanged(_selectedOption); // Debugging statement
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                //  errorText: _errors[fieldKey],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
