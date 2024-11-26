import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider_calculator.dart';
import 'getx_calculator.dart';
import 'image_upload.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculators App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'montserrat-medium',
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: ProviderCalculator(),
    ),
    GetXCalculator(),
    ImageUploadPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.blue.shade50,
          items: const [
            BottomNavigationBarItem(
              icon: Padding (
                padding: EdgeInsets.only(top: 10.0),
              
              child: Icon(Icons.home),
             ), label: 'Provider'
            ),
            BottomNavigationBarItem(
              icon: Padding (
                padding: EdgeInsets.only(top: 10.0),
              
              child:
               Icon(Icons.calculate_outlined),
             ), 
             label: 'GetX'
            ),
            BottomNavigationBarItem(
              icon: Padding (
                padding: EdgeInsets.only(top: 10.0),
              
              child:
               Icon(Icons.image),
             ),
              label: 'Upload'
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
