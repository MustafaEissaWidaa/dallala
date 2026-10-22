import 'package:dallala/features/home/presentation/widgets/featured_ads.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f4ee),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/01-Logo/dallala-mark.png",
                          height: 50,
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              'تتصفح في',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'الأبيض',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                Image.asset(
                                  "assets/03-Icons/png-dark/chevron-down.png",
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          "assets/03-Icons/png-dark/bell.png",
                          height: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              //search bar
              Container(
                width: 358,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: .9, color: Color(0xffe8ddcd)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hint: Text(
                      "ابحث عن عربية، خروف، بيت…",
                      style: TextStyle(fontSize: 16, color: Color(0xff6e5f50)),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ImageIcon(
                        AssetImage("assets/03-Icons/png-dark/search.png"),
                        size: 22,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xff231A12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            "assets/03-Icons/png-white/filter.png",
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              //categories section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "الأقسام",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          "عرض الكل",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff9c3812),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xfffdede4),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset("assets/03-Icons/png-terracotta/car.png",),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("سيارات",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),)
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xfffdede4),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset("assets/03-Icons/png-terracotta/livestock.png",),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("مواشي",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),)
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xfffdede4),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset("assets/03-Icons/png-terracotta/real-estate.png",),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("عقارات",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),)
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xfffdede4),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset("assets/03-Icons/png-terracotta/crops.png",),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("محاصيل",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),)
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color(0xfffdede4),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset("assets/03-Icons/png-terracotta/electronics.png",),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text("إلكترونيات",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 15,),
              //Featured Ads
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "إعلانات مميّزة",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "المزيد",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff9c3812),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          children: [
                            FeaturedAdCard(),
                            SizedBox(width: 10,),
                            FeaturedAdCard(),
                            SizedBox(width: 10,),
                            FeaturedAdCard(),
                            SizedBox(width: 10,),
                            FeaturedAdCard(),
                          ],
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}