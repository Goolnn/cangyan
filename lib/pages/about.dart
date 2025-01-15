import 'package:cangyan/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox.square(
                    dimension: 128.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: const Image(
                        image: AssetImage('assets/icon.png'),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '苍眼',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    return Text(
                      '${snapshot.data?.version}',
                    );
                  },
                ),
                const SizedBox.square(dimension: 8.0),
                const CheckUpdateButton(),
                const SizedBox.square(dimension: 16.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        '主要项目',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 4.0,
                              children: [
                                Text('项目名称'),
                                Text('仓库地址'),
                                Text('仓库作者'),
                                Text('开源协议'),
                              ],
                            ),
                            SizedBox.square(dimension: 8.0),
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 4.0,
                              children: [
                                Text('Cangyan'),
                                Text('https://github.com/Goolnn/cangyan'),
                                Text('谷林'),
                                Text('MIT'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 4.0,
                              children: [
                                Text('项目名称'),
                                Text('仓库地址'),
                                Text('仓库作者'),
                                Text('开源协议'),
                              ],
                            ),
                            SizedBox.square(dimension: 8.0),
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 4.0,
                              children: [
                                Text('cyFile'),
                                Text('https://github.com/Goolnn/cyfile'),
                                Text('谷林'),
                                Text('MIT'),
                              ],
                            ),
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
}
