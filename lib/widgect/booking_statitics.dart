import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

class BookingStatisticsGraphicChart extends StatelessWidget {
  final List<dynamic> statistics;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const BookingStatisticsGraphicChart({
    super.key,
    required this.statistics,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 8),
                ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ],
          ),
        ),
      );
    }

    if (statistics.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'No statistics available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Monthly Booking Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Chart(
              data: _prepareData(),
              variables: {
                'month': Variable(
                  accessor: (Map map) => map['month'] as String,
                ),
                'count': Variable(
                  accessor: (Map map) => map['count'] as num,
                  scale: LinearScale(min: 0), // Start bars from 0
                ),
                'status': Variable(
                  accessor: (Map map) => map['status'] as String,
                ),
              },
              marks: [
                IntervalMark(
                  // Position: month on Y-axis, count on X-axis for horizontal bars
                  position: Varset('month') * Varset('count'),
                  color: ColorEncode(
                    variable: 'status',
                    values: [
                      const Color(0XFFFE0B0B), // Failed (Red) - first in list
                      const Color(0xFF205BE9), // Completed (Blue) - second in list
                    ],
                  ),
                  // Use StackModifier for stacked bars (red + blue in same bar)
                  modifiers: [StackModifier()],
                ),
              ],
              axes: [
                Defaults.horizontalAxis, // Count values (5, 10, 15, etc.)
                Defaults.verticalAxis,   // Month labels (Jan, Feb, Mar, etc.)
              ],
              // Add coordinate transformation for horizontal bars
              coord: RectCoord(transposed: true),
            ),
          ),
          const SizedBox(height: 16),
          // Add legend
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0XFFFE0B0B),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Failed', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(width: 24),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFF205BE9),
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Completed', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  List<Map> _prepareData() {
    if (statistics.isEmpty) return [];

    List<Map> data = [];

    final completedData = statistics.firstWhere(
      (stat) => stat['status'] == 'completed',
      orElse: () => {'monthlyData': []},
    )['monthlyData'] as List<dynamic>;

    final failedData = statistics.firstWhere(
      (stat) => stat['status'] == 'failed',
      orElse: () => {'monthlyData': []},
    )['monthlyData'] as List<dynamic>;

    // Generate data for each month (reverse order so Aug appears at top)
    for (int i = 11; i >= 0; i--) {
      final month = _getMonthAbbreviation(i);
      
      final completedCount = i < completedData.length
          ? (completedData[i]['count'] as num)
          : 0;
      
      final failedCount = i < failedData.length
          ? (failedData[i]['count'] as num)
          : 0;

      // Add failed count first (will be on the left side of the bar)
      data.add({
        'month': month,
        'count': failedCount,
        'status': 'Failed',
      });

      // Add completed count second (will stack on top/right of failed)
      data.add({
        'month': month,
        'count': completedCount,
        'status': 'Completed',
      });
    }

    return data;
  }

  String _getMonthAbbreviation(int index) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[index];
  }
}