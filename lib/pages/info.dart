import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final cangyan.Summary summary;
  final cangyan.Pages pages;

  InfoPage({
    super.key,
    required this.summary,
  }) : pages = summary.pages();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Placeholder(),
      ),
    );
  }
}

// import 'package:cangyan/core/cyfile.dart' as cangyan;
// import 'package:cangyan/core/states.dart' as cangyan;
// import 'package:cangyan/pages/edit.dart';
// import 'package:cangyan/widgets.dart' as cangyan;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class InfoPage extends StatefulWidget {
//   final cangyan.InfoState state;

//   InfoPage({
//     super.key,
//     required cangyan.Summary summary,
//   }) : state = cangyan.InfoState.from(summary: summary);

//   @override
//   State<InfoPage> createState() => _InfoPageState();
// }

// class _InfoPageState extends State<InfoPage> {
//   static const platform = MethodChannel('com.goolnn.cangyan/intent');

//   late MemoryImage cover;

//   late final List<MemoryImage> pages;

//   @override
//   void initState() {
//     super.initState();

//     cover = MemoryImage(widget.state.summary().cover());

//     pages = widget.state.summary().pages().map((page) {
//       return MemoryImage(page);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final summary = widget.state.summary();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white10,
//         surfaceTintColor: Colors.transparent,
//         toolbarHeight: 48.0,
//         title: Text(summary.title()),
//         titleTextStyle: const TextStyle(
//           fontSize: 18.0,
//           color: Colors.black,
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 256.0 + 64.0,
//                   child: Image(
//                     image: cover,
//                   ),
//                 ),
//                 const Divider(),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           cangyan.Category(summary.category()),
//                           Expanded(
//                             child: cangyan.EditableText(
//                               summary.title(),
//                               onSubmitted: (text) {
//                                 setState(() {
//                                   widget.state.setTitle(title: text);
//                                 });
//                               },
//                             ),
//                           ),
//                           const cangyan.Progress(0.0),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(summary.comment()),
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Column(
//                           children: [
//                             Text(
//                               '创建于 ${_dateToString(summary.createdDate())}',
//                               style: const TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             Text(
//                               '更新于 ${_dateToString(summary.updatedDate())}',
//                               style: const TextStyle(
//                                 fontSize: 12.0,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Column(
//                 //     children: [
//                 //       ("作者", cangyan.Credit.artists),
//                 //       ("翻译", cangyan.Credit.translators),
//                 //       ("校对", cangyan.Credit.proofreaders),
//                 //       ("修图", cangyan.Credit.retouchers),
//                 //       ("嵌字", cangyan.Credit.typesetters),
//                 //       ("监修", cangyan.Credit.supervisors),
//                 //     ].map<Widget>((pair) {
//                 //       final names = summary.credits()[pair.$2] ?? <String>[];

//                 //       return Row(
//                 //         crossAxisAlignment: CrossAxisAlignment.start,
//                 //         children: [
//                 //           cangyan.Capsule(
//                 //             color: Colors.blue,
//                 //             child: Text(pair.$1),
//                 //           ),
//                 //           const SizedBox(width: 8.0),
//                 //           Expanded(
//                 //             child: Wrap(
//                 //               children: names.map<Widget>((credit) {
//                 //                 return cangyan.Capsule(
//                 //                   color: Colors.lightBlue,
//                 //                   child: Text(credit),
//                 //                 );
//                 //               }).toList()
//                 //                 ..add(const SizedBox(width: 4.0))
//                 //                 ..add(const cangyan.Capsule(
//                 //                   child: Text("+"),
//                 //                 )),
//                 //             ),
//                 //           )
//                 //         ],
//                 //       );
//                 //     }).toList(),
//                 //   ),
//                 // ),
//                 // const Divider(),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Wrap(
//                     children: [
//                       for (int i = 0; i < pages.length; i++)
//                         FractionallySizedBox(
//                           widthFactor: 1.0 / 3.0,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: GestureDetector(
//                                   behavior: HitTestBehavior.translucent,
//                                   onTap: () {
//                                     final editState = widget.state.openPage(
//                                       index: BigInt.from(i),
//                                     );

//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context) {
//                                         return EditPage(
//                                           pages[i],
//                                           state: editState,
//                                         );
//                                       }),
//                                     );
//                                   },
//                                   onLongPressStart: (details) {
//                                     showMenu<int>(
//                                       context: context,
//                                       position: RelativeRect.fromLTRB(
//                                         details.globalPosition.dx,
//                                         details.globalPosition.dy,
//                                         details.globalPosition.dx,
//                                         details.globalPosition.dy,
//                                       ),
//                                       items: [
//                                         const PopupMenuItem(
//                                           value: 1,
//                                           child: Text("向前插入新页"),
//                                         ),
//                                         const PopupMenuItem(
//                                           value: 2,
//                                           child: Text("向后插入新页"),
//                                         ),
//                                         if (pages.length > 1) ...[
//                                           const PopupMenuDivider(),
//                                           const PopupMenuItem(
//                                             value: 3,
//                                             child: Text("删除页面"),
//                                           ),
//                                         ],
//                                       ],
//                                     ).then((value) async {
//                                       if (value case 1) {
//                                         final images = (await platform
//                                                 .invokeListMethod("openImages"))
//                                             ?.map((image) => image as Uint8List)
//                                             .toList();

//                                         if (images == null) {
//                                           return;
//                                         }

//                                         for (final image in images.reversed) {
//                                           widget.state.insertPageBefore(
//                                             index: BigInt.from(i),
//                                             image: image,
//                                           );

//                                           setState(() {
//                                             pages.insert(
//                                               i,
//                                               MemoryImage(image),
//                                             );
//                                           });
//                                         }

//                                         if (i == 0) {
//                                           setState(() {
//                                             cover = pages.first;
//                                           });

//                                           widget.state
//                                               .setCover(cover: cover.bytes);
//                                         }
//                                       } else if (value case 2) {
//                                         final images = (await platform
//                                                 .invokeListMethod("openImages"))
//                                             ?.map((image) => image as Uint8List)
//                                             .toList();

//                                         if (images == null) {
//                                           return;
//                                         }

//                                         for (final image in images.reversed) {
//                                           widget.state.insertPageAfter(
//                                             index: BigInt.from(i),
//                                             image: image,
//                                           );

//                                           setState(() {
//                                             pages.insert(
//                                               i + 1,
//                                               MemoryImage(image),
//                                             );
//                                           });
//                                         }
//                                       } else if (value case 3) {
//                                         widget.state.removePage(
//                                           index: BigInt.from(i),
//                                         );

//                                         setState(() {
//                                           pages.removeAt(i);
//                                         });

//                                         if (i == 0) {
//                                           setState(() {
//                                             cover = pages.first;
//                                           });

//                                           widget.state
//                                               .setCover(cover: cover.bytes);
//                                         }
//                                       }
//                                     });
//                                   },
//                                   child: AspectRatio(
//                                     aspectRatio: 3.0 / 4.0,
//                                     child: cangyan.Image(
//                                       provider: pages[i],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Text('第${i + 1}页'),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _dateToString(cangyan.Date date) {
//     final year = '${date.year}年';
//     final month = '${date.month}月';
//     final day = '${date.day}日';
//     final hour = '${date.hour}'.padLeft(2, '0');
//     final minute = '${date.minute}'.padLeft(2, '0');
//     final second = '${date.second}'.padLeft(2, '0');

//     return '$year$month$day $hour:$minute:$second';
//   }
// }
