/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/circular_container.dart';
import 'package:go_router/go_router.dart';

class CraftsContainer extends StatelessWidget {
  const CraftsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/crafts'),
      child: const CircularContainer(
        height: 150,
        margin: EdgeInsets.zero,
        color: Color.fromARGB(255, 43, 61, 110),
        child: Center(
          child: Text(
            "Crafts Category",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/sizes.dart';
import 'package:go_router/go_router.dart';

class CraftsContainer extends StatelessWidget {
  const CraftsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/crafts'),
      borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
          image: DecorationImage(
            image: const AssetImage("images/crafts.png"),

            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: Sizes.xs,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.cardRadiusLg),
          child: const Padding(
            padding: EdgeInsets.all(Sizes.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "الحرف اليدوية",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.fontLarge + 5,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "منتجات يدوية",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color.fromARGB(195, 255, 255, 255),
                    fontSize: Sizes.fontSmall + 2,
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
