import 'package:cangyan/core.dart' as cangyan;
import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  final cangyan.Summary summary;

  const Tile({
    super.key,
    required this.summary,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
