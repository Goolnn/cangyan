import 'dart:math';

import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPage extends StatefulWidget {
  final MemoryImage image;

  final cangyan.Editor editor;

  const EditPage({
    super.key,
    required this.image,
    required this.editor,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final drawerController = cangyan.DrawerController();
  final viewerController = cangyan.PageViewerController();

  late final List<cangyan.Note> notes;

  int? index;
  cangyan.Note? note;

  @override
  void initState() {
    super.initState();

    drawerController.addListener(() {
      setState(() {});
    });

    notes = widget.editor.notes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: !drawerController.open,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }

            setState(() {
              drawerController.open = false;
            });
          },
          child: cangyan.Drawer(
            controller: drawerController,
            drawer: cangyan.TextPad(
              index: index,
              note: note,
              onIndexTap: () {
                final scale = viewerController.scale;

                viewerController.x = note!.x;
                viewerController.y = note!.y - (1.0 / 3.0) / scale;
              },
              onPrevTap: () {
                setState(() {
                  index = max(index! - 1, 1);
                  note = notes[index! - 1];
                });

                final scale = viewerController.scale;

                viewerController.x = note!.x;
                viewerController.y = note!.y - (1.0 / 3.0) / scale;
              },
              onNextTap: () {
                setState(() {
                  index = min(index! + 1, notes.length);
                  note = notes[index! - 1];
                });

                final scale = viewerController.scale;

                viewerController.x = note!.x;
                viewerController.y = note!.y - (1.0 / 3.0) / scale;
              },
              onEditing: () {
                drawerController.draggable = false;
                drawerController.factor = 7.0;
              },
              onSubmitted: (field, text) {
                drawerController.draggable = true;
                drawerController.factor = 3.0;

                switch (field) {
                  case cangyan.EditingField.content:
                    widget.editor.updateNoteContent(
                      index: BigInt.from(index! - 1),
                      content: text,
                    );

                    setState(() {
                      note!.texts[0].content = text;
                    });

                    break;
                  case cangyan.EditingField.comment:
                    widget.editor.updateNoteComment(
                      index: BigInt.from(index! - 1),
                      comment: text,
                    );

                    note!.texts[0].comment = text;

                    break;
                }
              },
            ),
            child: cangyan.PageViewer(
              controller: viewerController,
              image: widget.image,
              notes: notes,
              onAppendNote: (x, y) {
                HapticFeedback.vibrate();

                widget.editor.appendNote(
                  x: x,
                  y: y,
                );

                setState(() {
                  notes.add(cangyan.Note(
                    x: x,
                    y: y,
                    comfirm: null,
                    texts: [
                      cangyan.Text(
                        content: '',
                        comment: '',
                      ),
                    ],
                  ));
                });
              },
              onDoubleTap: () {
                viewerController.scale = 1.0;

                viewerController.x = 0.0;
                viewerController.y = 0.0;
              },
              onNoteTap: (index, note) {
                setState(() {
                  drawerController.open = true;

                  this.index = index + 1;
                  this.note = note;
                });
              },
              onNoteLongPress: (index, note) {
                HapticFeedback.vibrate();

                drawerController.open = false;

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('删除'),
                      content: const Text('确认删除这个标记吗？'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('取消'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (this.index == index + 1) {
                              setState(() {
                                this.index = 1;
                                this.note = notes[0];
                              });
                            }

                            widget.editor.removeNote(
                              index: BigInt.from(index),
                            );

                            setState(() {
                              notes.removeAt(index);
                            });

                            Navigator.pop(context);
                          },
                          child: const Text('确认'),
                        ),
                      ],
                    );
                  },
                );
              },
              onNoteMove: (index, x, y) {
                widget.editor.updateNotePosition(
                  index: BigInt.from(index),
                  x: x,
                  y: y,
                );

                setState(() {
                  notes[index].x = x;
                  notes[index].y = y;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
