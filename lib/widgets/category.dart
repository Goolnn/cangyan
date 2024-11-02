import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String category;

  const Category(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return category.isEmpty
        ? Container()
        : Card(
            color: Colors.blue,
            shape: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          );
  }
}
