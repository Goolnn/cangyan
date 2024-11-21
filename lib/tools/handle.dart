import 'package:cangyan/cangyan.dart' as cangyan;
import 'package:flutter/material.dart';

class Handle extends ChangeNotifier {
  final cangyan.Summary summary;

  late MemoryImage _cover;
  late int _pageCount;

  late String _category;
  late String _title;
  late (int, int) _number;
  late double _progress;

  late String _comment;

  late cangyan.Date _createdDate;
  late cangyan.Date _updatedDate;

  Handle(this.summary) {
    _cover = MemoryImage(summary.cover());
    _pageCount = summary.pageCount().toInt();

    _category = summary.category();
    _title = summary.title();
    _number = summary.number();
    _progress = summary.progress();

    _comment = summary.comment();

    _createdDate = summary.createdDate();
    _updatedDate = summary.updatedDate();
  }

  set cover(MemoryImage cover) {
    _cover = cover;

    summary.setCover(cover: cover.bytes);

    notifyListeners();
  }

  set category(String category) {
    _category = category;

    summary.setCategory(category: category);

    notifyListeners();
  }

  set title(String title) {
    _title = title;

    summary.setTitle(title: title);

    notifyListeners();
  }

  set number((int, int) number) {
    _number = number;

    summary.setNumber(number: number);

    notifyListeners();
  }

  set comment(String comment) {
    _comment = comment;

    summary.setComment(comment: comment);

    notifyListeners();
  }

  MemoryImage get cover => _cover;
  int get pageCount => _pageCount;

  String get category => _category;
  String get title => _title;
  (int, int) get number => _number;
  double get progress => _progress;

  String get comment => _comment;

  String get createdDate => _dateToString(_createdDate);
  String get updatedDate => _dateToString(_updatedDate);

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
