import 'package:flutter/material.dart';

class ProfileFeature extends StatefulWidget {
  const ProfileFeature({super.key});

  @override
  State<ProfileFeature> createState() => _ProfileFeatureState();
}

class _ProfileFeatureState extends State<ProfileFeature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: const[],
      ),
    );
  }
}