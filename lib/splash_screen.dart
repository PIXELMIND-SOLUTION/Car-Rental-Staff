import 'package:car_rental_staff_app/providers/auth_provider.dart';
import 'package:car_rental_staff_app/views/login_screen.dart';
import 'package:car_rental_staff_app/views/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _carController;
  
  late Animation<double> _backgroundAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _carSlideAnimation;
  late Animation<double> _carRotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    _checkAuthStatus();
  }

  void _initializeAnimations() {
    // Background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    // Car animation
    _carController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _carSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(parent: _carController, curve: Curves.easeOutBack));
    
    _carRotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _carController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    _backgroundController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _carController.forward();
  }

  void _checkAuthStatus() async {
    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 3500));
    
    if (!mounted) return;
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initializeUser();
      
      // Navigate based on auth status
      if (authProvider.user != null) {
        _navigateToMainLayout();
      } else {
        _navigateToLogin();
      }
    } catch (e) {
      print('Error checking auth status: $e');
      _navigateToLogin();
    }
  }

  void _navigateToMainLayout() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainLayout(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _carController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _logoController,
          _textController,
          _carController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF0f3460),
                    const Color(0xFFe94560),
                    _backgroundAnimation.value * 0.3,
                  )!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated floating elements
                ...List.generate(20, (index) => _buildFloatingElement(index)),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with animation
                      Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotationAnimation.value * 0.5,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF00d4ff),
                                  Color(0xFF5b86e5),
                                  Color(0xFFe94560),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00d4ff).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.directions_car_rounded,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // App name with animation
                      AnimatedOpacity(
                        opacity: _textOpacityAnimation.value,
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF00d4ff),
                                  Color(0xFFe94560),
                                  Color(0xFFffd700),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'Varahi Cars',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Staff Portal',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Animated car
                      SlideTransition(
                        position: _carSlideAnimation,
                        child: Transform.rotate(
                          angle: _carRotationAnimation.value,
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00d4ff), Color(0xFF5b86e5)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00d4ff).withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.car_rental,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 60),
                      
                      // Loading indicator
                      AnimatedOpacity(
                        opacity: _textOpacityAnimation.value,
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFF00d4ff),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingElement(int index) {
    final random = (index * 13) % 100;
    final delay = (random % 10) * 200.0;
    final duration = 3000 + (random % 20) * 100;
    final size = 20.0 + (random % 5) * 10.0;
    
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Positioned(
          left: (random % 80) / 100 * MediaQuery.of(context).size.width,
          top: (random % 70) / 100 * MediaQuery.of(context).size.height,
          child: AnimatedOpacity(
            opacity: (_backgroundAnimation.value * 0.3).clamp(0.0, 1.0),
            duration: Duration(milliseconds: duration),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00d4ff).withOpacity(0.2),
                    const Color(0xFFe94560).withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00d4ff).withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}