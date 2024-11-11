import 'package:cangyan/core/file.dart' as cangyan;
import 'package:cangyan/core/states.dart' as cangyan;
import 'package:cangyan/widgets.dart' as cangyan;
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  final cangyan.InfoState state;

  InfoPage({
    super.key,
    required cangyan.Summary summary,
  }) : state = cangyan.InfoState.from(summary: summary);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.state.summary();
    final pages = summary.pages();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 256.0 + 64.0,
                  child: Image.memory(summary.cover()),
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
                            child: cangyan.EditableText(
                              summary.title(),
                              editable: false,
                              onSubmitted: (text) {
                                widget.state.setTitle(title: text);
                              },
                            ),
                          ),
                          const cangyan.Progress(0.0),
                        ],
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 64.0 + 16.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(summary.comment()),
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
                              '更新于 ${_dateToString(summary.updatedDate())}',
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Column(
                //     children: [
                //       ("作者", cangyan.Credit.artists),
                //       ("翻译", cangyan.Credit.translators),
                //       ("校对", cangyan.Credit.proofreaders),
                //       ("修图", cangyan.Credit.retouchers),
                //       ("嵌字", cangyan.Credit.typesetters),
                //       ("监修", cangyan.Credit.supervisors),
                //     ].map<Widget>((pair) {
                //       final names = summary.credits()[pair.$2] ?? <String>[];

                //       return Row(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           cangyan.Capsule(
                //             color: Colors.blue,
                //             child: Text(pair.$1),
                //           ),
                //           const SizedBox(width: 8.0),
                //           Expanded(
                //             child: Wrap(
                //               children: names.map<Widget>((credit) {
                //                 return cangyan.Capsule(
                //                   color: Colors.lightBlue,
                //                   child: Text(credit),
                //                 );
                //               }).toList()
                //                 ..add(const SizedBox(width: 4.0))
                //                 ..add(const cangyan.Capsule(
                //                   child: Text("+"),
                //                 )),
                //             ),
                //           )
                //         ],
                //       );
                //     }).toList(),
                //   ),
                // ),
                // const Divider(),
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
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) {
                                    //     return EditPage(
                                    //       page: pages[i],
                                    //     );
                                    //   }),
                                    // );
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 3.0 / 4.0,
                                    child: cangyan.Image(
                                      image: pages[i],
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
