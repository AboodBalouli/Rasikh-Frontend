/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/circular_container.dart';
import 'package:flutter_application_1/core/constants/sizes.dart';
import 'package:go_router/go_router.dart';

class OrganizationContainer extends StatelessWidget {
  const OrganizationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/organizations'),
      child: const CircularContainer(
        height: 150,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: Sizes.sm),
        color: Colors.blueGrey,
        // borderRadius: Sizes.sm,
        child: Center(
          child: Text(
            "Organizations Category",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrganizationContainer extends StatelessWidget {
  const OrganizationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/organizations'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 160,
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: const AssetImage("images/organization.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "الجمعيات",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "تعرف على شركائنا والمبادرات المجتمعية",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
