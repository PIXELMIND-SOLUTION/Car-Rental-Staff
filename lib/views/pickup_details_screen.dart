// import 'package:car_rental_staff_app/controllers/auth_controller.dart';
// import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
// import 'package:car_rental_staff_app/views/car_details.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// class PickupDetailsScreen extends StatefulWidget {
//   final String id;

//   const PickupDetailsScreen({
//     super.key,
//     required this.id,
//   });

//   @override
//   State<PickupDetailsScreen> createState() => _PickupDetailsScreenState();
// }

// class _PickupDetailsScreenState extends State<PickupDetailsScreen> {
//   // Text controllers for the form fields
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _alternateMobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _pickupTimeController = TextEditingController();
//   final TextEditingController _pickupDateController = TextEditingController();

//   // Image variables
//   File? _frontImage;
//   File? _backImage;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploadingImages = false;

//   @override
//   void initState() {
//     super.initState();
//     // Call fetchSingleBooking after the widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context
//           .read<SingleBookingProvider>()
//           .fetchSingleBooking(widget.id);
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose controllers to prevent memory leaks
//     _nameController.dispose();
//     _mobileController.dispose();
//     _alternateMobileController.dispose();
//     _emailController.dispose();
//     _pickupTimeController.dispose();
//     _pickupDateController.dispose();
//     super.dispose();
//   }

//   void _populateFields(dynamic booking) {
//     if (booking != null) {
//       _nameController.text = booking['name'] ?? '';
//       _mobileController.text = booking['mobile'] ?? '';
//       _alternateMobileController.text = booking['alternateMobile'] ?? '';
//       _emailController.text = booking['email'] ?? '';
//       _pickupTimeController.text = booking['pickupTime'] ?? '';
//       _pickupDateController.text = booking['pickupDate'] ?? '';
//     }
//   }

//   // Show image source selection dialog
//   void _showImageSourceDialog(String imageType) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Image Source for $imageType'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera, imageType);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery, imageType);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Pick image from camera or gallery
//   Future<void> _pickImage(ImageSource source, String imageType) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           if (imageType == 'front') {
//             _frontImage = File(pickedFile.path);
//           } else {
//             _backImage = File(pickedFile.path);
//           }
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e')),
//       );
//     }
//   }

//   // Upload images to API
//   Future<bool> _uploadImages() async {
//     if (_frontImage == null || _backImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select both front and back images')),
//       );
//       return false;
//     }

//     setState(() {
//       _isUploadingImages = true;
//     });

//     try {
//       // Replace this URL with your actual API endpoint
//       final String apiUrl = 'http://194.164.148.244:4062/api/staff/uploaddeposite/${widget.id}';
      
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
//       // Add booking ID
//       request.fields['bookingId'] = widget.id;
      
//       // Add front image
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'depositeFront',
//           _frontImage!.path,
//         ),
//       );
      
//       // Add back image
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'depositeBack',
//           _backImage!.path,
//         ),
//       );

//       // Add any additional headers if needed
//       // request.headers['Authorization'] = 'Bearer YOUR_TOKEN';

//       var response = await request.send();
//       var responseBody = await response.stream.bytesToString();

//       print('kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${response.statusCode}');

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Images uploaded successfully!')),
//         );
//         return true;
//       } else {
//         throw Exception('Failed to upload images: ${response.statusCode}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading images: $e')),
//       );
//       return false;
//     } finally {
//       setState(() {
//         _isUploadingImages = false;
//       });
//     }
//   }

//   // Handle next button press
//   Future<void> _handleNextPress() async {
//     if (_frontImage != null && _backImage != null) {
//       bool uploadSuccess = await _uploadImages();
//       if (uploadSuccess) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CarDetails()),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload both front and back images before proceeding')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<SingleBookingProvider>(
//         builder: (context, bookingProvider, child) {
//           // Handle loading state
//           if (bookingProvider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           // Handle error state
//           if (bookingProvider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error: ${bookingProvider.error}',
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       bookingProvider.clearError();
//                       bookingProvider.fetchSingleBooking(widget.id);
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final booking = bookingProvider.currentBooking;
          
