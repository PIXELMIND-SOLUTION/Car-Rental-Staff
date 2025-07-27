import 'package:car_rental_staff_app/providers/home_booking_provider.dart';
import 'package:car_rental_staff_app/services/location/location_service.dart';
import 'package:car_rental_staff_app/utils/storage_helper.dart';
import 'package:car_rental_staff_app/views/profile_screen.dart';
import 'package:car_rental_staff_app/views/search_screen.dart';
import 'package:car_rental_staff_app/widgect/animated_hedder.dart';
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
  String? profileImage = "";

  @override
  void initState() {
    super.initState();
    _fetchAddress();
    _loadProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeBookingProvider>();
      // Fetch both today's bookings and statistics
      provider.refreshAllData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProfile() async {
    profileImage = await StorageHelper.getProfileImage();
    print("ppppppppppppppppppppppppppppppppppppppppppp$profileImage");
  }

  void _fetchAddress() async {
    // final address = await LocationService.getCurrentAddress();
    final address = "Fetching Location";
    setState(() {
      _address = address ?? 'Unable to fetch address';
      List<String> parts = _address.split(',');

      // If there's more than one part, remove the first one
      String trimmedAddress =
          parts.length > 1 ? parts.sublist(1).join(',').trim() : _address;
      _address = trimmedAddress;
    });
  }

  String _formatAddressWithEllipsis(String address) {
    if (address.isEmpty) return '';

    List<String> parts = address.split(',');
    if (parts.length <= 1) return address; // Return as is if no commas

    // Return first segment followed by ellipsis
    return '${parts[0]}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<HomeBookingProvider>(
          builder: (context, bookingProvider, child) {
            return RefreshIndicator(
              onRefresh: () => bookingProvider.refreshAllData(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 5),
                  // _buildLocationHeader(),
                  AnimatedLocationHeader(localImageUrl: _localImageUrl, profileImage: profileImage),
                  const SizedBox(height: 5),
                  _buildSearchBar(),
                  const SizedBox(height: 5),
                  _buildBookingsSection(bookingProvider),
                  const SizedBox(height: 24),
                  _buildStatisticsSection(bookingProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

//   Widget _buildLocationHeader() {
//   final screenWidth = MediaQuery.of(context).size.width;
//   final screenHeight = MediaQuery.of(context).size.height;

//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // LOGO + TEXT
//         Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: Image.asset(
//                 'assets/logoo.jpg',
//                 width: screenWidth * 0.22,
//                 height: screenWidth * 0.22,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(width: 12),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Varahi",
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.055,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF120698),
//                   ),
//                 ),
//                 Text(
//                   "Self Drive Cars",
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.035,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),

//         // PROFILE IMAGE

//                 Container(
//           width: screenWidth * 0.18,
//           height: screenHeight * 0.08,
//           padding: const EdgeInsets.all(2),
//           decoration: const BoxDecoration(
//             color: Color(0XFF120698),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               topLeft: Radius.circular(30),
//             ),
//           ),
//           child: Center(
//             child: profileImage == null
//                 ? GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ProfileScreen()));
//                     },
//                     child: CircleAvatar(
//                       radius: 30, // You can adjust the size
//                       backgroundImage: NetworkImage(_localImageUrl.toString()),
//                     ),
//                   )
//                 : CircleAvatar(
//                     radius: 25,
//                     backgroundImage: NetworkImage((profileImage).toString()),
//                   ),
//           ),
//         ),
//       ],
//     ),
//   );
// }


//   Widget _buildLocationHeader() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Padding(
//         //   padding: const EdgeInsets.all(16.0),
//         //   child: Row(
//         //     children: [
//         //        Icon(Icons.location_on_outlined, color: Color(0XFF120698),size: 35,),
//         //       const SizedBox(width: 8),
//         //       Column(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           const Text(
//         //             'Your Location',
//         //             style: TextStyle(fontSize: 12, color: Colors.grey),
//         //           ),
//         //           const SizedBox(height: 2),
//         //           Text(
//         //             _formatAddressWithEllipsis(_address),
//         //             style: const TextStyle(
//         //               fontSize: 12,
//         //               fontWeight: FontWeight.w500,
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     ],
//         //   ),
//         // ),
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       ClipRRect(
//         borderRadius: BorderRadius.circular(100), // Rounded logo
//         child: Image.asset(
//           'assets/logoo.jpg',
//           fit: BoxFit.cover,
//           width: screenWidth * 0.09,
//           height: screenWidth * 0.09, // Match width for perfect circle
//         ),
//       ),
//       SizedBox(height: 2), // Spacing between image and text
//       Text(
//         "Varahi",
//         style: TextStyle(
//           fontSize: screenWidth * 0.04,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF120698),
//         ),
//       ),
//     ],
//   ),
// ),


//         Container(
//           width: screenWidth * 0.18,
//           height: screenHeight * 0.06,
//           padding: const EdgeInsets.all(4),
//           decoration: const BoxDecoration(
//             color: Color(0XFF120698),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(30),
//               topLeft: Radius.circular(30),
//             ),
//           ),
//           child: Center(
//             child: profileImage == null
//                 ? GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ProfileScreen()));
//                     },
//                     child: CircleAvatar(
//                       radius: 30, // You can adjust the size
//                       backgroundImage: NetworkImage(_localImageUrl.toString()),
//                     ),
//                   )
//                 : CircleAvatar(
//                     radius: 25,
//                     backgroundImage: NetworkImage((profileImage).toString()),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

  // Widget _buildDefaultAvatar() {
  //   return const CircleAvatar(
  //     backgroundImage: NetworkImage(
  //       'https://avatar.iran.liara.run/public/boy?username=Ash',
  //     ),
  //     radius: 25,
  //   );
  // }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomSearchBar(
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
      ),
    );
  }

  Widget _buildBookingsSection(HomeBookingProvider bookingProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
      ),
    );
  }

  Widget _buildErrorWidget(HomeBookingProvider bookingProvider) {
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

  Widget _buildStatisticsSection(HomeBookingProvider bookingProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
      ),
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
