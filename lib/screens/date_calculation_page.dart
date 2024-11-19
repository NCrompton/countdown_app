import 'package:calendar/components/custom_number_picker.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/pages/add_date.dart';
import 'package:calendar/controllers/date_controller.dart';
import 'package:calendar/controllers/view_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateCalculationPage extends ConsumerStatefulWidget {
  const DateCalculationPage({super.key});

  @override
  ConsumerState<DateCalculationPage> createState() => _DateSelectionPageState();
}

class _DateSelectionPageState extends ConsumerState<DateCalculationPage> {
  final _numController = TextEditingController();
  final _visibilityController = VisibilityController(false);

  final _dateController = DateCalculatorController(DateTime.now(), 0);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Date Calculator"),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: ListenableBuilder(listenable: _dateController, builder: (BuildContext context, Widget? child){ 
            return ListenableBuilder(listenable: _visibilityController, builder: (BuildContext context, Widget? child){ 
              return _mainBody(context);
            });
          }),
      )
      ),
    );
  }

  Widget _mainBody(BuildContext context) {
    return Stack(children:[Column(
            children: [
              Expanded(child: _buildDatePicker()),
              _buildNumberPicker(context),
              Expanded(child: SizedBox()),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: CupertinoColors.systemGroupedBackground,
                child: Column(
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
                      _dateController.result.formateDateStringToStandard(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoButton.filled(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _visibilityController.toggleVisibility();
                  },
                  child: const Text('Add to Event'),
                ),
              ),
            ],
          ),
          FloatingBottomDrawer(
            visibilityController: _visibilityController,
            child: AddDatePage(date: _dateController.result), 
          ),
          ]);
  }

  Widget _buildNumberPicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: CupertinoTextField(
              controller: _numController,
              keyboardType: TextInputType.number,
              placeholder: 'Number of days',
              onChanged: (String value) {
                // Convert string to integer, default to 0 if invalid
                final number = int.tryParse(value) ?? 0;
                setState(() {
                  _dateController.setNum(number);
                });
              },
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 6,),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(90, 0, 123, 255),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: IconButton(
              icon: const Icon(Icons.numbers_sharp),
              onPressed: () => _showNumberPicker(context),
            )
          )
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      children: [
        Expanded(
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: _dateController.date,
            onDateTimeChanged: (date) {
              setState(() {
                _dateController.changeDate(date);
              });
            },
          ),
        ),
      ],
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
                setState(() {
                  _dateController.setNum(selectedItem);
                  _numController.text = selectedItem.toString();
                });
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
} 