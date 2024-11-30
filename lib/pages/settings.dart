import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool checkUpdate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  checkUpdate = !checkUpdate;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('自动检查最新版本'),
                  ),
                  Checkbox(
                    value: checkUpdate,
                    onChanged: (value) {
                      setState(() {
                        checkUpdate = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: FilledButton(
                onPressed: () {},
                child: const Text('检查更新'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
