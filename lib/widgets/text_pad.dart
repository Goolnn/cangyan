import 'package:cangyan/core.dart' as cangyan;
import 'package:flutter/material.dart';

class TextPad extends StatefulWidget {
  final cangyan.EditState state;

  final List<cangyan.Note> notes;
  final int index;
  final void Function()? onEditing;
  final void Function()? onSubmitted;

  const TextPad(
    this.state, {
    super.key,
    required this.notes,
    required this.index,
    this.onEditing,
    this.onSubmitted,
  });

  @override
  State<TextPad> createState() => _TextPadState();
}

class _TextPadState extends State<TextPad> {
  final controller = TextEditingController();

  bool editing = false;

  EditingField? field;

  @override
  Widget build(BuildContext context) {
    if (widget.notes.isEmpty) {
      return const Card();
    }

    final note = widget.notes[widget.index];
    final text = note.texts[0];

    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: editing
            ? PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) {
                    return;
                  }

                  setState(() {
                    editing = false;

                    if (widget.onSubmitted != null) {
                      widget.onSubmitted!();
                    }
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                        autofocus: true,
                        maxLines: null,
                      ),
                    ),
                    Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            editing = false;

                            switch (field) {
                              case EditingField.content:
                                widget.state.modifyNoteContent(
                                  noteIndex: BigInt.from(widget.index),
                                  content: controller.text,
                                );

                                text.content = controller.text;
                                break;
                              case EditingField.comment:
                                widget.state.modifyNoteComment(
                                  noteIndex: BigInt.from(widget.index),
                                  comment: controller.text,
                                );

                                text.comment = controller.text;
                                break;
                              default:
                                break;
                            }
                          });

                          field = null;

                          if (widget.onSubmitted != null) {
                            widget.onSubmitted!();
                          }
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${widget.index + 1}',
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              const Text('初译'),
                              Expanded(
                                child: GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      editing = true;

                                      field = EditingField.content;

                                      controller.text = text.content;
                                    });

                                    if (widget.onEditing != null) {
                                      widget.onEditing!();
                                    }
                                  },
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        text.content,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const VerticalDivider(),
                        Flexible(
                          child: Column(
                            children: [
                              const Text('校对'),
                              Expanded(
                                child: GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      editing = true;

                                      field = EditingField.comment;

                                      controller.text = text.comment;
                                    });

                                    if (widget.onEditing != null) {
                                      widget.onEditing!();
                                    }
                                  },
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        text.comment,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

enum EditingField {
  content,
  comment,
}
