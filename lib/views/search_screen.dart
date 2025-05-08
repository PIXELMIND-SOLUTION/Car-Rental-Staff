import 'package:car_rental_staff_app/widgect/custom_search.dart';
import 'package:car_rental_staff_app/widgect/recent_booking.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: screenWidth * 0.06,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.25),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              CustomSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  print('Search value: $value');
                },
                onClear: () {
                  _searchController.clear();
                  setState(() {}); // Refresh UI
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  DateTime today = DateTime.now();
                  DateTime date = DateTime.now().add(Duration(days: index));

                  String day = DateFormat('d').format(date);
                  String month = DateFormat('MMM').format(date);

                  // Check if this card's date is today
                  bool isToday = date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;

                  // Calendar icon
                  if (index == 4) {
                    return GestureDetector(
                      onTap: () => _selectFromCalendar(isStartDate: true),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 0,
                            child: Container(
                              height: 6,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 80,
                            width: 55,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Icon(Icons.calendar_month_sharp),
                          ),
                        ],
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 6,
                            width: 50,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? const Color(0XFF120698)
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 80,
                          width: 60,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isToday
                                ? const Color(0XFF120698)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                day,
                                style: TextStyle(
                                  color: isToday ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                month,
                                style: TextStyle(
                                  color: isToday ? Colors.white : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 25,
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectFromCalendar({required bool isStartDate}) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );
  }
}
