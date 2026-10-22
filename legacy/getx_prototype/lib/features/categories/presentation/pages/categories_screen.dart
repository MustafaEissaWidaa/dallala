import 'package:dallala/features/categories/presentation/widgets/active_ads.dart';
import 'package:dallala/features/categories/presentation/widgets/banner.dart';
import 'package:dallala/features/categories/presentation/widgets/categories_card.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f4ee),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "الأقسام",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffe8ddcd)),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/03-Icons/png-dark/search.png"),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              // active adds
              ActiveAds(),
              SizedBox(height: 15,),
              CategoriesBanner(),
              SizedBox(height: 15,),
              CategoriesCard()
            ],
          ),
        ),
      ),
    );
  }
}
