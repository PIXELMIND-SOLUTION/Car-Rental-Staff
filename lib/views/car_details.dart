
import 'dart:typed_data';

import 'package:car_rental_staff_app/providers/single_booking_provider.dart';
import 'package:car_rental_staff_app/views/all_bookings_screen.dart';
import 'package:car_rental_staff_app/views/booking_detail_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CarDetails extends StatefulWidget {
  final String? bookingId; // Add optional booking ID parameter
  
  const CarDetails({super.key, this.bookingId});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  // Add controller for OTP fields
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  // Flag to control OTP dialog visibility
  bool _showOtpDialog = false;

  // Add image picker and list to store captured images
  final ImagePicker _picker = ImagePicker();
  List<File> _capturedImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // If booking ID is provided, you can access the current booking from provider
    // The booking should already be loaded from the previous screen
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes when widget is disposed
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
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
          _capturedImages.add(File(photo.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e')),
      );
    }
  }

  // Function to delete image
  void _deleteImage(int index) {
    setState(() {
      _capturedImages.removeAt(index);
    });
  }

  // Function to upload images to API
  Future<bool> _uploadImages(String bookingId) async {
    if (_capturedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture at least one image')),
      );
      return false;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      var uri = Uri.parse('http://194.164.148.244:4062/api/staff/carimagesbeforepickup/$bookingId');
      var request = http.MultipartRequest('POST', uri);

      // Add all captured images to the request
      for (int i = 0; i < _capturedImages.length; i++) {
        var multipartFile = await http.MultipartFile.fromPath(
          'carImages',
          _capturedImages[i].path,
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

      setState(() {
        _isUploading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Images uploaded successfully')),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<SingleBookingProvider>(
      builder: (context, bookingProvider, child) {
        final booking = bookingProvider.currentBooking;
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // Main content
              SingleChildScrollView(
                child: Column(
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
                            "Car Details",
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
                      height: 25,
                    ),
                    Image.network(
                      '${booking?.car?.carImage[0]}',
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 263,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        height: 200,
                        child: Icon(Icons.error, size: screenWidth * 0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Car Images",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(height: 20),

                          _buildImageUploadCard(booking?.car?.carImage[0]),

                          SizedBox(
                            height: 20,
                          ),

                          // Display captured images as document cards
                          ..._capturedImages.asMap().entries.map((entry) {
                            int index = entry.key;
                            File image = entry.value;
                            return Column(
                              children: [
                                _buildCapturedImageCard(image, index),
                                const SizedBox(height: 15),
                              ],
                            );
                          }).toList(),

                          // Show default document card if no images captured
                          if (_capturedImages.isEmpty)
                            _buildDocumentCard(title: 'Aadhar Card'),
                          
                          SizedBox(
                            height: 25,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isUploading ? null : () async {
                                // First upload images, then show OTP dialog
                                String bookingId = booking?.id.toString() ?? '';
                                if (bookingId.isNotEmpty) {
                                  bool uploadSuccess = await _uploadImages(bookingId);
                                  if (uploadSuccess) {
                                    setState(() {
                                      _showOtpDialog = true;
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Booking ID not found')),
                                  );
                                }
                              },
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
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // OTP verification overlay with blur effect
              if (_showOtpDialog)
                BackdropFilter(
                  filter:
                      ImageFilter.blur(sigmaX: 15, sigmaY: 15), // increased blur
                  child: Container(
                    color: Color(0XFFFFFF).withOpacity(0.2),
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: _buildOtpVerificationCard(context, booking),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  // Widget to display individual captured image as document card
  Widget _buildCapturedImageCard(File imageFile, int index) {
    return Container(
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
              onTap: () => _deleteImage(index),
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

  Widget _buildOtpVerificationCard(BuildContext context, booking) {
    return Container(
      width: 343,
      height: 345,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Pickup otp verification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => _buildOtpTextField(index),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _verifyOtp(booking);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3182CE),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpTextField(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          }
        },
      ),
    );
  }


  
Future<void> _verifyOtp(booking) async {
  // Get OTP from controllers
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
    // Get user ID from booking data
    print('helooooooooooooooooooooooooooooooooenteredotp$enteredOtp');
    int sendOtp = int.parse(enteredOtp);
    String bookingId = booking?.id.toString() ?? '';
    print('heloooooooooooooooooooooooooooooooo$bookingId');

    if (bookingId.isEmpty) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking ID not found in booking data')),
      );
      return;
    }

    // Make API call to verify OTP
    final response = await http.post(
      Uri.parse('http://194.164.148.244:4062/api/staff/verify-otp/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        // Add authorization header if needed
        // 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'otp': sendOtp,
      }),
    );

    print('qwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwqwwwwwwwwwwwwwwwwwwwwwww${json.decode(response.body)}');
    
    if (response.statusCode == 200) {
      // OTP verification successful
      final responseData = json.decode(response.body);
      
      // Extract deposit PDF URL from response
      String? depositPdfPath = responseData['depositPDF'];
      if (depositPdfPath != null) {
        String fullPdfUrl = 'http://194.164.148.244:4062$depositPdfPath';
        print('PDF URL: $fullPdfUrl');
        
        // Download PDF before navigation
        await _downloadPdfToDownloads(fullPdfUrl, bookingId);
      }
      
      Navigator.pop(context); // Close loading dialog
      
      // Update booking status to 'picked_up'
      final bookingProvider = context.read<SingleBookingProvider>();
      if (booking?.id != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllBookingsScreen()),
        );
      } else {
        // If no booking ID, just navigate (fallback)
        setState(() {
          _showOtpDialog = false;
        });
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllBookingsScreen()),
        );
      }
    } else if (response.statusCode == 400) {
      Navigator.pop(context); // Close loading dialog
      // Invalid OTP
      final errorData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorData['message'] ?? 'Invalid OTP')),
      );
    } else if (response.statusCode == 404) {
      Navigator.pop(context); // Close loading dialog
      // User not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
    } else {
      Navigator.pop(context); // Close loading dialog
      // Other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed. Status code: ${response.statusCode}')),
      );
    }
  } catch (e) {
    Navigator.pop(context); // Close loading dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error: $e')),
    );
  }
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

  Widget _buildImageUploadCard(String? image) {
    return GestureDetector(
      onTap: _takePhoto,
      child: Container(
        height: 206,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image:  DecorationImage(
            image: NetworkImage('$image'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Light black overlay on top of the image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.7),
              ),
            ),

            // Center icon
            Center(
              child: _buildImageOption(icon: Icons.camera_alt),
            ),

            // Bottom gradient (optional)
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
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
  }) {
    return GestureDetector(
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
        ],
      ),
    );
  }
}