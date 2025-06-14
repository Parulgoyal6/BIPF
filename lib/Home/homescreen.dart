import 'package:bipf_app/ListBeneficiary/MyListBeneficiary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ListBeneficiary/list_beneficiary.dart';
import '../LoginPage/login.dart';
import '../MyAchievements/achievements.dart';
import '../MyActivity/ListingActivity.dart';
import '../MyActivity/MyActivity.dart';
import '../MyEvents/MyEvents.dart';
import '../MyResources/MyResources.dart';
import '../Reports/Reports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  Future<List> getDataForDate(DateTime date) async {
    // Dummy: return empty list for this date
    if (date == DateTime(2025, 6, 4)) {
      return [];
    }
    // else simulate some data
    return ['some', 'data'];
  }


  String? username;
  int syncCount = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int notificationCount = 0;
  DateTime _selectedDate = DateTime.now();

  String latitude = "0.00", longitude = "0.00";
  @override
  void initState() {
    super.initState();

    // Delay pop-up till UI builds
    // Future.delayed(Duration.zero, () {
    //   welcome(context);
    //showCalendarDialog(context);
    // });
  }

  DateTime? pickedDate;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          // drawer: Drawer(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     children: [
          //       const DrawerHeader(
          //         decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //             colors: [Colors.red, Colors.yellow],
          //             begin: Alignment.topLeft,
          //             end: Alignment.bottomRight,
          //           ),
          //         ),
          //         child: Row(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             CircleAvatar(
          //               radius: 30,
          //               backgroundColor: Colors.white,
          //               child: Icon(
          //                 Icons.person,
          //                 size: 40,
          //                 color: Colors.red,
          //               ),
          //             ),
          //             SizedBox(width: 10),
          //             Text(
          //               'Amit Kumar',
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 24,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.library_books, color: Colors.green),
          //         title: Text('Library Setup'),
          //         onTap: () {},
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.dashboard, color: Colors.orangeAccent),
          //         title: Text('Dashboard'),
          //         onTap: () {},
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.person, color: Colors.teal),
          //         title: Text('Facilitator Visits'),
          //         onTap: () {},
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.settings, color: Colors.purple),
          //         title: Text('Settings'),
          //         onTap: () {},
          //       ),
          //       ListTile(
          //         leading: Icon(Icons.logout, color: Colors.redAccent),
          //         title: Text('Logout'),
          //         onTap: () {},
          //       ),
          //     ],
          //   ),
          // ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow.shade800, Colors.yellow.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Header (Profile + Notification + Logout)
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile Image + Name
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.yellow[800],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //const SizedBox(height: 4),
                              const SizedBox(
                                width: 150,
                                child: Text(
                                  'Welcome! Sasmita',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                width: 150,
                                child: Text(
                                  'Community Mobilizer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Notification & Logout
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.sync,
                                      color: Colors.blue),
                                  iconSize: 25,
                                  onPressed: () {},
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 6,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.orangeAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                icon:
                                    const Icon(Icons.logout, color: Colors.red),
                                iconSize: 25,
                                onPressed: () async {
                                  bool confirm =
                                      await _onLogoutConfirm(context);
                                  if (confirm) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  }
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
                Stack(children: [
                  // Header (Profile + Notification + Logout)
                  // Positioned(
                  // top: 100,
                  // left: 16,
                  // right: 16,
                  //  // child: _buildMyCard(),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        // color:Colors.white,
                        // color: BrandColors.primaryAccent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 20.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final gridHeight = constraints.maxHeight;

                            return GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: 6,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: (constraints.maxWidth / 2) /
                                    (gridHeight / 3.2),
                              ),
                              itemBuilder: (context, index) {
                                final menuItems = [
                                  {
                                    "title": "My Activity",
                                    // "icon": Icons.article,
                                    "icon": Image.asset(
                                      'assets/women.jpeg', // path to your image in assets folder
                                      width: 140,  // set size similar to icon
                                      height: 140,
                                    ),
                                    "onTap": () async {

                                      Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyActivityScreen()
                                                ),
                                              );
                                      // DateTime? pickedDate =
                                      //     await showDatePicker(
                                      //   context: context,
                                      //   initialDate: DateTime.now(),
                                      //   firstDate: DateTime(2020),
                                      //   lastDate: DateTime(2100),
                                      //   builder: (context, child) {
                                      //     return Theme(
                                      //       data: ThemeData.light().copyWith(
                                      //         colorScheme: ColorScheme.light(
                                      //           primary: Colors.yellow[800]!,
                                      //           onPrimary: Colors.white,
                                      //           onSurface: Colors.black,
                                      //         ),
                                      //         dialogBackgroundColor:
                                      //             Colors.white,
                                      //       ),
                                      //       child: child!,
                                      //     );
                                      //   },
                                      // );
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         ListingForm(),
                                      //   ),
                                      // );
                                  // if (pickedDate != null) {
                                  //   print("selectedDate $pickedDate");
                                  //
                                  //   // Let's say this returns List<dynamic> of activities
                                  //   List dataForDate = await getDataForDate(
                                  //       pickedDate);
                                  //   print("datais $dataForDate");
                                  //
                                  //   if (dataForDate.isNotEmpty) {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ListingFormActivity(
                                  //                 selectedDate: pickedDate),
                                  //       ),
                                  //     );
                                  //   } else {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ListingFormActivity(
                                  //                 selectedDate: pickedDate),
                                  //       ),
                                  //     );
                                  //   }
                                  // }
                                  }
                                  },
                                  {
                                    "title": "My Events",
                                    // "icon": Icons.group,
                                    "icon": Image.asset(
                                      'assets/events.png', // path to your image in assets folder
                                      width: 140,  // set size similar to icon
                                      height: 140,
                                    ),
                                    "onTap": () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MyEventsScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  {
                                    "title": "My Achievements",
                                    // "icon": Icons.people,
                                    "icon": Image.asset(
                                      'assets/achievement.png', // path to your image in assets folder
                                      width: 120,  // set size similar to icon
                                      height: 120,
                                    ),
                                    "onTap": () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Well done! You have being doing very well'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );

                                      // Delay navigation until after snackbar is shown (optional)
                                      Future.delayed(Duration(milliseconds: 10), () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MyAchievementsChart()),
                                        );
                                      }
                                      );
                                    }

                                  },
                                  {
                                    "title": "View/Add/Delete Beneficiary",
                                    // "icon": Icons.list_alt,
                                    "icon": Image.asset(
                                      'assets/beneficiary.png', // path to your image in assets folder
                                      width: 120,  // set size similar to icon
                                      height: 120,
                                    ),
                                    "onTap": () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListBeneficiary()),
                                      );
                                    }
                                  },
                                  {
                                    "title": "My Resources",
                                    // "icon": Icons.menu_book,
                                    "icon": Image.asset(
                                      'assets/resources.png', // path to your image in assets folder
                                      width: 120,  // set size similar to icon
                                      height: 120,
                                    ),
                                    "onTap": () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyResourcesScreen()));
                                    }
                                  },
                                  {
                                    "title": "Reports",
                                    "icon": Image.asset(
                                      'assets/report.png', // path to your image in assets folder
                                      width: 120,  // set size similar to icon
                                      height: 120,
                                    ),
                                    "onTap": () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportsScreen()));

                                    },
                                  }

                                ];

                                final item = menuItems[index];
                                return _buildMenuBox(
                                  icon: item["icon"] as Widget,
                                  // iconColor: item["iconColor"] as Color,
                                  title: item["title"] as String,
                                  // backgroundColor:
                                  //  item["backgroundColor"] as Color,
                                  onTap: item["onTap"] as VoidCallback,
                                  // count: item["count"] as int,
                                  // count: (item["count"] as int),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Widget _buildMyCard() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10),
  //     // child: Card(
  //     //   shape: RoundedRectangleBorder(
  //     //     borderRadius: BorderRadius.circular(20),
  //     //   ),
  //     //   elevation: 4,
  //     //   color: Colors.white,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 SizedBox(
  //                   width: 130,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () async {
  //                       DateTime? pickedDate = await showDatePicker(
  //                         context: context,
  //                         initialDate: DateTime.now(),
  //                         firstDate: DateTime(2020),
  //                         lastDate: DateTime(2100),
  //                         builder: (context, child) {
  //                           return Theme(
  //                             data: ThemeData.light().copyWith(
  //                               colorScheme: ColorScheme.light(
  //                                 primary: Colors.yellow[800]!,
  //                                 onPrimary: Colors.white,
  //                                 onSurface: Colors.black,
  //                               ),
  //                               dialogBackgroundColor: Colors.white,
  //                             ),
  //                             child: child!,
  //                           );
  //                         },
  //                       );
  //
  //                       if (pickedDate != null) {
  //                         print("Selected Activity Date: $pickedDate");
  //
  //                         // Navigate to ListingForm with selected date
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) =>
  //                                 ListingForm(selectedDate: pickedDate),
  //                           ),
  //                         );
  //                       }
  //                     },
  //                     label: Text("My Activity",style: TextStyle(color: Colors.white),),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.yellow[800],
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 130,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () {
  //                       // Aap yahan bhi same calendar ya koi events list dikha sakte ho
  //                     },
  //                     label: Text("My Event", style: TextStyle(color: Colors.white),),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.yellow[800],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //           ],
  //         ),
  //       // ),
  //     ),
  //   );
  // }

  // Future<void> welcome(BuildContext context) async {
  //   final overlay = Overlay.of(context);
  //   late OverlayEntry entry;
  //
  //   entry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: MediaQuery.of(context).size.height * 0.4,
  //       left: 30,
  //       right: 30,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Center(
  //           child: Card(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             color: Colors.grey[200],
  //             elevation: 8,
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: const [
  //                   //CircularProgressIndicator(),
  //                   SizedBox(width: 20),
  //                   Text(
  //                     "Welcome Parul !!",
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  //
  //   overlay.insert(entry);
  //
  //   // Auto remove after 2 seconds
  //   await Future.delayed(const Duration(seconds: 2));
  //   entry.remove();
  // }

  // void showCalendarDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Select a Date for Schedule Event",style: TextStyle(fontSize: 12),),
  //         content: Container(
  //           width: 300,
  //           height: 350,
  //           child: CalendarDatePicker(
  //             initialDate: DateTime.now(),
  //             firstDate: DateTime(2000),
  //             lastDate: DateTime(2100),
  //             onDateChanged: (DateTime date) {
  //               // Jab date select ho jaye turant:
  //               Navigator.of(context).pop();  // Dialog close karo
  //
  //               // Fir navigate karo next screen par
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => ListingForm(selectedDate: date),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text("Close"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildMenuBox({
    required String title,
    required Widget icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon in white circle with yellow icon
            Container(
              // padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              // child: Icon(icon, size: 50, color: Colors.yellow[800]),
              child: icon,

            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Exit App?',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('Are you sure you want to exit?',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[300],
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          SystemNavigator.pop(); // Exit the app
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  Future<bool> _onLogoutConfirm(BuildContext context) async {
    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Logout?',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text('Are you sure you want to logout?',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[300],
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false;
  }
}
