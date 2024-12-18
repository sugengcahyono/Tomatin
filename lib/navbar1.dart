import 'package:flutter/material.dart';
import 'package:tomat_in/beranda.dart';
import 'package:tomat_in/riwayat.dart';

class NavigationBarApp1 extends StatelessWidget {
  const NavigationBarApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const MyWidget(),
      debugShowCheckedModeBanner: false, // Menonaktifkan tulisan debug
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final List<Widget> _pages = [
     beranda(),
     RiwayatScreen(),
    // const Center(child: Text('Halaman Kunjungan')),
    // const Center(child: Text('Halaman Akun')),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Warna latar belakang navbar
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFB71C1C), // Warna item yang dipilih (hijau)
        unselectedItemColor: Colors.black, // Warna item yang tidak dipilih (putih)
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.group),
          //   label: 'Kunjungan',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_2),
          //   label: 'Akun',
          // ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
