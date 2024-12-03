import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBudgetEntryPage extends ConsumerStatefulWidget {
  const AddBudgetEntryPage({super.key});

  @override
  ConsumerState<AddBudgetEntryPage> createState() => _AddBudgetEntryPageState();
}

class _AddBudgetEntryPageState extends ConsumerState<AddBudgetEntryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _newTypeController = TextEditingController();
  String _selectedCurrency = 'USD';
  int _selectedType = 0;

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'HKD'];
  List<String> _entryTypes = ['None', 'Food', 'Transport', 'Entertainment', 'Shopping'];

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
                  _entryTypes.add(_newTypeController.text);
                  _selectedType = _entryTypes.indexOf(_newTypeController.text);
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

  void _showTypeSelector() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Add New Type'),
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddTypeDialog();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
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
                    child: Text(type),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
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
      _selectedCurrency = 'HKD';
      _selectedType = 0;
    });
  }

  void _submitForm() {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
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
      return;
    }

    // Create and submit entry
    final entry = {
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'currency': _selectedCurrency,
      'type': _selectedType,
    };

    // TODO: Add to provider
    print(entry);

    _resetForm();
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
                  // Entry Name Input
                  CupertinoTextField(
                    controller: _nameController,
                    placeholder: 'Entry Name',
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Price Input
                  CupertinoTextField(
                    controller: _priceController,
                    placeholder: 'Price',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Currency Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: const Text('Currency: ')
                        ),
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) => Container(
                                  height: 216,
                                  padding: const EdgeInsets.only(top: 6.0),
                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  color: CupertinoColors.systemBackground,
                                  child: SafeArea(
                                    top: false,
                                    child: CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: 32.0,
                                      onSelectedItemChanged: (int selectedItem) {
                                        setState(() {
                                          _selectedCurrency = _currencies[selectedItem];
                                        });
                                      },
                                      children: List<Widget>.generate(_currencies.length,
                                          (int index) {
                                        return Center(
                                          child: Text(
                                            _currencies[index],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              _selectedCurrency,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                color: CupertinoColors.systemBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Entry Type Selection
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: const Text('Type: ')
                        ),
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _showTypeSelector,
                            child: Text(
                              _entryTypes[_selectedType],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: _selectedType == 0?  CupertinoColors.inactiveGray:CupertinoColors.systemBlue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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