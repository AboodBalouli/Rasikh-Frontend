import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/star_selector.dart';

class RateOrderPage extends StatefulWidget {
  final String orderId;

  const RateOrderPage({super.key, required this.orderId});

  @override
  State<RateOrderPage> createState() => _RateOrderPageState();
}

class _RateOrderPageState extends State<RateOrderPage> {
  int rating = 0;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تقييم الطلب',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 83, 148, 93),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            Text(
              'كيف كانت تجربتك؟',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'ساعدنا بتحسين خدماتنا من خلال تقييمك',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            StarSelector(
              rating: rating,
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),

            const SizedBox(height: 24),

            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'اكتب ملاحظاتك (اختياري)',
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: rating == 0
                    ? null
                    : () {
                        context.pushReplacement('/rating-thank-you');
                      },
                child: const Text('إرسال التقييم'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
