import 'package:flutter/material.dart';

class CustomSwitchTile extends StatefulWidget {
  final String title;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchTileState createState() => _CustomSwitchTileState();
}

class _CustomSwitchTileState extends State<CustomSwitchTile> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
        widget.onChanged(value);
      },
      activeColor: Colors.white,
      activeTrackColor: const Color(0xFF967BB6), // Change active track color here
    );
  }
}
