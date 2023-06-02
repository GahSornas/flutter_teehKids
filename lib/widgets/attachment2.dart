import 'dart:io';
import 'package:flutter/material.dart';

class Attachment2 extends StatelessWidget {
  final File pic2;

  const Attachment2({super.key, required this.pic2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: SizedBox(
          width: 100,
          height: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.file(
              pic2,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
