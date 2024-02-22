import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyConsumer<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T value) builder;

  const MyConsumer({super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, value, child) {
        return builder(context, value);
      },
    );
  }
}
