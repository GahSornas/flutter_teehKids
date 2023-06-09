import 'dart:io';
import 'package:flutter/material.dart';

class Attachment extends StatelessWidget {
  final File pic;

  const Attachment({super.key, required this.pic});

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
              pic,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
