import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDatePage extends ConsumerStatefulWidget {
  final DateTime? date;
  
  const AddDatePage({
    super.key,
    this.date,
   });

  @override
  ConsumerState<AddDatePage> createState() => _AddDatePageState();
}

class _AddDatePageState extends ConsumerState<AddDatePage> {
  final TextEditingController _nameController = TextEditingController();
  late DateTime _selectedDate = widget.date ?? DateTime.now();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
              // Button to close the modal
              CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_nameController.text.isEmpty) {
      // Show error
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter an event name'),
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

    final newEvent = CountdownData(
      name: _nameController.text,
      date: _selectedDate,
    );

    ref.read(asyncDateStateProvider.notifier).addDate(newEvent);
    _nameController.clear();
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedDate = widget.date ?? DateTime.now();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Event Name Input
          CupertinoTextField(
            controller: _nameController,
            placeholder: 'Event Name',
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),

          // Date/Time Input
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate.formateDateStringToStandard(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(CupertinoIcons.calendar),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          CupertinoButton.filled(
            onPressed: _submitForm,
            child: const Text('Add Event'),
          ),
        ],
      ),
    );
  }
}