// 1. First, create a main layout widget that will handle the navigation

import 'package:car_rental_staff_app/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_staff_app/views/home_screen.dart';
import 'package:car_rental_staff_app/views/search_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  
  // List of screens to navigate between
  static final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(0),
          ),
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: 'Home',
              index: 0,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              textScaleFactor: textScaleFactor,
            ),
            _buildNavItem(
              icon: Icons.category,
              label: 'Search',
              index: 1,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              textScaleFactor: textScaleFactor,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: 'Profile',
              index: 2,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              textScaleFactor: textScaleFactor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required double screenWidth,
    required double screenHeight,
    required double textScaleFactor,
  }) {
    final bool isSelected = _selectedIndex == index;
    
    if (isSelected) {
      // Highlighted item
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0XFF120698), size: 24),
            SizedBox(width: screenWidth * 0.01),
            Text(
              label,
              style: TextStyle(
                color: const Color(0XFF120698),
                fontSize: 14 * textScaleFactor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
    } else {
      // Non-highlighted item (icon only)
      return IconButton(
        onPressed: () => _onItemTapped(index),
        icon: Icon(icon, color: Colors.grey),
      );
    }
  }
}

