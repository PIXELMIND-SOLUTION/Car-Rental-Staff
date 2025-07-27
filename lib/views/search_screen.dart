




// import 'package:car_rental_staff_app/models/booking_model.dart';
// import 'package:car_rental_staff_app/providers/booking_provider.dart';
// import 'package:car_rental_staff_app/widgect/custom_search.dart';
// import 'package:car_rental_staff_app/widgect/recent_booking.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   List<Booking> _allBookings = [];
//   List<Booking> _filteredBookings = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       final provider = Provider.of<BookingProvider>(context, listen: false);
//       await provider.fetchTodayBookings();
//       _allBookings = provider.todayBookings;
//       _filteredBookings = _allBookings;
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//               screenWidth * 0.03, screenHeight * 0.015, screenWidth * 0.03, 0),
//           child: ListView(
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.arrow_back,
//                           color: Colors.black,
//                           size: screenWidth * 0.06,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.25),
//                   Expanded(
//                     child: Text(
//                       "Search",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: screenWidth * 0.045,
//                         fontWeight: FontWeight.w800,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               CustomSearchBar(
//                 controller: _searchController,
//                 onChanged: (value) {
//                   setState(() {
//                     _filteredBookings = _allBookings
//                         .where((booking) =>
//                             booking.car.carName
//                                 .toLowerCase()
//                                 .contains(value.toLowerCase()) ||
//                             booking.car.model
//                                 .toLowerCase()
//                                 .contains(value.toLowerCase()))
//                         .toList();
//                   });
//                 },
//                 onClear: () {
//                   _searchController.clear();
//                   setState(() {
//                     _filteredBookings = _allBookings;
//                   });
//                 },
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(5, (index) {
//                   DateTime today = DateTime.now();
//                   DateTime date = DateTime.now().add(Duration(days: index));

//                   String day = DateFormat('d').format(date);
//                   String month = DateFormat('MMM').format(date);

//                   bool isToday = date.day == today.day &&
//                       date.month == today.month &&
//                       date.year == today.year;

//                   if (index == 4) {
//                     return GestureDetector(
//                       onTap: () => _selectFromCalendar(isStartDate: true),
//                       child: Stack(
//                         alignment: Alignment.topCenter,
//                         children: [
//                           Positioned(
//                             top: 0,
//                             child: Container(
//                               height: 6,
//                               width: 50,
//                               decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(top: 4),
//                             height: 80,
//                             width: 55,
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.black12),
//                             ),
//                             child: const Icon(Icons.calendar_month_sharp),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   return GestureDetector(
//                     onTap: () {},
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       children: [
//                         Positioned(
//                           top: 0,
//                           child: Container(
//                             height: 6,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               color: isToday
//                                   ? const Color(0XFF120698)
//                                   : Colors.black,
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 4),
//                           height: 80,
//                           width: 60,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             color: isToday
//                                 ? const Color(0XFF120698)
//                                 : Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.black12),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 day,
//                                 style: TextStyle(
//                                   color: isToday ? Colors.white : Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 month,
//                                 style: TextStyle(
//                                   color: isToday ? Colors.white : Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 25),
//               const Text(
//                 'Total Bookings',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const SizedBox(height: 12),
//               if (_isLoading)
//                 const Center(child: CircularProgressIndicator())
//               else if (_filteredBookings.isEmpty)
//                 const Text('No bookings match your search.')
//               else
//                 Column(
//                   children: _filteredBookings
//                       .map((booking) => RecentBookingCard(booking: booking))
//                       .toList(),
//                 ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectFromCalendar({required bool isStartDate}) async {
//     final DateTime today = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: today,
//       firstDate: today,
//       lastDate: DateTime(today.year + 1),
//     );
//     // Optional: add calendar-based filtering here
//   }
// }





// import 'package:car_rental_staff_app/models/booking_model.dart';
// import 'package:car_rental_staff_app/providers/booking_provider.dart';
// import 'package:car_rental_staff_app/widgect/custom_search.dart';
// import 'package:car_rental_staff_app/widgect/recent_booking.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   List<Booking> _allBookings = [];
//   List<Booking> _filteredBookings = [];
//   bool _isLoading = true;
//   int _selectedDateIndex = 0; // Track selected date index (0 = today)

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       final provider = Provider.of<BookingProvider>(context, listen: false);
//       await provider.fetchTodayBookings();
//       _allBookings = provider.currentBookings; // Use currentBookings instead of todayBookings
//       _filteredBookings = _allBookings;
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(
//               screenWidth * 0.03, screenHeight * 0.015, screenWidth * 0.03, 0),
//           child: ListView(
//             children: [
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(5),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.arrow_back,
//                           color: Colors.black,
//                           size: screenWidth * 0.06,
//                         ),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: screenWidth * 0.25),
//                   Expanded(
//                     child: Text(
//                       "Search",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: screenWidth * 0.045,
//                         fontWeight: FontWeight.w800,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
              
//               // Search bar with clear filter option
//               Row(
//                 children: [
//                   Expanded(
//                     child: CustomSearchBar(
//                       controller: _searchController,
//                       onChanged: (value) {
//                         setState(() {
//                           _filteredBookings = _allBookings
//                               .where((booking) =>
//                                   booking.car.carName
//                                       .toLowerCase()
//                                       .contains(value.toLowerCase()) ||
//                                   booking.car.model
//                                       .toLowerCase()
//                                       .contains(value.toLowerCase()))
//                               .toList();
//                         });
//                       },
//                       onClear: () {
//                         _searchController.clear();
//                         setState(() {
//                           _filteredBookings = _allBookings;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Clear Filter Button
//                   Consumer<BookingProvider>(
//                     builder: (context, provider, child) {
//                       if (provider.isDateFiltered) {
//                         return ElevatedButton.icon(
//                           onPressed: () async {
//                             provider.clearDateFilter();
//                             setState(() {
//                               _selectedDateIndex = 0; // Reset to today
//                               _allBookings = provider.currentBookings;
//                               _filteredBookings = _allBookings;
//                             });
//                           },
//                           icon: const Icon(Icons.clear, size: 16),
//                           label: const Text('Clear'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red.shade100,
//                             foregroundColor: Colors.red.shade700,
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                             textStyle: const TextStyle(fontSize: 12),
//                           ),
//                         );
//                       }
//                       return const SizedBox.shrink();
//                     },
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 24),
              
//               // Date selection row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(5, (index) {
//                   DateTime today = DateTime.now();
//                   DateTime date = DateTime.now().add(Duration(days: index));

//                   String day = DateFormat('d').format(date);
//                   String month = DateFormat('MMM').format(date);

//                   bool isToday = date.day == today.day &&
//                       date.month == today.month &&
//                       date.year == today.year;

//                   bool isSelected = _selectedDateIndex == index;

//                   if (index == 4) {
//                     return GestureDetector(
//                       onTap: () => _selectFromCalendar(),
//                       child: Stack(
//                         alignment: Alignment.topCenter,
//                         children: [
//                           Positioned(
//                             top: 0,
//                             child: Container(
//                               height: 6,
//                               width: 50,
//                               decoration: BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             margin: const EdgeInsets.only(top: 4),
//                             height: 80,
//                             width: 55,
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: Colors.black12),
//                             ),
//                             child: const Icon(Icons.calendar_month_sharp),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   return GestureDetector(
//                     onTap: () async {
//                       setState(() {
//                         _selectedDateIndex = index;
//                         _isLoading = true;
//                       });

