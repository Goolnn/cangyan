import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: _colorScheme,
  dividerTheme: _dividerTheme,
  filledButtonTheme: _filledButtonTheme,
  dialogTheme: _dialogTheme,
  popupMenuTheme: _popupMenuTheme,
);

final _colorScheme = ColorScheme(
  primary: Colors.blue,
  onPrimary: Colors.white,
  secondary: Colors.blue.shade50,
  onSecondary: Colors.black87,
  error: Colors.red,
  onError: Colors.yellow,
  surface: Colors.white,
  onSurface: Colors.black87,
  brightness: Brightness.light,
);

final _dividerTheme = DividerThemeData(
  color: Colors.grey.shade300,
);

final _filledButtonTheme = FilledButtonThemeData(
  style: FilledButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  ),
);

final _dialogTheme = DialogTheme(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
);

final _popupMenuTheme = PopupMenuThemeData(
  shape: RoundedRectangleBorder(
    side: BorderSide(
      width: 0.5,
      color: Colors.grey.shade300,
    ),
    borderRadius: BorderRadius.circular(12.0),
  ),
  menuPadding: const EdgeInsets.all(6.0),
  elevation: 4.0,
);
