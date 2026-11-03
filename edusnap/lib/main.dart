import 'package:flutter/material.dart';

import 'Pages/JournalList/journal_list_page.dart';

void main() => runApp(const EduSnapApp());

class EduSnapApp extends StatelessWidget {
  const EduSnapApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'EduSnap',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF146C60)),
      useMaterial3: true,
    ),
    home: const JournalListPage(),
  );
}
