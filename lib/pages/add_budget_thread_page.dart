import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_thread_provider.dart';
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

  final _spacing = const SizedBox(height: 20);

  void _submitBudgetThread(String threadName, String currency) {
    ref.read(budgetThreadProviderProvider.notifier)
      .addBudgetThread(BudgetThread(
        threadName: threadName, 
        preferredCurrency: Currency.fromText(currency)!
      ));
  }

  @override
  Widget build(BuildContext context) {
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
                  CupertinoTextField(
                    controller: _currencyController,
                    placeholder: 'Preferred Currency',
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: CupertinoColors.systemGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            CupertinoButton.filled(
              child: const Text('Done'),
              onPressed: () => _submitBudgetThread(_threadNameController.text, _currencyController.text),
            ),
          ],
        ),
      );
  }
}