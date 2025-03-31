import 'package:flutter/material.dart';

class LocationMainScreen extends StatefulWidget {
  const LocationMainScreen({super.key});

  @override
  State<LocationMainScreen> createState() => _LocationsMainScreenState();
}

class _LocationsMainScreenState extends State<LocationMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Locations'),
    );
  }
}
