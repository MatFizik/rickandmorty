import 'package:flutter/material.dart';

class EpisodesMainScreen extends StatefulWidget {
  const EpisodesMainScreen({super.key});

  @override
  State<EpisodesMainScreen> createState() => _EpisodesMainScreenState();
}

class _EpisodesMainScreenState extends State<EpisodesMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Episodes'),
    );
  }
}
