import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider_calculator.dart';
import 'getx_calculator.dart';
import 'image_upload.dart';
import 'state_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculators App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'poppins-regular',
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<Widget> _screens = [
    ProviderCalculator(),
    GetXCalculator(),
    ImageUploadPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _screens[navigationProvider.selectedIndex];
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationProvider.selectedIndex,
          selectedItemColor: Colors.deepPurpleAccent[700],
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.deepPurple.shade50,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.home),
              ),
              label: 'Provider',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.calculate_outlined),
              ),
              label: 'GetX',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Icon(Icons.image),
                
              ),
              label: 'Upload',
              
            ),
          ],
          onTap: (index) {
            navigationProvider.updateIndex(index);
          },
        ),
      ),
    );
  }
}
