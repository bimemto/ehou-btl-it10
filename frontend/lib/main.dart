import 'package:flutter/material.dart';
import 'package:frontend/clothes/clothes_page.dart';
import 'package:frontend/customers/customers_page.dart';
import 'package:frontend/employees/employees_page.dart';
import 'package:frontend/receipt/receipts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Cửa Hàng',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý cửa hàng máy tính'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentTab = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: currentTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.laptop),
            label: 'Máy Tính',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Khách Hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Nhân Viên',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Hóa Đơn',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentTab,
        children: const <Widget>[
          ClothesPage(),
          CustomersPage(),
          EmployeesPage(),
          ReceiptsPage(),
        ],
      ),
    );
  }
}
