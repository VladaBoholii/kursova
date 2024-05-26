import 'package:flutter/material.dart';

class NullWidget extends StatefulWidget {
  const NullWidget({super.key});

  @override
  State<NullWidget> createState() => _NullWidgetState();
}

class _NullWidgetState extends State<NullWidget> {
  @override
  void initState() {
    super.initState();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
