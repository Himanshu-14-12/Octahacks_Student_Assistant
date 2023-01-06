import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_assistant_app/Screens/finance/finance.dart';
import 'package:student_assistant_app/Screens/login.dart';
import 'package:student_assistant_app/Screens/maindrawer.dart';
import 'finance/models/transaction.dart' as Trans;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSectionIndex = 0;

  void _selectSection(int index) {
    setState(() {
      _selectedSectionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as List;
    var _currentUser = args[0];
    List<Trans.Transaction> _userTransactions = args[1];
    final List<Widget> _sections = [
      FinanceScreen(_userTransactions),
      Center(
        child: Text('Calendar'),
      ),
      Center(child: Text('jobs')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Assistant'),
        actions: [
          ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/login'),
                );
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
          ),
        ],
      ),
      body: _sections[_selectedSectionIndex],
      drawer: MainDrawer(_currentUser),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedSectionIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Expenses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.laptop), label: 'Jobs'),
        ],
        selectedItemColor: Theme.of(context).selectedRowColor,
        onTap: _selectSection,
      ),
    );
  }
}
