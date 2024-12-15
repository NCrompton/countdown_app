import 'package:calendar/components/input_wrapper.dart';
import 'package:calendar/controllers/input_controller.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/utils/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class EntryAttributeRow<T> extends StatefulWidget {
  final String attributeName;
  /// default input controller value toString()
  final String? attributeValueString;
  final InputController<T> inputController;
  final IconData? icon;
  final Widget? customInput;
  final List<T>? enumList;
  final bool allowExitEditing;
  final bool? skip;

  const EntryAttributeRow({
    super.key,
    required this.attributeName,
    required this.inputController,
    this.attributeValueString,
    this.icon,
    this.enumList,
    this.customInput,
    this.skip,
    bool? allowExitEditing,
  }):
    allowExitEditing = allowExitEditing ?? true,
    assert(T == String 
      || T == int 
      || T == double 
      || T == DateTime 
      || inputController is InputController<ProjectEnum> 
      || customInput != null 
    );

  String get value => attributeValueString ?? inputController.value.toString();

  bool get isString => T == String;
  bool get isInt => T == int;
  bool get isDouble => T == double;
  bool get isDateTime => T == DateTime;
  bool get isProjectEnum => inputController is InputController<ProjectEnum>; // it is not possible to check generic type superclass 
  bool get isCustomValue => customInput != null;

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
        if (widget.isInt) FilteringTextInputFormatter.allow(RegExp(intRegex)),
        if (widget.isDouble) FilteringTextInputFormatter.allow(RegExp(doubleRegex)),
      ],
      onChanged: (v) {
        if (widget.isInt) (widget.inputController as InputController<int>).silentSet(int.parse(v));
        if (widget.isDouble) (widget.inputController as InputController<double>).silentSet(double.parse(v));
      },
    );
  }

  Widget _buildDateTimeInputWidget() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.dateAndTime,
      onDateTimeChanged: (widget.inputController as InputController<DateTime>).set,
    );
  }

  Widget _buildStringInputWidget() {
    return CupertinoTextField(
        placeholder: widget.attributeName,
        controller: TextEditingController()..text = (widget.inputController as InputController<String>).value,
        onChanged: (widget.inputController as InputController<String>).silentSet, 
    );
  }

  Widget? _buildEnumInputWidget() {
    if (widget.enumList == null) return null;
    //TODO: Why T is not ProjectEnum

    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32.0,
      onSelectedItemChanged: (int selectedItem) =>
        widget.inputController.set(widget.enumList![selectedItem]),
      children: widget.enumList!.map((type) => Center(
        child: Text((type as ProjectEnum).displayName),
      )).toList(),
    );
  }

  void _handleTextFieldInput(String v) {
    if (!isEditing) return;
    if (widget.isInt && int.tryParse(v) != null)
      {(widget.inputController as InputController<int>).set(int.parse(v));}
    else if (widget.isDouble && double.tryParse(v) != null)
      {(widget.inputController as InputController<double>).set(double.parse(v));}
    else if (widget.isString)
      {(widget.inputController as InputController<String>).set(v);}
  }

  void _handleTextFieldSubmit() {
    widget.inputController.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.inputController,
      builder: (context, child) {
        return (widget.isString || widget.isInt || widget.isDouble) 
          ? InputFieldWrapper(
            text: widget.attributeName,
            value: widget.value ,
            onSumbmit: _handleTextFieldSubmit,
            child: (widget.isString)
              ? _buildStringInputWidget()
              : _buildIntInputWidget()
          )
        : (widget.isDateTime || widget.isProjectEnum || widget.isCustomValue)
          ? PickerWrapper(
            text: widget.attributeName, 
            value: widget.value,
            picker: (widget.isDateTime)
              ? _buildDateTimeInputWidget()
              : (widget.isProjectEnum)
                ? _buildEnumInputWidget()
                : widget.customInput
          )
        : const Text("Unknown Attribute Value");
      }
    );
  }
}