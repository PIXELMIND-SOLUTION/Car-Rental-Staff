// // import 'package:car_rental_staff_app/views/search_screen.dart';
// // import 'package:car_rental_staff_app/widgect/custom_search.dart';
// // import 'package:car_rental_staff_app/widgect/recent_booking.dart';
// // import 'package:flutter/material.dart';

// // import 'package:flutter/widgets.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   final TextEditingController _searchController = TextEditingController();

// //   String? userId;
// //   String? _localImageUrl;
// //   String _address = 'Fetching location...';

// //   @override
// //   void initState() {
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final screenHeight = MediaQuery.of(context).size.height;

// //     // Determine if device is in landscape mode
// //     final isLandscape =
// //         MediaQuery.of(context).orientation == Orientation.landscape;

// //     // Scale factors for responsive sizing
// //     final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: Padding(
// //           padding: EdgeInsets.fromLTRB(
// //               screenWidth * 0.03, screenHeight * 0.015, screenWidth * 0.03, 0),
// //           child: ListView(
// //             children: [
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       const Icon(
// //                         Icons.location_on_outlined,
// //                         size: 24,
// //                         color: Color(0XFF120698),
// //                       ),
// //                       SizedBox(width: screenWidth * 0.01),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('Your Location',
// //                               style: TextStyle(fontSize: 12 * textScaleFactor)),
// //                           Text(
// //                             _address,
// //                             style: TextStyle(fontSize: 12 * textScaleFactor),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                   Row(
// //                     children: [
// //                       SizedBox(width: screenWidth * 0.03),
// //                       Container(
// //                         width: screenWidth * 0.15,
// //                         height: screenHeight * 0.06,
// //                         padding: const EdgeInsets.all(4),
// //                         decoration: const BoxDecoration(
// //                           color: Color(0XFF120698),
// //                           borderRadius: BorderRadius.only(
// //                             bottomLeft: Radius.circular(30),
// //                             topLeft: Radius.circular(30),
// //                           ),
// //                         ),
// //                         child: _localImageUrl != null
// //                             ? ClipOval(
// //                                 child: Image.network(
// //                                   _localImageUrl!,
// //                                   width: 50, // Set width/height as needed
// //                                   height: 50,
// //                                   fit: BoxFit
// //                                       .fill, // Change to BoxFit.contain if needed
// //                                 ),
// //                               )
// //                             : const CircleAvatar(
// //                                 backgroundImage: NetworkImage(
// //                                     'https://avatar.iran.liara.run/public/boy?username=Ash'),
// //                               ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(
// //                 height: 24,
// //               ),
// //               CustomSearchBar(
// //                 controller: _searchController,
// //                 onChanged: (value) {
// //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
// //                 },
// //                 onClear: () {
// //                   _searchController.clear();
// //                   setState(() {}); // Refresh UI
// //                 },
// //               ),
// //               const SizedBox(height: 24),
// //               const Text(
// //                 'Total Bookings',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //               ),
// //               const SizedBox(height: 12),
// //               RecentBookingCard(),
// //               SizedBox(
// //                 height: 20,
// //               ),
// //               const Text(
// //                 'Booking Statitics',
// //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //               ),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.end,
// //                 children: [
// //                   Container(
// //                     width: 15,
// //                     height: 15,
// //                     decoration: BoxDecoration(
// //                         color: Color(0XFF205BE9),
// //                         borderRadius: BorderRadius.circular(10)),
// //                   ),
// //                   SizedBox(
// //                     width: 15,
// //                   ),
// //                   Text('Completed'),
// //                   SizedBox(
// //                     width: 15,
// //                   ),
// //                   Container(
// //                     width: 15,
// //                     height: 15,
// //                     decoration: BoxDecoration(
// //                         color: Color(0XFFFE0B0B),
// //                         borderRadius: BorderRadius.circular(10)),
// //                   ),
// //                   SizedBox(
// //                     width: 15,
// //                   ),
// //                   Text('Completed'),
// //                 ],
// //               ),
// //               Image.asset('assets/graph.png')
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }




// // home_screen.dart
// import 'package:car_rental_staff_app/views/search_screen.dart';
// import 'package:car_rental_staff_app/widgect/custom_search.dart';
// import 'package:car_rental_staff_app/widgect/recent_booking.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:car_rental_staff_app/providers/booking_provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String? _localImageUrl;
//   String _address = 'Fetching location...';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<BookingProvider>().fetchTodayBookings();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Consumer<BookingProvider>(
//             builder: (context, bookingProvider, child) {
//               return RefreshIndicator(
//                 onRefresh: () => bookingProvider.fetchTodayBookings(),
//                 child: ListView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   children: [
//                     _buildLocationHeader(),
//                     const SizedBox(height: 24),
//                     _buildSearchBar(),
//                     const SizedBox(height: 24),
//                     _buildBookingsSection(bookingProvider),
//                     const SizedBox(height: 24),
//                     _buildStatisticsSection(),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.location_on_outlined, color: Color(0XFF120698)),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Your Location',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   _address,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Container(
//           width: 50,
//           height: 50,
//           decoration: const BoxDecoration(
//             color: Color(0XFF120698),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30),
//               bottomLeft: Radius.circular(30),
//             ),
//           ),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(30),
//               bottomLeft: Radius.circular(30),
//             ),
//             child: _localImageUrl != null
//                 ? Image.network(
//                     _localImageUrl!,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         _buildDefaultAvatar(),
//                   )
//                 : _buildDefaultAvatar(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDefaultAvatar() {
//     return const CircleAvatar(
//       backgroundImage: NetworkImage(
//         'https://avatar.iran.liara.run/public/boy?username=Ash',
//       ),
//       radius: 25,
//     );
//   }

