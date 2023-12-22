import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final dynamic isSelected;
  final dynamic changeSelection;
  const CustomRadioButton({super.key, this.isSelected, this.changeSelection});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState(isSelected, changeSelection);
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  dynamic isSelected;
  dynamic changeSelection;
  _CustomRadioButtonState(this.isSelected, this.changeSelection);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        changeSelection();
        setState(() {
          isSelected = true;
        });
      },
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: isSelected ? const Color(0xff201A30) : const Color(0xff38304C),
            child: isSelected ? const Icon(Icons.check, color: Colors.white) : const Text(""),
          ),
        ),
      ),
    );
  }
}