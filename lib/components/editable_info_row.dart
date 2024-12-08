
import 'package:calendar/components/picker_wrapper.dart';
import 'package:calendar/controllers/input_controller.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntryAttributeRow<T> extends StatefulWidget {
  final String attributeName;
  /// default input controller value toString()
  final String? attributeValueString;
  final InputController<T> inputController;
  final IconData? icon;
  final Widget? customInput;
  final List<T>? enumList;

  const EntryAttributeRow({
    super.key,
    required this.attributeName,
    required this.inputController,
    this.attributeValueString,
    this.icon,
    this.enumList,
    this.customInput
  });

  @override
  State<EntryAttributeRow<T>> createState() => _EntryAttributeRowState<T>();
}
 
class _EntryAttributeRowState<T> extends State<EntryAttributeRow<T>> {
  bool isEditing = false;

  Widget _buildIntInputWidget() {
    return CupertinoTextField(
      placeholder: widget.attributeName,
      keyboardType: TextInputType.number,
      controller: TextEditingController()..text = widget.inputController.value.toString(),
      inputFormatters: [
        if (T == int) FilteringTextInputFormatter.allow(RegExp(intRegex)),
        if (T == double) FilteringTextInputFormatter.allow(RegExp(doubleRegex)),
      ],
      onChanged: (v) {
        if (T == int) (widget.inputController as InputController<int>).silentSet(int.parse(v));
        if (T == double) (widget.inputController as InputController<double>).silentSet(double.parse(v));
      },
    );
  }

  Widget _buildDateTimeInputWidget() {
    return PickerWrapper(
      text: (widget.inputController.value as DateTime).formatToDisplay(), 
      picker: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        onDateTimeChanged: (widget.inputController as InputController<DateTime>).set,
      )
    );
  }

  Widget _buildStringInputWidget() {
    return CupertinoTextField(
      placeholder: widget.attributeName,
      controller: TextEditingController()..text = (widget.inputController as InputController<String>).value,
      onChanged: (widget.inputController as InputController<String>).silentSet, // value view will be rebuilt when isEditing is updated, hence no need to notify listener
    );
  }

  Widget? _buildEnumInputWidget() {
    if (widget.enumList == null) return null;

    return PickerWrapper(
      text: (widget.inputController.value as Enum).name,
      picker: CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        onSelectedItemChanged: (int selectedItem) =>
          widget.inputController.set(widget.enumList![selectedItem]),
        children: widget.enumList!.map((type) => Center(
          child: Text((type as Enum).name),
        )).toList(),
      ));
  }

  void _handleTextFieldInput(String v) {
    if (!isEditing) return;
    if (T == int && int.tryParse(v) != null)
      {(widget.inputController as InputController<int>).set(int.parse(v));}
    else if (T == double && double.tryParse(v) != null)
      {(widget.inputController as InputController<double>).set(double.parse(v));}
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.inputController,
      child: IconButton(
        icon: !isEditing ? const Icon(CupertinoIcons.pencil) : const Icon(CupertinoIcons.check_mark),
        onPressed: () =>
          setState(() {
            isEditing = !isEditing;
          }),
      ),
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: !isEditing ? 
                  Row(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Text(widget.attributeName)
                    ),
                    Text(widget.attributeValueString ?? widget.inputController.value.toString())
                  ]):
                  T == String? _buildStringInputWidget():
                  T == int || T == double? _buildIntInputWidget():
                  T == DateTime? _buildDateTimeInputWidget():
                  _buildEnumInputWidget() ?? 
                  widget.customInput ?? const Text("Unknown Attribute Value"),
              ),
          
              const SizedBox(width: 12),
          
              child ?? const SizedBox(),
            ],
          ),
        );
      }
    );
  }
}