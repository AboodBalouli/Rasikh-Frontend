import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RatingThankYouPage extends StatelessWidget {
  const RatingThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: const Icon(
                  Icons.check_circle,
                  size: 90,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'شكرًا لتقييمك!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'رأيك يهمنا ويساعدنا على تقديم الأفضل',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/home'); // Todo: Adjust navigation as needed
                  },
                  child: const Text('العودة لطلباتي'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
