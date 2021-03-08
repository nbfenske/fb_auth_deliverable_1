import 'package:flutter/material.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _success;
String _userEmail;

// Author: Nathan Fenske
// To be implemented, will construct widgets to allow for email/password login
class _RegisterEmailSection extends StatefulWidget {
  final String title = 'Registration';
  @override
  State<StatefulWidget> createState() =>
      _RegisterEmailSectionState();
}

// Author: Nathan Fenske
// To be implemented, will construct widgets to allow for email/password login
class _RegisterEmailSectionState extends State<_RegisterEmailSection> {
  @override
  Widget build(BuildContext context) {
    //TODO UI content here
  }
}