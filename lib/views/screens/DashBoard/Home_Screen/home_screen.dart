import 'package:flutter/material.dart';
import 'package:logistics/services/theme.dart';

import 'Components/highlight_order.dart';
import 'Components/midsection.dart';
import 'Components/top_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopSection(),
            MidSection(),
          ],
        ),
      ),
    );
  }
}
