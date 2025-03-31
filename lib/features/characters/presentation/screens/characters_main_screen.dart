import 'package:flutter/material.dart';

class CharactersMainScreen extends StatefulWidget {
  const CharactersMainScreen({super.key});

  @override
  State<CharactersMainScreen> createState() => _CharactersMainScreenState();
}

class _CharactersMainScreenState extends State<CharactersMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Characters'),
    );
  }
}
