import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/auth_action_buttons.dart';
import 'package:flutter_application_1/core/utils/responsive.dart';
import 'dart:async';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({super.key});

  @override
  State<RegisterLogin> createState() => _RegisterLoginState();
}

class _RegisterLoginState extends State<RegisterLogin> {
  bool _isAnimate = false;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _animationTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We get screen height to calculate the initial centering position
    final screenHeight = MediaQuery.of(context).size.height;
    final startTopPadding = screenHeight * 0.3;

    return Scaffold(
      backgroundColor: Colors.white, // Ensure background is white
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  height: _isAnimate ? context.hp(15) : startTopPadding,
                ),
                Image.asset(
                  "assets/images/logobg.png",
                  height: context.hp(30),
                  fit: BoxFit.contain,
                ),
                Text(
                  "راسخ",
                  style: TextStyle(
                    fontSize: context.sp(30),
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: _isAnimate ? 1.0 : 0.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.wp(5)),
                    child: AuthActionButtons(),
                  ),
                ),
                SizedBox(height: context.hp(15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
