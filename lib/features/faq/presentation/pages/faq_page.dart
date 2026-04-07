import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/faq/data/models/faq_items.dart';
import 'package:flutter_application_1/core/constants/colors.dart';
import '../widgets/faq_section.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFA),
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logobg.png',
          height: 90,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFFAFBFA),
        foregroundColor: TColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: const [
          FaqSection(
            title: ' المستخدمون',
            faqs: [
              FaqItem(
                question: 'ما هو التطبيق؟',
                answer:
                    'منصة تسوق إلكترونية تجمع المستخدمين والبائعين والجمعيات.',
              ),
              FaqItem(
                question: 'هل أحتاج إلى حساب؟',
                answer:
                    'يمكنك التصفح بدون حساب، ولكن الشراء يتطلب تسجيل الدخول.',
              ),
              FaqItem(
                question: 'كيف أتابع طلبي؟',
                answer: 'من خلال صفحة "طلباتي" داخل التطبيق بعد تسجيل الدخول.',
              ),
            ],
          ),

          SizedBox(height: 24),

          FaqSection(
            title: ' البائعون',
            faqs: [
              FaqItem(
                question: 'كيف أسجل كبائع؟',
                answer:
                    'يمكنك التسجيل من صفحة "التسجيل كبائع" وإدخال بيانات المتجر.',
              ),
              FaqItem(
                question: 'كيف اضيف منتجات ؟ ',
                answer:
                    'عند انشاء المتجر يمكنك اضافة منتجاتك من خلال لوحة التحكم.',
              ),
            ],
          ),

          SizedBox(height: 24),

          /*
          FaqSection(
            title: 'الجمعيات',
            faqs: [
              FaqItem(
                question: 'كيف تنضم الجمعية؟',
                answer: 'عبر تسجيل الجمعيات ورفع المستندات الرسمية للمراجعة.',
              ),
              FaqItem(
                question: 'هل يمكن استقبال تبرعات؟',
                answer: 'نعم، يدعم التطبيق استقبال التبرعات مباشرة.',
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
