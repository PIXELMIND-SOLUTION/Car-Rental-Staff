import 'package:car_rental_staff_app/views/booking_detail_screen.dart';
import 'package:car_rental_staff_app/views/pickup_details_screen.dart';
import 'package:car_rental_staff_app/widgect/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Model classes remain unchanged
class Car {
  final String id;
  final String name;
  final String type;
  final int seats;
  final String image;
  final double pricePerDay;

  Car({
    required this.id,
    required this.name,
    required this.type,
    required this.seats,
    required this.image,
    required this.pricePerDay,
  });
}

class Booking {
  final String id;
  final String userId;
  final Car car;
  final DateTime rentalStartDate;
  final DateTime rentalEndDate;
  final double totalPrice;
  final String otp;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.car,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.totalPrice,
    required this.otp,
    required this.status,
  });

  bool get isPickup => status == "pickup";
  bool get isReturn => status == "return";
}

class AllBookingsScreen extends StatefulWidget {
  const AllBookingsScreen({super.key});

  @override
  State<AllBookingsScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {
  // Static data for bookings
  late List<Booking> allBookings;
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        allBookings = _createMockBookings();
        isLoading = false;
      });
    });
  }

  // Create mock data for bookings - unchanged
// Create mock data for bookings - with fixed status values
  List<Booking> _createMockBookings() {
    // Create a few car models
    final Car hondaCity = Car(
      id: 'car1',
      name: 'Honda City',
      type: 'automatic',
      seats: 5,
      image: 'assets/car.png',
      pricePerDay: 2500,
    );

    final Car toyotaInnova = Car(
      id: 'car2',
      name: 'Toyota Innova',
      type: 'manual',
      seats: 7,
      image: 'assets/car.png',
      pricePerDay: 3500,
    );

    final Car hyundaiVenue = Car(
      id: 'car3',
      name: 'Hyundai Venue',
      type: 'manual',
      seats: 5,
      image: 'assets/car.png',
      pricePerDay: 2000,
    );

    final Car marutiSwift = Car(
      id: 'car4',
      name: 'Maruti Swift',
      type: 'automatic',
      seats: 5,
      image: 'assets/car.png',
      pricePerDay: 1800,
    );

    // Create bookings with these cars
    return [
      // Active bookings
      Booking(
        id: 'book1001',
        userId: 'user123',
        car: hondaCity,
        rentalStartDate: DateTime.now().add(Duration(days: 1)),
        rentalEndDate: DateTime.now().add(Duration(days: 3)),
        totalPrice: 5000,
        otp: '1234',
        status: 'pickup', // Changed from 'isPickup' to 'pickup'
      ),
      Booking(
        id: 'book1002',
        userId: 'user123',
        car: toyotaInnova,
        rentalStartDate: DateTime.now().add(Duration(days: 5)),
        rentalEndDate: DateTime.now().add(Duration(days: 8)),
        totalPrice: 10500,
        otp: '5678',
        status: 'pickup', // Changed from 'isPickup' to 'pickup'
      ),

      // return bookings
      Booking(
        id: 'book1003',
        userId: 'user123',
        car: marutiSwift,
        rentalStartDate: DateTime.now().subtract(Duration(days: 10)),
        rentalEndDate: DateTime.now().subtract(Duration(days: 8)),
        totalPrice: 3600,
        otp: '9012',
        status: 'return', // Changed from 'isReturn' to 'return'
      ),
      Booking(
        id: 'book1004',
        userId: 'user123',
        car: hondaCity,
        rentalStartDate: DateTime.now().subtract(Duration(days: 20)),
        rentalEndDate: DateTime.now().subtract(Duration(days: 18)),
        totalPrice: 5000,
        otp: '3456',
        status: 'return', // Changed from 'isReturn' to 'return'
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final paddingValue = screenWidth * 0.04;

    return DefaultTabController(
      length: 2, // Fixed: Changed from 3 to 2 since there are only 2 tabs
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: screenHeight * 0.03),
              // Header with back button and title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingValue),
                child: Row(
                  children: [
                    Container(
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
                    SizedBox(width: screenWidth * 0.25),
                    Expanded(
                      child: Text(
                        "Bookings",
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
              ),
              SizedBox(height: screenHeight * 0.02),

              // TabBar for Pickup/Return tabs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingValue),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.04,
                          child: Center(
                            child: Text(
                              "Pickup",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.04,
                          child: Center(
                            child: Text(
                              "Return",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0XFF1808C5),
                    indicator: BoxDecoration(
                      color: const Color(0XFF1808C5),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                  ),
                ),
              ),

              // Search bar - now has consistent padding
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: paddingValue,
                  vertical: screenHeight * 0.02,
                ),
                child: CustomSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    print('Search value: $value');
                  },
                  onClear: () {
                    _searchController.clear();
                    setState(() {}); // Refresh UI
                  },
                ),
              ),

              // Date picker row - now has consistent padding
              Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingValue),
                child: Row(
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
                                    color:
                                        isToday ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  month,
                                  style: TextStyle(
                                    color:
                                        isToday ? Colors.white : Colors.black,
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
              ),

              SizedBox(height: screenHeight * 0.02),

              // TabBarView content
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          // Active bookings tab
                          _buildBookingList(
                            context,
                            allBookings
                                .where((booking) => booking.isPickup)
                                .toList(),
                            "No active bookings",
                            paddingValue,
                            screenWidth,
                            screenHeight,
                          ),

                          // return bookings tab
                          _buildBookingList(
                            context,
                            allBookings
                                .where((booking) => booking.isReturn)
                                .toList(),
                            "No return bookings",
                            paddingValue,
                            screenWidth,
                            screenHeight,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingList(
    BuildContext context,
    List<Booking> bookings,
    String emptyMessage,
    double paddingValue,
    double screenWidth,
    double screenHeight,
  ) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(paddingValue),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Column(
            children: [
              _buildBookingCard(
                context,
                booking: booking,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context, {
    required Booking booking,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>CarPickupDetailsScreen()));
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking.car.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Text(
                        booking.isReturn
                            ? "Completed"
                            : "ID: ${booking.id.substring(booking.id.length - 4)}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: screenWidth * 0.04,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  booking.car.type == 'automatic'
                                      ? "Automatic"
                                      : "Manual",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.012),
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: screenWidth * 0.04,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  "${booking.car.seats} Seaters",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              "Collect Date & time: ${_formatDate(booking.rentalStartDate)}, ${_formatTime(booking.rentalStartDate)}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.025,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              "Return Date & time: ${_formatDate(booking.rentalEndDate)}, ${_formatTime(booking.rentalEndDate)}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.025,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.32,
                        height: screenHeight * 0.08,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          image: booking.car.image.isNotEmpty
                              ? DecorationImage(
                                  image: AssetImage(booking.car.image),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: booking.car.image.isEmpty
                            ? Icon(
                                Icons.directions_car,
                                size: screenWidth * 0.12,
                                color: Colors.black54,
                              )
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: const Color(0XFF1808C5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.03),
                    bottomRight: Radius.circular(screenWidth * 0.03),
                  ),
                ),
                child: Text(
                  "₹${booking.totalPrice.toStringAsFixed(0)}/-",
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
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
