import 'package:car_rental_staff_app/views/return_upload_screen.dart';
import 'package:flutter/material.dart';

class CarPickupDetailsScreen extends StatefulWidget {
  const CarPickupDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CarPickupDetailsScreen> createState() => _CarPickupDetailsScreenState();
}

class _CarPickupDetailsScreenState extends State<CarPickupDetailsScreen> {
  bool isPickupExpanded = true;
  bool isReturnExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
              SizedBox(
                height: 30,
              ),
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
                          const Icon(Icons.settings,
                              size: 16, color: Colors.grey),
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
                              Icon(Icons.airline_seat_recline_normal,
                                  size: 16, color: Colors.grey),
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
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.blue),
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

              SizedBox(
                height: 30,
              ),

              // Pickup Section (Collapsible)
              _buildCollapsibleSection(
                title: 'Pickup details',
                isExpanded: isPickupExpanded,
                onTap: () {
                  setState(() {
                    isPickupExpanded = !isPickupExpanded;
                  });
                },
                child: isPickupExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Pickup Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          // Name field
                          _buildInputField(
                            icon: Icons.person_outline,
                            label: 'Name',
                          ),

                          // Mobile Number field
                          _buildInputField(
                            icon: Icons.phone_outlined,
                            label: 'Mobile Number',
                          ),

                          // Alternate Mobile Number field
                          _buildInputField(
                            icon: Icons.phone_outlined,
                            label: 'Alternate Mobile Number',
                          ),

                          // Email field
                          _buildInputField(
                            icon: Icons.email_outlined,
                            label: 'Email',
                          ),

                          // Pickup time and date
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  icon: Icons.access_time_outlined,
                                  label: 'Pickup time',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildInputField(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Pickup date',
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 20, thickness: 1),
                          _buildSecurityDepositSection(),
                        ],
                      )
                    : SizedBox(),
              ),

              SizedBox(
                height: 30,
              ),

              // Return Section (Collapsible)
              _buildCollapsibleSection(
                title: 'Return Details',
                isExpanded: isReturnExpanded,
                onTap: () {
                  setState(() {
                    isReturnExpanded = !isReturnExpanded;
                  });
                },
                child: isReturnExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25,
                          ),

                          Text(
                            'Return Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          // Name field
                          _buildInputField(
                            icon: Icons.person_outline,
                            label: 'Name',
                          ),

                          // Mobile Number field
                          _buildInputField(
                            icon: Icons.phone_outlined,
                            label: 'Mobile Number',
                          ),

                          // Alternate Mobile Number field
                          _buildInputField(
                            icon: Icons.phone_outlined,
                            label: 'Alternate Mobile Number',
                          ),

                          // Email field
                          _buildInputField(
                            icon: Icons.email_outlined,
                            label: 'Email',
                          ),

                          // Return time and date
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  icon: Icons.access_time_outlined,
                                  label: 'Return time',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildInputField(
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Return date',
                                ),
                              ),
                            ],
                          ),

                          // Delay information
                          Row(
                            children: [
                              Expanded(
                                child: _buildInputField(
                                  icon: Icons.timelapse_outlined,
                                  label: 'Delay time',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildInputField(
                                  icon: Icons.date_range_outlined,
                                  label: 'Date date',
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : SizedBox(),
              ),

              const SizedBox(height: 20),
              _buildBottomButtons(),
              SizedBox(
                height: 130,
              ),
              _buildButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
  }) {
    return Container(
      height: 206,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/adhar.png'),
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
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 2), // subtle downward shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: const Color.fromARGB(255, 162, 162, 162))),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityDepositSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security Deposit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(
              4,
              (index) => _buildDocumentCard(
                title: 'Aadhar card',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E0AFE), // #FF1206
              Color(0xFF120698), // #981206
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '₹ 500/- Paid to continue',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.file_upload_outlined,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E0AFE), // #FF1206
              Color(0xFF120698), // #981206
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnUploadScreen(id: "1234")));
              },
              child: Text(
                'Proceed',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
