
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
    final String carName = booking.car.carName;
    final String carModel = booking.car.model;
    final String carImage = booking.car.carImage.isEmpty
        ? booking.car.carImage[0]
        : 'assets/car.png'; // fallback to your asset

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen()));
      },
      child: Container(
        height: 142,
        width: 353,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400, width: 2),
            right: BorderSide(color: Colors.grey.shade400, width: 2),
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
                            "ID: ${booking.id.length > 4 ? booking.id.substring(booking.id.length - 4) : booking.id}",
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
                                image: booking.car.carImage.isEmpty
                                    ? NetworkImage(carImage)
                                    : const AssetImage('assets/car.png') as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text("Collect Date & time : $startDateTime",
                      style: TextStyle(fontSize: 9, color: Colors.grey.shade800)),
                  const SizedBox(height: 4),
                  Text("Return Date & time : $endDateTime",
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
    );
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
