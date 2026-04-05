import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/screens/user_account.dart';
import '../admin/admin_tools_page.dart';
import '../screens/about_us.dart';
import '../screens/attractions.dart';
import '../screens/home.dart';
import '../screens/my_reservations.dart';
import '../screens/reservation.dart';
import '../screens/smart_travel.dart';
import '../theme/app_theme.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

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

  @override
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  _usernameCtrl.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => _onItemTapped(index),
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
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.only(bottom: screenHeight * 0.04),
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
            ),
            child: Text(
              "Menu",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
                height: 2.6,
              ),
            ),
          ),
          Column(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyReservationsPage(),
                    ),
                  );
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
