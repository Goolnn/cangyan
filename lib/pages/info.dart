import 'package:cangyan/core/api/cyfile/credit.dart';
import 'package:cangyan/core/api/cyfile/date.dart';
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48.0,
                    vertical: 8.0,
                  ),
                  child: cangyan.Image(image: summary.cover()),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          cangyan.Category(summary.category()),
                          Expanded(
                            child: cangyan.Title(
                              summary.title(),
                              summary.number(),
                            ),
                          ),
                          cangyan.Progress(summary.progress()),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '简介' * 100,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Text(
                              '创建于 ${_dateToString(summary.createdDate())}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '修改于 ${_dateToString(summary.savedDate())}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
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
      ),
    );
  }

  String _dateToString(Date date) {
    final year = '${date.year}年';
    final month = '${date.month}月';
    final day = '${date.day}日';
    final hour = '${date.hour}'.padLeft(2, '0');
    final minute = '${date.minute}'.padLeft(2, '0');
    final second = '${date.second}'.padLeft(2, '0');

    return '$year$month$day $hour:$minute:$second';
  }
}
