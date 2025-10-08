import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/models/attraction_model.dart';
import 'package:tourism_app/screens/user_account.dart';
import '../admin/admin_tools_page.dart';
import '../screens/home.dart'; // Import your home screen
import '../screens/reservation.dart';
import '../screens/smart_travel.dart';
import '../screens/about_us.dart';
import '../screens/attractions.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final _usernameCtrl = TextEditingController();
  late final StreamSubscription<User?> _authSub;
  int _selectedIndex = 2; // Home is the default page
  static const int homeIndex = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _pages = [
    ReservePage(
      key: const ValueKey('transport'),
      accomodations: false,
      transport: true,
      //tour: false,
    ),
    SmartTravel(),
    //Center(child: Text("Smart Travel Page", style: TextStyle(fontSize: 24))),
    HomeScreen(),
    ReservePage(
      key: const ValueKey('accommodation'),
      accomodations: true,
      transport: false,
      //tour: false,
    ),
    ReservePage(
      key: const ValueKey('tour'),
      accomodations: false,
      transport: false,
      //tour: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _usernameCtrl.text = user?.displayName ?? user?.email ?? 'Guest';
    _authSub = FirebaseAuth.instance.userChanges().listen((user) {
      setState(() {
        _usernameCtrl.text = user?.displayName ?? user?.email ?? 'Guest';
      });
    });
  }

  void dispose() {
    _authSub.cancel();
    _usernameCtrl.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    // if (index == 0) {
    //   _scaffoldKey.currentState?.openDrawer();
    // } else {
    setState(() {
      _selectedIndex = index;
    });
    // }
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Do you want to exit from app ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final canPop = Navigator.of(context).canPop();
        if (canPop) return true;

        if (_selectedIndex == homeIndex) {
          final shouldExit = await _confirmExit(context);
          return shouldExit;
        }

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: NavDrawer(),
        appBar: AppBar(
          leading: LogoButton(
            onTapHome: () {
              if (_selectedIndex != homeIndex) {
                setState(() => _selectedIndex = homeIndex);
              }
            },
          ),
          actions: [
            Text(
              _usernameCtrl.text,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const AccountMenuButton(),
            Builder(
              builder:
                  (ctx) => IconButton(
                    icon: const Icon(Icons.menu),
                    tooltip: 'Menu',
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  ),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) => _onItemTapped(index),
            backgroundColor: Color.fromARGB(255, 100, 233, 202),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black54,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.train, size: 25),
                label: "Transport",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.travel_explore, size: 25),
                label: "Smart Travel",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 25),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.hotel, size: 25),
                label: "Accomodation",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map, size: 25),
                label: "Tour",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.only(bottom: screenHeight * 0.04),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 100, 233, 202),
            ),
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 24, color: Colors.white, height: 6),
            ),
          ),
          Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: screenHeight * 0.02,
            children: [
              ListTile(
                leading: Image.asset(
                  "images/myReservation_icon.png",
                  width: 40,
                  height: 40,
                ),
                title: Text("My Reservations"),
                onTap: () {
                  Navigator.pop(context);
                  print("Settings Clicked");
                },
              ),
              ListTile(
                leading: Image.asset(
                  "images/attraction_icon.png",
                  width: 40,
                  height: 40,
                ),
                title: Text("Tourist Attractions"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Attractions()),
                  );
                  print("About Clicked");
                },
              ),
              ListTile(
                leading: Image.asset(
                  "images/history_icon.png",
                  width: 40,
                  height: 40,
                ),
                title: Text("History"),
                onTap: () {
                  Navigator.pop(context);
                  print("About Clicked");
                },
              ),
              ListTile(
                leading: Image.asset(
                  "images/support_icon.png",
                  width: 40,
                  height: 40,
                ),
                title: Text("Online Support"),
                onTap: () {
                  Navigator.pop(context);
                  print("About Clicked");
                },
              ),
              ListTile(
                leading: Image.asset(
                  "images/about_icon.png",
                  width: 40,
                  height: 40,
                ),
                title: Text("About"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AboutPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogoButton extends StatelessWidget {
  const LogoButton({super.key, this.onTapHome});

  final VoidCallback? onTapHome;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapHome,
      onLongPress: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AdminToolsPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Image.asset('images/logo.png'),
      ),
    );
  }
}
