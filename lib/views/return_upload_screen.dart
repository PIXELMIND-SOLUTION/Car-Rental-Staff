// import 'dart:ui';
// import 'package:car_rental_staff_app/views/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class ReturnUploadScreen extends StatefulWidget {
//   final String id;

//   const ReturnUploadScreen({
//     super.key,
//     required this.id,
//   });

//   @override
//   State<ReturnUploadScreen> createState() => _ReturnUploadScreenState();
// }

// class _ReturnUploadScreenState extends State<ReturnUploadScreen> {
//     final List<TextEditingController> _otpControllers =
//       List.generate(4, (index) => TextEditingController());
//   bool showOtpOverlay = false;

//   final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());


//   @override
//   void dispose() {
//     for (var controller in _otpControllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _showOtpVerification() {
//     setState(() {
//       showOtpOverlay = true;
//     });
//   }

//   void _verifyOtp() {
//     String otp = _otpControllers.map((controller) => controller.text).join();
//     print("llllllllllllllllllllll$otp");
    
//     // Check if OTP is valid (example: 4 digits)
//     if (otp.length == 4 && otp == '1234') {
//       Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
//       setState(() {
//         showOtpOverlay = false;
//       });
      
//       // Additional logic after verification (e.g., navigate to next screen)
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
//     } else {
//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid OTP')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // Main Content
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 50,
//                   ),
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
//                           "id: #1234",
//                           style: TextStyle(
//                             color: const Color.fromARGB(255, 255, 0, 0),
//                             fontSize: screenWidth * 0.045,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Card(
//                     elevation: 1,
//                     color: const Color(0XFFFFFFFF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       side: BorderSide(color: Colors.grey.shade200),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'TS 05 TD 4544',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.red.shade700,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: const [
//                               Text(
//                                 'Hyundai Verna',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),

//                           // Automatic & Seaters Row
//                           Row(
//                             children: [
//                               const Icon(Icons.settings,
//                                   size: 16, color: Colors.grey),
//                               const SizedBox(width: 4),
//                               const Text(
//                                 'Automatic',
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Row(
//                                 children: const [
//                                   Icon(Icons.airline_seat_recline_normal,
//                                       size: 16, color: Colors.grey),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     '5 Seaters',
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),

