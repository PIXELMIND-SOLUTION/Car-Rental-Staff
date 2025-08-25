
// import 'package:car_rental_staff_app/models/booking_model.dart';
// import 'package:car_rental_staff_app/views/booking_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class RecentBookingCard extends StatelessWidget {
//   final Booking booking;

//   const RecentBookingCard({super.key, required this.booking});

//   @override
//   Widget build(BuildContext context) {
//     final String startDateTime = booking.rentalStartDate;
//     final String endDateTime = booking.rentalEndDate;
//     final String carName = booking.car.carName;
//     final String carModel = booking.car.model;
//     final String carImage = booking.car.carImage.isEmpty
//         ? booking.car.carImage[0]
//         : 'assets/car.png'; // fallback to your asset

//     return GestureDetector(
// onTap: () {
//   if (booking.status == "active") {
//     Navigator.push(
//       context, 
//       MaterialPageRoute(
//         builder: (context) => BookingScreen(bookingId: booking.id)
//       )
//     );
//   } else if (booking.status == "completed") {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//                 size: 28,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 "Booking Completed",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "This booking has been completed successfully.",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black54,
//                 ),
//               ),
//               SizedBox(height: 12),
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Booking ID: ",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       booking.id.length > 8 
//                           ? booking.id.substring(booking.id.length - 8)
//                           : booking.id,
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: Text(
//                 "OK",
//                 style: TextStyle(
//                   color: Color(0XFF1808C5),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// },
//       child: Container(
//         height: 142,
//         width: 353,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border(
//             bottom: BorderSide(color: Colors.grey.shade400, width: 3),
//             right: BorderSide(color: Colors.grey.shade400, width: 3),
//             top: BorderSide(color: Colors.grey.shade400, width: 1),
//             left: BorderSide(color: Colors.grey.shade400, width: 1),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               offset: const Offset(3, 3),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: OverflowBox(
//           maxHeight: double.infinity,
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text.rich(
//                               TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: carName,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: ' $carModel',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 const Icon(Icons.settings,
//                                     size: 16, color: Colors.black54),
//                                 const SizedBox(width: 6),
//                                 Text('Automatic',
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.grey.shade800)),
//                               ],
//                             ),
//                             const SizedBox(height: 6),
//                             Row(
//                               children: [
//                                 const Icon(Icons.event_seat,
//                                     size: 16, color: Colors.black54),
//                                 const SizedBox(width: 6),
//                                 Text('5 Seaters',
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         color: Colors.grey.shade800)),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             "${booking.status[0].toUpperCase()}${booking.status.substring(1).toLowerCase()} ID: ${booking.id.length > 4 ? booking.id.substring(booking.id.length - 4) : booking.id}",
//                             style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.red,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 6),
//                           Container(
//                             width: 120,
//                             height: 70,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               image: DecorationImage(
//                                 image: booking.car.carImage.isEmpty
//                                     ? NetworkImage(carImage)
//                                     : const AssetImage('assets/car.png') as ImageProvider,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Text("Collect Date & time : $startDateTime",
//                       style: TextStyle(fontSize: 9, color: Colors.grey.shade800)),
//                   const SizedBox(height: 4),
//                   Text("Return Date & time : $endDateTime",
//                       style: TextStyle(fontSize: 9, color: Colors.grey.shade800)),
//                 ],
//               ),
//               Positioned(
//                 bottom: -9,
//                 right: -16,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(booking.paymentStatus),
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(10),
//                       bottomRight: Radius.circular(10),
//                     ),
//                   ),
//                   child: Text(
//                     booking.paymentStatus.toUpperCase(),
//                     style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'paid':
//         return Colors.green;
//       case 'pending':
//         return Color(0XFF051840);
//       case 'failed':
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return const Color(0xFF071952);
//     }
//   }
// }






import 'package:car_rental_staff_app/models/booking_model.dart';
import 'package:car_rental_staff_app/views/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentBookingCard extends StatelessWidget {
  final Booking booking;

  const RecentBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final String startDateTime = booking.rentalStartDate;
    final String endDateTime = booking.rentalEndDate;
    
    // Add null safety checks for car properties
    final String carName = booking.car?.carName ?? 'Unknown Car';
    final String carModel = booking.car?.model ?? 'Unknown Model';
    final String carImage = booking.car?.carImage.isNotEmpty == true
        ? booking.car!.carImage[0]
        : 'assets/car.png'; // fallback to your asset

    return GestureDetector(
      onTap: () {
        if (booking.status == "confirmed") {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => BookingScreen(bookingId: booking.id)
            )
          );
        } else if (booking.status == "active" ) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Booking Active",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This booking has been active.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Booking ID: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            booking.id.length > 8 
                                ? booking.id.substring(booking.id.length - 8)
                                : booking.id,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Color(0XFF1808C5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
        else if (booking.status == "completed" ) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Booking Completed",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This booking has been completed successfully.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Booking ID: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            booking.id.length > 8 
                                ? booking.id.substring(booking.id.length - 8)
                                : booking.id,
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Color(0XFF1808C5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 142,
          width: 353,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade400, width: 3),
              right: BorderSide(color: Colors.grey.shade400, width: 3),
              top: BorderSide(color: Colors.grey.shade400, width: 1),
              left: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: const Offset(3, 3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: OverflowBox(
            maxHeight: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: carName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' $carModel',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.settings,
                                      size: 16, color: Colors.black54),
                                  const SizedBox(width: 6),
                                  Text('Automatic',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade800)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.event_seat,
                                      size: 16, color: Colors.black54),
                                  const SizedBox(width: 6),
                                  Text('5 Seaters',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade800)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${booking.status[0].toUpperCase()}${booking.status.substring(1).toLowerCase()} ID: ${booking.id.length > 4 ? booking.id.substring(booking.id.length - 4) : booking.id}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 120,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: _getCarImageProvider(carImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text("Collect Date & time : $startDateTime,${booking.from}",
                        style: TextStyle(fontSize: 9, color: Colors.grey.shade800)),
                    const SizedBox(height: 4),
                    Text("Return Date & time : $endDateTime,${booking.from}",
                        style: TextStyle(fontSize: 9, color: Colors.grey.shade800)),
                  ],
                ),
                Positioned(
                  bottom: -9,
                  right: -16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.paymentStatus),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      booking.paymentStatus.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to get the correct image provider
  ImageProvider _getCarImageProvider(String carImage) {
    if (booking.car?.carImage.isNotEmpty == true) {
      // If car image URL exists, use NetworkImage
      return NetworkImage(carImage);
    } else {
      // Otherwise use asset image
      return const AssetImage('assets/car.png');
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Color(0XFF051840);
      case 'failed':
      case 'cancelled':
        return Colors.red;
      default:
        return const Color(0xFF071952);
    }
  }
}