//   Widget _buildSearchBar() {
//     return CustomSearchBar(
//       controller: _searchController,
//       onChanged: (value) {
//         if (value.isNotEmpty) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const SearchScreen()),
//           );
//         }
//       },
//       onClear: () {
//         _searchController.clear();
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildBookingsSection(BookingProvider bookingProvider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Today\'s Bookings',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),

//           ],
//         ),
//         const SizedBox(height: 12),
//         if (bookingProvider.isLoading)
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.all(32.0),
//               child: CircularProgressIndicator(),
//             ),
//           )
//         else if (bookingProvider.todayBookings.isEmpty)
//           _buildEmptyState()
//         else
//           Column(
//             children: bookingProvider.todayBookings
//                 .map((booking) => Padding(
//                       padding: const EdgeInsets.only(bottom: 12),
//                       child: RecentBookingCard(booking: booking),
//                     ))
//                 .toList(),
//           ),
//       ],
//     );
//   }

//   Widget _buildErrorWidget(BookingProvider bookingProvider) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.red.shade200),
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 32),
//           const SizedBox(height: 8),
//           Text(
//             bookingProvider.errorMessage ?? 'Failed to load bookings',
//             textAlign: TextAlign.center,
//             style: const TextStyle(color: Colors.red),
//           ),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: () => bookingProvider.fetchTodayBookings(),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Container(
//       padding: const EdgeInsets.all(32),
//       child: Column(
//         children: [
//           Icon(
//             Icons.event_busy,
//             size: 64,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No bookings for today',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Check back later or refresh to see new bookings',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatisticsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Booking Statistics',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             _buildLegendItem(
//               color: const Color(0XFF205BE9),
//               label: 'Completed',
//             ),
//             const SizedBox(width: 16),
//             _buildLegendItem(
//               color: const Color(0XFFFE0B0B),
//               label: 'Pending',
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Image.asset(
//             'assets/graph.png',
//             errorBuilder: (context, error, stackTrace) => Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Center(
//                 child: Text('Chart not available'),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLegendItem({required Color color, required String label}) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12),
//         ),
//       ],
//     );
//   }
// }




// Updated home_screen.dart
import 'package:car_rental_staff_app/views/search_screen.dart';
import 'package:car_rental_staff_app/widgect/booking_statitics.dart';
import 'package:car_rental_staff_app/widgect/custom_search.dart';
import 'package:car_rental_staff_app/widgect/recent_booking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental_staff_app/providers/booking_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _localImageUrl;
  String _address = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<BookingProvider>();
      // Fetch both today's bookings and statistics
      provider.refreshAllData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<BookingProvider>(
            builder: (context, bookingProvider, child) {
              return RefreshIndicator(
                onRefresh: () => bookingProvider.refreshAllData(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    _buildLocationHeader(),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildBookingsSection(bookingProvider),
                    const SizedBox(height: 24),
                    _buildStatisticsSection(bookingProvider),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Color(0XFF120698)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Location',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  _address,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0XFF120698),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            child: _localImageUrl != null
                ? Image.network(
                    _localImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultAvatar(),
                  )
                : _buildDefaultAvatar(),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return const CircleAvatar(
      backgroundImage: NetworkImage(
        'https://avatar.iran.liara.run/public/boy?username=Ash',
      ),
      radius: 25,
    );
  }

  Widget _buildSearchBar() {
    return CustomSearchBar(
      controller: _searchController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchScreen()),
          );
        }
      },
      onClear: () {
        _searchController.clear();
        setState(() {});
      },
    );
  }

  Widget _buildBookingsSection(BookingProvider bookingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Bookings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (bookingProvider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (bookingProvider.errorMessage != null)
          _buildErrorWidget(bookingProvider)
        else if (bookingProvider.todayBookings.isEmpty)
          _buildEmptyState()
        else
          Column(
            children: bookingProvider.todayBookings
                .map((booking) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RecentBookingCard(booking: booking),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildErrorWidget(BookingProvider bookingProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            bookingProvider.errorMessage ?? 'Failed to load bookings',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => bookingProvider.fetchTodayBookings(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No bookings for today',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later or refresh to see new bookings',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BookingProvider bookingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Statistics',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     _buildLegendItem(
        //       color: const Color(0xFF205BE9),
        //       label: 'Completed',
        //     ),
        //     const SizedBox(width: 16),
        //     _buildLegendItem(
        //       color: const Color(0XFFFE0B0B),
        //       label: 'Failed', // Updated to match API response
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 12),
        // Replace the static image with the dynamic chart
        BookingStatisticsGraphicChart(
          statistics: bookingProvider.bookingStatistics,
          isLoading: bookingProvider.isStatisticsLoading,
          errorMessage: bookingProvider.statisticsErrorMessage,
          onRetry: () => bookingProvider.fetchBookingStatistics(),
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}