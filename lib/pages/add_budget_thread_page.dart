import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBudgetThreadPage extends StatefulWidget {
  final Function? dismiss;

  const AddBudgetThreadPage({super.key, this.dismiss});

  @override
  State<AddBudgetThreadPage> createState() => _AddBudgetThreadPageState();
}

class _AddBudgetThreadPageState extends State<AddBudgetThreadPage> {
  final TextEditingController _threadNameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  final _spacing = const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Add a new trip",
              style: TextStyle(
                fontSize: 32,
              ),
            ),
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
            _spacing,
            ElevatedButton(
              onPressed: () {
                // Assuming there's a function to handle the submission
                // This is a placeholder for the actual submission logic
                _submitBudgetThread(_threadNameController.text, _currencyController.text);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      );
  }

  void _submitBudgetThread(String threadName, String currency) {
    // Placeholder for actual submission logic
    print('Submitting budget thread: $threadName, Currency: $currency');
  }
}