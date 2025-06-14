import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../Common/DatabaseHelper.dart';
// import 'package:image_picker/image_picker.dart';

class AddActivity extends StatefulWidget {
  final Map<String, dynamic>? existingEvent;
  const AddActivity({super.key, this.existingEvent});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final TextEditingController ActivityNameController = TextEditingController();
  final TextEditingController _maleController = TextEditingController();
  final TextEditingController _femaleController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _TotalController = TextEditingController();
  final TextEditingController _boysController = TextEditingController();
  final TextEditingController _girlsController = TextEditingController();
  final TextEditingController TargetController = TextEditingController();
  final TextEditingController GuestNameController = TextEditingController();
  TextEditingController inputCostController = TextEditingController();
  TextEditingController revenueController = TextEditingController();
  TextEditingController expenseController = TextEditingController();

  final Set<String> selectedActivities = {};
  final TextEditingController othersController = TextEditingController();
  final TextEditingController GuestDesignationController =
      TextEditingController();
  final TextEditingController ResourceNameController = TextEditingController();
  final TextEditingController ResourceDesignationController =
      TextEditingController();
  final TextEditingController TopicNameController = TextEditingController();
  final TextEditingController TentativeAmountController =
      TextEditingController();
  final TextEditingController ObservationController = TextEditingController();
  final TextEditingController ChapterController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final Map<String, String?> _errors = {};
  bool _isDropdownOpen =  false;
  int wordCount = 0;
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

  DateTime? selectedDate;
  String? _selectedActivity = "";
  String? _selectedUnnatiActivity = "";
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

    int total = female + male + boys + girls + other;
    setState(() {
      _TotalController.text = total.toString(); // Update total field
    }); // Update total field
  }

  final List<String> activities = [
    "Mushroom",
    "Goat rearing",
    "Poultry",
    "Tailoring",
    "Vegetable farm",
    "Petty Shop/Shop",
    "Floriculture",
    "Snacks making",
    "Others"
  ];

  void initState() {
    // TODO: implement initState
    super.initState();

    // Add listeners to automatically update total
    _maleController.addListener(_calculateTotal);
    _femaleController.addListener(_calculateTotal);
    _otherController.addListener(_calculateTotal);
    _boysController.addListener(_calculateTotal);
    _girlsController.addListener(_calculateTotal);
  }
