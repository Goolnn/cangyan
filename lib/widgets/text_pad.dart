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
  late cangyan.Note note;

  @override
  void initState() {
    super.initState();

    note = widget.notes[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 8.0),
                Text(
                  '${widget.index + 1}',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox.square(
                    dimension: 32.0,
                    child: RawMaterialButton(
                      shape: const CircleBorder(),
                      onPressed: () {},
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
            const SizedBox(height: 4.0),
            const Text('初译'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      note.texts[0].content,
                    ),
                  ),
                ),
              ),
            ),
            const Text('校对'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      note.texts[0].comment,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
