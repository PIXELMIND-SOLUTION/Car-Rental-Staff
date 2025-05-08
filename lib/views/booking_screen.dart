import 'package:car_rental_staff_app/views/pickup_details_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Make sure to add this to your pubspec.yaml:
// assets:
//   - assets/adhar.png

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const BookingScreen(),
    );
  }
}

class BookingScreen extends StatelessWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header - Fixed part
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  Text(
                    "id: #1234",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 0, 0),
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Car details card
                      Card(
                        elevation: 1,
                        color: const Color(0XFFFFFFFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'TS 05 TD 4544',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Hyundai Verna',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Automatic & Seaters Row
                              Row(
                                children: [
                                  const Icon(Icons.settings, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Automatic',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    children: const [
                                      Icon(Icons.airline_seat_recline_normal, size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        '5 Seaters',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Date & Time Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Text(
                                    '23-03-2025',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Icon(Icons.access_time, size: 16, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Text(
                                    '11:00 AM',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Uploaded Documents Section
                      const Text(
                        'Uploaded Documents',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Document cards
                      _buildDocumentCard(
                        title: 'Aadhar Card',
                        status: 'Verified',
                        statusColor: Colors.green,
                      ),

                      const SizedBox(height: 25),

                      _buildDocumentCard(
                        title: 'Aadhar card',
                        status: 'Pending',
                        statusColor: Colors.red,
                      ),

                      const SizedBox(height: 25),

                      _buildDocumentCard(
                        title: 'Aadhar card',
                        status: 'Pending',
                        statusColor: Colors.red,
                      ),
                      
                      // Extra space at the bottom for the button
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PickupDetailsScreen(id: "1234")));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Proceed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      width: double.infinity,
      height: 206,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/adhar.png'), // your background image
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blue,
                    Colors.white70,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Text Row at bottom
          Positioned(
            bottom: 6,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}