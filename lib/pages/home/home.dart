import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gardenapp/pages/home/widgets/add_page.dart';
import 'package:gardenapp/pages/home/widgets/statistics_page.dart';
import 'package:gardenapp/pages/home/widgets/menu.dart';
import 'package:gardenapp/pages/home/widgets/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = 0;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
      switch (index) {
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          ).then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StatisticsPage()),
          ).then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Transform(
              transform: Matrix4.identity()..rotateZ(20),
              origin: const Offset(150, 50),
              child: Image.asset(
                'assets/images/bg_liquid.png',
                width: 220,
              ),
            ),
            Positioned(
              right: 0,
              top: 200,
              child: Transform(
                transform: Matrix4.identity()..rotateZ(20),
                origin: const Offset(180, 100),
                child: Image.asset(
                  'assets/images/bg_liquid.png',
                  width: 200,
                ),
              ),
            ),
            Column(
              children: [
                const HeaderSection(),
                const SizedBox(height: 90),
                MenuSection(),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      color: const Color(0xfff6f8ff),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color.fromARGB(255, 95, 234, 121),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.grey.withOpacity(0.7),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                label: 'Plants',
                icon: Icon(
                  FontAwesomeIcons.seedling,
                  size: 30,
                  color: _selectedIndex == 0
                      ? const Color.fromARGB(255, 95, 234, 121)
                      : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                ),
              ),
              const BottomNavigationBarItem(
                label: "",
                icon: Icon(
                  CupertinoIcons.add_circled_solid,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              BottomNavigationBarItem(
                label: "Statistics",
                icon: Icon(
                  Icons.leaderboard_rounded,
                  size: 30,
                  color: _selectedIndex == 2
                      ? const Color.fromARGB(255, 95, 234, 121)
                      : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
