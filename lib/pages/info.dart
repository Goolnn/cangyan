import 'package:cangyan/core/api/cyfile/summary.dart';
import 'package:cangyan/widgets/widgets.dart' as cangyan;
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final Summary summary;

  const InfoPage({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 256.0 + 64.0,
                child: Center(
                  child: cangyan.Image(image: summary.cover()),
                ),
              ),
              const Divider(),
              SizedBox(
                height: 32.0,
                child: Row(
                  children: [
                    cangyan.Category(summary.category()),
                    Expanded(
                      child: cangyan.Title(
                        summary.title(),
                        summary.number(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    cangyan.Progress(summary.progress()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
