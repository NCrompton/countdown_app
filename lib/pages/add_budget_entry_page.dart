import 'package:calendar/components/input_value_row.dart';
import 'package:calendar/dummy/dummy_data.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:calendar/utils/view_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBudgetEntryPage extends ConsumerStatefulWidget {
  final void Function()? dismiss;
  final BudgetThread? thread;

  const AddBudgetEntryPage({
    super.key, 
    this.thread,
    this.dismiss,
  });

  @override
  ConsumerState<AddBudgetEntryPage> createState() => _AddBudgetEntryPageState();
}

class _AddBudgetEntryPageState extends ConsumerState<AddBudgetEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _newTypeController = TextEditingController();
  DateTime _createTime = DateTime.now();
  Currency _selectedCurrency = Currency.hkd;
  int _selectedType = 0;

  final List<Currency> _currencies = Currency.values;
  final List<BudgetEntryType> _entryTypes = entryTypes;

  void _showAddTypeDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Add New Type'),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CupertinoTextField(
            controller: _newTypeController,
            placeholder: 'Type name',
            autofocus: true,
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Cancel'),
            onPressed: () {
              _newTypeController.clear();
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Add'),
            onPressed: () {
              if (_newTypeController.text.isNotEmpty) {
                setState(() {
                  _entryTypes.add(BudgetEntryType(name: _newTypeController.text));
                  _selectedType = _entryTypes.indexWhere((e) => e.typeName == _newTypeController.text);
                });
                _newTypeController.clear();
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all fields'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
    );
  }

  void _showTypeSelector() {
    showCupertinoPickerPopup(
      context: context, 
      picker: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.0,
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    _selectedType = selectedItem;
                  });
                },
                children: _entryTypes.map((type) => Center(
                  child: Text(type.typeName),
                )).toList(),
              ),
    );
  }

  void _showCurrencyPicker() {
    return showCupertinoPickerPopup(
        context: context, 
        picker: CupertinoPicker(
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: 32.0,
          onSelectedItemChanged: (selectedItem) =>
            setState(() => _selectedCurrency = _currencies[selectedItem]),
          children: List<Widget>.generate(_currencies.length,
              (int index) {
            return Center(
              child: Text(_currencies[index].name),
            );
          })
        ),
      );
  }

  void _showCreateTimePicker() {
    showCupertinoPickerPopup(
      context: context, 
      picker: CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        mode: CupertinoDatePickerMode.dateAndTime,
        onDateTimeChanged: (dateTime) =>
          setState(() {_createTime = dateTime;}),
      )
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _newTypeController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _nameController.text = "";
      _priceController.text = "";
      _newTypeController.text = "";
      _selectedCurrency = Currency.hkd;
      _selectedType = 0;
    });
  }

  void _submitForm() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) return _showErrorDialog();

    // Create and submit entry
    final entry =  BudgetEntry(
      entryName: _nameController.text,
      price: LocalizedPrice(valueParam: double.parse(_priceController.text)),
      type: _entryTypes[_selectedType],
      time: _createTime,
      threadParam: widget.thread,
    );
    // TODO: check success
    if (widget.thread != null) {
      ref.read(budgetThreadEntryProviderProvider(widget.thread!.id).notifier).addNewEntry(entry);
    } else {
      ref.read(budgetEntriesProviderProvider.notifier).addEntries(entry);
    }
      

    _resetForm();
    if (widget.dismiss != null) widget.dismiss!();
  }

  Widget _buildPicker({
    required String text,
    required void Function() onPressed,
    IconData? icon,
  }) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: onPressed,
                  child: Text(
                    text,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: CupertinoColors.systemBlue,
                    ),
                  ),
                ),
              ),

              if (icon != null) Icon(icon),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TODO: thread picker

                  InputValueRow(controller: _nameController, placeholder: "Entry Name"),
                  const SizedBox(height: 16),
    
                  InputValueRow(controller: _priceController, placeholder: "Price", isDouble: true,),
                  const SizedBox(height: 16),
      
                  // Currency Dropdown
                  _buildPicker(
                    text: _selectedCurrency.name.toUpperCase(), 
                    onPressed: _showCurrencyPicker, 
                    icon: CupertinoIcons.money_dollar
                  ),
                  const SizedBox(height: 16),
      
                  // Entry Type Selection
                  _buildPicker(
                    text: _entryTypes[_selectedType].typeName, 
                    onPressed: _showTypeSelector, 
                    icon: _entryTypes[_selectedType].icon,
                  ),
                  const SizedBox(height: 16,),

                  // Entry Time Selection
                  _buildPicker(
                    text: _createTime.formatToStandard(), 
                    onPressed: _showCreateTimePicker, 
                    icon: CupertinoIcons.calendar
                  ),
                ],
              ),
            ),
          ),
          // Submit Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CupertinoButton.filled(
              onPressed: _submitForm,
              child: const Text('Add Entry'),
            ),
          ),
        ],
      ),
    );
  }
}