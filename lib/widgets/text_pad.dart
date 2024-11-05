import 'package:cangyan/core/file.dart' as cangyan;
import 'package:flutter/material.dart';

class TextPad extends StatelessWidget {
  final List<cangyan.Note> notes;
  final int index;

  const TextPad({
    super.key,
    required this.notes,
    required this.index,
  });

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
                  '${index + 1}',
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