//                       final provider = Provider.of<BookingProvider>(context, listen: false);
                      
//                       if (index == 0) {
//                         // Today - fetch today's bookings
//                         await provider.fetchTodayBookings();
//                       } else {
//                         // Other dates - fetch by specific date
//                         await provider.fetchBookingsByDate(date);
//                       }

//                       setState(() {
//                         _allBookings = provider.currentBookings;
//                         _filteredBookings = _allBookings;
//                         _isLoading = false;
//                       });
//                     },
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       children: [
//                         Positioned(
//                           top: 0,
//                           child: Container(
//                             height: 6,
//                             width: 50,
//                             decoration: BoxDecoration(
//                               color: isSelected
//                                   ? const Color(0XFF120698)
//                                   : (isToday ? const Color(0XFF120698) : Colors.black),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(top: 4),
//                           height: 80,
//                           width: 60,
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? const Color(0XFF120698)
//                                 : (isToday ? const Color(0XFF120698) : Colors.white),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.black12),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 day,
//                                 style: TextStyle(
//                                   color: (isSelected || isToday) ? Colors.white : Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 month,
//                                 style: TextStyle(
//                                   color: (isSelected || isToday) ? Colors.white : Colors.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//               ),
              
//               const SizedBox(height: 25),
              
//               // Show selected date info
//               Consumer<BookingProvider>(
//                 builder: (context, provider, child) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         provider.isDateFiltered 
//                             ? 'Bookings for ${DateFormat('MMM dd, yyyy').format(provider.selectedDate!)}'
//                             : 'Today\'s Bookings',
//                         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                       Text(
//                         '${_filteredBookings.length} bookings',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
              
//               const SizedBox(height: 12),
              
//               // Bookings list
//               if (_isLoading)
//                 const Center(child: CircularProgressIndicator())
//               else if (_filteredBookings.isEmpty)
//                 Center(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 40),
//                       Icon(
//                         Icons.search_off,
//                         size: 64,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         _searchController.text.isNotEmpty 
//                             ? 'No bookings match your search.'
//                             : 'No bookings found for this date.',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               else
//                 Column(
//                   children: _filteredBookings
//                       .map((booking) => RecentBookingCard(booking: booking))
//                       .toList(),
//                 ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _selectFromCalendar() async {
//     final DateTime today = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: today,
//       firstDate: DateTime(today.year - 1),
//       lastDate: DateTime(today.year + 1),
//     );
    
//     if (picked != null) {
//       setState(() {
//         _selectedDateIndex = -1; // Indicate custom date selected
//         _isLoading = true;
//       });

//       final provider = Provider.of<BookingProvider>(context, listen: false);
//       await provider.fetchBookingsByDate(picked);

//       setState(() {
//         _allBookings = provider.currentBookings;
//         _filteredBookings = _allBookings;
//         _isLoading = false;
//       });
//     }
//   }
// }




import 'package:car_rental_staff_app/models/booking_model.dart';
import 'package:car_rental_staff_app/providers/booking_provider.dart';
import 'package:car_rental_staff_app/widgect/custom_search.dart';
import 'package:car_rental_staff_app/widgect/recent_booking.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Booking> _allBookings = [];
  List<Booking> _filteredBookings = [];
  bool _isLoading = true;
  int _selectedDateIndex = 0; // Track selected date index (0 = today)

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      await provider.fetchTodayBookings();
      _allBookings = provider.currentBookings; // Use currentBookings instead of todayBookings
      _filteredBookings = _allBookings;
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Helper method to filter bookings with null safety
  void _filterBookings(String searchValue) {
    setState(() {
      _filteredBookings = _allBookings.where((booking) {
        // Only search in bookings that have car data
        if (booking.car == null) return false;
        
        final carName = booking.car!.carName.toLowerCase();
        final carModel = booking.car!.model.toLowerCase();
        final searchTerm = searchValue.toLowerCase();
        
        return carName.contains(searchTerm) || carModel.contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                    padding: const EdgeInsets.all(5),
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
                    child: Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Search bar with clear filter option
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _searchController,
                      onChanged: (value) {
                        _filterBookings(value);
                      },
                      onClear: () {
                        _searchController.clear();
                        setState(() {
                          _filteredBookings = _allBookings;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Clear Filter Button
                  Consumer<BookingProvider>(
                    builder: (context, provider, child) {
                      if (provider.isDateFiltered) {
                        return ElevatedButton.icon(
                          onPressed: () async {
                            provider.clearDateFilter();
                            setState(() {
                              _selectedDateIndex = 0; // Reset to today
                              _allBookings = provider.currentBookings;
                              _filteredBookings = _allBookings;
                            });
                          },
                          icon: const Icon(Icons.clear, size: 16),
                          label: const Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade100,
                            foregroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Date selection row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  DateTime today = DateTime.now();
                  DateTime date = DateTime.now().add(Duration(days: index));

                  String day = DateFormat('d').format(date);
                  String month = DateFormat('MMM').format(date);

                  bool isToday = date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;

                  bool isSelected = _selectedDateIndex == index;

                  if (index == 4) {
                    return GestureDetector(
                      onTap: () => _selectFromCalendar(),
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
                    onTap: () async {
                      setState(() {
                        _selectedDateIndex = index;
                        _isLoading = true;
                      });

                      final provider = Provider.of<BookingProvider>(context, listen: false);
                      
                      if (index == 0) {
                        // Today - fetch today's bookings
                        await provider.fetchTodayBookings();
                      } else {
                        // Other dates - fetch by specific date
                        await provider.fetchBookingsByDate(date);
                      }

                      setState(() {
                        _allBookings = provider.currentBookings;
                        // Filter out bookings with null car data
                        _filteredBookings = _allBookings.where((booking) => booking.car != null).toList();
                        _isLoading = false;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 6,
                            width: 50,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0XFF120698)
                                  : (isToday ? const Color(0XFF120698) : Colors.black),
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
                            color: isSelected
                                ? const Color(0XFF120698)
                                : (isToday ? const Color(0XFF120698) : Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                day,
                                style: TextStyle(
                                  color: (isSelected || isToday) ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                month,
                                style: TextStyle(
                                  color: (isSelected || isToday) ? Colors.white : Colors.black,
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
              
              const SizedBox(height: 25),
              
              // Show selected date info
              Consumer<BookingProvider>(
                builder: (context, provider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.isDateFiltered 
                            ? 'Bookings for ${DateFormat('MMM dd, yyyy').format(provider.selectedDate!)}'
                            : 'Today\'s Bookings',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        '${_filteredBookings.length} bookings',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              // Bookings list
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_filteredBookings.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isNotEmpty 
                            ? 'No bookings match your search.'
                            : 'No bookings found for this date.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: _filteredBookings
                      .where((booking) => booking.car != null) // Additional safety check
                      .map((booking) => RecentBookingCard(booking: booking))
                      .toList(),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectFromCalendar() async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 1),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateIndex = -1; // Indicate custom date selected
        _isLoading = true;
      });

      final provider = Provider.of<BookingProvider>(context, listen: false);
      await provider.fetchBookingsByDate(picked);

      setState(() {
        _allBookings = provider.currentBookings;
        // Filter out bookings with null car data
        _filteredBookings = _allBookings.where((booking) => booking.car != null).toList();
        _isLoading = false;
      });
    }
  }
}