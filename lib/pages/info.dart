import 'package:cangyan/core/file.dart' as cangyan;
import 'package:cangyan/pages/edit.dart';
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final cangyan.Project project;

  const InfoPage({super.key, required this.project});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late List<cangyan.Page> pages;

  @override
  void initState() {
    super.initState();

    pages = widget.project.pages();
  }

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
                  child: cangyan.Image(image: widget.project.cover()),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          cangyan.Category(widget.project.category()),
                          Expanded(
                            child: cangyan.Title(
                              widget.project.title(),
                              widget.project.number(),
                            ),
                          ),
                          cangyan.Progress(widget.project.progress()),
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
                              '创建于 ${_dateToString(widget.project.createdDate())}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '修改于 ${_dateToString(widget.project.savedDate())}',
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
                      ("作者", cangyan.Credit.artists),
                      ("翻译", cangyan.Credit.translators),
                      ("校对", cangyan.Credit.proofreaders),
                      ("修图", cangyan.Credit.retouchers),
                      ("嵌字", cangyan.Credit.typesetters),
                      ("监修", cangyan.Credit.supervisors),
                    ].map<Widget>((pair) {
                      final names =
                          widget.project.credits()[pair.$2] ?? <String>[];

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cangyan.Capsule(
                            Text(pair.$1),
                            backgroundColor: Colors.blue,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Wrap(
                              children: names.map<Widget>((credit) {
                                return cangyan.Capsule(
                                  Text(credit),
                                  backgroundColor: Colors.lightBlue,
                                );
                              }).toList()
                                ..add(const SizedBox(width: 4.0))
                                ..add(const cangyan.Capsule(
                                  Text("+"),
                                )),
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      for (int i = 0; i < pages.length; i++)
                        FractionallySizedBox(
                          widthFactor: 1.0 / 3.0,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return EditPage(
                                          page: pages[i],
                                        );
                                      }),
                                    );
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 3.0 / 4.0,
                                    child: cangyan.Image(
                                      image: pages[i].data,
                                    ),
                                  ),
                                ),
                              ),
                              Text('第${i + 1}页'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _dateToString(cangyan.Date date) {
    final year = '${date.year}年';
    final month = '${date.month}月';
    final day = '${date.day}日';
    final hour = '${date.hour}'.padLeft(2, '0');
    final minute = '${date.minute}'.padLeft(2, '0');
    final second = '${date.second}'.padLeft(2, '0');

    return '$year$month$day $hour:$minute:$second';
  }
}
