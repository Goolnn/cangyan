import 'package:cangyan/core/file.dart' as cangyan;
import 'package:flutter/material.dart';

class TextPad extends StatefulWidget {
  final List<cangyan.Note> notes;
  final int index;
  final void Function()? onEditing;
  final void Function()? onSubmitted;

  const TextPad({
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

  @override
  Widget build(BuildContext context) {
    cangyan.Note note = widget.notes[widget.index];

    String content = note.texts[0].content;
    String comment = note.texts[0].comment;

    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: editing
            ? Row(
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

                          content = controller.text;
                        });

                        if (widget.onSubmitted != null) {
                          widget.onSubmitted!();
                        }
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ),
                ],
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

                                      controller.text = content;
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
                                        content,
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

                                      controller.text = comment;
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
                                        comment,
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
