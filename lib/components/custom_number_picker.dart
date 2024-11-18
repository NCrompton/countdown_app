import 'package:flutter/cupertino.dart';

class CustomNumberPicker extends StatefulWidget {
  final void Function(int horizontal, int vertical) onNumbersSelected;
  final int horizontalInitialValue;
  final int verticalInitialValue;
  final int horizontalMaxValue;
  final int verticalMaxValue;

  const CustomNumberPicker({
    super.key,
    required this.onNumbersSelected,
    this.horizontalInitialValue = 1,
    this.verticalInitialValue = 1,
    this.horizontalMaxValue = 10,
    this.verticalMaxValue = 100,
  });

  @override
  State<CustomNumberPicker> createState() => _CustomNumberPickerState();
}

class _CustomNumberPickerState extends State<CustomNumberPicker> {
  late int _selectedHorizontalNumber;
  late int _selectedVerticalNumber;
  final _horizontalController = ScrollController();
  final _verticalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedHorizontalNumber = widget.horizontalInitialValue;
    _selectedVerticalNumber = widget.verticalInitialValue;
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Horizontal Picker
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.horizontalMaxValue,
            itemBuilder: (context, index) {
              final number = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedHorizontalNumber = number;
                    widget.onNumbersSelected(
                      _selectedHorizontalNumber,
                      _selectedVerticalNumber,
                    );
                  });
                },
                child: Container(
                  width: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedHorizontalNumber == number 
                      ? CupertinoColors.systemBlue.withOpacity(0.1)
                      : null,
                    border: _selectedHorizontalNumber == number
                      ? Border.all(color: CupertinoColors.systemBlue)
                      : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 24,
                      color: _selectedHorizontalNumber == number
                        ? CupertinoColors.systemBlue
                        : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Vertical Picker
        Container(
          height: 200,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            controller: _verticalController,
            itemCount: widget.verticalMaxValue,
            itemBuilder: (context, index) {
              final number = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVerticalNumber = number;
                    widget.onNumbersSelected(
                      _selectedHorizontalNumber,
                      _selectedVerticalNumber,
                    );
                  });
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedVerticalNumber == number 
                      ? CupertinoColors.systemBlue.withOpacity(0.1)
                      : null,
                    border: _selectedVerticalNumber == number
                      ? Border.all(color: CupertinoColors.systemBlue)
                      : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 20,
                      color: _selectedVerticalNumber == number
                        ? CupertinoColors.systemBlue
                        : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Result Display
        Text(
          '$_selectedHorizontalNumber × $_selectedVerticalNumber = ${_selectedHorizontalNumber * _selectedVerticalNumber}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 