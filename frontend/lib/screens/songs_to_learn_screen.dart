import 'package:flutter/material.dart';

class SongsToLearnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Songs to Learn',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