//                           // Date & Time Row
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: const [
//                               Icon(Icons.calendar_today,
//                                   size: 16, color: Colors.blue),
//                               SizedBox(width: 4),
//                               Text(
//                                 '23-03-2025',
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                               SizedBox(width: 16),
//                               Icon(Icons.access_time,
//                                   size: 16, color: Colors.blue),
//                               SizedBox(width: 4),
//                               Text(
//                                 '11:00 AM',
//                                 style: TextStyle(
//                                   color: Colors.black87,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 30),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Pickup Photos',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Security deposit section
//                   const Text(
//                     'Return Upload',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 2,
//                     childAspectRatio: 1.5,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     children: List.generate(
//                       4,
//                       (index) => _buildDocumentCard(
//                         title: 'Aadhar card',
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),

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
//                             onTap: () {},
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: _buildImageOption(
//                             icon: Icons.file_upload_outlined,
//                             title: 'Upload',
//                             subtitle: 'Bike Front & Back',
//                             onTap: () {},
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // ID cards
//                   _buildDocumentCard(
//                     title: 'Aadhar Card',
//                   ),

//                   const SizedBox(height: 25),

//                   _buildDocumentCard(
//                     title: 'Aadhar card',
//                   ),

//                   SizedBox(height: 25),

//                   // Next button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _showOtpVerification,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF120698),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         'Proceed',
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
//           ),

//           // OTP Verification Overlay
//           if (showOtpOverlay)
//             buildOtpVerificationDialog(
//                 context, _otpControllers, _focusNodes, _verifyOtp)
//         ],
//       ),
//     );
//   }

//   Widget buildOtpVerificationDialog(
//       BuildContext context,
//       List<TextEditingController> otpControllers,
//       List<FocusNode> otpFocusNodes,
//       VoidCallback onVerify) {
//     return Positioned.fill(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(
//             sigmaX: 10, sigmaY: 10), // increased blur for softer effect
//         child: Container(
//           color: Colors.black.withOpacity(0.3), // slightly darker shade
//           child: Center(
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.85,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.15), // glass effect
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 25, // stronger blur on shadow
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Return otp verification',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(
//                           4,
//                           (index) => Container(
//                             width: 50,
//                             height: 50,
//                             margin: const EdgeInsets.symmetric(horizontal: 6),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(6),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.15),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: TextField(
//                                 controller: _otpControllers[index],
//                                 focusNode: _focusNodes[index],
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.zero,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 keyboardType: TextInputType.number,
//                                 style: const TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(1),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                                 onChanged: (value) {
//                                   if (value.isNotEmpty && index < 3) {
//                                     otpFocusNodes[index].unfocus();
//                                     FocusScope.of(context)
//                                         .requestFocus(otpFocusNodes[index + 1]);
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: onVerify,
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.zero,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ).copyWith(
//                             backgroundColor:
//                                 MaterialStateProperty.resolveWith<Color>(
//                               (Set<MaterialState> states) {
//                                 return Colors.transparent;
//                               },
//                             ),
//                             shadowColor:
//                                 MaterialStateProperty.all(Colors.transparent),
//                             elevation: MaterialStateProperty.all(0),
//                           ),
//                           child: Ink(
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF003082), Color(0xFF0071BC)],
//                                 begin: Alignment.centerLeft,
//                                 end: Alignment.centerRight,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Container(
//                               alignment: Alignment.center,
//                               child: const Text(
//                                 'Verify',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required IconData icon,
//     required String label,
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
//   }) {
//     return Container(
//       width: double.infinity,
//       height: 206,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         image: const DecorationImage(
//           image: AssetImage('assets/adhar.png'), // your background image
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Gradient overlay at bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: 60,
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius:
//                     BorderRadius.vertical(bottom: Radius.circular(12)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






import 'dart:ui';
import 'dart:io';
import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
import 'package:car_rental_staff_app/views/home_screen.dart';
import 'package:car_rental_staff_app/views/main_layout.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';


class ReturnUploadScreen extends StatefulWidget {
  final String id;

  const ReturnUploadScreen({
    super.key,
    required this.id,
  });

  @override
  State<ReturnUploadScreen> createState() => _ReturnUploadScreenState();
}

