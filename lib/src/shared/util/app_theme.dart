import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get theme => ThemeData(
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.black,
          indicatorColor: Colors.white,
          iconTheme: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: Colors.black);
              }
              return const IconThemeData(color: Colors.grey);
            },
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(color: Colors.white);
              }
              return const TextStyle(color: Colors.grey);
            },
          ),
        ),
      );
}
