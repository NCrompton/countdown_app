import 'package:calendar/model/countdown_data.dart';
import 'package:calendar/controllers/date_controller.dart';
import 'package:calendar/controllers/view_provider.dart';
import 'package:calendar/providers/date_provider.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _padding = 16.0;

class DateCalculationPage extends ConsumerStatefulWidget {
  const DateCalculationPage({super.key});

  @override
  ConsumerState<DateCalculationPage> createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends ConsumerState<DateCalculationPage> {
  final _numController = TextEditingController();
  final _nameController = TextEditingController();
  final _visibilityController = VisibilityController(false);

  bool _showingTimePicker = false;
  final _dateController = DateCalculatorController(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), 0);

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
      date: _dateController.result,
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
    if (mounted) Navigator.of(context).pop();
  }

  void _addToTarget(CountdownData newEvent) =>
    ref.read(asyncDateStateProvider.notifier).setTargetDate(newEvent.id);

  void _resetState() {
    _dateController.date = DateTime.now();
    _nameController.clear();
  }

  void _toggleAllowTime(bool? _) {
    final now = DateTime.now(); 
    final selectedDate = _dateController.date;
    _dateController.changeDate(!_showingTimePicker? selectedDate.add(Duration(hours: now.hour, minutes: now.minute)):
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0));
    setState(() {
      _showingTimePicker = !_showingTimePicker;
    });
  }

  Widget _mainBody(BuildContext context, bool isTargetDateEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildDatePicker()),
          const SizedBox(height: _padding),
          _buildNameInput(),
          const SizedBox(height: _padding),
          _buildNumberPicker(context),
          const SizedBox(height: _padding),
          _buildTimePicker(),
          const Expanded(child: SizedBox()),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: CupertinoColors.systemGroupedBackground,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Result Date:',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dateController.result.formatToStandard(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 64),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interval From Now:',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _dateController.result.difference(DateTime.now()).inDays.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(_padding),
            child: CupertinoButton.filled(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _submitForm(isTargetDateEmpty);
              },
              child: const Text('Add Event'),
            ),
          ),
        ],
      );
  }

  Widget _buildNumberPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _padding),
      child: Row(
        children: [
          Flexible(
            child: CupertinoTextField(
              controller: _numController,
              keyboardType: TextInputType.number,
              placeholder: 'Number of days',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(intRegex)),
              ],
              onChanged: (String value) {
                // Convert string to integer, default to 0 if invalid
                final diff = int.tryParse(value) ?? 0;
                _dateController.changeDiff(diff);
              },
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 6,),
          GestureDetector(
            onTap: () => _showNumberPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              decoration: const BoxDecoration(
                color: CupertinoColors.activeBlue,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              // child: const Icon(Icons.numbers, color: Colors.white),
              child: const Text("#", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, color: Colors.white),)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _padding),
      child: CupertinoTextField(
        controller: _nameController,
        placeholder: 'Event Name',
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _padding),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CupertinoCheckbox(value: _showingTimePicker, onChanged: _toggleAllowTime),
            const SizedBox(width: 16),
      
            // Time Input
            Expanded(
              child: GestureDetector(
                onTap: () => _showingTimePicker? _showTimePicker(context): null,
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: _showingTimePicker? CupertinoColors.systemGrey: CupertinoColors.lightBackgroundGray),
                    color: _showingTimePicker? CupertinoColors.transparent: CupertinoColors.extraLightBackgroundGray,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_dateController.date.hour.toString().padLeft(2, '0')}:${_dateController.date.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 16, color: _showingTimePicker? CupertinoColors.black: CupertinoColors.lightBackgroundGray),
                      ),
                      const Icon(CupertinoIcons.clock),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  void _showTimePicker(BuildContext context) {
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
                  mode: CupertinoDatePickerMode.time,  // Only date, no time
                  initialDateTime: _dateController.date,
                  onDateTimeChanged: (newDateTime) {
                      _dateController.changeDate(
                        DateTime(
                          _dateController.date.year,
                          _dateController.date.month,
                          _dateController.date.day,
                          newDateTime.hour,
                          newDateTime.minute,
                        )
                      ); 
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

  Widget _buildDatePicker() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: _dateController.date,
      onDateTimeChanged: (newDateTime) {
        _dateController.changeDate(
          DateTime(
            newDateTime.year,
            newDateTime.month,
            newDateTime.day,
            _dateController.date.hour,
            _dateController.date.minute,
            newDateTime.minute,
          )
        );
      },
    );
  }

  void _showNumberPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
            top: false,
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem: _dateController.diff,
              ),
              onSelectedItemChanged: (int selectedItem) {
                _dateController.changeDiff(selectedItem);
                _numController.text = selectedItem.toString();
              },
              children: List<Widget>.generate(1000, (int index) {
                return Center(
                  child: Text(index.toString()),
                );
              }),
            ),
          ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isTargetDateEmpty = ref.watch(asyncDateStateProvider.select((state) => state.value?.targetDate == null));
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Add New Date"),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        child: SafeArea(
          child: ListenableBuilder(listenable: _dateController, builder: (BuildContext context, Widget? child){ 
            return ListenableBuilder(listenable: _visibilityController, builder: (BuildContext context, Widget? child){ 
              return _mainBody(context, isTargetDateEmpty);
            });
          }),
        )
      ),
    );
  }
} 