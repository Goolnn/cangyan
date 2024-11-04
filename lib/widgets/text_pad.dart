import 'package:cangyan/core/file.dart' as cangyan;
import 'package:flutter/material.dart';

class TextPad extends StatelessWidget {
  final List<cangyan.Note> notes;
  final int index;
  final void Function() onClose;

  const TextPad({
    super.key,
    required this.notes,
    required this.index,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox.fromSize(
                      size: const Size.fromRadius(16.0),
                      child: RawMaterialButton(
                        shape: const CircleBorder(),
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                    ),
                    Text('${index + 1}'),
                    SizedBox.fromSize(
                      size: const Size.fromRadius(16.0),
                      child: RawMaterialButton(
                        shape: const CircleBorder(),
                        onPressed: onClose,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (index >= 0)
                      for (int i = 0; i < notes[index].texts.length; i++)
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notes[index].texts[i].content),
                                  if (notes[index]
                                      .texts[i]
                                      .comment
                                      .isNotEmpty) ...[
                                    const Divider(),
                                    Text(notes[index].texts[i].comment),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