// Declare controllers and profit variable

  double profit = 0;

  void calculateProfit() {
    double input = double.tryParse(inputCostController.text) ?? 0;
    double revenue = double.tryParse(revenueController.text) ?? 0;
    double expense = double.tryParse(expenseController.text) ?? 0;
    setState(() {
      profit = revenue - (input + expense);
    });
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



  Future<void> _selectDated(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: today,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool showLivelihoodFields = false;
  bool showUnnati = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownActivity(
              label: 'Name Of Activity',
              items: [
                'Select Activity',
                "Unnati Calendar",
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
                  _selectedActivity = (value == 'Select Activity') ? '' : value;
                  showLivelihoodFields =
                      _selectedActivity == 'Livelihood Data Collection/FU';
                  showUnnati = _selectedActivity == 'Unnati Calendar';
                });
              },
            ),
            if (showLivelihoodFields) ...[
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
                            items: GPList.map((String value) => DropdownMenuItem(
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
              Card(
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Name of the Business Holder',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: TentativeAmountController,
                        decoration: InputDecoration(
                          hintText: 'Enter name',
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
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Father's Name/ Husband Name",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: EventNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Father's Name/Husband Name",
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
                elevation: 3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Member Name",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: EventNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Member Name",
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
              //           "Select Activities",
              //           style: TextStyle(
              //               fontSize: 18, fontWeight: FontWeight.bold),
              //         ),
              //         const SizedBox(height: 12),
              //         ...activities.map((activity) => CheckboxListTile(
              //               title: Text(activity),
              //               value: selectedActivities.contains(activity),
              //               onChanged: (bool? value) {
              //                 setState(() {
              //                   if (value == true) {
              //                     selectedActivities.add(activity);
              //                   } else {
              //                     selectedActivities.remove(activity);
              //                   }
              //                 });
              //               },
              //               controlAffinity: ListTileControlAffinity.leading,
              //             )),
              //         const SizedBox(height: 12),
              //         if (selectedActivities.contains('Others'))...[
              //         TextField(
              //           controller: othersController,
              //           decoration: const InputDecoration(
              //             hintText: "Enter other activity",
              //             border: OutlineInputBorder(),
              //             contentPadding:
              //                 EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //           ),
              //         )]
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
                      const Text(
                        'Select Activities',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDropdownOpen = !_isDropdownOpen;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  selectedActivities.isEmpty
                                      ? 'Select Activities'
                                      : selectedActivities.join(', '),
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
                        Container(
                          height: 200, // Adjust height as needed
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: activities.map((name) {
                              return CheckboxListTile(
                                title: Text(name),
                                value: selectedActivities.contains(name),
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedActivities.add(name);
                                    } else {
                                      selectedActivities.remove(name);
                                    }
                                  });
                                },
                              );
                            }).toList(),
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
                        'Remarks',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        // controller: ObservationController,
                        maxLines: null,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z\s]')), // ONLY allows letters and space
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter remarks',
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


              Card(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('Date of Monitoring:'),
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
                        onTap: () => _selectDated(context),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Cost Card
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Input Cost",
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: inputCostController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => calculateProfit(),
                            decoration: InputDecoration(
                              hintText: "Enter amount",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Total Revenue Card
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Revenue",
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: revenueController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => calculateProfit(),
                            decoration: InputDecoration(
                              hintText: "Enter amount",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expenses Card
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Expenses (Rent/Transport/Salary, etc.)",
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: expenseController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => calculateProfit(),
                            decoration: InputDecoration(
                              hintText: "Enter amount",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Profit Card
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Profit / Income",
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                "₹ ${profit.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
            if(showUnnati)...[
              _buildDropdownUnnatiActivity(
                label: 'Unnati Calendar Activity',
                items: [
                  'Select Activity',
                  "Follow up of the 1st training",
                  'Skill Training Covering Maternal health During & After Pregnancy.',
                  'Follow up of the & 2nd training focussing',
                  // 'Follow up of the Skill Training Covering Maternal health During & After Pregnancy.',
                  'Follow up of the 1st Skill Training Covering Maternal health During & After Pregnancy.',
                  'Skill training covering child health and feeding',
                  'Skill Training Covering  Child health',
                ],
                fieldKey: 'activity',
                selectedValue: _selectedUnnatiActivity,
                onChanged: (value) {
                  setState(() {
                    _selectedUnnatiActivity = (value == 'Select Activity') ? '' : value;
                  });
                },
              ),


            ],
    if (!showLivelihoodFields) ...[
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
                          items: GPList.map((String value) => DropdownMenuItem(
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
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
            //           ),
            //
            //         ),
            //
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
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8), // yahan vertical padding kam karo
                      ),
                    ),
                  ],
                ),
              ),
            ),],

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
            // You can add more form fields here...
            // Card(
            //   elevation: 3,
            //   color: Colors.white,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text(
            //           'Participants Count',
            //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //         ),
            //         const SizedBox(height: 5),
            //         TextField(
            //           controller: _maleController,
            //           keyboardType: TextInputType.number,
            //           decoration: const InputDecoration(
            //             hintText: 'Men',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         TextField(
            //           controller: _femaleController,
            //           keyboardType: TextInputType.number,
            //           decoration: const InputDecoration(
            //             hintText: 'Women',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         TextField(
            //           controller: _boysController,
            //           keyboardType: TextInputType.number,
            //           decoration: const InputDecoration(
            //             hintText: 'Boys',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         TextField(
            //           controller: _girlsController,
            //           keyboardType: TextInputType.number,
            //           decoration: const InputDecoration(
            //             hintText: 'Girls',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         TextField(
            //           controller: _otherController,
            //           keyboardType: TextInputType.number,
            //           decoration: const InputDecoration(
            //             hintText: 'Other',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         TextFormField(
            //           readOnly: true,
            //           controller: _TotalController,
            //           keyboardType: TextInputType.number,
            //           decoration: InputDecoration(
            //             hintText: 'Total Participants',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //             suffixIcon: GestureDetector(
            //               onTap: () {
            //                 // Show a dialog or snackbar when icon is tapped
            //                 showDialog(
            //                   context: context,
            //                   builder: (context) => AlertDialog(
            //                     title: Text('Hint'),
            //                     content: Text('Enter the number of participants attending the event.'),
            //                     actions: [
            //                       TextButton(
            //                         onPressed: () => Navigator.pop(context),
            //                         child: Text('OK'),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               },
            //               child: Icon(Icons.info_outline),
            //             ),
            //           ),
            //         ),
            //
            //
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
            //
            // // Card(
            // //   elevation: 3,
            // //   color: Colors.white,
            // //   child: Padding(
            // //     padding: const EdgeInsets.all(8.0),
            // //     child: Column(
            // //       crossAxisAlignment: CrossAxisAlignment.start,
            // //       children: [
            // //         const Text(
            // //           'Guest Name',
            // //           style: TextStyle(fontSize: 14),
            // //         ),
            // //         const SizedBox(height: 8),
            // //         TextFormField(
            // //           controller: GuestNameController,
            // //           decoration: InputDecoration(
            // //             hintText: 'Enter Guest Name',
            // //             border: OutlineInputBorder(),
            // //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
            // //           ),
            // //
            // //         ),
            // //         const SizedBox(height: 10),
            // //         const Text(
            // //           'Guest Designation',
            // //           style: TextStyle(fontSize: 14),
            // //         ),
            // //         const SizedBox(height: 8),
            // //         TextFormField(
            // //           controller: GuestDesignationController,
            // //           decoration: InputDecoration(
            // //             hintText: 'Enter Guest Designation',
            // //             border: OutlineInputBorder(),
            // //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
            // //           ),
            // //
            // //         ),
            // //       ],
            // //     ),
            // //   ),
            // // ),
            // // Card(
            // //   elevation: 3,
            // //   color: Colors.white,
            // //   child: Padding(
            // //     padding: const EdgeInsets.all(8.0),
            // //     child: Column(
            // //       crossAxisAlignment: CrossAxisAlignment.start,
            // //       children: [
            // //         const Text(
            // //           'Resource Person Name',
            // //           style: TextStyle(fontSize: 14),
            // //         ),
            // //         const SizedBox(height: 8),
            // //         TextFormField(
            // //           controller: ResourceNameController,
            // //           decoration: InputDecoration(
            // //             hintText: 'Enter Resource Person Name',
            // //             border: OutlineInputBorder(),
            // //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
            // //           ),
            // //
            // //         ),
            // //         const SizedBox(height: 10),
            // //         const Text(
            // //           'Resource Person Designation',
            // //           style: TextStyle(fontSize: 14),
            // //         ),
            // //         const SizedBox(height: 8),
            // //         TextFormField(
            // //           controller: ResourceDesignationController,
            // //           decoration: InputDecoration(
            // //             hintText: 'Enter Resource Person Designation',
            // //             border: OutlineInputBorder(),
            // //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),  // yahan vertical padding kam karo
            // //           ),
            // //
            // //         ),
            // //       ],
            // //     ),
            // //   ),
            // // ),
            // Container(
            //   width: screenWidth * 0.95,
            //   child: Card(
            //     elevation: 3,
            //     color: Colors.white,
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text(
            //             'Photo',
            //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //           ),
            //           const SizedBox(height: 16),
            //
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               // Upload Button Container (Square)
            //               Container(
            //                 width: 120,
            //                 height: 100,
            //                 decoration: BoxDecoration(
            //                   border: Border.all(color: Colors.grey.shade300),
            //                   borderRadius: BorderRadius.circular(8),
            //                   color: Colors.yellow.shade50,
            //                 ),
            //                 child: ElevatedButton.icon(
            //                   onPressed: () {
            //                     //   pickImageFromGallery();
            //                   },
            //                   icon: const Icon(Icons.camera_alt),
            //                   label: const Text(
            //                     'Upload\nPhoto',
            //                     textAlign: TextAlign.center,
            //                   ),
            //                   style: ElevatedButton.styleFrom(
            //                     backgroundColor: Colors.orange,
            //                     foregroundColor: Colors.white,
            //                     minimumSize: const Size(150, 150),
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(8),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //
            //               const SizedBox(width: 16),
            //
            //               // Image Preview Container (Square)
            //               Container(
            //                 width: 150,
            //                 height: 100,
            //                 decoration: BoxDecoration(
            //                   border: Border.all(color: Colors.grey.shade300),
            //                   borderRadius: BorderRadius.circular(8),
            //                   color: Colors.grey[100],
            //                 ),
            //                 child: _imageFile != null
            //                     ? ClipRRect(
            //                   borderRadius: BorderRadius.circular(8),
            //                   child: Image.file(
            //                     _imageFile!,
            //                     width: 100,
            //                     height: 100,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 )
            //                     : const Center(
            //                   child: Text("No image"),
            //                 ),
            //               ),
            //             ],
            //           ),
            //
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            //
            // _buildDropdownBeneficiary(
            //   label:
            //   'Beneficiary',
            //   items: [
            //     'Select Beneficiary',
            //     'Rahul',
            //     'Ravi',
            //     'Gunjan',
            //   ],
            //   fieldKey: 'beneficairy',
            //   selectedValue: _selectedBeneficiary,
            //   onChanged: (value) {
            //     setState(() {
            //       //_selectedLibraryPeriod = value;
            //       _selectedBeneficiary =
            //       (value == 'Select Beneficiary') ? '' : value;
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
            //           'Observation',
            //           style: TextStyle(fontSize: 14),
            //         ),
            //         const SizedBox(height: 8),
            //         TextFormField(
            //           controller: ObservationController,
            //           maxLines: null,
            //           inputFormatters: [
            //             FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // ONLY allows letters and space
            //           ],
            //           decoration: InputDecoration(
            //             hintText: 'Enter Observation',
            //             border: OutlineInputBorder(),
            //             contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            //           ),
            //         ),
            //         const SizedBox(height: 4),
            //         Text(
            //           '$wordCount / 100 words',
            //           style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            ElevatedButton(
              onPressed: () {
                _submit();
              },
              child: const Text(
                'Submit',
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
        'date': _selectedDate.toString(),
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

      await DatabaseHelper.instance.AddingEventData(data, 'Activity_Form');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Inserted Successfully'),
      ));
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
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

  Widget _buildDropdownUnnatiActivity({
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
                    _selectedUnnatiActivity =
                        (value == 'Select Activity') ? '' : value;
                    onChanged(_selectedUnnatiActivity); // Debugging statement
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
