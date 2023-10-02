import 'package:flutter/material.dart';
import 'package:tiktok/repository/app_colors.dart';
import 'package:tiktok/utils/utils.dart';
import 'package:tiktok/view/screen/auth/widget/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index){
            setState(() {
              pageIndex = index;
            });
          },
          currentIndex: pageIndex,
            backgroundColor: AppColors.backgroundColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: 30,
                  ),
                  label: "Search"),
              BottomNavigationBarItem(icon: CustomIcon(), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message,
                    size: 30,
                  ),
                  label: "Message"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  label: "Profile"),
            ]),
        body: Utils.pages[pageIndex]);
  }
}
