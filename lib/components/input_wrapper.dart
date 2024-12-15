import 'package:calendar/utils/view_helper.dart';
import 'package:flutter/material.dart';

class InputWrapper extends StatelessWidget {
  final String text;
  final Widget child;

  const InputWrapper({
    super.key,
    required this.text,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    )
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: child
                  ),
                ]
              )
            )
          ]
        )
    );
  }
}


class PickerWrapper extends StatelessWidget {
  final String text;
  final String value;
  final Widget? picker;

  const PickerWrapper({
    super.key,
    required this.text,
    required this.value,
    this.picker,
  });

  @override
  Widget build(BuildContext context) {
    return InputWrapper(
      text: text,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(value),
            )
          ),
                      
          const SizedBox(width: 12),
                    
          if (picker != null)
          IconButton(
            visualDensity: const VisualDensity(vertical: -2),
            color: Colors.grey,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showCupertinoPickerPopup(
              context: context, 
              picker: picker!,
            ),
          ),
        ]
      ),
    );
  }
}


class InputFieldWrapper extends StatefulWidget {
  final String text;
  final String value;
  final Widget child;
  final void Function() onSumbmit;

  const InputFieldWrapper({
    super.key,
    required this.text,
    required this.value,
    required this.child,
    required this.onSumbmit,
  });

  @override
  State<InputFieldWrapper> createState() => InputFieldWrapperState();
}

class InputFieldWrapperState extends State<InputFieldWrapper> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return InputWrapper(
      text: widget.text,
      child: Row(
          children: [
            Expanded(
              child: !isEdit 
              ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(widget.value),
              )
              : widget.child
            ),
                        
            const SizedBox(width: 12),
                      
            IconButton(
              visualDensity: const VisualDensity(vertical: -2),
              color: Colors.grey,
              icon: isEdit ? const Icon(Icons.check) : const Icon(Icons.edit_outlined),
              onPressed: () => setState(() {
                if (isEdit) widget.onSumbmit();
                isEdit = !isEdit;
              }),
            ),
          ]
        )
    );
  }
}