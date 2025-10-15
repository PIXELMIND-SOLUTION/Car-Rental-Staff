
// import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
// import 'package:car_rental_staff_app/views/pickup_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:photo_view/photo_view.dart';
// import 'dart:io';
// import 'dart:convert';

// class BookingScreen extends StatefulWidget {
//   final String bookingId;

//   const BookingScreen({Key? key, required this.bookingId}) : super(key: key);

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   bool _isUploading = false;
//   File? _selectedAadharFile;
//   File? _selectedLicenseFile;
//   final ImagePicker _picker = ImagePicker();
  
//   // Keep track of locally uploaded images before API response
//   String? _localAadharImagePath;
//   String? _localLicenseImagePath;
  
//   // Track which documents were uploaded by staff
//   Set<String> _staffUploadedDocs = {};

//   @override
//   void initState() {
//     super.initState();

//     print('oooooooooooooooooooooooo${widget.bookingId}');
//     // Call fetchSingleBooking after the widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context
//           .read<SingleBookingProvider>()
//           .fetchSingleBooking(widget.bookingId);
//     });
//   }

//   // Show full screen image with zoom capability
//   void _showImageFullScreen({
//     File? imageFile,
//     String? imageUrl,
//     required String title,
//   }) {
//     ImageProvider? imageProvider;
    
//     if (imageFile != null) {
//       imageProvider = FileImage(imageFile);
//     } else if (imageUrl != null && imageUrl.isNotEmpty) {
//       imageProvider = NetworkImage(imageUrl);
//     }
    
