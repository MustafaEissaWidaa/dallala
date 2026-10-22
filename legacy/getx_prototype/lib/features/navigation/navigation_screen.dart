import 'package:dallala/features/account/presentation/pages/account_screen.dart';
import 'package:dallala/features/add/presentation/pages/add_screen.dart';
import 'package:dallala/features/categories/presentation/pages/categories_screen.dart';
import 'package:dallala/features/chats/presentation/pages/chats_screen.dart';
import 'package:dallala/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  static const Color primary = Color(0xFFB0472A);
  static const Color inactive = Color(0xFF6E625A);
  static const String iconsPath = 'assets/03-Icons/png-dark';

  int currentIndex = 0;
  int unreadChats = 2;

  final List<Widget> pages = const [
    HomeScreen(),
    CategoriesScreen(),
    SizedBox.shrink(), // Add button placeholder
    ChatsScreen(),
    AccountScreen(),
  ];

  void onItemTapped(int index) {
    if (index == 2) {
      Get.to(() => AddScreen());
      return;
    }
    setState(() => currentIndex = index);
  }

  Widget navIcon(String name) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: ImageIcon(AssetImage('$iconsPath/$name.png'), size: 26),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5EE),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFEFE7DE))),
        ),
        child: BottomNavigationBar(
          
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onItemTapped,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: primary,
          unselectedItemColor: inactive,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800,fontSize: 15),
          items: [
            BottomNavigationBarItem(icon: navIcon('nav-home'), label: 'الرئيسية'),
            BottomNavigationBarItem(
              icon: navIcon('nav-categories'),
              label: 'الاقسام',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 54,
                height: 50,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: ImageIcon(
                    AssetImage('$iconsPath/plus.png'),
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Badge(
                  isLabelVisible: unreadChats > 0,
                  label: Text('$unreadChats'),
                  backgroundColor: primary,
                  textColor: Colors.white,
                  child: const ImageIcon(
                    AssetImage('$iconsPath/chat.png'),
                    size: 26,
                  ),
                ),
              ),
              label: 'الرسايل',
            ),
            BottomNavigationBarItem(icon: navIcon('user'), label: 'الحساب'),
          ],
        ),
      ),
    );
  }
}
