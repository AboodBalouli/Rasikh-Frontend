import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderSent extends StatefulWidget {
  const OrderSent({super.key});

  @override
  State<OrderSent> createState() => _OrderSentState();
}

class _OrderSentState extends State<OrderSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 50,
              color: Colors.green[300],
            ),
            const SizedBox(height: 20),
            const Text(
              'تم إرسال الطلب بنجاح!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE3A428),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'شكراً لتسوقك معنا. سيتم معالجة طلبك قريباً.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 60,

              child: Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 202, 224, 197),
                      Color.fromARGB(255, 83, 125, 93),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        162,
                        173,
                        171,
                      ).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.go('/home');
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Center(
                      child: Text(
                        'العودة إلى المتجر',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
