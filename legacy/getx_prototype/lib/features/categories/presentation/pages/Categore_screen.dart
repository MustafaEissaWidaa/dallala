import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class CategoreScreen extends StatefulWidget {
  final String id;
  final String name;
  const CategoreScreen({super.key, required this.id, required this.name});

  @override
  State<CategoreScreen> createState() => _CategoreScreenState();
}

class _CategoreScreenState extends State<CategoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f4ee),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 184,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/05-Backgrounds/png/card-placeholder-terracotta@3x.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/03-Icons/png-dark/arrow-back.png",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 370,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hint: Text(
                          'ابحث في السيارات… مثلاً هايلكس',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff6e5f50),
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ImageIcon(
                            AssetImage('assets/03-Icons/png-dark/search.png'),
                            color: Color(0xff6e5f50),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
