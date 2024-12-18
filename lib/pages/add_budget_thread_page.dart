import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
import 'package:calendar/utils/view_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBudgetThreadPage extends ConsumerStatefulWidget {
  final Function? dismiss;

  const AddBudgetThreadPage({super.key, this.dismiss});

  @override
  ConsumerState<AddBudgetThreadPage> createState() => _AddBudgetThreadPageState();
}

class _AddBudgetThreadPageState extends ConsumerState<AddBudgetThreadPage> {
  final TextEditingController _threadNameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  Currency _selectedCurrency = Currency.hkd;
  final List<Currency> _currencies = Currency.values;

  final _spacing = const SizedBox(height: 20);

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
              child: Text(_currencies[index].displayName),
            );
          })
        ),
      );
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

  void _submitBudgetThread(String threadName, String currency) {
    ref.read(budgetThreadProviderProvider.notifier)
      .addBudgetThread(BudgetThread(
        threadName: threadName, 
        preferredCurrency: _selectedCurrency
      ));
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(budgetThreadProviderProvider);
    return  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Add a new trip",
              style: TextStyle(
                fontSize: 32,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _spacing,
                  CupertinoTextField(
                    controller: _threadNameController,
                    placeholder: 'Trip Name',
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  _spacing,
                   _buildPicker(
                    text: _selectedCurrency.name.toUpperCase(), 
                    onPressed: _showCurrencyPicker, 
                    icon: CupertinoIcons.money_dollar
                  ),
                ],
              ),
            ),
            switch(provider) {
              AsyncLoading() => const CupertinoButton.filled(
                onPressed: null,
                child: CircularProgressIndicator(), 
              ),
              _ => CupertinoButton.filled(
                child: const Text('Done'),
                onPressed: () => _submitBudgetThread(_threadNameController.text, _currencyController.text),
              ),
            }
          ],
        ),
      );
  }
}