import 'package:cangyan/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cangyan/widgets.dart' as cangyan;

class AboutPage extends StatelessWidget {
  const AboutPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return cangyan.Page(
      buttons: [
        cangyan.HeaderButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 16.0,
          ),
        ),
      ],
      header: const Center(
        child: Text('关于'),
      ),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;

            if (height <= 400.0) {
              return _buildNarrowLayout(context);
            } else {
              return _buildStandardLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStandardLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16.0,
        children: [
          _buildAppInfoWidget(context),
          _buildContributionsWidget(context),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        spacing: 16.0,
        children: [
          _buildAppInfoWidget(context),
          _buildContributionsWidget(context),
        ],
      ),
    );
  }

  Widget _buildAppInfoWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
      ],
    );
  }

  Widget _buildContributionsWidget(BuildContext context) {
    return Flexible(
      child: Column(
        spacing: 8.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '主要项目',
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          Expanded(
            child: Container(
              // 圆角边框
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const SingleChildScrollView(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  spacing: 8.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 8.0,
                      children: [
                        Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('项目名称'),
                            Text('仓库地址'),
                            Text('仓库作者'),
                            Text('开源协议'),
                          ],
                        ),
                        Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cangyan'),
                            Text('https://github.com/Goolnn/cangyan'),
                            Text('谷林'),
                            Text('MIT'),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8.0,
                      children: [
                        Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('项目名称'),
                            Text('仓库地址'),
                            Text('仓库作者'),
                            Text('开源协议'),
                          ],
                        ),
                        Column(
                          spacing: 4.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('cyFile'),
                            Text('https://github.com/Goolnn/cyfile'),
                            Text('谷林'),
                            Text('MIT'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