class _ReturnUploadScreenState extends State<ReturnUploadScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  bool showOtpOverlay = false;
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Image picker and captured images for return upload
  final ImagePicker _picker = ImagePicker();
  List<File> _capturedReturnImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Fetch booking data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SingleBookingProvider>().fetchSingleBooking(widget.id);
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }


  
// Function to download PDF and save to public Downloads folder
Future<void> _downloadPdfToDownloads(String pdfUrl, String bookingId) async {
  try {
    // Request storage permission
    bool hasPermission = await _requestStoragePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied. Cannot download PDF.')),
      );
      return;
    }

    // Create Dio instance for downloading
    Dio dio = Dio();
    
    String fileName = 'deposit_receipt_${bookingId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    String filePath;
    
    if (Platform.isAndroid) {
      // For Android - save to public Downloads directory
      filePath = '/storage/emulated/0/Download/$fileName';
      
      // Alternative paths to try if the first one fails
      List<String> possiblePaths = [
        '/storage/emulated/0/Download/$fileName',
        '/sdcard/Download/$fileName',
        '/storage/sdcard0/Download/$fileName',
      ];
      
      // Try to create the Downloads directory if it doesn't exist
      for (String path in possiblePaths) {
        try {
          Directory downloadsDir = Directory(path.substring(0, path.lastIndexOf('/')));
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          filePath = path;
          break;
        } catch (e) {
          print('Failed to create directory for path: $path');
          continue;
        }
      }
    } else if (Platform.isIOS) {
      // For iOS, save to app documents directory (iOS doesn't have a public Downloads folder)
      Directory appDocDir = await getApplicationDocumentsDirectory();
      filePath = '${appDocDir.path}/$fileName';
    } else {
      throw Exception('Unsupported platform');
    }

    print('Attempting to save PDF to: $filePath');

    // Show downloading progress
    _showDownloadProgress();

    // Download the file
    await dio.download(
      pdfUrl,
      filePath,
      options: Options(
        receiveTimeout: const Duration(minutes: 5),
        sendTimeout: const Duration(minutes: 5),
        headers: {
          'Accept': 'application/pdf',
          'User-Agent': 'Mozilla/5.0 (Android; Mobile)',
        },
      ),
      onReceiveProgress: (received, total) {
        if (total != -1) {
          double progress = received / total;
          print('Download progress: ${(progress * 100).toStringAsFixed(0)}%');
        }
      },
    );

    // Hide download progress
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // Verify the file was downloaded successfully
    File downloadedFile = File(filePath);
    bool fileExists = await downloadedFile.exists();
    
    if (!fileExists) {
      throw Exception('File was not created at expected location');
    }

    int fileSize = await downloadedFile.length();
    if (fileSize == 0) {
      throw Exception('Downloaded file is empty');
    }

    print('File downloaded successfully: $filePath (Size: $fileSize bytes)');

    // For Android, add the file to MediaStore so it appears in file managers
    if (Platform.isAndroid) {
      await _addToMediaStore(filePath, fileName);
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF saved to Downloads'),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Show Location',
          onPressed: () => _showFileLocation(fileName),
        ),
      ),
    );

  } catch (e) {
    // Hide download progress if showing
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    
    print('Error downloading PDF: $e');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download failed: ${e.toString()}'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => _downloadPdfToDownloads(pdfUrl, bookingId),
        ),
      ),
    );
  }
}

// Show file location instead of trying to open
void _showFileLocation(String fileName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('PDF Downloaded'),
      content: Text(
        'Your receipt has been saved to:\n\n'
        'Downloads > $fileName\n\n'
        'You can find it in your phone\'s Downloads folder using any file manager app.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// Add file to Android MediaStore so it appears in file managers
Future<void> _addToMediaStore(String filePath, String fileName) async {
  try {
    if (Platform.isAndroid) {
      // Use method channel to add file to MediaStore
      const platform = MethodChannel('file_operations');
      await platform.invokeMethod('addToMediaStore', {
        'filePath': filePath,
        'fileName': fileName,
        'mimeType': 'application/pdf'
      });
    }
  } catch (e) {
    print('Error adding to MediaStore: $e');
    // This is not critical, file should still be accessible
  }
}

// Improved permission handling for different Android versions
Future<bool> _requestStoragePermission() async {
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;
    
    print('Android SDK version: $sdkInt');
    
    if (sdkInt >= 33) {
      // Android 13+ (API 33+) - Scoped storage, no special permission needed for Downloads
      return true;
    } else if (sdkInt >= 30) {
      // Android 11-12 (API 30-32) - Need MANAGE_EXTERNAL_STORAGE
      var status = await Permission.manageExternalStorage.status;
      if (status.isDenied) {
        status = await Permission.manageExternalStorage.request();
      }
      
      if (status.isDenied) {
        // Fallback to regular storage permission
        var storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      }
      return status.isGranted;
    } else {
      // Android 10 and below - Use regular storage permission
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }
  return true; // iOS or other platforms
}

// Open the downloaded PDF file
Future<void> _openPdfFile(String filePath) async {
  try {
    // Try to open with default PDF viewer
    OpenResult result = await OpenFile.open(filePath);
    
    if (result.type == ResultType.done) {
      print('PDF opened successfully');
    } else {
      String errorMessage = 'Failed to open PDF';
      
      switch (result.type) {
        case ResultType.noAppToOpen:
          errorMessage = 'No PDF viewer found. Please install a PDF reader app.';
          break;
        case ResultType.fileNotFound:
          errorMessage = 'PDF file not found';
          break;
        case ResultType.permissionDenied:
          errorMessage = 'Permission denied to open PDF';
          break;
        case ResultType.error:
          errorMessage = 'Error opening PDF: ${result.message}';
          break;
        default:
          errorMessage = 'Unknown error opening PDF';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    print('Error opening PDF: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error opening PDF: $e')),
    );
  }
}

// Alternative method using SAF (Storage Access Framework) for Android 10+
Future<void> _downloadUsingSAF(String pdfUrl, String bookingId) async {
  try {
    if (!Platform.isAndroid) return;
    
    // Use SAF to let user choose where to save
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    
    if (directoryPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No directory selected')),
      );
      return;
    }
    
    String fileName = 'deposit_receipt_${bookingId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    String filePath = '$directoryPath/$fileName';
    
    // Download using Dio
    Dio dio = Dio();
    _showDownloadProgress();
    
    await dio.download(pdfUrl, filePath);
    
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to: $directoryPath')),
    );
    
  } catch (e) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    print('SAF download error: $e');
  }
}




