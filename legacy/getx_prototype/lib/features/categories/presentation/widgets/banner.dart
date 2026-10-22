import 'package:flutter/material.dart';

class CategoriesBanner extends StatefulWidget {
  const CategoriesBanner({super.key});

  @override
  State<CategoriesBanner> createState() => _CategoriesBannerState();
}

class _CategoriesBannerState extends State<CategoriesBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 385,
      height: 104,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(
            "assets/05-Backgrounds/png/category-banner-livestock@3x.png",
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Color(0xff2A7F61),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset("assets/03-Icons/png-white/livestock.png"),
              ),
            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "سوق المواشي",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "ضأن حمري، ماعز، أبقار، إبل ·",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(" ٨٦٤ إعلان",style: TextStyle(fontSize: 16, color: Colors.white),),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}