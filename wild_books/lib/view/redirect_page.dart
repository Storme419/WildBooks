import 'package:flutter/material.dart';
import 'package:wild_books/view/account_page.dart';
import 'package:wild_books/view/register_page.dart';
import '../utils/db.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  final user = supabase.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return user != null ? AccountPage() : RegisterPage();
  }
}