void _showDownloadProgress() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Downloading PDF...'),
          ],
        ),
      );
    },
  );
}


  // Function to take photo from camera
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );
      
      if (photo != null) {
        setState(() {
          _capturedReturnImages.add(File(photo.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _capturedReturnImages.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Function to delete image
  void _deleteReturnImage(int index) {
    setState(() {
      _capturedReturnImages.removeAt(index);
    });
  }

  // Function to upload return images to API
  Future<bool> _uploadReturnImages() async {
    if (_capturedReturnImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture at least one return image')),
      );
      return false;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      print("pppppppppppppppppppppppppppppppppppppppppppppppp${widget.id}");
      var uri = Uri.parse('http://194.164.148.244:4062/api/staff/carreturnimages/${widget.id}');
      var request = http.MultipartRequest('POST', uri);

      // Add all captured return images to the request
      for (int i = 0; i < _capturedReturnImages.length; i++) {
        var multipartFile = await http.MultipartFile.fromPath(
          'carReturnImages',
          _capturedReturnImages[i].path,
        );
        request.files.add(multipartFile);
      }

      // Add headers if needed
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        // Add authorization header if needed
        // 'Authorization': 'Bearer $token',
      });

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('llllllllllllllllllllllllllllllllllll$responseBody');

      setState(() {
        _isUploading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Return images uploaded successfully')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload images. Status: ${response.statusCode}')),
        );
        return false;
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
      return false;
    }
  }

  void _showOtpVerification() async {
    // First upload images, then show OTP dialog
    bool uploadSuccess = await _uploadReturnImages();
    if (uploadSuccess) {
      setState(() {
        showOtpOverlay = true;
      });
    }
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _otpControllers.map((controller) => controller.text).join();
    
    // Validate OTP length
    if (enteredOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 4-digit OTP')),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      
if (enteredOtp is String) {
  print('OTP is a String: $enteredOtp');
}

if (enteredOtp is int) {
  print('OTP is an Integer: $enteredOtp');
} else {
  print('OTP is not an Integer');
}

            

      // Make API call to verify return OTP
      final response = await http.post(
        Uri.parse('http://194.164.148.244:4062/api/staff/verify-return-otp/${widget.id}'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization header if needed
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'returnOTP': enteredOtp,
        }),
      );

      Navigator.pop(context); // Close loading dialog
      print('Return OTP verification status: ${response.body}');
      
      if (response.statusCode == 200) {
        // OTP verification successful
        final responseData = json.decode(response.body);
        print('Return OTP verification successful: $responseData');

              String? depositPdfPath = responseData['depositPDF'];
      if (depositPdfPath != null) {
        String fullPdfUrl = 'http://194.164.148.244:4062$depositPdfPath';
        print('PDF URL: $fullPdfUrl');
        
        // Download PDF before navigation
        await _downloadPdfToDownloads(fullPdfUrl, widget.id);
      }
        
        setState(() {
          showOtpOverlay = false;
        });
        
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
        
      } else if (response.statusCode == 400) {
        // Invalid OTP
        final errorData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? 'Invalid OTP')),
        );
      } else if (response.statusCode == 404) {
        // Booking not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking not found')),
        );
      } else {
        // Other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      print('Return OTP verification error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
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
          // Show loading indicator
          if (bookingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message
          if (bookingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${bookingProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bookingProvider.fetchSingleBooking(widget.id);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final booking = bookingProvider.currentBooking;

          return Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
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
                              "id: #${booking?.id != null ? booking!.id.substring(booking!.id.length - 4) : widget.id.substring(widget.id.length - 4)}",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 0, 0),
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      
                      // Car Details Card
                      _buildCarDetailsCard(booking, screenWidth),
                      
                      SizedBox(height: 30),
                      const SizedBox(height: 10),
                      const Text(
                        'Pickup Photos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Display pickup photos from booking data
                      _buildPickupPhotosGrid(booking),

                      const SizedBox(height: 30),
                      const Text(
                        'Return Upload',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                                subtitle: 'Car Front & Back',
                                onTap: _takePhoto,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildImageOption(
                                icon: Icons.file_upload_outlined,
                                title: 'Upload',
                                subtitle: 'Car Front & Back',
                                onTap: _pickImage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Display captured return images as individual document cards
                      ..._capturedReturnImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        File image = entry.value;
                        return Column(
                          children: [
                            _buildCapturedReturnImageCard(image, index),
                            const SizedBox(height: 25),
                          ],
                        );
                      }).toList(),

                      // Show default document card if no images captured
                      if (_capturedReturnImages.isEmpty)
                        _buildDocumentCard(title: 'Return Image'),

                      const SizedBox(height: 25),

                      SizedBox(height: 25),

                      // Next button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _showOtpVerification,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF120698),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isUploading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Proceed',
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

              // OTP Verification Overlay
              if (showOtpOverlay)
                buildOtpVerificationDialog(
                    context, _otpControllers, _focusNodes, _verifyOtp)
            ],
          );
        },
      ),
    );
  }

  Widget _buildCarDetailsCard(booking, double screenWidth) {
    return Card(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking?.car?.carName ?? 'Hyundai Verna',
                  style: const TextStyle(
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
                Text(
                  booking?.car?.type ?? 'Automatic',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(Icons.airline_seat_recline_normal,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${booking?.car?.seats ?? 5} Seaters',
                      style: const TextStyle(
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
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  booking?.rentalEndDate ?? '23-03-2025',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.blue),
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
    );
  }

  Widget _buildPickupPhotosGrid(booking) {
    final pickupImages = booking?.carImagesBeforePickup ?? [];
    
    if (pickupImages.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 50, color: Colors.grey.shade500),
              const SizedBox(height: 8),
              Text(
                'No pickup photos available',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: pickupImages.length,
      itemBuilder: (context, index) {
        final image = pickupImages[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image.url ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.error, size: 40),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget to display individual captured return image as document card
  Widget _buildCapturedReturnImageCard(File imageFile, int index) {
    return Container(
      width: double.infinity,
      height: 206,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: FileImage(imageFile),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Delete button in top right corner
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _deleteReturnImage(index),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
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

  Widget buildOtpVerificationDialog(
      BuildContext context,
      List<TextEditingController> otpControllers,
      List<FocusNode> otpFocusNodes,
      VoidCallback onVerify) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 10, sigmaY: 10), // increased blur for softer effect
        child: Container(
          color: Colors.black.withOpacity(0.3), // slightly darker shade
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // glass effect
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 25, // stronger blur on shadow
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Return otp verification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: TextField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 3) {
                                    otpFocusNodes[index].unfocus();
                                    FocusScope.of(context)
                                        .requestFocus(otpFocusNodes[index + 1]);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: onVerify,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ).copyWith(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                return Colors.transparent;
                              },
                            ),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF003082), Color(0xFF0071BC)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
        color: Colors.grey.shade300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 50,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 8),
          Text(
            'No return images yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}