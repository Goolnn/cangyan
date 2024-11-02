import 'package:cangyan/core/api/cyfile/credit.dart';
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
              cangyan.Title(
                summary.title(),
                summary.number(),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ("作者", Credit.artists),
                    ("翻译", Credit.translators),
                    ("校对", Credit.proofreaders),
                    ("修图", Credit.retouchers),
                    ("嵌字", Credit.typesetters),
                    ("监修", Credit.supervisors),
                  ].map<Widget>((pair) {
                    final names = summary.credits()[pair.$2] ?? <String>[];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cangyan.Capsule(
                          pair.$1,
                          backgroundColor: Colors.blue,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Wrap(
                            children: names.map<Widget>((credit) {
                              return cangyan.Capsule(
                                credit,
                                backgroundColor: Colors.lightBlue,
                              );
                            }).toList()
                              ..add(const SizedBox(width: 4.0))
                              ..add(const cangyan.Capsule("+")),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
