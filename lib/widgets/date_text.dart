import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:flutter/material.dart';

class DateText extends StatelessWidget {
  final cangyan.Date date;

  final String? prefix;
  final String? separator;

  const DateText(
    this.date, {
    super.key,
    this.prefix,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${prefix ?? ''}${separator ?? ''}${_dateToString(date)}',
      style: const TextStyle(
        fontSize: 10.0,
        color: Colors.grey,
      ),
    );
  }

  String _dateToString(cangyan.Date date) {
    final year = '${date.year}年';
    final month = '${date.month}月';
    final day = '${date.day}日';
    final hour = '${date.hour}'.padLeft(2, '0');
    final minute = '${date.minute}'.padLeft(2, '0');
    final second = '${date.second}'.padLeft(2, '0');

    return '$year$month$day $hour:$minute:$second';
  }
}
