import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_application_1/core/constants/colors.dart';
import 'package:flutter_application_1/core/constants/custom_back_button.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  static const String _aboutText = '''
يُعد تطبيق سلة بيت منصة رقمية ذكية تهدف إلى ربط المنتجين المنزليين بالمستهلكين ضمن بيئة موثوقة، سهلة الاستخدام، وشاملة. يوفّر التطبيق مساحة موحّدة لعرض وبيع المنتجات المنزلية، بما يشمل الأطعمة البيتية والحِرف اليدوية، مع التركيز على دعم المشاريع الصغيرة وتعزيز الاقتصاد المحلي.

يُمكّن التطبيق أصحاب المنتجات المنزلية من إنشاء متاجرهم الخاصة، إدارة منتجاتهم، وتحسين عرضها باستخدام أدوات مدعومة بالذكاء الاصطناعي، مثل تحسين الصور وتوليد أوصاف ذكية للمنتجات. في المقابل، يتيح للمستخدمين تصفّح المنتجات، البحث عنها، الاطلاع على تقييمات البائعين، وإتمام عمليات الشراء بسهولة وأمان.

يركّز سلة بيت على الشمولية وإتاحة الفرص، حيث يوفّر بيئة رقمية داعمة للأفراد، كما يتيح للجمعيات والمؤسسات ذات العلاقة المشاركة والإشراف، بما يعزّز الثقة ويضمن جودة المحتوى المعروض. ومن خلال دمج التقنيات الحديثة مع القيم المجتمعية، يسهم التطبيق في الحفاظ على الهوية الثقافية للمنتجات المنزلية وتعزيز الاستدامة الاقتصادية والاجتماعية.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFA),
      appBar: AppBar(
        leading: const CustomBackButton(),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section with decoration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TColors.primary.withOpacity(0.15),
                          TColors.primary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: TColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'حول التطبيق',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: TColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content card with glass morphism
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.85),
                        Colors.white.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: TColors.primary.withOpacity(0.12),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Text(
                    _aboutText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: TColors.textPrimary,
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // App version footer
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.favorite,
                  color: TColors.primary.withOpacity(0.7),
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
