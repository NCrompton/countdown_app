import 'package:calendar/components/editable_info_row.dart';
import 'package:calendar/components/picker_wrapper.dart';
import 'package:calendar/controllers/input_controller.dart';
import 'package:calendar/dummy/dummy_data.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetEntryPage extends ConsumerWidget {
  final BudgetEntry entry;

  const BudgetEntryPage({
    super.key,
    required this.entry,
  });

  InputController<String> get _nameController => InputController(entry.entryName);
  InputController<double> get _priceController => InputController(entry.price.value);
  InputController<Currency> get _currencyController => InputController(entry.price.currency);
  InputController<DateTime> get _createDateController => InputController(entry.entryTime);
  InputController<BudgetEntryType> get _typeController => InputController(entry.entryType);

  BudgetEntry get newEntry => entry
      ..entryName = _nameController.value
      ..entryTime = _createDateController.value
      ..entryType = _typeController.value
      ..price.value = _priceController.value
      ..price.currency = _currencyController.value;

  List<ChangedValue> get targets => [
    ChangedValue(name: "Name", oldValue: entry.entryName, newValue: newEntry.entryName),
    ChangedValue(name: "Price", oldValue: entry.price.value.toString(), newValue: newEntry.price.value.toString()),
    ChangedValue(name: "Currency", oldValue: entry.price.currency.name, newValue: newEntry.price.currency.name),
    ChangedValue(name: "Create Time", oldValue: entry.entryTime.formatToDisplay(), newValue: newEntry.entryTime.formatToDisplay()),
    ChangedValue(name: "Type", oldValue: entry.entryType.typeName, newValue: newEntry.entryType.typeName),
  ];

  Widget _buildTypeInputWidget(BuildContext context) {
    return PickerWrapper(
      text: _typeController.value.typeName, 
      picker: CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        onSelectedItemChanged: (int selectedItem) {
          _typeController.set(entryTypes[selectedItem]);
        },
        children: entryTypes.map((type) => Center(
          child: Text(type.typeName),
        )).toList(),
      ),
    );
  }

  void _updateEntry(WidgetRef ref) {
    ref.read(budgetEntriesProviderProvider.notifier).updateEntry(newEntry);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        middle: Text(entry.entryName),
      ),
      child: FloatingBottomDrawerPage(
        heightPortion: 0.7,
        drawerChild: (dismiss) => ChangedValuePreview(
          targets: targets,
          onConfirm:() {
            _updateEntry(ref);
            dismiss();
          },
          onReject: dismiss,
        ),
        builder: (context, visibilityController) {
         return  Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          EntryAttributeRow<String>(attributeName: "Name", inputController: _nameController,),
                          EntryAttributeRow<double>(attributeName: "Price", inputController: _priceController,),
                          EntryAttributeRow<Currency>(attributeName: "Currency", attributeValueString: _currencyController.value.name, inputController: _currencyController, enumList:Currency.values),
                          EntryAttributeRow<DateTime>(attributeName: "Create Time", attributeValueString: _createDateController.value.formatToDisplay(), inputController: _createDateController,),
                          EntryAttributeRow<BudgetEntryType>(attributeName: "Type", attributeValueString: _typeController.value.typeName, inputController: _typeController, customInput: _buildTypeInputWidget(context),),
                        ],
                      ),
                    ),
                    CupertinoButton.filled(
                      onPressed: () {
                        visibilityController.setVisibility(true);
                      },
                      child: const Text("Update Budget"), 
                    )
                  ],
                );
        }
      )
    );
  }
}

class ChangedValue {
  final String name;
  final String oldValue;
  final String newValue;

  const ChangedValue({
    required this.name,
    required this.oldValue,
    required this.newValue,
  });
}

class ChangedValuePreview extends StatelessWidget {
  final List<ChangedValue> targets;
  final void Function() onConfirm;
  final void Function() onReject;

  const ChangedValuePreview({
    super.key,
    required this.targets,
    required this.onConfirm,
    required this.onReject,
  });

  Widget _buildRow(ChangedValue target) {
    return Builder(
      builder: (context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(target.name),
            Text(target.oldValue),
            const Icon(CupertinoIcons.arrow_right),
            Text(target.newValue),
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: targets.length + 1, // +1 for the row with buttons
      itemBuilder: (context, index) {
        if (index < targets.length) {
          return _buildRow(targets[index]);
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton.filled(
                onPressed: onConfirm,
                child: const Text("Confirm"),
              ),
              CupertinoButton(
                color: CupertinoColors.destructiveRed,
                onPressed: onReject,
                child: const Text("Reject"),
              ),
            ],
          );
        }
      },
    );
  }
}

// class BudgetEntryListenable extends StatelessWidget {
//   InputController<String> get _nameController => InputController(entry.entryName);
//   InputController<double> get _priceController => InputController(entry.price.value);
//   InputController<Currency> get _currencyController => InputController(entry.price.currency);
//   InputController<DateTime> get _createDateController => InputController(entry.entryTime);
//   InputController<BudgetEntryType> get _typeController => InputController(entry.entryType);

//   const BudgetEntryListenable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: 
//       builder: builder);
//   }
// }