//           // Populate fields when booking data is available
//           if (booking != null) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _populateFields(booking);
//             });
//           }
      
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 50,),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.arrow_back,
//                               color: Colors.black,
//                               size: screenWidth * 0.06,
//                             ),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ),
//                         SizedBox(width: screenWidth * 0.25),
//                         Text(
//                           "ID: ${booking?.id.substring(booking.id.length - 4) ?? widget.id.substring(widget.id.length - 4)}",
//                           style: TextStyle(
//                             color: const Color.fromARGB(255, 255, 0, 0),
//                             fontSize: screenWidth * 0.045,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Pickup Details',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Name field
//                   _buildDisplayField(
//                     icon: Icons.person_outline,
//                     label: 'Name',
//                     value: booking?.car?.model ?? 'Not Available'
//                   ),

//                   // Mobile Number field
//                   _buildDisplayField(
//                     icon: Icons.phone_outlined,
//                     label: 'Mobile Number',
//                     value: booking?.userId!.mobile ?? 'Not Available'
//                   ),

//                   // Alternate Mobile Number field
//                   _buildDisplayField(
//                     icon: Icons.phone_outlined,
//                     label: 'Alternate Mobile Number',
//                     value: booking?.userId!.mobile ?? 'Not Available'
//                   ),

//                   // Email field
//                   _buildDisplayField(
//                     icon: Icons.email_outlined,
//                     label: 'Email',
//                     value: booking?.userId?.email ?? 'Not Available'
//                   ),

