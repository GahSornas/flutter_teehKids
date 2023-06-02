import 'dart:io';
import 'package:flutter/material.dart';

class Attachment3 extends StatelessWidget {
  final File pic3;

  const Attachment3({super.key, required this.pic3});

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
              pic3,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
