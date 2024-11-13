import 'package:cangyan/widgets.dart' as cangyan;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  static const platform = MethodChannel('goolnn.cangyan/intent');

  final images = <Uint8List>[];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: 512.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '新建项目',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  const Text('标题：'),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(4.0),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: [
                              for (int i = 0; i < images.length; i++)
                                FractionallySizedBox(
                                  widthFactor: 1.0 / 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 3.0 / 4.0,
                                          child: cangyan.Image(
                                            image: images[i],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text('第${i + 1}页'),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8.0,
                        right: 8.0,
                        child: FloatingActionButton.small(
                          shape: const CircleBorder(),
                          onPressed: () async {
                            final images =
                                (await platform.invokeListMethod("openImages"))
                                    ?.map((image) => image as Uint8List)
                                    .toList();

                            if (images == null) {
                              return;
                            }

                            for (final image in images) {
                              setState(() {
                                this.images.add(image);
                              });
                            }
                          },
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('取消'),
                    ),
                    FilledButton(
                      onPressed: () {
                        // TODO
                      },
                      child: const Text('创建'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