//                   // Pickup time and date
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDisplayField(
//                           icon: Icons.access_time_outlined,
//                           label: 'Pickup time',
//                           value: booking?.from ?? 'Not set',
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: _buildDisplayField(
//                           icon: Icons.calendar_today_outlined,
//                           label: 'Pickup date',
//                           value: booking?.rentalStartDate ?? 'Not set',
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Security deposit section
//                   const Text(
//                     'Security deposit',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Bike selection
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                          Text(
//                           '${booking?.deposit}',
//                           style: TextStyle(
//                             color: Color.fromARGB(255, 18, 11, 213),
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Scan/Upload container
//                   Container(
//                     width: double.infinity,
//                     height: 150,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1B1B3D),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildImageOption(
//                             icon: Icons.camera_alt,
//                             title: 'Scan',
//                             subtitle: 'Bike Front & Back',
//                             onTap: () => _showImageSourceDialog('front'),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: _buildImageOption(
//                             icon: Icons.file_upload_outlined,
//                             title: 'Upload',
//                             subtitle: 'Bike Front & Back',
//                             onTap: () => _showImageSourceDialog('back'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // ID cards - Front Image
//                   _buildDocumentCard(
//                     title: 'Front Side',
//                     image: _frontImage,
//                     onTap: () => _showImageSourceDialog('front'),
//                   ),

//                   const SizedBox(height: 25),

//                   // ID cards - Back Image
//                   _buildDocumentCard(
//                     title: 'Back Side',
//                     image: _backImage,
//                     onTap: () => _showImageSourceDialog('back'),
//                   ),

//                   SizedBox(
//                     height: 25,
//                   ),

//                   // Next button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isUploadingImages ? null : _handleNextPress,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF120698),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: _isUploadingImages
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                               'Next',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDisplayField({
//   required IconData icon,
//   required String label,
//   required String value,
// }) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 16),
//     decoration: BoxDecoration(
//       border: Border(
//         bottom: BorderSide(color: const Color.fromARGB(255, 162, 162, 162)),
//       ),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey.shade600, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

//   Widget _buildInputField({
//     required IconData icon,
//     required String label,
//     required TextEditingController controller,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         border: Border(
//             bottom:
//                 BorderSide(color: const Color.fromARGB(255, 162, 162, 162))),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey.shade600, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: label,
//                 hintStyle: TextStyle(color: Colors.grey.shade500),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//               width: 65,
//               height: 57,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(8)),
//               child: Icon(icon,
//                   color: const Color.fromARGB(255, 0, 0, 0), size: 36)),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentCard({
//     required String title,
//     File? image,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 206,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: image != null
//               ? DecorationImage(
//                   image: FileImage(image),
//                   fit: BoxFit.cover,
//                 )
//               : const DecorationImage(
//                   image: AssetImage('assets/adhar.png'),
//                   fit: BoxFit.cover,
//                 ),
//         ),
//         child: Stack(
//           children: [
//             // Gradient overlay at bottom
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               height: 60,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius:
//                       const BorderRadius.vertical(bottom: Radius.circular(12)),
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Camera icon overlay if no image is selected
//             if (image == null)
//               const Center(
//                 child: Icon(
//                   Icons.add_a_photo,
//                   color: Colors.white,
//                   size: 48,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }









// import 'package:car_rental_staff_app/controllers/auth_controller.dart';
// import 'package:car_rental_staff_app/models/single_booking_model.dart';
// import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
// import 'package:car_rental_staff_app/views/car_details.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// class PickupDetailsScreen extends StatefulWidget {
//   final String id;

//   const PickupDetailsScreen({
//     super.key,
//     required this.id,
//   });

//   @override
//   State<PickupDetailsScreen> createState() => _PickupDetailsScreenState();
// }

// class _PickupDetailsScreenState extends State<PickupDetailsScreen> {
//   // Text controllers for the form fields
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _alternateMobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _pickupTimeController = TextEditingController();
//   final TextEditingController _pickupDateController = TextEditingController();

//   // Image variables
//   File? _frontImage;
//   File? _backImage;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploadingFrontImage = false;
//   bool _isUploadingBackImage = false;

//   // Variables to track existing deposit proof
//   String? _existingFrontImageUrl;
//   String? _existingBackImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     // Call fetchSingleBooking after the widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context
//           .read<SingleBookingProvider>()
//           .fetchSingleBooking(widget.id);
//     });
//   }

//   @override
//   void dispose() {
//     // Dispose controllers to prevent memory leaks
//     _nameController.dispose();
//     _mobileController.dispose();
//     _alternateMobileController.dispose();
//     _emailController.dispose();
//     _pickupTimeController.dispose();
//     _pickupDateController.dispose();
//     super.dispose();
//   }

//   void _populateFields(dynamic booking) {
//     if (booking != null) {
//       _nameController.text = booking['name'] ?? '';
//       _mobileController.text = booking['mobile'] ?? '';
//       _alternateMobileController.text = booking['alternateMobile'] ?? '';
//       _emailController.text = booking['email'] ?? '';
//       _pickupTimeController.text = booking['pickupTime'] ?? '';
//       _pickupDateController.text = booking['pickupDate'] ?? '';
//     }
//   }

//   void _checkExistingDepositProof(Booking booking) {
//     print("ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg${booking.depositeProof[0].label}");
//     for (var depositProof in booking.depositeProof) {
//       if (depositProof.label == 'depositeFront') {
//         print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${depositProof.url}");
//         _existingFrontImageUrl = depositProof.url;
//       } else if (depositProof.label == 'depositeBack') {
//                 print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk${depositProof.url}");

//         _existingBackImageUrl = depositProof.url;
//       }
//     }
//     }

//   // Show image source selection dialog
//   void _showImageSourceDialog(String imageType) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Image Source for $imageType'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Camera'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera, imageType);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Gallery'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery, imageType);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Pick image from camera or gallery
//   Future<void> _pickImage(ImageSource source, String imageType) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: source,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         setState(() {
//           if (imageType == 'front') {
//             _frontImage = File(pickedFile.path);
//           } else {
//             _backImage = File(pickedFile.path);
//           }
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e')),
//       );
//     }
//   }

//   // Upload single image to API
//   Future<bool> _uploadSingleImage(String imageType) async {
//     File? imageFile = imageType == 'front' ? _frontImage : _backImage;
    
//     if (imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select ${imageType} image first')),
//       );
//       return false;
//     }

//     setState(() {
//       if (imageType == 'front') {
//         _isUploadingFrontImage = true;
//       } else {
//         _isUploadingBackImage = true;
//       }
//     });

//     try {
//       // Replace this URL with your actual API endpoint
//       final String apiUrl = 'http://194.164.148.244:4062/api/staff/uploaddeposite/${widget.id}';
      
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
//       // Add booking ID
//       request.fields['bookingId'] = widget.id;
      
//       // Add image with appropriate field name
//       String fieldName = imageType == 'front' ? 'depositeFront' : 'depositeBack';
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           fieldName,
//           imageFile.path,
//         ),
//       );

//       // Add any additional headers if needed
//       // request.headers['Authorization'] = 'Bearer YOUR_TOKEN';

//       var response = await request.send();
//       var responseBody = await response.stream.bytesToString();

//       print('Upload ${imageType} response: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${imageType.capitalize()} image uploaded successfully!')),
//         );
        
//         // Refresh booking data to get updated deposit proof
//         context.read<SingleBookingProvider>().fetchSingleBooking(widget.id);
        
//         return true;
//       } else {
//         throw Exception('Failed to upload ${imageType} image: ${response.statusCode}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading ${imageType} image: $e')),
//       );
//       return false;
//     } finally {
//       setState(() {
//         if (imageType == 'front') {
//           _isUploadingFrontImage = false;
//         } else {
//           _isUploadingBackImage = false;
//         }
//       });
//     }
//   }

//   // Handle next button press
//   Future<void> _handleNextPress() async {
//     // Check if both images are uploaded (either existing or newly uploaded)
//     bool hasFrontImage = _existingFrontImageUrl != null || _frontImage != null;
//     bool hasBackImage = _existingBackImageUrl != null || _backImage != null;
    
//     if (hasFrontImage && hasBackImage) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => CarDetails()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload both front and back images before proceeding')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<SingleBookingProvider>(
//         builder: (context, bookingProvider, child) {
//           // Handle loading state
//           if (bookingProvider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           // Handle error state
//           if (bookingProvider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error: ${bookingProvider.error}',
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       bookingProvider.clearError();
//                       bookingProvider.fetchSingleBooking(widget.id);
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final booking = bookingProvider.currentBooking;
          
//           // Populate fields and check existing deposit proof when booking data is available
//           if (booking != null) {
//                         print("Boooooooooooooking Nullllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");

//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               // _populateFields(booking);
//               _checkExistingDepositProof(booking);
//             });
//           }else{
//             print("Boooooooooooooking Nulllllllllllllll");
//           }
      
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 50,),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.arrow_back,
//                               color: Colors.black,
//                               size: screenWidth * 0.06,
//                             ),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ),
//                         SizedBox(width: screenWidth * 0.25),
//                         Text(
//                           "ID: ${booking?.id.substring(booking.id.length - 4) ?? widget.id.substring(widget.id.length - 4)}",
//                           style: TextStyle(
//                             color: const Color.fromARGB(255, 255, 0, 0),
//                             fontSize: screenWidth * 0.045,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Pickup Details',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Name field
//                   _buildDisplayField(
//                     icon: Icons.person_outline,
//                     label: 'Name',
//                     value: booking?.car?.model ?? 'Not Available'
//                   ),

//                   // Mobile Number field
//                   _buildDisplayField(
//                     icon: Icons.phone_outlined,
//                     label: 'Mobile Number',
//                     value: booking?.userId!.mobile ?? 'Not Available'
//                   ),

//                   // Alternate Mobile Number field
//                   _buildDisplayField(
//                     icon: Icons.phone_outlined,
//                     label: 'Alternate Mobile Number',
//                     value: booking?.userId!.mobile ?? 'Not Available'
//                   ),

//                   // Email field
//                   _buildDisplayField(
//                     icon: Icons.email_outlined,
//                     label: 'Email',
//                     value: booking?.userId?.email ?? 'Not Available'
//                   ),

//                   // Pickup time and date
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDisplayField(
//                           icon: Icons.access_time_outlined,
//                           label: 'Pickup time',
//                           value: booking?.from ?? 'Not set',
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: _buildDisplayField(
//                           icon: Icons.calendar_today_outlined,
//                           label: 'Pickup date',
//                           value: booking?.rentalStartDate ?? 'Not set',
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Security deposit section
//                   const Text(
//                     'Security deposit',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   // Bike selection
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                          Text(
//                           '${booking?.deposit}',
//                           style: TextStyle(
//                             color: Color.fromARGB(255, 18, 11, 213),
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Scan/Upload container
//                   Container(
//                     width: double.infinity,
//                     height: 150,
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1B1B3D),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildImageOption(
//                             icon: Icons.camera_alt,
//                             title: 'Scan',
//                             subtitle: 'Bike Front & Back',
//                             onTap: () => _showImageSourceDialog('front'),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: _buildImageOption(
//                             icon: Icons.file_upload_outlined,
//                             title: 'Upload',
//                             subtitle: 'Bike Front & Back',
//                             onTap: () => _showImageSourceDialog('back'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // ID cards - Front Image
//                   _buildDocumentCard(
//                     title: 'Front Side',
//                     image: _frontImage,
//                     existingImageUrl: _existingFrontImageUrl,
//                     onTap: () => _showImageSourceDialog('front'),
//                     onUpload: () => _uploadSingleImage('front'),
//                     isUploading: _isUploadingFrontImage,
//                   ),

//                   const SizedBox(height: 25),

//                   // ID cards - Back Image
//                   _buildDocumentCard(
//                     title: 'Back Side',
//                     image: _backImage,
//                     existingImageUrl: _existingBackImageUrl,
//                     onTap: () => _showImageSourceDialog('back'),
//                     onUpload: () => _uploadSingleImage('back'),
//                     isUploading: _isUploadingBackImage,
//                   ),

//                   SizedBox(
//                     height: 25,
//                   ),

//                   // Next button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _handleNextPress,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF120698),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         'Next',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDisplayField({
//   required IconData icon,
//   required String label,
//   required String value,
// }) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 16),
//     decoration: BoxDecoration(
//       border: Border(
//         bottom: BorderSide(color: const Color.fromARGB(255, 162, 162, 162)),
//       ),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey.shade600, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

//   Widget _buildInputField({
//     required IconData icon,
//     required String label,
//     required TextEditingController controller,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         border: Border(
//             bottom:
//                 BorderSide(color: const Color.fromARGB(255, 162, 162, 162))),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.grey.shade600, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: label,
//                 hintStyle: TextStyle(color: Colors.grey.shade500),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//               width: 65,
//               height: 57,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(8)),
//               child: Icon(icon,
//                   color: const Color.fromARGB(255, 0, 0, 0), size: 36)),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             subtitle,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDocumentCard({
//     required String title,
//     File? image,
//     String? existingImageUrl,
//     VoidCallback? onTap,
//     VoidCallback? onUpload,
//     bool isUploading = false,
//   }) {
//     // Determine which image to show - priority: new image > existing image > default
//     ImageProvider imageProvider;
//     bool hasImage = false;
    
//     if (image != null) {
//       imageProvider = FileImage(image);
//       hasImage = true;
//     } else if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
//       imageProvider = NetworkImage(existingImageUrl!);
//       hasImage = true;
//     } else {
//       imageProvider = const AssetImage('assets/adhar.png');
//       hasImage = false;
//     }

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 206,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: imageProvider,
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Gradient overlay at bottom
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               height: 60,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius:
//                       const BorderRadius.vertical(bottom: Radius.circular(12)),
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
            
//             // Upload icon - show when there's a selected image but not uploaded, or when replacing existing image
//             if ((image != null && onUpload != null) || (existingImageUrl == null && !hasImage))
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: GestureDetector(
//                   onTap: image != null ? onUpload : null,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: image != null ? const Color(0xFF120698) : Colors.grey.withOpacity(0.7),
//                       shape: BoxShape.circle,
//                     ),
//                     child: isUploading
//                         ? const CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           )
//                         : Icon(
//                             image != null ? Icons.cloud_upload : Icons.add_a_photo,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                   ),
//                 ),
//               ),
            
//             // Success checkmark for existing uploaded images
//             if (existingImageUrl != null && existingImageUrl!.isNotEmpty && image == null)
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
              
//             // Camera icon overlay if no image is selected and no existing image
//             if (!hasImage && image == null)
//               const Center(
//                 child: Icon(
//                   Icons.add_a_photo,
//                   color: Colors.white,
//                   size: 48,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Extension to capitalize string
// extension StringCapitalization on String {
//   String capitalize() {
//     if (isEmpty) return this;
//     return this[0].toUpperCase() + substring(1);
//   }
// }



















import 'package:car_rental_staff_app/controllers/auth_controller.dart';
import 'package:car_rental_staff_app/models/single_booking_model.dart';
import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
import 'package:car_rental_staff_app/views/car_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

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
  // Text controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _alternateMobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _pickupDateController = TextEditingController();

  // Image variables
  File? _frontImage;
  File? _backImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingFrontImage = false;
  bool _isUploadingBackImage = false;

  // Variables to track existing deposit proof
  String? _existingFrontImageUrl;
  String? _existingBackImageUrl;
  
  // Variables to track upload success
  bool _frontImageUploaded = false;
  bool _backImageUploaded = false;

  @override
  void initState() {
    super.initState();
    // Call fetchSingleBooking after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SingleBookingProvider>()
          .fetchSingleBooking(widget.id);
    });
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _mobileController.dispose();
    _alternateMobileController.dispose();
    _emailController.dispose();
    _pickupTimeController.dispose();
    _pickupDateController.dispose();
    super.dispose();
  }

  void _populateFields(dynamic booking) {
    if (booking != null) {
      _nameController.text = booking['name'] ?? '';
      _mobileController.text = booking['mobile'] ?? '';
      _alternateMobileController.text = booking['alternateMobile'] ?? '';
      _emailController.text = booking['email'] ?? '';
      _pickupTimeController.text = booking['pickupTime'] ?? '';
      _pickupDateController.text = booking['pickupDate'] ?? '';
    }
  }

  void _checkExistingDepositProof(Booking booking) {
    for (var depositProof in booking.depositeProof) {
      if (depositProof.label == 'depositeFront') {
        setState(() {
          _existingFrontImageUrl = depositProof.url;
          _frontImageUploaded = true; // Mark as uploaded if existing
        });
      } else if (depositProof.label == 'depositeBack') {
        setState(() {
          _existingBackImageUrl = depositProof.url;
          _backImageUploaded = true; // Mark as uploaded if existing
        });
      }
    }
  }

  // Show image source selection dialog
  void _showImageSourceDialog(String imageType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source for $imageType'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, imageType);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, imageType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source, String imageType) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          if (imageType == 'front') {
            _frontImage = File(pickedFile.path);
            _frontImageUploaded = false; // Reset upload status when new image is selected
          } else {
            _backImage = File(pickedFile.path);
            _backImageUploaded = false; // Reset upload status when new image is selected
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Upload single image to API
  Future<bool> _uploadSingleImage(String imageType) async {
    File? imageFile = imageType == 'front' ? _frontImage : _backImage;
    
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select ${imageType} image first')),
      );
      return false;
    }

    setState(() {
      if (imageType == 'front') {
        _isUploadingFrontImage = true;
      } else {
        _isUploadingBackImage = true;
      }
    });

    try {
      // Replace this URL with your actual API endpoint
      final String apiUrl = 'http://194.164.148.244:4062/api/staff/uploaddeposite/${widget.id}';
      
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
      // Add booking ID
      request.fields['bookingId'] = widget.id;
      
      // Add image with appropriate field name
      String fieldName = imageType == 'front' ? 'depositeFront' : 'depositeBack';
      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          imageFile.path,
        ),
      );

      // Add any additional headers if needed
      // request.headers['Authorization'] = 'Bearer YOUR_TOKEN';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Upload ${imageType} response: ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          if (imageType == 'front') {
            _frontImageUploaded = true;
          } else {
            _backImageUploaded = true;
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${imageType.capitalize()} image uploaded successfully!')),
        );
        
        // Refresh booking data to get updated deposit proof
        context.read<SingleBookingProvider>().fetchSingleBooking(widget.id);
        
        return true;
      } else {
        throw Exception('Failed to upload ${imageType} image: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading ${imageType} image: $e')),
      );
      return false;
    } finally {
      setState(() {
        if (imageType == 'front') {
          _isUploadingFrontImage = false;
        } else {
          _isUploadingBackImage = false;
        }
      });
    }
  }

  // Check if both images are uploaded
  bool _areBothImagesUploaded() {
    return _frontImageUploaded && _backImageUploaded;
  }

  // Handle next button press
  Future<void> _handleNextPress() async {
    if (_areBothImagesUploaded()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CarDetails()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both front and back images before proceeding')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<SingleBookingProvider>(
        builder: (context, bookingProvider, child) {
          // Handle loading state
          if (bookingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Handle error state
          if (bookingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${bookingProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      bookingProvider.clearError();
                      bookingProvider.fetchSingleBooking(widget.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final booking = bookingProvider.currentBooking;
          
          // Populate fields and check existing deposit proof when booking data is available
          if (booking != null) {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              // _populateFields(booking);
              _checkExistingDepositProof(booking);
            });
          }
      
          return SingleChildScrollView(
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
                          "ID: ${booking?.id.substring(booking.id.length - 4) ?? widget.id.substring(widget.id.length - 4)}",
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
                  _buildDisplayField(
                    icon: Icons.person_outline,
                    label: 'Name',
                    value: booking?.car?.model ?? 'Not Available'
                  ),

                  // Mobile Number field
                  _buildDisplayField(
                    icon: Icons.phone_outlined,
                    label: 'Mobile Number',
                    value: booking?.userId!.mobile ?? 'Not Available'
                  ),

                  // Alternate Mobile Number field
                  _buildDisplayField(
                    icon: Icons.phone_outlined,
                    label: 'Alternate Mobile Number',
                    value: booking?.userId!.mobile ?? 'Not Available'
                  ),

                  // Email field
                  _buildDisplayField(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: booking?.userId?.email ?? 'Not Available'
                  ),

                  // Pickup time and date
                  Row(
                    children: [
                      Expanded(
                        child: _buildDisplayField(
                          icon: Icons.access_time_outlined,
                          label: 'Pickup time',
                          value: booking?.from ?? 'Not set',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDisplayField(
                          icon: Icons.calendar_today_outlined,
                          label: 'Pickup date',
                          value: booking?.rentalStartDate ?? 'Not set',
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
                         Text(
                          '${booking?.deposit}',
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
                            onTap: () => _showImageSourceDialog('front'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildImageOption(
                            icon: Icons.file_upload_outlined,
                            title: 'Upload',
                            subtitle: 'Bike Front & Back',
                            onTap: () => _showImageSourceDialog('back'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ID cards - Front Image
                  _buildDocumentCard(
                    title: 'Front Side',
                    image: _frontImage,
                    existingImageUrl: _existingFrontImageUrl,
                    onTap: () => _showImageSourceDialog('front'),
                    onUpload: () => _uploadSingleImage('front'),
                    isUploading: _isUploadingFrontImage,
                    isUploaded: _frontImageUploaded,
                  ),

                  const SizedBox(height: 25),

                  // ID cards - Back Image
                  _buildDocumentCard(
                    title: 'Back Side',
                    image: _backImage,
                    existingImageUrl: _existingBackImageUrl,
                    onTap: () => _showImageSourceDialog('back'),
                    onUpload: () => _uploadSingleImage('back'),
                    isUploading: _isUploadingBackImage,
                    isUploaded: _backImageUploaded,
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  // Next button - disabled if both images not uploaded
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _areBothImagesUploaded() ? _handleNextPress : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _areBothImagesUploaded() 
                          ? const Color(0xFF120698) 
                          : Colors.grey,
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
          );
        },
      ),
    );
  }

  Widget _buildDisplayField({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: const Color.fromARGB(255, 162, 162, 162)),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
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
              controller: controller,
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
    File? image,
    String? existingImageUrl,
    VoidCallback? onTap,
    VoidCallback? onUpload,
    bool isUploading = false,
    bool isUploaded = false,
  }) {
    // Determine which image to show - priority: new image > existing image > default
    ImageProvider imageProvider;
    bool hasImage = false;
    
    if (image != null) {
      imageProvider = FileImage(image);
      hasImage = true;
    } else if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(existingImageUrl!);
      hasImage = true;
    } else {
      imageProvider = const AssetImage('assets/adhar.png');
      hasImage = false;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 206,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: imageProvider,
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
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(12)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Upload/Success icon
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: (image != null && !isUploaded) ? onUpload : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isUploaded ? Colors.green : 
                           (image != null && !isUploaded) ? const Color(0xFF120698) : 
                           Colors.grey.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: isUploading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Icon(
                          isUploaded ? Icons.check :
                          (image != null && !isUploaded) ? Icons.cloud_upload : 
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ),
              
            // Camera icon overlay if no image is selected and no existing image
            if (!hasImage && image == null)
              const Center(
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 48,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize string
extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}