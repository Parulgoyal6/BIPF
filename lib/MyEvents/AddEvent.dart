import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Common/DatabaseHelper.dart';
import '../Common/SharedPreferHelper.dart';
import '../Models/adding_an_event.dart';
// import 'package:image_picker/image_picker.dart';

class AddEvent extends StatefulWidget {
  // final Map<String, dynamic>? existingEvent;
  final bool isReschedule;
  final bool isInitiate;
  const AddEvent(
      {super.key, this.isReschedule = false, this.isInitiate = false});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String? selectedGP;
  List<TextEditingController> guestNameControllers = [TextEditingController()];
  List<TextEditingController> guestDesignationControllers = [
    TextEditingController()
  ];
  List<TextEditingController> resourceNameControllers = [
    TextEditingController()
  ];
  List<TextEditingController> resourceDesignationControllers = [
    TextEditingController()
  ];

  final TextEditingController EventNameController = TextEditingController();
  final TextEditingController TentativeAmountController = TextEditingController();
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
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
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

    // Add listeners to automatically update total
    _maleController.addListener(_calculateTotal);
    _femaleController.addListener(_calculateTotal);
    _otherController.addListener(_calculateTotal);
    _boysController.addListener(_calculateTotal);
    _girlsController.addListener(_calculateTotal);
    if (widget.isReschedule) {
      getData();
    } else if (widget.isInitiate) {
      getData();
    }
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
  String id = "";
  RxList<AddingAnEvent> list_data = <AddingAnEvent>[].obs;
  Future<void> getData() async {
    id = await SharedPreferHelper.getPrefString('id', "");
    list_data.assignAll(await DatabaseHelper.instance
        .getAddingAnEvent("Select * from Event_Form where local_id = '${id}'"));
    if (list_data.length > 0) {
      EventNameController.text = list_data[0].name_of_event.toString();
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


  // Function to show the date picker and update selectedDate
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),   // You can adjust these limits
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

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
      appBar: (widget.isReschedule || widget.isInitiate)
          ? AppBar(
              backgroundColor:
                  widget.isReschedule ? Colors.orange : Colors.orange,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                widget.isReschedule ? 'Reschedule Event' : 'Initiate Event',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isReschedule) ...[
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8), // yahan vertical padding kam karo
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
                      ] ),
                ),
              ),
            ] else if (widget.isInitiate) ...[
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8), // yahan vertical padding kam karo
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
                      ] ),
                ),
              ),
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
                            value: selectedSHG,
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
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                            items: selectedSHG != null
                                ? SHGList[selectedSHG]!
                                .map((String value) =>
                                DropdownMenuItem(value: value, child: Text(value)))
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
                      ))), // You can add more form fields here...
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
                        'Expected Participants',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        // readOnly: true,
                        controller: TargetController,
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
                        'Tentative Amount',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: TentativeAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
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
              //           'Target Number of Population',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //           controller: TargetController,
              //           decoration: InputDecoration(
              //             hintText: 'Enter target Number of population',
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

              Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < guestNameControllers.length; i++) ...[
                        const Text(
                          'Guest Name',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: guestNameControllers[i],
                          decoration: InputDecoration(
                            hintText: 'Enter Guest Name',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  guestNameControllers
                                      .add(TextEditingController());
                                  guestDesignationControllers
                                      .add(TextEditingController());
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Guest Designation',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: guestDesignationControllers[i],
                          decoration: const InputDecoration(
                            hintText: 'Enter Guest Designation',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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
                      for (int i = 0;
                          i < resourceNameControllers.length;
                          i++) ...[
                        const Text(
                          'Resource Person Name',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: resourceNameControllers[i],
                          decoration: InputDecoration(
                            hintText: 'Enter Resource Person Name',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  resourceNameControllers
                                      .add(TextEditingController());
                                  resourceDesignationControllers
                                      .add(TextEditingController());
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Resource Person Designation',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: resourceDesignationControllers[i],
                          decoration: const InputDecoration(
                            hintText: 'Enter Resource Person Designation',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),

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

              _buildDropdownBeneficiary(
                label: 'Beneficiary',
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
              //           'Topic Name',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //           controller: TopicNameController,
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
            ] else ...[
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8), // yahan vertical padding kam karo
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
                      ] ),
                ),
              ),
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
                            value: selectedSHG,
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
                              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            ),
                            items: selectedSHG != null
                                ? SHGList[selectedSHG]!
                                .map((String value) =>
                                DropdownMenuItem(value: value, child: Text(value)))
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
                      ))), // You can add more form fields here...

              Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expected Participants',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        // readOnly: true,
                        controller: TargetController,
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
                        'Tentative Amount',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: TentativeAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
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
              //           'Target Number of Population',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         const SizedBox(height: 8),
              //         TextFormField(
              //           controller: TargetController,
              //           decoration: InputDecoration(
              //             hintText: 'Enter target Number of population',
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

    final String formattedStartTime = _startTime != null
        ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
        : '';

    final String formattedEndTime = _endTime != null
        ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
        : '';

    final data = {
      'name_of_event': EventNameController.text.trim(),
      'start_time': formattedStartTime,
      'end_time': formattedEndTime,
      'date': _selectedDate.toString(),
      'district': selectedGP.toString(),
      'block': selectedSHG.toString(),
      'village': selectedVillage.toString(),
      'total_participants': _TotalController.text,
      'men': _maleController.text,
      'women': _femaleController.text,
      'girls': _girlsController.text,
      'boys': _boysController.text,
      'other': _otherController.text,
      'image': _imageFile.toString(),
      'unplanned': _selectedOption.toString(),
      'target_number_of_population': TargetController.text,
      'guest_name': GuestNameController.text,
      'beneficiary': _selectedBeneficiary.toString(),
      'observation': ObservationController.text,
      'guest_designation': GuestDesignationController.text,
      'resource_person_name': ResourceNameController.text,
      'resource_person_designation': ResourceDesignationController.text,
      'topic_name': TopicNameController.text,
      'chapter_name': ChapterController.text,
    };

    try {
      if (widget.isReschedule) {
        // Assuming you have an update method in your DB helper:
        // await DatabaseHelper.instance.updateEventData(data, formData['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event Updated Successfully')),
        );
      } else {
        await DatabaseHelper.instance.AddingEventData(data, 'Event_Form');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data Inserted Successfully')),
        );
      }
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
