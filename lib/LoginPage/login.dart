
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../Common/BrandColors.dart';
import '../Home/homescreen.dart';

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login>{

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  String? userIdError;
  String? passwordError;
  String latitude = "0.00";
  String longitude = "0.00";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dio = Dio();
  @override
  void initState() {
    super.initState();
    _checkAndGetLocation();
  }

  Future<void> _checkAndGetLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showGpsDialog(context);
    } else {
      await _fetchAndSetLocation();
      // Continuously get the location updates
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1, // Update location after moving 10 meters
        ),
      ).listen((Position position) {
        setState(() {
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
        });
        print("latitude: $latitude, longitude: $longitude");
      });
    }
  }

  Future<void> _showGpsDialog(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.orangeAccent),
              SizedBox(width: 10),
              Text(
                "GPS Required",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: const Text(
            "Please enable GPS to use this feature.",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await Geolocator.openLocationSettings();
                    bool gpsEnabled = await _checkLocationService();
                    while (!gpsEnabled) {
                      await Future.delayed(const Duration(seconds: 1));
                      gpsEnabled = await _checkLocationService();
                    }
                    await _fetchAndSetLocation();
                  },
                  child: const Text(
                    "Open Settings",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkLocationService() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> _fetchAndSetLocation() async {
    try {
      Position position = await _getGeoLocation(context);
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
      print("latitude: $latitude, longitude: $longitude");
    } catch (e) {
      print("Error fetching location: $e");
    }
  }


  Future<Position> _getGeoLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return Future.error('Failed to get the current location: $e');
    }
  }

  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   body: Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     color: Colors.white,
    //     child: Stack(
    //       children: [
    //         // Background image
    //         // Container(
    //         //   decoration: BoxDecoration(
    //         //     image: DecorationImage(
    //         //       image: AssetImage('assets/logo.png'),
    //         //       fit: BoxFit.cover,
    //         //       alignment: Alignment.center,
    //         //     ),
    //         //   ),
    //         // ),
    //         SafeArea(
    //           child: SingleChildScrollView(
    //             child: Form(
    //               key: _formKey,
    //               child: Column(
    //                 children: [
    //                   SizedBox(height: screenHeight * 0.05),
    //                   // App logo with sliding images
    //                   Center(
    //                     child: LogoSlider(), // The sliding logo widget
    //                   ),
    //                   SizedBox(height: screenHeight * 0.02),
    //                   const Text(
    //                     "BANSIDHAR & ILA PANDA FOUDATION",
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                   SizedBox(height: screenHeight * 0.02),
    //
    //                   Padding(
    //                     padding: EdgeInsets.symmetric(
    //                         horizontal: screenWidth * 0.08),
    //                     child: Card(
    //                       elevation: 10,
    //                       shadowColor: Colors.black26,
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(20),
    //                       ),
    //                       color: Colors.orangeAccent,
    //                       // White with transparency
    //                       child: Padding(
    //                         padding: EdgeInsets.all(screenWidth * 0.03),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             // Center(
    //                             //   child: Padding(
    //                             //     padding: EdgeInsets.only(
    //                             //         bottom: screenHeight * 0.02),
    //                             //     child: const Text(
    //                             //       "Facilitator Login",
    //                             //       style: TextStyle(
    //                             //         fontSize: 16,
    //                             //         fontWeight: FontWeight.bold,
    //                             //         color: Colors.black,
    //                             //       ),
    //                             //     ),
    //                             //   ),
    //                             // ),
    //                             const Text(
    //                               "User ID",
    //                               style: TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.w600,
    //                                 color: Colors.black,
    //                               ),
    //                             ),
    //                             SizedBox(height: 5),
    //                             TextFormField(
    //                               controller: userIdController,
    //                               decoration: InputDecoration(
    //                                 filled: true,
    //                                 fillColor: Colors.grey[200],
    //                                 border: OutlineInputBorder(
    //                                   borderRadius: BorderRadius.circular(15),
    //                                   borderSide: BorderSide(
    //                                       color: Colors.grey.shade300),
    //                                 ),
    //                                 hintText: "example@gmail.com",
    //                                 hintStyle: TextStyle(
    //                                     color: Colors.grey[500],
    //                                     fontSize: 14
    //                                 ),
    //                               ),
    //                               validator: (value) {
    //                                 if (value == null || value.isEmpty) {
    //                                   return 'Please Enter Your User Id';
    //                                 }
    //                                 return null;
    //                               },
    //                             ),
    //                             SizedBox(height: 15),
    //                             const Text(
    //                               "Password",
    //                               style: TextStyle(
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.w600,
    //                                 color: Colors.black,
    //                               ),
    //                             ),
    //                             SizedBox(height: 5),
    //                             TextFormField(
    //                               controller: passwordController,
    //                               obscureText: !isPasswordVisible,
    //                               decoration: InputDecoration(
    //                                 filled: true,
    //                                 fillColor: Colors.grey[200],
    //                                 border: OutlineInputBorder(
    //                                   borderRadius: BorderRadius.circular(15),
    //                                   borderSide: BorderSide(
    //                                       color: Colors.grey.shade300),
    //                                 ),
    //                                 hintText: "****",
    //                                 hintStyle: TextStyle(
    //                                     color: Colors.grey[500],
    //                                     fontSize: 14
    //                                 ),
    //                                 suffixIcon: IconButton(
    //                                   icon: Icon(
    //                                     isPasswordVisible
    //                                         ? Icons.visibility
    //                                         : Icons.visibility_off,
    //                                     color: Colors.orangeAccent,
    //                                   ),
    //                                   onPressed: () {
    //                                     setState(() {
    //                                       isPasswordVisible = !isPasswordVisible;
    //                                     });
    //                                   },
    //                                 ),
    //                               ),
    //                               validator: (value) {
    //                                 if (value == null || value.isEmpty) {
    //                                   return 'Please Enter Your password';
    //                                 }
    //                                 return null;
    //                               },
    //                             ),
    //
    //                             SizedBox(height: screenHeight * 0.01),
    //                             SizedBox(
    //                               width: screenWidth * 0.8,
    //                               // Adjust width if needed
    //                               child: ElevatedButton(
    //                                 onPressed: () {
    //                                   if (_formKey.currentState?.validate() ?? false) {
    //                                     verifyUser(context);
    //                                   }
    //                                 },
    //
    //                                 style: ElevatedButton.styleFrom(
    //                                   backgroundColor: Colors.grey[400],
    //                                   padding: EdgeInsets.symmetric(
    //                                     vertical: screenHeight * 0.015,
    //                                   ),
    //                                   shape: RoundedRectangleBorder(
    //                                     borderRadius: BorderRadius.circular(15),
    //                                   ),
    //                                   elevation: 5,
    //                                   shadowColor: Colors.black26,
    //                                   minimumSize: Size(double.infinity, 50),
    //                                 ),
    //                                 child: Text(
    //
    //                                   "Sign In",
    //
    //                                   style: TextStyle(
    //                                     fontSize: screenWidth * 0.04,
    //                                     color: Colors.black,
    //                                     fontWeight: FontWeight.bold,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(height: screenHeight * 0.05),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           bottom: 190,
    //           left: 0,
    //           right: 0,
    //           child: Padding(
    //             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Icon(
    //                       Icons.location_on,
    //                       color: Colors.orangeAccent,
    //                     ),
    //                     SizedBox(width: 8),
    //                     Text(
    //                       "$latitude, $longitude",
    //                       style: TextStyle(
    //                         fontSize: 14,
    //                         color: Colors.black,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //           bottom: 5,
    //           left: 0,
    //           right: 0,
    //           child: Column(
    //             children: [
    //               SizedBox(height: 5),
    //               const Text(
    //                 "Technology Partner: Indev Consultancy Pvt Ltd",
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   color: Colors.black,
    //                 ),
    //                 textAlign: TextAlign.center,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
          children: [
      // Background Curve (Grey + White)
      Positioned.fill(
      child: ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade400, Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
    ),
    ),

    // Your existing SafeArea/Form and other content comes here...


          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    // App logo with sliding images
                    Center(
                      child: LogoSlider(), // The sliding logo widget
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      "BANSIDHAR & ILA PANDA FOUNDATION",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.09),
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white.withOpacity(0.85),
                       //  color: Colors.orangeAccent,
                       // color: BrandColors.primaryAccent,
                        // White with transparency
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: screenHeight * 0.02),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                "User ID",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: userIdController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300),
                                  ),
                                  hintText: "example@gmail.com",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15),
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300),
                                  ),
                                  hintText: "****",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      // color: Colors.green,
                                      color: Colors.orangeAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                              ),
                              // SizedBox(height: 15),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: TextButton(
                              //     onPressed: () {
                              //       // Handle Forgot Password
                              //     },
                              //     child: const Text(
                              //       "Forgot Password?",
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Login Button
                              SizedBox(height: screenHeight * 0.03),
                              SizedBox(
                                width: screenWidth * 0.8,
                                // Adjust width if needed
                                child: ElevatedButton(
                                  onPressed: () {
    if (_formKey.currentState?.validate() ?? false) {
                                        verifyUser(context);
                                      }

                                  },

                                  style: ElevatedButton.styleFrom(
                                    // backgroundColor: Colors.red,
                                    backgroundColor: Colors.grey[400],
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.015,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.black26,
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  child: Text(

                                    "Log In",

                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        // color: Colors.green,
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "$latitude, $longitude",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Version: 1.0.0",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
                child: const Text(
                  "Technology Partner: Indev Consultancy Pvt. Ltd.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }


  Future<void> verifyUser(BuildContext context) async {
    try {
      String userId = userIdController.text.trim();
      String pass = passwordController.text.trim();

      if (userId == 'CMSasmita' && pass == 'Sasmita@123') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print('ejeeje');
        Get.snackbar(
          "Invalid Credentials",
          "Please enter the correct user id and password.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Exception: $e");
    }
  }


}
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.85); // Start at bottom left
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.85); // Smooth curve
    path.lineTo(size.width, 0); // Top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class LogoSlider extends StatefulWidget {
  @override
  _LogoSliderState createState() => _LogoSliderState();
}

class _LogoSliderState extends State<LogoSlider> {

  final PageController _pageController = PageController();

  final List<String> _images = [
    'assets/logo.png',
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _startSliding);

  }

  void _startSliding() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _images.length;
        });
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startSliding();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipOval(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            physics: const NeverScrollableScrollPhysics(), // Prevents swiping outside the images
            itemBuilder: (context, index) {
              return FittedBox(
                fit: BoxFit.scaleDown, // Ensures the image is scaled down inside the circle
                child: Image.asset(
                  _images[index],
                  height: 95, // Slightly smaller than container size for padding
                  width: 95,
                ),
              );
            },
          ),
        ),
      ),
    );
  }




}

