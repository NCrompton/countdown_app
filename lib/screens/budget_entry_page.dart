import 'package:calendar/components/editable_info_row.dart';
import 'package:calendar/components/picker_wrapper.dart';
import 'package:calendar/controllers/input_controller.dart';
import 'package:calendar/dummy/dummy_data.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        heightPortion: 0.6,
        drawerChild: (dismiss) => ChangedValuePreview(
          targets: targets,
          onConfirm:() {
            _updateEntry(ref);
            dismiss();
          },
          onReject: dismiss,
        ),
        builder: (context, visibilityController) {
         return  Container(
          color: CupertinoColors.secondarySystemBackground,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    EntryAttributeRow<String>(attributeName: "Name", inputController: _nameController,),
                    EntryAttributeRow<double>(attributeName: "Price", inputController: _priceController,),
                    EntryAttributeRow<Currency>(attributeName: "Currency", attributeValueString: _currencyController.value.name.toUpperCase(), inputController: _currencyController, enumList:Currency.values, allowExitEditing: false,),
                    EntryAttributeRow<DateTime>(attributeName: "Create Time", attributeValueString: _createDateController.value.formatToDisplay(), inputController: _createDateController, allowExitEditing: false,),
                    EntryAttributeRow<BudgetEntryType>(attributeName: "Type", attributeValueString: _typeController.value.typeName, inputController: _typeController, customInput: _buildTypeInputWidget(context), allowExitEditing: false,),
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
          ),
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
  bool get isChange => oldValue != newValue;

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
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    target.name, 
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ...!target.isChange
                ? _buildChangesRow(target)
                : _buildNonChangeRow(target),
              ]
            ),
          ),
        );
      }
    );
  }

  List<Widget> _buildChangesRow(ChangedValue target) {
    return [
      const Expanded(flex: 1, child: SizedBox()),
      Expanded(
        flex: 3,
        child: Text(
          target.oldValue,
          style: const TextStyle(color: Color(negativeColor), ),
        ),
      ),
      const Expanded(
        flex: 2,
        child: Icon(CupertinoIcons.arrow_right)
      ),
      Expanded(
        flex: 3,
        child: Text(
          target.newValue,
          style: const TextStyle(color: Color(positiveColor)),
        ),
      ),
    ];
  }

  List<Widget> _buildNonChangeRow(ChangedValue target) {
    return [
      const Expanded(flex: 1, child: SizedBox()),
      Expanded(
        flex: 4,
        child: Text(
          target.oldValue,
          style: const TextStyle(color: Colors.black,)
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...targets.map(_buildRow).toList(),
            const SizedBox(height: 12),
            Row(
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
              ]
            ),
          ],
        ),
      ),
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
