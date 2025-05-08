import 'package:car_rental_staff_app/views/search_screen.dart';
import 'package:car_rental_staff_app/widgect/custom_search.dart';
import 'package:car_rental_staff_app/widgect/recent_booking.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String? userId;
  String? _localImageUrl;
  String _address = 'Fetching location...';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine if device is in landscape mode
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Scale factors for responsive sizing
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              screenWidth * 0.03, screenHeight * 0.015, screenWidth * 0.03, 0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 24,
                        color: Color(0XFF120698),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Location',
                              style: TextStyle(fontSize: 12 * textScaleFactor)),
                          Text(
                            _address,
                            style: TextStyle(fontSize: 12 * textScaleFactor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: screenWidth * 0.03),
                      Container(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.06,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0XFF120698),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        child: _localImageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  _localImageUrl!,
                                  width: 50, // Set width/height as needed
                                  height: 50,
                                  fit: BoxFit
                                      .fill, // Change to BoxFit.contain if needed
                                ),
                              )
                            : const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://avatar.iran.liara.run/public/boy?username=Ash'),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              CustomSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
                },
                onClear: () {
                  _searchController.clear();
                  setState(() {}); // Refresh UI
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Total Bookings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              RecentBookingCard(),
              SizedBox(
                height: 12,
              ),
              RecentBookingCard(),
              SizedBox(
                height: 12,
              ),
              RecentBookingCard(),
              SizedBox(
                height: 20,
              ),
              const Text(
                'Booking Statitics',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Color(0XFF205BE9),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Completed'),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        color: Color(0XFFFE0B0B),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Completed'),
                ],
              ),
              Image.asset('assets/graph.png')
            ],
          ),
        ),
      ),
    );
  }
}