//     if (imageProvider == null) return;

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ImageFullScreenViewer(
//           imageProvider: imageProvider!,
//           title: title,
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage(String documentType, {bool isEdit = false}) async {
//     try {
//       // Show dialog to choose between camera and gallery
//       final ImageSource? source = await showDialog<ImageSource>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Select Image Source'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text('Camera'),
//                   onTap: () => Navigator.of(context).pop(ImageSource.camera),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text('Gallery'),
//                   onTap: () => Navigator.of(context).pop(ImageSource.gallery),
//                 ),
//               ],
//             ),
//           );
//         },
//       );

//       if (source != null) {
//         final XFile? image = await _picker.pickImage(
//           source: source,
//           imageQuality: 80,
//           maxWidth: 1920,
//           maxHeight: 1920,
//         );
        
//         if (image != null) {
//           setState(() {
//             if (documentType == 'aadhar') {
//               _selectedAadharFile = File(image.path);
//               _localAadharImagePath = image.path; // Store local path
//             } else {
//               _selectedLicenseFile = File(image.path);
//               _localLicenseImagePath = image.path; // Store local path
//             }
//           });
          
//           _showSuccessSnackBar('${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} selected successfully');
          
//           // If this is an edit operation, upload immediately
//           if (isEdit) {
//             final provider = context.read<SingleBookingProvider>();
//             final booking = provider.currentBooking;
            
//             if (booking != null && booking.userId?.id != null) {
//               _showUploadConfirmationDialog(booking.userId!.id, documentType);
//             }
//           }
//         }
//       }
//     } catch (e) {
//       _showErrorSnackBar('Error picking image: $e');
//     }
//   }

//   void _showUploadConfirmationDialog(String userId, String documentType) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Update Document'),
//           content: Text(
//             'Do you want to upload the new ${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} immediately?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Keep the local image but don't upload yet
//               },
//               child: const Text('Upload Later'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 await _uploadSingleDocument(userId, documentType);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo.shade700,
//               ),
//               child: const Text(
//                 'Upload Now',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _uploadSingleDocument(String userId, String documentType) async {
//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       File? fileToUpload;
//       if (documentType == 'aadhar') {
//         fileToUpload = _selectedAadharFile;
//       } else {
//         fileToUpload = _selectedLicenseFile;
//       }

//       if (fileToUpload == null) {
//         _showErrorSnackBar('No file selected to upload');
//         return;
//       }

//       // Call upload API with only the selected document
//       final result = await _uploadDocumentsAPI(
//         userId: userId,
//         aadharFile: documentType == 'aadhar' ? fileToUpload : null,
//         licenseFile: documentType == 'license' ? fileToUpload : null,
//       );

//       // Refresh the booking data after successful upload
//       await context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
      
//       _showSuccessSnackBar('${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} updated successfully!');
      
//       // Keep the local image path until API response comes back with new URL
//       // Don't clear immediately - let the API response URL take precedence
//       setState(() {
//         if (documentType == 'aadhar') {
//           _selectedAadharFile = null;
//           // Keep _localAadharImagePath until refresh completes
//         } else {
//           _selectedLicenseFile = null;
//           // Keep _localLicenseImagePath until refresh completes
//         }
//       });

//       // Clear local paths after a short delay to allow API data to load
//       Future.delayed(const Duration(milliseconds: 500), () {
//         if (mounted) {
//           setState(() {
//             if (documentType == 'aadhar') {
//               _localAadharImagePath = null;
//             } else {
//               _localLicenseImagePath = null;
//             }
//           });
//         }
//       });
      
//     } catch (e) {
//       _showErrorSnackBar('Failed to update document: $e');
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }


//   Future<void> _uploadMissingDocuments(String userId) async {
//     if (_selectedAadharFile == null && _selectedLicenseFile == null) {
//       _showErrorSnackBar('Please select at least one document to upload');
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       // Call your upload API here - replace with your actual implementation
//       final result = await _uploadDocumentsAPI(
//         userId: userId,
//         aadharFile: _selectedAadharFile,
//         licenseFile: _selectedLicenseFile,
//       );

//       // Refresh the booking data after successful upload
//       await context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
      
//       _showSuccessSnackBar('Documents uploaded successfully!');
      
//       // Mark uploaded documents as staff uploaded
//       setState(() {
//         if (_selectedAadharFile != null) {
//           _staffUploadedDocs.add('aadhar');
//         }
//         if (_selectedLicenseFile != null) {
//           _staffUploadedDocs.add('license');
//         }
//       });
      
//       // Clear selected files and local paths after successful upload
//       setState(() {
//         _selectedAadharFile = null;
//         _selectedLicenseFile = null;
//         _localAadharImagePath = null;
//         _localLicenseImagePath = null;
//       });
      
//     } catch (e) {
//       _showErrorSnackBar('Failed to upload documents: $e');
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   // Replace this with your actual upload implementation
//   Future<UploadedDocuments> _uploadDocumentsAPI({
//     required String userId,
//     File? aadharFile,
//     File? licenseFile,
//   }) async {
//     print("Uploading documents for user: $userId");

//     // Replace with your actual base URL
//     const String baseUrl = 'http://194.164.148.244:4062/api/staff';
//     final uri = Uri.parse('$baseUrl/upload-documents/$userId');
//     final request = http.MultipartRequest('POST', uri);

//     // Helper to get content type based on extension
//     MediaType? getMediaType(String path) {
//       final ext = path.split('.').last.toLowerCase();
//       switch (ext) {
//         case 'jpg':
//         case 'jpeg':
//           return MediaType('image', 'jpeg');
//         case 'png':
//           return MediaType('image', 'png');
//         case 'pdf':
//           return MediaType('application', 'pdf');
//         default:
//           throw Exception('Unsupported file type: $ext');
//       }
//     }

//     // Add files to request only if they exist
//     if (aadharFile != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'aadharCard',
//           aadharFile.path,
//           contentType: getMediaType(aadharFile.path),
//         ),
//       );
//     }

//     if (licenseFile != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'drivingLicense',
//           licenseFile.path,
//           contentType: getMediaType(licenseFile.path),
//         ),
//       );
//     }

//     try {
//       print("Uploading documents for user: $userId");

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print("Response code: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         return UploadedDocuments.fromJson(data['documents']);
//       } else {
//         throw Exception('Failed to upload documents: ${response.body}');
//       }
//     } catch (e) {
//       print("Error uploading documents: $e");
//       throw Exception('Error uploading documents: $e');
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showMissingDocumentsDialog(List<String> missingDocs, String userId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: const Text('Missing Documents'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'The following documents are missing and need to be uploaded:',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   ...missingDocs.map((doc) => Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.warning, color: Colors.orange, size: 16),
//                         const SizedBox(width: 8),
//                         Text(
//                           doc,
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   )).toList(),
//                   const SizedBox(height: 20),
                  
//                   // Document upload section
//                   if (missingDocs.contains('Aadhar Card')) ...[
//                     const Text('Upload Aadhar Card:', style: TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Container(
//                       width: double.infinity,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: InkWell(
//                         onTap: () => _pickImage('aadhar').then((_) => setDialogState(() {})),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               _selectedAadharFile != null ? Icons.check_circle : Icons.upload_file,
//                               color: _selectedAadharFile != null ? Colors.green : Colors.grey,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               _selectedAadharFile != null ? 'Aadhar Card Selected' : 'Select Aadhar Card',
//                               style: TextStyle(
//                                 color: _selectedAadharFile != null ? Colors.green : Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                   ],
                  
//                   if (missingDocs.contains('Driving License')) ...[
//                     const Text('Upload Driving License:', style: TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 8),
//                     Container(
//                       width: double.infinity,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: InkWell(
//                         onTap: () => _pickImage('license').then((_) => setDialogState(() {})),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               _selectedLicenseFile != null ? Icons.check_circle : Icons.upload_file,
//                               color: _selectedLicenseFile != null ? Colors.green : Colors.grey,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               _selectedLicenseFile != null ? 'License Selected' : 'Select Driving License',
//                               style: TextStyle(
//                                 color: _selectedLicenseFile != null ? Colors.green : Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                   ],
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: _isUploading ? null : () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: _isUploading ? null : () async {
//                     await _uploadMissingDocuments(userId);
//                     Navigator.of(context).pop();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigo.shade700,
//                   ),
//                   child: _isUploading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Text(
//                           'Upload',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _handleProceed() {
//     final provider = context.read<SingleBookingProvider>();
//     final booking = provider.currentBooking;

//     if (booking == null) {
//       _showErrorSnackBar('Booking data not available');
//       return;
//     }

//     // Check for missing documents - check both null and empty URL
//     List<String> missingDocs = [];
    
//     print('Checking Aadhar: ${booking.userId?.documents?.aadharCard}');
//     print('Checking License: ${booking.userId?.documents?.drivingLicense}');
    
//     if (booking.userId?.documents?.aadharCard == null || 
//         booking.userId?.documents?.aadharCard?.url == null ||
//         booking.userId!.documents!.aadharCard!.url!.isEmpty) {
//       missingDocs.add('Aadhar Card');
//     }
    
//     if (booking.userId?.documents?.drivingLicense == null || 
//         booking.userId?.documents?.drivingLicense?.url == null ||
//         booking.userId!.documents!.drivingLicense!.url!.isEmpty) {
//       missingDocs.add('Driving License');
//     }

//     print('Missing docs: $missingDocs');

//     if (missingDocs.isNotEmpty) {
//       _showMissingDocumentsDialog(missingDocs, booking.userId?.id ?? '');
//     } else {
//       // All documents are present, proceed to next screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PickupDetailsScreen(id: widget.bookingId),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<SingleBookingProvider>(
//         builder: (context, provider, child) {
//           // Get the current booking data
//           final booking = provider.currentBooking;

//           print('pppppppppppppppppppppppppppppppp${booking?.userId?.documents?.aadharCard?.url}');
//           print('pppppppppppppppppppppppppppppppp${booking?.userId?.documents?.drivingLicense?.url}');

//           return SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Header - Fixed part
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.arrow_back,
//                             color: Colors.black,
//                             size: screenWidth * 0.06,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       SizedBox(width: screenWidth * 0.25),
//                       Text(
//                         "ID: ${booking?.id.substring(booking.id.length - 4) ?? widget.bookingId.substring(widget.bookingId.length - 4)}",
//                         style: TextStyle(
//                           color: const Color.fromARGB(255, 255, 0, 0),
//                           fontSize: screenWidth * 0.045,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Scrollable content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           // Car details card
//                           Card(
//                             elevation: 1,
//                             color: const Color(0XFFFFFFFF),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               side: BorderSide(color: Colors.grey.shade200),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         booking?.car?.vehicleNumber ?? 'TS 05 TD 4544',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.red.shade700,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         '${booking?.car?.carName ?? 'Hyundai'} ',
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),

//                                   // Automatic & Seaters Row
//                                   Row(
//                                     children: [
//                                       const Icon(Icons.settings,
//                                           size: 16, color: Colors.grey),
//                                       const SizedBox(width: 4),
//                                       const Text(
//                                         'Automatic',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       Row(
//                                         children: const [
//                                           Icon(
//                                               Icons.airline_seat_recline_normal,
//                                               size: 16,
//                                               color: Colors.grey),
//                                           SizedBox(width: 4),
//                                           Text(
//                                             '5 Seaters',
//                                             style: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),

//                                   // Date & Time Row
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       const Icon(Icons.calendar_today,
//                                           size: 16, color: Colors.blue),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         booking?.rentalStartDate ??
//                                             '23-03-2025',
//                                         style: const TextStyle(
//                                           color: Colors.black87,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       const Icon(Icons.access_time,
//                                           size: 16, color: Colors.blue),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         booking?.to ?? '11:00 AM',
//                                         style: const TextStyle(
//                                           color: Colors.black87,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           // Uploaded Documents Section
//                           const Text(
//                             'Uploaded Documents',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           // Document cards
//                           _buildDocumentCard(
//                             title: 'Aadhar Card',
//                             status: booking?.userId?.documents?.aadharCard?.status?.toUpperCase() ?? 'NOT UPLOADED',
//                             statusColor: booking?.userId?.documents?.aadharCard?.status == 'verified'
//                                 ? Colors.green
//                                 : booking?.userId?.documents?.aadharCard?.status != null
//                                     ? Colors.orange
//                                     : Colors.red,
//                             imageUrl: booking?.userId?.documents?.aadharCard?.url,
//                             localImagePath: _localAadharImagePath,
//                             documentType: 'aadhar',
//                           ),

//                           const SizedBox(height: 25),

//                           _buildDocumentCard(
//                             title: 'Driving License',
//                             status: booking?.userId?.documents?.drivingLicense?.status?.toUpperCase() ?? 'NOT UPLOADED',
//                             statusColor: booking?.userId?.documents?.drivingLicense?.status == 'verified'
//                                 ? Colors.green
//                                 : booking?.userId?.documents?.drivingLicense?.status != null
//                                     ? Colors.orange
//                                     : Colors.red,
//                             imageUrl: booking?.userId?.documents?.drivingLicense?.url,
//                             localImagePath: _localLicenseImagePath,
//                             documentType: 'license',
//                           ),

//                           const SizedBox(height: 25),

//                           // Extra space at the bottom for the button
//                           const SizedBox(height: 80),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       bottomSheet: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(16),
//         color: Colors.white,
//         child: ElevatedButton(
//           onPressed: _handleProceed,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.indigo.shade700,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: const Text(
//             'Proceed',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentCard({
//     required String title,
//     required String status,
//     required Color statusColor,
//     String? imageUrl,
//     String? localImagePath,
//     required String documentType,
//   }) {
//     // Determine which image to show - priority: API URL > local image > placeholder
//     String? displayImagePath;
//     bool isNetworkImage = false;
    
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       displayImagePath = imageUrl;
//       isNetworkImage = true;
//     } else if (localImagePath != null) {
//       displayImagePath = localImagePath;
//       isNetworkImage = false;
//     }
    
//     bool isMissing = displayImagePath == null;
//     bool hasDocument = !isMissing;
    
//     // Check if this document was uploaded by staff (should have edit option)
//     bool isStaffUploaded = _staffUploadedDocs.contains(documentType);
    
//     return GestureDetector(
//       onTap: () {
//         if (hasDocument) {
//           // Show full screen view for existing documents
//           _showImageFullScreen(
//             imageFile: !isNetworkImage && displayImagePath != null ? File(displayImagePath!) : null,
//             imageUrl: isNetworkImage ? displayImagePath : null,
//             title: title,
//           );
//         } else {
//           // Allow upload only if document is missing
//           _pickImage(documentType);
//         }
//       },
//       child: Container(
//         width: double.infinity,
//         height: 206,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: displayImagePath != null
//               ? DecorationImage(
//                   image: isNetworkImage 
//                       ? NetworkImage(displayImagePath) as ImageProvider
//                       : FileImage(File(displayImagePath)),
//                   fit: BoxFit.cover,
//                 )
//               : const DecorationImage(
//                   image: AssetImage('assets/adhar.png'),
//                   fit: BoxFit.cover,
//                 ),
//         ),
//         child: Stack(
//           children: [
//             // Show upload overlay if document is missing
//             if (isMissing)
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.black.withOpacity(0.6),
//                 ),
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.cloud_upload,
//                         color: Colors.white,
//                         size: 40,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Tap to Upload',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
            
//             // Full screen view icon when image exists
//             if (hasDocument)
//               Positioned(
//                 top: 12,
//                 left: 12,
//                 child: GestureDetector(
//                   onTap: () => _showImageFullScreen(
//                     imageFile: !isNetworkImage && displayImagePath != null ? File(displayImagePath!) : null,
//                     imageUrl: isNetworkImage ? displayImagePath : null,
//                     title: title,
//                   ),
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.fullscreen,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ),
            
//             // Edit icon for documents uploaded by staff
//             if (hasDocument && isStaffUploaded)
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.edit,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     onPressed: () => _pickImage(documentType, isEdit: true),
//                     padding: const EdgeInsets.all(8),
//                     constraints: const BoxConstraints(
//                       minWidth: 36,
//                       minHeight: 36,
//                     ),
//                   ),
//                 ),
//               ),

//             // Loading overlay during upload
//             if (_isUploading)
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.black.withOpacity(0.7),
//                 ),
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Uploading...',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
            
//             // Gradient overlay at bottom
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               height: 60,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   borderRadius:
//                       BorderRadius.vertical(bottom: Radius.circular(12)),
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.blue,
//                       Colors.white70,
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Text Row at bottom
//             Positioned(
//               bottom: 6,
//               left: 12,
//               right: 12,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: statusColor, width: 1),
//                     ),
//                     child: Text(
//                       status,
//                       style: TextStyle(
//                         color: statusColor,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Full screen image viewer with zoom capability
// class ImageFullScreenViewer extends StatelessWidget {
//   final ImageProvider imageProvider;
//   final String title;

//   const ImageFullScreenViewer({
//     super.key,
//     required this.imageProvider,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: PhotoView(
//         imageProvider: imageProvider,
//         minScale: PhotoViewComputedScale.contained,
//         maxScale: PhotoViewComputedScale.covered * 4.0,
//         initialScale: PhotoViewComputedScale.contained,
//         heroAttributes: PhotoViewHeroAttributes(tag: title),
//         loadingBuilder: (context, event) => const Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//         errorBuilder: (context, error, stackTrace) => const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 color: Colors.white,
//                 size: 64,
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Failed to load image',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Document Info Classes (add these if not already in your project)
// class DocumentInfo {
//   final String url;
//   final DateTime uploadedAt;
//   final String status;

//   DocumentInfo({
//     required this.url,
//     required this.uploadedAt,
//     required this.status,
//   });

//   factory DocumentInfo.fromJson(Map<String, dynamic> json) {
//     return DocumentInfo(
//       url: json['url'] ?? '',
//       uploadedAt: json['uploadedAt'] != null 
//           ? DateTime.parse(json['uploadedAt']) 
//           : DateTime.now(),
//       status: json['status'] ?? 'unknown',
//     );
//   }
// }

// class UploadedDocuments {
//   final DocumentInfo? aadharCard;
//   final DocumentInfo? drivingLicense;

//   UploadedDocuments({
//     this.aadharCard,
//     this.drivingLicense,
//   });

//   UploadedDocuments.empty()
//       : aadharCard = null,
//         drivingLicense = null;

//   factory UploadedDocuments.fromJson(Map<String, dynamic>? json) {
//     if (json == null || json.isEmpty) {
//       return UploadedDocuments.empty();
//     }

//     return UploadedDocuments(
//       aadharCard: json['aadharCard'] != null 
//           ? DocumentInfo.fromJson(json['aadharCard']) 
//           : null,
//       drivingLicense: json['drivingLicense'] != null 
//           ? DocumentInfo.fromJson(json['drivingLicense']) 
//           : null,
//     );
//   }

//   bool get hasAnyDocuments => aadharCard != null || drivingLicense != null;
//   bool get hasAllDocuments => aadharCard != null && drivingLicense != null;

// }












// import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
// import 'package:car_rental_staff_app/views/pickup_details_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image/image.dart' as img;
// import 'dart:io';
// import 'dart:convert';

// class BookingScreen extends StatefulWidget {
//   final String bookingId;

//   const BookingScreen({Key? key, required this.bookingId}) : super(key: key);

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   bool _isUploading = false;
//   bool _isValidating = false;
  
//   // Front and back files for each document
//   File? _aadharFrontFile;
//   File? _aadharBackFile;
//   File? _licenseFrontFile;
//   File? _licenseBackFile;
  
//   final ImagePicker _picker = ImagePicker();
//   final TextRecognizer _textRecognizer = TextRecognizer();
  
//   // Keep track of locally uploaded images before API response
//   String? _localAadharImagePath;
//   String? _localLicenseImagePath;
  
//   // Track which documents were uploaded by staff
//   Set<String> _staffUploadedDocs = {};

//   @override
//   void initState() {
//     super.initState();
//     print('oooooooooooooooooooooooo${widget.bookingId}');
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
//     });
//   }

//   @override
//   void dispose() {
//     _textRecognizer.close();
//     super.dispose();
//   }

//   // Aadhaar validation
//   bool _isValidAadhaarDocument(String text) {
//     final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
//     final aadhaarKeywords = [
//       'aadhaar',
//       'aadhar',
//       'government of india',
//       'भारत सरकार',
//       'unique identification authority of india',
//       'uidai',
//     ];
    
//     final aadhaarNumberPattern = RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}\b');
    
//     bool hasKeyword = aadhaarKeywords.any((keyword) => cleanText.contains(keyword));
//     bool hasAadhaarNumber = aadhaarNumberPattern.hasMatch(text);
    
//     return hasKeyword || hasAadhaarNumber;
//   }

//   // Driving License validation
//   bool _isValidLicenseDocument(String text) {
//     final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
//     final licenseKeywords = [
//       'driving licence',
//       'driving license',
//       'dl',
//       'transport',
//       'motor vehicles',
//       'ड्राइविंग लाइसेंस',
//       'वाहन',
//       'परिवहन',
//     ];
    
//     final dlNumberPatterns = [
//       RegExp(r'\b[A-Z]{2}[0-9]{2}[A-Z0-9]{11,13}\b'),
//       RegExp(r'\b[A-Z]{2}-?[0-9]{2}-?[0-9]{4}-?[0-9]{7}\b'),
//     ];
    
//     bool hasKeyword = licenseKeywords.any((keyword) => cleanText.contains(keyword));
//     bool hasValidPattern = dlNumberPatterns.any((pattern) => pattern.hasMatch(text));
    
//     return hasKeyword || hasValidPattern;
//   }

//   // Image quality validation
//   bool _isValidImageQuality(File imageFile) {
//     try {
//       final bytes = imageFile.readAsBytesSync();
//       final image = img.decodeImage(bytes);
      
//       if (image == null) return false;
//       if (image.width < 300 || image.height < 200) return false;
//       if (bytes.length < 10000 || bytes.length > 10000000) return false;
      
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<bool> _validateDocument(File imageFile, bool isAadhar) async {
//     try {
//       setState(() => _isValidating = true);
      
//       if (!_isValidImageQuality(imageFile)) {
//         _showValidationError('Image quality is too low. Please upload a clear photo.');
//         return false;
//       }
      
//       final inputImage = InputImage.fromFile(imageFile);
//       final recognizedText = await _textRecognizer.processImage(inputImage);
//       final extractedText = recognizedText.text;
      
//       if (extractedText.isEmpty) {
//         _showValidationError('No text found in image. Please upload a clear document photo.');
//         return false;
//       }
      
//       bool isValid = false;
//       if (isAadhar) {
//         isValid = _isValidAadhaarDocument(extractedText);
//         if (!isValid) {
//           _showValidationError('This doesn\'t appear to be an Aadhaar card. Please upload a valid Aadhaar document.');
//         }
//       } else {
//         isValid = _isValidLicenseDocument(extractedText);
//         if (!isValid) {
//           _showValidationError('This doesn\'t appear to be a driving license. Please upload a valid driving license.');
//         }
//       }
      
//       return isValid;
//     } catch (e) {
//       _showValidationError('Document validation failed. Please try again.');
//       return false;
//     } finally {
//       setState(() => _isValidating = false);
//     }
//   }

//   void _showValidationError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 4),
//       ),
//     );
//   }

//   // Combine front and back images
//   Future<File> _combineImages(File frontImage, File backImage, String documentType) async {
//     try {
//       final frontBytes = await frontImage.readAsBytes();
//       final backBytes = await backImage.readAsBytes();
      
//       final frontImg = img.decodeImage(frontBytes)!;
//       final backImg = img.decodeImage(backBytes)!;
      
//       final maxWidth = frontImg.width > backImg.width ? frontImg.width : backImg.width;
//       final resizedFront = img.copyResize(frontImg, width: maxWidth);
//       final resizedBack = img.copyResize(backImg, width: maxWidth);
      
//       final combinedHeight = resizedFront.height + resizedBack.height + 20;
//       final combinedImg = img.Image(width: maxWidth, height: combinedHeight, numChannels: 3);
      
//       img.fill(combinedImg, color: img.ColorRgb8(255, 255, 255));
//       img.compositeImage(combinedImg, resizedFront, dstX: 0, dstY: 0);
//       img.compositeImage(combinedImg, resizedBack, dstX: 0, dstY: resizedFront.height + 20);
      
//       final combinedBytes = img.encodeJpg(combinedImg, quality: 85);
      
//       final tempDir = Directory.systemTemp;
//       final combinedFile = File('${tempDir.path}/${documentType}_combined_${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await combinedFile.writeAsBytes(combinedBytes);
      
//       return combinedFile;
//     } catch (e) {
//       throw Exception('Failed to combine images: $e');
//     }
//   }

//   void _showImageFullScreen({
//     File? imageFile,
//     String? imageUrl,
//     required String title,
//   }) {
//     ImageProvider? imageProvider;
    
//     if (imageFile != null) {
//       imageProvider = FileImage(imageFile);
//     } else if (imageUrl != null && imageUrl.isNotEmpty) {
//       imageProvider = NetworkImage(imageUrl);
//     }
    
//     if (imageProvider == null) return;

//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ImageFullScreenViewer(
//           imageProvider: imageProvider!,
//           title: title,
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImage(String documentType, String side, {bool isEdit = false}) async {
//     try {
//       final ImageSource? source = await showDialog<ImageSource>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Select Image Source'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt),
//                   title: const Text('Camera'),
//                   onTap: () => Navigator.of(context).pop(ImageSource.camera),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.photo_library),
//                   title: const Text('Gallery'),
//                   onTap: () => Navigator.of(context).pop(ImageSource.gallery),
//                 ),
//               ],
//             ),
//           );
//         },
//       );

//       if (source != null) {
//         final XFile? image = await _picker.pickImage(
//           source: source,
//           imageQuality: 80,
//           maxWidth: 1920,
//           maxHeight: 1920,
//         );
        
//         if (image != null) {
//           final imageFile = File(image.path);
//           bool isValid = false;
          
//           // Skip validation for back side of license
//           if (documentType == 'license' && side == 'back') {
//             isValid = true;
//           } else {
//             isValid = await _validateDocument(imageFile, documentType == 'aadhar');
//           }
          
//           if (isValid) {
//             setState(() {
//               if (documentType == 'aadhar' && side == 'front') {
//                 _aadharFrontFile = imageFile;
//               } else if (documentType == 'aadhar' && side == 'back') {
//                 _aadharBackFile = imageFile;
//               } else if (documentType == 'license' && side == 'front') {
//                 _licenseFrontFile = imageFile;
//               } else if (documentType == 'license' && side == 'back') {
//                 _licenseBackFile = imageFile;
//               }
//             });
            
//             _showSuccessSnackBar('${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} $side side selected successfully');
            
//             if (isEdit) {
//               final provider = context.read<SingleBookingProvider>();
//               final booking = provider.currentBooking;
              
//               if (booking != null && booking.userId?.id != null) {
//                 _showUploadConfirmationDialog(booking.userId!.id, documentType);
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       _showErrorSnackBar('Error picking image: $e');
//     }
//   }

//   void _showUploadConfirmationDialog(String userId, String documentType) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Update Document'),
//           content: Text(
//             'Do you want to upload the new ${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} immediately?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Upload Later'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 await _uploadSingleDocument(userId, documentType);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo.shade700,
//               ),
//               child: const Text(
//                 'Upload Now',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _uploadSingleDocument(String userId, String documentType) async {
//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       File? combinedFile;
      
//       if (documentType == 'aadhar') {
//         if (_aadharFrontFile == null || _aadharBackFile == null) {
//           _showErrorSnackBar('Please upload both front and back sides of Aadhar Card');
//           return;
//         }
//         combinedFile = await _combineImages(_aadharFrontFile!, _aadharBackFile!, 'aadhar');
//       } else {
//         if (_licenseFrontFile == null || _licenseBackFile == null) {
//           _showErrorSnackBar('Please upload both front and back sides of Driving License');
//           return;
//         }
//         combinedFile = await _combineImages(_licenseFrontFile!, _licenseBackFile!, 'license');
//       }

//       final result = await _uploadDocumentsAPI(
//         userId: userId,
//         aadharFile: documentType == 'aadhar' ? combinedFile : null,
//         licenseFile: documentType == 'license' ? combinedFile : null,
//       );

//       await context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
      
//       _showSuccessSnackBar('${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} updated successfully!');
      
//       setState(() {
//         if (documentType == 'aadhar') {
//           _aadharFrontFile = null;
//           _aadharBackFile = null;
//         } else {
//           _licenseFrontFile = null;
//           _licenseBackFile = null;
//         }
//       });

//       Future.delayed(const Duration(milliseconds: 500), () {
//         if (mounted) {
//           setState(() {
//             if (documentType == 'aadhar') {
//               _localAadharImagePath = null;
//             } else {
//               _localLicenseImagePath = null;
//             }
//           });
//         }
//       });
      
//     } catch (e) {
//       _showErrorSnackBar('Failed to update document: $e');
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   Future<void> _uploadMissingDocuments(String userId) async {
//     bool hasCompleteAadhar = _aadharFrontFile != null && _aadharBackFile != null;
//     bool hasCompleteLicense = _licenseFrontFile != null && _licenseBackFile != null;
    
//     if (!hasCompleteAadhar && !hasCompleteLicense) {
//       _showErrorSnackBar('Please upload both front and back sides of at least one document');
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       File? combinedAadhar;
//       File? combinedLicense;
      
//       if (hasCompleteAadhar) {
//         combinedAadhar = await _combineImages(_aadharFrontFile!, _aadharBackFile!, 'aadhar');
//       }
      
//       if (hasCompleteLicense) {
//         combinedLicense = await _combineImages(_licenseFrontFile!, _licenseBackFile!, 'license');
//       }

//       final result = await _uploadDocumentsAPI(
//         userId: userId,
//         aadharFile: combinedAadhar,
//         licenseFile: combinedLicense,
//       );

//       await context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
      
//       _showSuccessSnackBar('Documents uploaded successfully!');
      
//       setState(() {
//         if (hasCompleteAadhar) {
//           _staffUploadedDocs.add('aadhar');
//           _aadharFrontFile = null;
//           _aadharBackFile = null;
//         }
//         if (hasCompleteLicense) {
//           _staffUploadedDocs.add('license');
//           _licenseFrontFile = null;
//           _licenseBackFile = null;
//         }
//         _localAadharImagePath = null;
//         _localLicenseImagePath = null;
//       });
      
//     } catch (e) {
//       _showErrorSnackBar('Failed to upload documents: $e');
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   Future<UploadedDocuments> _uploadDocumentsAPI({
//     required String userId,
//     File? aadharFile,
//     File? licenseFile,
//   }) async {
//     print("Uploading documents for user: $userId");

//     const String baseUrl = 'http://194.164.148.244:4062/api/staff';
//     final uri = Uri.parse('$baseUrl/upload-documents/$userId');
//     final request = http.MultipartRequest('POST', uri);

//     MediaType? getMediaType(String path) {
//       final ext = path.split('.').last.toLowerCase();
//       switch (ext) {
//         case 'jpg':
//         case 'jpeg':
//           return MediaType('image', 'jpeg');
//         case 'png':
//           return MediaType('image', 'png');
//         case 'pdf':
//           return MediaType('application', 'pdf');
//         default:
//           throw Exception('Unsupported file type: $ext');
//       }
//     }

//     if (aadharFile != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'aadharCard',
//           aadharFile.path,
//           contentType: getMediaType(aadharFile.path),
//         ),
//       );
//     }

//     if (licenseFile != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'drivingLicense',
//           licenseFile.path,
//           contentType: getMediaType(licenseFile.path),
//         ),
//       );
//     }

//     try {
//       print("Uploading documents for user: $userId");

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print("Response code: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         return UploadedDocuments.fromJson(data['documents']);
//       } else {
//         throw Exception('Failed to upload documents: ${response.body}');
//       }
//     } catch (e) {
//       print("Error uploading documents: $e");
//       throw Exception('Error uploading documents: $e');
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showMissingDocumentsDialog(List<String> missingDocs, String userId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             bool hasCompleteAadhar = _aadharFrontFile != null && _aadharBackFile != null;
//             bool hasCompleteLicense = _licenseFrontFile != null && _licenseBackFile != null;
            
//             return AlertDialog(
//               title: const Text('Missing Documents'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'The following documents are missing and need to be uploaded:',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ...missingDocs.map((doc) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.warning, color: Colors.orange, size: 16),
//                           const SizedBox(width: 8),
//                           Text(
//                             doc,
//                             style: const TextStyle(fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                     )).toList(),
//                     const SizedBox(height: 20),
                    
//                     if (missingDocs.contains('Aadhar Card')) ...[
//                       const Text('Upload Aadhar Card:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
                      
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildUploadBox(
//                               'Front Side',
//                               _aadharFrontFile,
//                               () => _pickImage('aadhar', 'front').then((_) => setDialogState(() {})),
//                               setDialogState,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: _buildUploadBox(
//                               'Back Side',
//                               _aadharBackFile,
//                               () => _pickImage('aadhar', 'back').then((_) => setDialogState(() {})),
//                               setDialogState,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                     ],
                    
//                     if (missingDocs.contains('Driving License')) ...[
//                       const Text('Upload Driving License:', style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
                      
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildUploadBox(
//                               'Front Side',
//                               _licenseFrontFile,
//                               () => _pickImage('license', 'front').then((_) => setDialogState(() {})),
//                               setDialogState,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: _buildUploadBox(
//                               'Back Side',
//                               _licenseBackFile,
//                               () => _pickImage('license', 'back').then((_) => setDialogState(() {})),
//                               setDialogState,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                     ],
                    
//                     if (_isValidating)
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             ),
//                             const SizedBox(width: 12),
//                             const Expanded(
//                               child: Text(
//                                 'Validating document...',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: _isUploading || _isValidating ? null : () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: (_isUploading || _isValidating || (!hasCompleteAadhar && !hasCompleteLicense)) ? null : () async {
//                     await _uploadMissingDocuments(userId);
//                     Navigator.of(context).pop();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.indigo.shade700,
//                   ),
//                   child: _isUploading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         )
//                       : const Text(
//                           'Upload',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildUploadBox(String label, File? file, VoidCallback onTap, StateSetter setState) {
//     return Column(
//       children: [
//         Container(
//           height: 80,
//           decoration: BoxDecoration(
//             border: Border.all(color: file != null ? Colors.green : Colors.grey[300]!),
//             borderRadius: BorderRadius.circular(8),
//             color: file != null ? Colors.green.shade50 : Colors.white,
//           ),
//           child: file != null
//               ? Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(7),
//                       child: Image.file(
//                         file,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         height: double.infinity,
//                       ),
//                     ),
//                     Positioned(
//                       top: 4,
//                       right: 4,
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: const BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.check,
//                           color: Colors.white,
//                           size: 12,
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//               : InkWell(
//                   onTap: onTap,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.upload_file, color: Colors.grey, size: 24),
//                       const SizedBox(height: 4),
//                       Text(
//                         label,
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 10,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//         ),
//         if (file != null) ...[
//           const SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextButton(
//                 onPressed: () => setState(() {
//                   if (label.contains('Aadhar')) {
//                     if (label.contains('Front')) {
//                       _aadharFrontFile = null;
//                     } else {
//                       _aadharBackFile = null;
//                     }
//                   } else {
//                     if (label.contains('Front')) {
//                       _licenseFrontFile = null;
//                     } else {
//                       _licenseBackFile = null;
//                     }
//                   }
//                 }),
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   minimumSize: const Size(40, 20),
//                 ),
//                 child: const Text(
//                   'Remove',
//                   style: TextStyle(fontSize: 10, color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ],
//     );
//   }

//   void _handleProceed() {
//     final provider = context.read<SingleBookingProvider>();
//     final booking = provider.currentBooking;

//     if (booking == null) {
//       _showErrorSnackBar('Booking data not available');
//       return;
//     }

//     List<String> missingDocs = [];
    
//     print('Checking Aadhar: ${booking.userId?.documents?.aadharCard}');
//     print('Checking License: ${booking.userId?.documents?.drivingLicense}');
    
//     if (booking.userId?.documents?.aadharCard == null || 
//         booking.userId?.documents?.aadharCard?.url == null ||
//         booking.userId!.documents!.aadharCard!.url!.isEmpty) {
//       missingDocs.add('Aadhar Card');
//     }
    
//     if (booking.userId?.documents?.drivingLicense == null || 
//         booking.userId?.documents?.drivingLicense?.url == null ||
//         booking.userId!.documents!.drivingLicense!.url!.isEmpty) {
//       missingDocs.add('Driving License');
//     }

//     print('Missing docs: $missingDocs');

//     if (missingDocs.isNotEmpty) {
//       _showMissingDocumentsDialog(missingDocs, booking.userId?.id ?? '');
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PickupDetailsScreen(id: widget.bookingId),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<SingleBookingProvider>(
//         builder: (context, provider, child) {
//           final booking = provider.currentBooking;

//           print('pppppppppppppppppppppppppppppppp${booking?.userId?.documents?.aadharCard?.url}');
//           print('pppppppppppppppppppppppppppppppp${booking?.userId?.documents?.drivingLicense?.url}');

//           return SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.arrow_back,
//                             color: Colors.black,
//                             size: screenWidth * 0.06,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                       SizedBox(width: screenWidth * 0.25),
//                       Text(
//                         "ID: ${booking?.id.substring(booking.id.length - 4) ?? widget.bookingId.substring(widget.bookingId.length - 4)}",
//                         style: TextStyle(
//                           color: const Color.fromARGB(255, 255, 0, 0),
//                           fontSize: screenWidth * 0.045,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Card(
//                             elevation: 1,
//                             color: const Color(0XFFFFFFFF),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               side: BorderSide(color: Colors.grey.shade200),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         booking?.car?.vehicleNumber ?? 'TS 05 TD 4544',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.red.shade700,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         '${booking?.car?.carName ?? 'Hyundai'} ',
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),

//                                   Row(
//                                     children: [
//                                       const Icon(Icons.settings,
//                                           size: 16, color: Colors.grey),
//                                       const SizedBox(width: 4),
//                                       const Text(
//                                         'Automatic',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       Row(
//                                         children: const [
//                                           Icon(
//                                               Icons.airline_seat_recline_normal,
//                                               size: 16,
//                                               color: Colors.grey),
//                                           SizedBox(width: 4),
//                                           Text(
//                                             '5 Seaters',
//                                             style: TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 12),

//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       const Icon(Icons.calendar_today,
//                                           size: 16, color: Colors.blue),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         booking?.rentalStartDate ??
//                                             '23-03-2025',
//                                         style: const TextStyle(
//                                           color: Colors.black87,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 16),
//                                       const Icon(Icons.access_time,
//                                           size: 16, color: Colors.blue),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         booking?.to ?? '11:00 AM',
//                                         style: const TextStyle(
//                                           color: Colors.black87,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           const Text(
//                             'Uploaded Documents',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           _buildDocumentCard(
//                             title: 'Aadhar Card',
//                             status: booking?.userId?.documents?.aadharCard?.status?.toUpperCase() ?? 'NOT UPLOADED',
//                             statusColor: booking?.userId?.documents?.aadharCard?.status == 'verified'
//                                 ? Colors.green
//                                 : booking?.userId?.documents?.aadharCard?.status != null
//                                     ? Colors.orange
//                                     : Colors.red,
//                             imageUrl: booking?.userId?.documents?.aadharCard?.url,
//                             localImagePath: _localAadharImagePath,
//                             documentType: 'aadhar',
//                           ),

//                           const SizedBox(height: 25),

//                           _buildDocumentCard(
//                             title: 'Driving License',
//                             status: booking?.userId?.documents?.drivingLicense?.status?.toUpperCase() ?? 'NOT UPLOADED',
//                             statusColor: booking?.userId?.documents?.drivingLicense?.status == 'verified'
//                                 ? Colors.green
//                                 : booking?.userId?.documents?.drivingLicense?.status != null
//                                     ? Colors.orange
//                                     : Colors.red,
//                             imageUrl: booking?.userId?.documents?.drivingLicense?.url,
//                             localImagePath: _localLicenseImagePath,
//                             documentType: 'license',
//                           ),

//                           const SizedBox(height: 25),
//                           const SizedBox(height: 80),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       bottomSheet: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(16),
//         color: Colors.white,
//         child: ElevatedButton(
//           onPressed: _handleProceed,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.indigo.shade700,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: const Text(
//             'Proceed',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentCard({
//     required String title,
//     required String status,
//     required Color statusColor,
//     String? imageUrl,
//     String? localImagePath,
//     required String documentType,
//   }) {
//     String? displayImagePath;
//     bool isNetworkImage = false;
    
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       displayImagePath = imageUrl;
//       isNetworkImage = true;
//     } else if (localImagePath != null) {
//       displayImagePath = localImagePath;
//       isNetworkImage = false;
//     }
    
//     bool isMissing = displayImagePath == null;
//     bool hasDocument = !isMissing;
//     bool isStaffUploaded = _staffUploadedDocs.contains(documentType);
    
//     return GestureDetector(
//       onTap: () {
//         if (hasDocument) {
//           _showImageFullScreen(
//             imageFile: !isNetworkImage && displayImagePath != null ? File(displayImagePath!) : null,
//             imageUrl: isNetworkImage ? displayImagePath : null,
//             title: title,
//           );
//         } else {
//           _showUploadOptionsDialog(documentType);
//         }
//       },
//       child: Container(
//         width: double.infinity,
//         height: 206,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: displayImagePath != null
//               ? DecorationImage(
//                   image: isNetworkImage 
//                       ? NetworkImage(displayImagePath) as ImageProvider
//                       : FileImage(File(displayImagePath)),
//                   fit: BoxFit.cover,
//                 )
//               : const DecorationImage(
//                   image: AssetImage('assets/adhar.png'),
//                   fit: BoxFit.cover,
//                 ),
//         ),
//         child: Stack(
//           children: [
//             if (isMissing)
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.black.withOpacity(0.6),
//                 ),
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.cloud_upload,
//                         color: Colors.white,
//                         size: 40,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Tap to Upload',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
            
//             if (hasDocument)
//               Positioned(
//                 top: 12,
//                 left: 12,
//                 child: GestureDetector(
//                   onTap: () => _showImageFullScreen(
//                     imageFile: !isNetworkImage && displayImagePath != null ? File(displayImagePath!) : null,
//                     imageUrl: isNetworkImage ? displayImagePath : null,
//                     title: title,
//                   ),
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.fullscreen,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ),
            
//             if (hasDocument && isStaffUploaded)
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.edit,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     onPressed: () => _showUploadOptionsDialog(documentType, isEdit: true),
//                     padding: const EdgeInsets.all(8),
//                     constraints: const BoxConstraints(
//                       minWidth: 36,
//                       minHeight: 36,
//                     ),
//                   ),
//                 ),
//               ),

//             if (_isUploading)
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.black.withOpacity(0.7),
//                 ),
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Uploading...',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
            
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               height: 60,
//               child: Container(
//                 decoration: const BoxDecoration(
//                   borderRadius:
//                       BorderRadius.vertical(bottom: Radius.circular(12)),
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.blue,
//                       Colors.white70,
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 6,
//               left: 12,
//               right: 12,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       color: Color.fromARGB(255, 255, 255, 255),
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: statusColor, width: 1),
//                     ),
//                     child: Text(
//                       status,
//                       style: TextStyle(
//                         color: statusColor,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showUploadOptionsDialog(String documentType, {bool isEdit = false}) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       documentType == 'aadhar' ? Icons.credit_card : Icons.directions_car,
//                       color: Colors.indigo.shade700,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'Upload ${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'}',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Please upload both front and back sides',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
                
//                 ListTile(
//                   leading: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.indigo.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.camera_alt,
//                       color: Colors.indigo.shade700,
//                     ),
//                   ),
//                   title: const Text('Upload Front Side'),
//                   subtitle: const Text('Take or select front photo'),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImage(documentType, 'front', isEdit: isEdit);
//                   },
//                 ),
                
//                 const Divider(),
                
//                 ListTile(
//                   leading: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.indigo.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(
//                       Icons.camera_alt,
//                       color: Colors.indigo.shade700,
//                     ),
//                   ),
//                   title: const Text('Upload Back Side'),
//                   subtitle: const Text('Take or select back photo'),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImage(documentType, 'back', isEdit: isEdit);
//                   },
//                 ),
                
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ImageFullScreenViewer extends StatelessWidget {
//   final ImageProvider imageProvider;
//   final String title;

//   const ImageFullScreenViewer({
//     super.key,
//     required this.imageProvider,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: PhotoView(
//         imageProvider: imageProvider,
//         minScale: PhotoViewComputedScale.contained,
//         maxScale: PhotoViewComputedScale.covered * 4.0,
//         initialScale: PhotoViewComputedScale.contained,
//         heroAttributes: PhotoViewHeroAttributes(tag: title),
//         loadingBuilder: (context, event) => const Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//         errorBuilder: (context, error, stackTrace) => const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 color: Colors.white,
//                 size: 64,
//               ),
//               SizedBox(height: 16),
//               Text(
//                 'Failed to load image',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DocumentInfo {
//   final String url;
//   final DateTime uploadedAt;
//   final String status;

//   DocumentInfo({
//     required this.url,
//     required this.uploadedAt,
//     required this.status,
//   });

//   factory DocumentInfo.fromJson(Map<String, dynamic> json) {
//     return DocumentInfo(
//       url: json['url'] ?? '',
//       uploadedAt: json['uploadedAt'] != null 
//           ? DateTime.parse(json['uploadedAt']) 
//           : DateTime.now(),
//       status: json['status'] ?? 'unknown',
//     );
//   }
// }

// class UploadedDocuments {
//   final DocumentInfo? aadharCard;
//   final DocumentInfo? drivingLicense;

//   UploadedDocuments({
//     this.aadharCard,
//     this.drivingLicense,
//   });

//   UploadedDocuments.empty()
//       : aadharCard = null,
//         drivingLicense = null;

//   factory UploadedDocuments.fromJson(Map<String, dynamic>? json) {
//     if (json == null || json.isEmpty) {
//       return UploadedDocuments.empty();
//     }

//     return UploadedDocuments(
//       aadharCard: json['aadharCard'] != null 
//           ? DocumentInfo.fromJson(json['aadharCard']) 
//           : null,
//       drivingLicense: json['drivingLicense'] != null 
//           ? DocumentInfo.fromJson(json['drivingLicense']) 
//           : null,
//     );
//   }

//   bool get hasAnyDocuments => aadharCard != null || drivingLicense != null;
//   bool get hasAllDocuments => aadharCard != null && drivingLicense != null;
// }






























import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
import 'package:car_rental_staff_app/views/pickup_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:photo_view/photo_view.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:convert';

class BookingScreen extends StatefulWidget {
  final String bookingId;

  const BookingScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isUploading = false;
  bool _isValidating = false;
  bool _isCombining = false;
  
  // Front and back files for each document
  File? _aadharFrontFile;
  File? _aadharBackFile;
  File? _licenseFrontFile;
  File? _licenseBackFile;
  
  // Combined images
  File? _aadharCombinedFile;
  File? _licenseCombinedFile;
  
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  
  // Track which documents were uploaded by staff
  Set<String> _staffUploadedDocs = {};

  @override
  void initState() {
    super.initState();
    print('Booking ID: ${widget.bookingId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
    });
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  // Aadhaar validation
  bool _isValidAadhaarDocument(String text) {
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    final aadhaarKeywords = [
      'aadhaar',
      'aadhar',
      'government of india',
      'भारत सरकार',
      'unique identification authority of india',
      'uidai',
    ];
    
    final aadhaarNumberPattern = RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}\b');
    
    bool hasKeyword = aadhaarKeywords.any((keyword) => cleanText.contains(keyword));
    bool hasAadhaarNumber = aadhaarNumberPattern.hasMatch(text);
    
    return hasKeyword || hasAadhaarNumber;
  }

  // Driving License validation
  bool _isValidLicenseDocument(String text) {
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    final licenseKeywords = [
      'driving licence',
      'driving license',
      'dl',
      'transport',
      'motor vehicles',
      'ड्राइविंग लाइसेंस',
      'वाहन',
      'परिवहन',
    ];
    
    final dlNumberPatterns = [
      RegExp(r'\b[A-Z]{2}[0-9]{2}[A-Z0-9]{11,13}\b'),
      RegExp(r'\b[A-Z]{2}-?[0-9]{2}-?[0-9]{4}-?[0-9]{7}\b'),
    ];
    
    bool hasKeyword = licenseKeywords.any((keyword) => cleanText.contains(keyword));
    bool hasValidPattern = dlNumberPatterns.any((pattern) => pattern.hasMatch(text));
    
    return hasKeyword || hasValidPattern;
  }

  // Image quality validation
  bool _isValidImageQuality(File imageFile) {
    try {
      final bytes = imageFile.readAsBytesSync();
      final image = img.decodeImage(bytes);
      
      if (image == null) return false;
      if (image.width < 300 || image.height < 200) return false;
      if (bytes.length < 10000 || bytes.length > 10000000) return false;
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _validateDocument(File imageFile, bool isAadhar) async {
    try {
      setState(() => _isValidating = true);
      
      if (!_isValidImageQuality(imageFile)) {
        _showValidationError('Image quality is too low. Please upload a clear photo.');
        return false;
      }
      
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final extractedText = recognizedText.text;
      
      if (extractedText.isEmpty) {
        _showValidationError('No text found in image. Please upload a clear document photo.');
        return false;
      }
      
      bool isValid = false;
      if (isAadhar) {
        isValid = _isValidAadhaarDocument(extractedText);
        if (!isValid) {
          _showValidationError('This doesn\'t appear to be an Aadhaar card. Please upload a valid Aadhaar document.');
        }
      } else {
        isValid = _isValidLicenseDocument(extractedText);
        if (!isValid) {
          _showValidationError('This doesn\'t appear to be a driving license. Please upload a valid driving license.');
        }
      }
      
      return isValid;
    } catch (e) {
      _showValidationError('Document validation failed. Please try again.');
      return false;
    } finally {
      setState(() => _isValidating = false);
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Combine front and back images
  Future<File> _combineImages(File frontImage, File backImage, String documentType) async {
    try {
      setState(() => _isCombining = true);
      
      final frontBytes = await frontImage.readAsBytes();
      final backBytes = await backImage.readAsBytes();
      
      final frontImg = img.decodeImage(frontBytes)!;
      final backImg = img.decodeImage(backBytes)!;
      
      final maxWidth = frontImg.width > backImg.width ? frontImg.width : backImg.width;
      final resizedFront = img.copyResize(frontImg, width: maxWidth);
      final resizedBack = img.copyResize(backImg, width: maxWidth);
      
      final combinedHeight = resizedFront.height + resizedBack.height + 20;
      final combinedImg = img.Image(width: maxWidth, height: combinedHeight, numChannels: 3);
      
      img.fill(combinedImg, color: img.ColorRgb8(255, 255, 255));
      img.compositeImage(combinedImg, resizedFront, dstX: 0, dstY: 0);
      img.compositeImage(combinedImg, resizedBack, dstX: 0, dstY: resizedFront.height + 20);
      
      final combinedBytes = img.encodeJpg(combinedImg, quality: 85);
      
      final tempDir = Directory.systemTemp;
      final combinedFile = File('${tempDir.path}/${documentType}_combined_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await combinedFile.writeAsBytes(combinedBytes);
      
      setState(() => _isCombining = false);
      
      return combinedFile;
    } catch (e) {
      setState(() => _isCombining = false);
      throw Exception('Failed to combine images: $e');
    }
  }

  void _showImageFullScreen({
    File? imageFile,
    String? imageUrl,
    required String title,
  }) {
    ImageProvider? imageProvider;
    
    if (imageFile != null) {
      imageProvider = FileImage(imageFile);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      imageProvider = NetworkImage(imageUrl);
    }
    
    if (imageProvider == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageFullScreenViewer(
          imageProvider: imageProvider!,
          title: title,
        ),
      ),
    );
  }

  Future<void> _pickImage(String documentType, String side) async {
    try {
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1920,
          maxHeight: 1920,
        );
        
        if (image != null) {
          final imageFile = File(image.path);
          bool isValid = false;
          
          // Skip validation for back side of license
          if (documentType == 'license' && side == 'back') {
            isValid = true;
          } else {
            isValid = await _validateDocument(imageFile, documentType == 'aadhar');
          }
          
          if (isValid) {
            setState(() {
              if (documentType == 'aadhar' && side == 'front') {
                _aadharFrontFile = imageFile;
                _aadharCombinedFile = null; // Reset combined when changing images
              } else if (documentType == 'aadhar' && side == 'back') {
                _aadharBackFile = imageFile;
                _aadharCombinedFile = null;
              } else if (documentType == 'license' && side == 'front') {
                _licenseFrontFile = imageFile;
                _licenseCombinedFile = null;
              } else if (documentType == 'license' && side == 'back') {
                _licenseBackFile = imageFile;
                _licenseCombinedFile = null;
              }
            });
            
            _showSuccessSnackBar('${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} $side side selected successfully');
          }
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  Future<void> _handleCombineAndUpload(String documentType) async {
    try {
      File? combinedFile;
      
      if (documentType == 'aadhar') {
        if (_aadharFrontFile == null || _aadharBackFile == null) {
          _showErrorSnackBar('Please upload both front and back sides');
          return;
        }
        combinedFile = await _combineImages(_aadharFrontFile!, _aadharBackFile!, 'aadhar');
        setState(() {
          _aadharCombinedFile = combinedFile;
        });
      } else {
        if (_licenseFrontFile == null || _licenseBackFile == null) {
          _showErrorSnackBar('Please upload both front and back sides');
          return;
        }
        combinedFile = await _combineImages(_licenseFrontFile!, _licenseBackFile!, 'license');
        setState(() {
          _licenseCombinedFile = combinedFile;
        });
      }
      
      _showSuccessSnackBar('Images combined successfully! Review and upload.');
      
    } catch (e) {
      _showErrorSnackBar('Failed to combine images: $e');
    }
  }

  Future<void> _uploadCombinedDocument(String userId, String documentType) async {
    setState(() {
      _isUploading = true;
    });

    try {
      File? combinedFile;
      
      if (documentType == 'aadhar') {
        combinedFile = _aadharCombinedFile;
      } else {
        combinedFile = _licenseCombinedFile;
      }

      if (combinedFile == null) {
        _showErrorSnackBar('Please combine images first');
        return;
      }

      final result = await _uploadDocumentsAPI(
        userId: userId,
        aadharFile: documentType == 'aadhar' ? combinedFile : null,
        licenseFile: documentType == 'license' ? combinedFile : null,
      );

      await context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
      
      _showSuccessSnackBar('${documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} uploaded successfully!');
      
      setState(() {
        if (documentType == 'aadhar') {
          _aadharFrontFile = null;
          _aadharBackFile = null;
          _aadharCombinedFile = null;
          _staffUploadedDocs.add('aadhar');
        } else {
          _licenseFrontFile = null;
          _licenseBackFile = null;
          _licenseCombinedFile = null;
          _staffUploadedDocs.add('license');
        }
      });
      
    } catch (e) {
      _showErrorSnackBar('Failed to upload document: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<UploadedDocuments> _uploadDocumentsAPI({
    required String userId,
    File? aadharFile,
    File? licenseFile,
  }) async {
    print("Uploading documents for user: $userId");

    const String baseUrl = 'http://194.164.148.244:4062/api/staff';
    final uri = Uri.parse('$baseUrl/upload-documents/$userId');
    final request = http.MultipartRequest('POST', uri);

    MediaType? getMediaType(String path) {
      final ext = path.split('.').last.toLowerCase();
      switch (ext) {
        case 'jpg':
        case 'jpeg':
          return MediaType('image', 'jpeg');
        case 'png':
          return MediaType('image', 'png');
        case 'pdf':
          return MediaType('application', 'pdf');
        default:
          throw Exception('Unsupported file type: $ext');
      }
    }

    if (aadharFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'aadharCard',
          aadharFile.path,
          contentType: getMediaType(aadharFile.path),
        ),
      );
    }

    if (licenseFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'drivingLicense',
          licenseFile.path,
          contentType: getMediaType(licenseFile.path),
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return UploadedDocuments.fromJson(data['documents']);
      } else {
        throw Exception('Failed to upload documents: ${response.body}');
      }
    } catch (e) {
      print("Error uploading documents: $e");
      throw Exception('Error uploading documents: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _navigateToDocumentUploadScreen(String documentType) {
    final provider = context.read<SingleBookingProvider>();
    final booking = provider.currentBooking;
    
    if (booking == null || booking.userId?.id == null) {
      _showErrorSnackBar('Booking data not available');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentUploadScreen(
          documentType: documentType,
          userId: booking.userId!.id,
          bookingId: widget.bookingId,
          aadharFrontFile: _aadharFrontFile,
          aadharBackFile: _aadharBackFile,
          licenseFrontFile: _licenseFrontFile,
          licenseBackFile: _licenseBackFile,
          aadharCombinedFile: _aadharCombinedFile,
          licenseCombinedFile: _licenseCombinedFile,
          onDocumentsUpdated: () {
            // Reload booking data when returning from upload screen
            context.read<SingleBookingProvider>().fetchSingleBooking(widget.bookingId);
          },
        ),
      ),
    );
  }

  void _handleProceed() {
    final provider = context.read<SingleBookingProvider>();
    final booking = provider.currentBooking;

    if (booking == null) {
      _showErrorSnackBar('Booking data not available');
      return;
    }

    List<String> missingDocs = [];
    
    if (booking.userId?.documents?.aadharCard == null || 
        booking.userId?.documents?.aadharCard?.url == null ||
        booking.userId!.documents!.aadharCard!.url!.isEmpty) {
      missingDocs.add('Aadhar Card');
    }
    
    if (booking.userId?.documents?.drivingLicense == null || 
        booking.userId?.documents?.drivingLicense?.url == null ||
        booking.userId!.documents!.drivingLicense!.url!.isEmpty) {
      missingDocs.add('Driving License');
    }

    if (missingDocs.isNotEmpty) {
      _showErrorSnackBar('Please upload all required documents before proceeding');
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PickupDetailsScreen(id: widget.bookingId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<SingleBookingProvider>(
        builder: (context, provider, child) {
          final booking = provider.currentBooking;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        "ID: ${booking?.id.substring(booking.id.length - 4) ?? widget.bookingId.substring(widget.bookingId.length - 4)}",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 0, 0),
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                                        booking?.car?.vehicleNumber ?? 'TS 05 TD 4544',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${booking?.car?.carName ?? 'Hyundai'} ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

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
                                          Icon(
                                              Icons.airline_seat_recline_normal,
                                              size: 16,
                                              color: Colors.grey),
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

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 16, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      Text(
                                        booking?.rentalStartDate ??
                                            '23-03-2025',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.access_time,
                                          size: 16, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      Text(
                                        booking?.to ?? '11:00 AM',
                                        style: const TextStyle(
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

                          const Text(
                            'Uploaded Documents',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _buildDocumentCard(
                            title: 'Aadhar Card',
                            status: booking?.userId?.documents?.aadharCard?.status?.toUpperCase() ?? 'NOT UPLOADED',
                            statusColor: booking?.userId?.documents?.aadharCard?.status == 'verified'
                                ? Colors.green
                                : booking?.userId?.documents?.aadharCard?.status != null
                                    ? Colors.orange
                                    : Colors.red,
                            imageUrl: booking?.userId?.documents?.aadharCard?.url,
                            documentType: 'aadhar',
                          ),

                          const SizedBox(height: 25),

                          _buildDocumentCard(
                            title: 'Driving License',
                            status: booking?.userId?.documents?.drivingLicense?.status?.toUpperCase() ?? 'NOT UPLOADED',
                            statusColor: booking?.userId?.documents?.drivingLicense?.status == 'verified'
                                ? Colors.green
                                : booking?.userId?.documents?.drivingLicense?.status != null
                                    ? Colors.orange
                                    : Colors.red,
                            imageUrl: booking?.userId?.documents?.drivingLicense?.url,
                            documentType: 'license',
                          ),

                          const SizedBox(height: 25),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: _handleProceed,
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
    String? imageUrl,
    required String documentType,
  }) {
    bool hasDocument = imageUrl != null && imageUrl.isNotEmpty;
    bool isStaffUploaded = _staffUploadedDocs.contains(documentType);
    
    // Check if there's a local combined image ready
    File? localCombinedImage;
    if (documentType == 'aadhar' && _aadharCombinedFile != null) {
      localCombinedImage = _aadharCombinedFile;
    } else if (documentType == 'license' && _licenseCombinedFile != null) {
      localCombinedImage = _licenseCombinedFile;
    }
    
    return GestureDetector(
      onTap: () {
        if (hasDocument) {
          _showImageFullScreen(
            imageUrl: imageUrl,
            title: title,
          );
        } else {
          _navigateToDocumentUploadScreen(documentType);
        }
      },
      child: Container(
        width: double.infinity,
        height: 206,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: hasDocument
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : localCombinedImage != null
                  ? DecorationImage(
                      image: FileImage(localCombinedImage),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage('assets/adhar.png'),
                      fit: BoxFit.cover,
                    ),
        ),
        child: Stack(
          children: [
            if (!hasDocument && localCombinedImage == null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.6),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (hasDocument || localCombinedImage != null)
              Positioned(
                top: 12,
                left: 12,
                child: GestureDetector(
                  onTap: () => _showImageFullScreen(
                    imageFile: localCombinedImage,
                    imageUrl: hasDocument ? imageUrl : null,
                    title: title,
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            
            if (hasDocument && isStaffUploaded)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => _navigateToDocumentUploadScreen(documentType),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ),

            if (_isUploading)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.7),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Uploading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(12)),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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
}

class DocumentUploadScreen extends StatefulWidget {
  final String documentType;
  final String userId;
  final String bookingId;
  final File? aadharFrontFile;
  final File? aadharBackFile;
  final File? licenseFrontFile;
  final File? licenseBackFile;
  final File? aadharCombinedFile;
  final File? licenseCombinedFile;
  final VoidCallback onDocumentsUpdated;

  const DocumentUploadScreen({
    Key? key,
    required this.documentType,
    required this.userId,
    required this.bookingId,
    this.aadharFrontFile,
    this.aadharBackFile,
    this.licenseFrontFile,
    this.licenseBackFile,
    this.aadharCombinedFile,
    this.licenseCombinedFile,
    required this.onDocumentsUpdated,
  }) : super(key: key);

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  late File? _frontFile;
  late File? _backFile;
  late File? _combinedFile;
  
  bool _isUploading = false;
  bool _isCombining = false;
  bool _isValidating = false;
  
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    // Initialize with existing files
    _frontFile = widget.documentType == 'aadhar' 
        ? widget.aadharFrontFile 
        : widget.licenseFrontFile;
    _backFile = widget.documentType == 'aadhar' 
        ? widget.aadharBackFile 
        : widget.licenseBackFile;
    _combinedFile = widget.documentType == 'aadhar' 
        ? widget.aadharCombinedFile 
        : widget.licenseCombinedFile;
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  // Aadhaar validation
  bool _isValidAadhaarDocument(String text) {
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    final aadhaarKeywords = [
      'aadhaar',
      'aadhar',
      'government of india',
      'भारत सरकार',
      'unique identification authority of india',
      'uidai',
    ];
    
    final aadhaarNumberPattern = RegExp(r'\b\d{4}[\s-]?\d{4}[\s-]?\d{4}\b');
    
    bool hasKeyword = aadhaarKeywords.any((keyword) => cleanText.contains(keyword));
    bool hasAadhaarNumber = aadhaarNumberPattern.hasMatch(text);
    
    return hasKeyword || hasAadhaarNumber;
  }

  // Driving License validation
  bool _isValidLicenseDocument(String text) {
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    final licenseKeywords = [
      'driving licence',
      'driving license',
      'dl',
      'transport',
      'motor vehicles',
      'ड्राइविंग लाइसेंस',
      'वाहन',
      'परिवहन',
    ];
    
    final dlNumberPatterns = [
      RegExp(r'\b[A-Z]{2}[0-9]{2}[A-Z0-9]{11,13}\b'),
      RegExp(r'\b[A-Z]{2}-?[0-9]{2}-?[0-9]{4}-?[0-9]{7}\b'),
    ];
    
    bool hasKeyword = licenseKeywords.any((keyword) => cleanText.contains(keyword));
    bool hasValidPattern = dlNumberPatterns.any((pattern) => pattern.hasMatch(text));
    
    return hasKeyword || hasValidPattern;
  }

  Future<bool> _validateDocument(File imageFile, bool isAadhar) async {
    try {
      setState(() => _isValidating = true);
      
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final extractedText = recognizedText.text;
      
      if (extractedText.isEmpty) {
        _showError('No text found in image. Please upload a clear document photo.');
        return false;
      }
      
      bool isValid = false;
      if (isAadhar) {
        isValid = _isValidAadhaarDocument(extractedText);
        if (!isValid) {
          _showError('This doesn\'t appear to be an Aadhaar card. Please upload a valid Aadhaar document.');
        }
      } else {
        isValid = _isValidLicenseDocument(extractedText);
        if (!isValid) {
          _showError('This doesn\'t appear to be a driving license. Please upload a valid driving license.');
        }
      }
      
      return isValid;
    } catch (e) {
      _showError('Document validation failed. Please try again.');
      return false;
    } finally {
      setState(() => _isValidating = false);
    }
  }

  Future<void> _pickImage(String side) async {
    try {
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source != null) {
        final XFile? image = await _picker.pickImage(
          source: source,
          imageQuality: 80,
          maxWidth: 1920,
          maxHeight: 1920,
        );
        
        if (image != null) {
          final imageFile = File(image.path);
          bool isValid = false;
          
          // Skip validation for back side of license
          if (widget.documentType == 'license' && side == 'back') {
            isValid = true;
          } else {
            isValid = await _validateDocument(imageFile, widget.documentType == 'aadhar');
          }
          
          if (isValid) {
            setState(() {
              if (side == 'front') {
                _frontFile = imageFile;
                _combinedFile = null; // Reset combined when changing images
              } else if (side == 'back') {
                _backFile = imageFile;
                _combinedFile = null;
              }
            });
            
            _showSuccess('${widget.documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} $side side selected successfully');
          }
        }
      }
    } catch (e) {
      _showError('Error picking image: $e');
    }
  }

  Future<void> _combineImages() async {
    try {
      if (_frontFile == null || _backFile == null) {
        _showError('Please upload both front and back sides');
        return;
      }

      setState(() => _isCombining = true);
      
      final frontBytes = await _frontFile!.readAsBytes();
      final backBytes = await _backFile!.readAsBytes();
      
      final frontImg = img.decodeImage(frontBytes)!;
      final backImg = img.decodeImage(backBytes)!;
      
      final maxWidth = frontImg.width > backImg.width ? frontImg.width : backImg.width;
      final resizedFront = img.copyResize(frontImg, width: maxWidth);
      final resizedBack = img.copyResize(backImg, width: maxWidth);
      
      final combinedHeight = resizedFront.height + resizedBack.height + 20;
      final combinedImg = img.Image(width: maxWidth, height: combinedHeight, numChannels: 3);
      
      img.fill(combinedImg, color: img.ColorRgb8(255, 255, 255));
      img.compositeImage(combinedImg, resizedFront, dstX: 0, dstY: 0);
      img.compositeImage(combinedImg, resizedBack, dstX: 0, dstY: resizedFront.height + 20);
      
      final combinedBytes = img.encodeJpg(combinedImg, quality: 85);
      
      final tempDir = Directory.systemTemp;
      final combinedFile = File('${tempDir.path}/${widget.documentType}_combined_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await combinedFile.writeAsBytes(combinedBytes);
      
      setState(() {
        _combinedFile = combinedFile;
        _isCombining = false;
      });
      
      _showSuccess('Images combined successfully! Review and upload.');
      
    } catch (e) {
      setState(() => _isCombining = false);
      _showError('Failed to combine images: $e');
    }
  }

  Future<void> _uploadDocument() async {
    if (_combinedFile == null) {
      _showError('Please combine images first');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final result = await _uploadDocumentsAPI(
        userId: widget.userId,
        aadharFile: widget.documentType == 'aadhar' ? _combinedFile : null,
        licenseFile: widget.documentType == 'license' ? _combinedFile : null,
      );

      // Call the callback to update parent
      widget.onDocumentsUpdated();
      
      _showSuccess('${widget.documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'} uploaded successfully!');
      
      // Navigate back
      Navigator.pop(context);
      
    } catch (e) {
      _showError('Failed to upload document: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<UploadedDocuments> _uploadDocumentsAPI({
    required String userId,
    File? aadharFile,
    File? licenseFile,
  }) async {
    print("Uploading documents for user: $userId");

    const String baseUrl = 'http://194.164.148.244:4062/api/staff';
    final uri = Uri.parse('$baseUrl/upload-documents/$userId');
    final request = http.MultipartRequest('POST', uri);

    MediaType? getMediaType(String path) {
      final ext = path.split('.').last.toLowerCase();
      switch (ext) {
        case 'jpg':
        case 'jpeg':
          return MediaType('image', 'jpeg');
        case 'png':
          return MediaType('image', 'png');
        case 'pdf':
          return MediaType('application', 'pdf');
        default:
          throw Exception('Unsupported file type: $ext');
      }
    }

    if (aadharFile != null) {
      print("kkkkkkkkkkkkkkkkkkkkkk${aadharFile.path}");
      request.files.add(
        await http.MultipartFile.fromPath(
          'aadharCard',
          aadharFile.path,
          contentType: getMediaType(aadharFile.path),
        ),
      );
    }

    if (licenseFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'drivingLicense',
          licenseFile.path,
          contentType: getMediaType(licenseFile.path),
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return UploadedDocuments.fromJson(data['documents']);
      } else {
        throw Exception('Failed to upload documents: ${response.body}');
      }
    } catch (e) {
      print("Error uploading documents: $e");
      throw Exception('Error uploading documents: $e');
    }
  }

  void _showImageFullScreen(File? imageFile, String title) {
    if (imageFile == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageFullScreenViewer(
          imageProvider: FileImage(imageFile),
          title: title,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasCompleteImages = _frontFile != null && _backFile != null;
    bool hasCombined = _combinedFile != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload ${widget.documentType == 'aadhar' ? 'Aadhar Card' : 'Driving License'}'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Front Side
            Text(
              'Front Side',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickImage('front'),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: _frontFile != null ? Colors.green : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: _frontFile != null ? Colors.green.shade50 : Colors.grey[50],
                ),
                child: _frontFile != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(
                              _frontFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 20),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: IconButton(
                              onPressed: () {
                                _showImageFullScreen(_frontFile, 'Front Side');
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.fullscreen, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, color: Colors.grey, size: 50),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to upload front side',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),
            
            if (_frontFile != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _frontFile = null;
                    _combinedFile = null;
                  });
                },
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                label: const Text('Remove Front', style: TextStyle(color: Colors.red, fontSize: 14)),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Back Side
            Text(
              'Back Side',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickImage('back'),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: _backFile != null ? Colors.green : Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: _backFile != null ? Colors.green.shade50 : Colors.grey[50],
                ),
                child: _backFile != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.file(
                              _backFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 20),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: IconButton(
                              onPressed: () {
                                _showImageFullScreen(_backFile, 'Back Side');
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.fullscreen, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, color: Colors.grey, size: 50),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to upload back side',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),
            
            if (_backFile != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _backFile = null;
                    _combinedFile = null;
                  });
                },
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                label: const Text('Remove Back', style: TextStyle(color: Colors.red, fontSize: 14)),
              ),
            ],
            
            // Combine Button
            if (hasCompleteImages && !hasCombined) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isCombining ? null : _combineImages,
                icon: _isCombining 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.merge_type, size: 24),
                label: Text(
                  _isCombining ? 'Combining...' : 'Combine Images',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
            
            // Combined Image Preview
            if (hasCombined) ...[
              const SizedBox(height: 32),
              Text(
                'Combined Preview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  _showImageFullScreen(_combinedFile, 'Combined Document');
                },
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _combinedFile!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _combinedFile = null;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Recombine Images', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadDocument,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Upload Document',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
            
            if (_isValidating)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Validating document...',
                        style: TextStyle(fontSize: 14),
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
}

class ImageFullScreenViewer extends StatelessWidget {
  final ImageProvider imageProvider;
  final String title;

  const ImageFullScreenViewer({
    super.key,
    required this.imageProvider,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: PhotoView(
        imageProvider: imageProvider,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4.0,
        initialScale: PhotoViewComputedScale.contained,
        heroAttributes: PhotoViewHeroAttributes(tag: title),
        loadingBuilder: (context, event) => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentInfo {
  final String url;
  final DateTime uploadedAt;
  final String status;

  DocumentInfo({
    required this.url,
    required this.uploadedAt,
    required this.status,
  });

  factory DocumentInfo.fromJson(Map<String, dynamic> json) {
    return DocumentInfo(
      url: json['url'] ?? '',
      uploadedAt: json['uploadedAt'] != null 
          ? DateTime.parse(json['uploadedAt']) 
          : DateTime.now(),
      status: json['status'] ?? 'unknown',
    );
  }
}

class UploadedDocuments {
  final DocumentInfo? aadharCard;
  final DocumentInfo? drivingLicense;

  UploadedDocuments({
    this.aadharCard,
    this.drivingLicense,
  });

  UploadedDocuments.empty()
      : aadharCard = null,
        drivingLicense = null;

  factory UploadedDocuments.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return UploadedDocuments.empty();
    }

    return UploadedDocuments(
      aadharCard: json['aadharCard'] != null 
          ? DocumentInfo.fromJson(json['aadharCard']) 
          : null,
      drivingLicense: json['drivingLicense'] != null 
          ? DocumentInfo.fromJson(json['drivingLicense']) 
          : null,
    );
  }

  bool get hasAnyDocuments => aadharCard != null || drivingLicense != null;
  bool get hasAllDocuments => aadharCard != null && drivingLicense != null;
}