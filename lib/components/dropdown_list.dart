import 'package:flutter/material.dart';

class CustomDropdownList extends StatelessWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String?>
      onChanged; // Change ValueChanged<String> to ValueChanged<String?>
  final List<TextStyle> itemStyles;

  CustomDropdownList({
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemStyles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xFFCAADEE)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          items: items.asMap().entries.map<DropdownMenuItem<String>>((entry) {
            int index = entry.key;
            String item = entry.value;
            return DropdownMenuItem<String>(
              value: item,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  item,
                  style: itemStyles[index],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
