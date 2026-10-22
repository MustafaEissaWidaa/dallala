import 'package:dallala/features/categories/presentation/pages/Categore_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CategoriesCard extends StatefulWidget {
  const CategoriesCard({super.key});

  @override
  State<CategoriesCard> createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  List CardInfo = [
    {
      'id': '1',
      'image': 'assets/03-Icons/png-terracotta/car.png',
      'name': 'سيارات',
      'count': '٥٢٠',
    },
    {
      'id': '2',
      'image': 'assets/03-Icons/png-terracotta/real-estate.png',
      'name': 'عقارات',
      'count': '٤١٢',
    },
    {
      'id': '3',
      'image': 'assets/03-Icons/png-terracotta/crops.png',
      'name': 'محاصيل',
      'count': '٦٣٠',
    },
    {
      'id': '4',
      'image': 'assets/03-Icons/png-terracotta/rickshaw.png',
      'name': 'ركشات ومواتر',
      'count': '٢٨٤',
    },
    {
      'id': '5',
      'image': 'assets/03-Icons/png-terracotta/electronics.png',
      'name': 'إلكترونيات',
      'count': '٧٤٥',
    },
    {
      'id': '6',
      'image': 'assets/03-Icons/png-terracotta/furniture.png',
      'name': 'أثاث ومنزل',
      'count': '٣٣٦',
    },
    {
      'id': '7',
      'image': 'assets/03-Icons/png-terracotta/jobs.png',
      'name': 'وظائف',
      'count': '١٩٨',
    },
    {
      'id': '8',
      'image': 'assets/03-Icons/png-terracotta/services.png',
      'name': 'خدمات',
      'count': '٢٤١',
    },
    {
      'id': '9',
      'image': 'assets/03-Icons/png-dark/nav-categories.png',
      'name': 'أخرى',
      'count': '٥٠',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        mainAxisExtent: 129,
      ),
      itemCount: CardInfo.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Get.to(
          () => CategoreScreen(
            id: CardInfo[index]['id'],
            name: CardInfo[index]['name'],
          ),
        ),
        child: Container(
          width: 113,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                color: Colors.black12,
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xffFDEDE4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(CardInfo[index]['image']),
                ),
              ),
              SizedBox(height: 5),
              Text(
                CardInfo[index]['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(CardInfo[index]['count'], style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
