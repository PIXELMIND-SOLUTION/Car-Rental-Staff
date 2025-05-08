import 'package:car_rental_staff_app/views/car_details.dart';
import 'package:flutter/material.dart';

class PickupDetailsScreen extends StatefulWidget {
  final String id;

  const PickupDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  State<PickupDetailsScreen> createState() => _PickupDetailsScreenState();
}

class _PickupDetailsScreenState extends State<PickupDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
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
              const SizedBox(height: 10),
              const Text(
                'Pickup Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

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
                icon: Icons.phone_outlined,
                label: 'Email',
              ),

              // Pickup time and date
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      icon: Icons.phone_outlined,
                      label: 'Pickup time',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildInputField(
                      icon: Icons.phone_outlined,
                      label: 'Pickup date',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Security deposit section
              const Text(
                'Security deposit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),

              // Bike selection
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bike',
                      style: TextStyle(
                        color: Color.fromARGB(255, 18, 11, 213),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Scan/Upload container
              Container(
                width: double.infinity,
                height: 150,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B3D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.camera_alt,
                        title: 'Scan',
                        subtitle: 'Bike Front & Back',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildImageOption(
                        icon: Icons.file_upload_outlined,
                        title: 'Upload',
                        subtitle: 'Bike Front & Back',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ID cards
              _buildDocumentCard(
                title: 'Aadhar Card',
              ),

              const SizedBox(height: 25),

              _buildDocumentCard(
                title: 'Aadhar card',
              ),

              SizedBox(
                height: 25,
              ),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CarDetails()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF120698),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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

  Widget _buildImageOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 65,
              height: 57,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon,
                  color: const Color.fromARGB(255, 0, 0, 0), size: 36)),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
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
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
