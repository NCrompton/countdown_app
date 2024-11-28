import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDatePage extends ConsumerStatefulWidget {
  final DateTime? date;
  final Function? dismiss;
  
  const AddDatePage({
    super.key,
    this.date,
    this.dismiss,
   });

  @override
  ConsumerState<AddDatePage> createState() => _AddDatePageState();
}

class _AddDatePageState extends ConsumerState<AddDatePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _showTimePicker = false;
  late DateTime _selectedDate;

  @override
  initState() {
    super.initState();

    if (widget.date == null) {
      final now = DateTime.now(); 
      _selectedDate = DateTime(now.year, now.month, now.day);
    } else {
      _showTimePicker = true;
      _selectedDate = widget.date!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context, CupertinoDatePickerMode mode) {
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
                  mode: mode,  // Only date, no time
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      // Preserve the time while updating the date
                      _selectedDate = mode == CupertinoDatePickerMode.date ?
                      DateTime(
                        newDateTime.year,
                        newDateTime.month,
                        newDateTime.day,
                        _selectedDate.hour,
                        _selectedDate.minute,
                      ) : 
                      DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        newDateTime.hour,
                        newDateTime.minute,
                      ); 
                    });
                  },
                ),
              ),
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

  void _submitForm(bool isTargetDateEmpty) {
    if (_nameController.text.isEmpty) {
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

    if (isTargetDateEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Target Date'),
          content: const Text('Do you want to set target date as new event'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                _addToTarget(newEvent);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('NO'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
    _resetState();

    if (widget.dismiss == null) return;
    widget.dismiss!();
  }

  void _addToTarget(CountdownData newEvent) {
    ref.read(asyncDateStateProvider.notifier).setTargetDate(newEvent.id);
  }

  void _resetState() {
    _selectedDate = DateTime.now();
    _nameController.clear();
  }

  void _toggleAllowTime(bool? _) {
    final now = DateTime.now(); 
    setState(() {
      _showTimePicker = !_showTimePicker;
      _selectedDate = _showTimePicker? _selectedDate.add(Duration(hours: now.hour, minutes: now.minute)):
          DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isTargetDateEmpty = ref.watch(asyncDateStateProvider.select((state) => state.value?.targetDate == null));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
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

                // Date Input
                GestureDetector(
                  onTap: () => _showDatePicker(context, CupertinoDatePickerMode.date),
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
                          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(CupertinoIcons.calendar),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Time Input Session
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CupertinoCheckbox(value: _showTimePicker, onChanged: _toggleAllowTime),
                    const SizedBox(width: 16),

                    // Time Input
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showTimePicker? _showDatePicker(context, CupertinoDatePickerMode.time): null,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: _showTimePicker? CupertinoColors.systemGrey: CupertinoColors.lightBackgroundGray),
                            color: _showTimePicker? CupertinoColors.transparent: CupertinoColors.extraLightBackgroundGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 16, color: _showTimePicker? CupertinoColors.black: CupertinoColors.lightBackgroundGray),
                              ),
                              const Icon(CupertinoIcons.clock),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Add Event Button at bottom
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoButton.filled(
            onPressed: () => _submitForm(isTargetDateEmpty),
            child: const Text('Add Event'),
          ),
        ),
      ],
    );
  }
}