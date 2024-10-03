import 'package:flutter/material.dart';


class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color(0xFF21690F),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
      body: Center(
        child: currentPageIndex == 0
            ? Text(
                'Home Page',
                style: Theme.of(context).textTheme.headline4,
              )
            : ListView(
                children: const <Widget>[
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notification 1'),
                    subtitle: Text('This is a notification'),
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notification 2'),
                    subtitle: Text('This is a notification'),
                  ),
                ],
              ),
      ),
    );
  }
}
