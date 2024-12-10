import 'package:calendar/components/editable_info_row.dart';
import 'package:calendar/components/picker_wrapper.dart';
import 'package:calendar/controllers/input_controller.dart';
import 'package:calendar/layout/floating_bottom_drawer.dart';
import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:calendar/utils/const.dart';
import 'package:calendar/utils/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetEntryPage extends ConsumerStatefulWidget {
  final BudgetEntry entry;

  const BudgetEntryPage({
    super.key,
    required this.entry,
  });

  @override
  ConsumerState<BudgetEntryPage> createState() => _BudgetEntryPageState();
}

class _BudgetEntryPageState extends ConsumerState<BudgetEntryPage> {
  InputController<String> _nameController = InputController("");
  InputController<double> _priceController = InputController(0.0);
  InputController<Currency> _currencyController = InputController(Currency.hkd);
  InputController<DateTime> _createDateController = InputController(DateTime.now());
  InputController<BudgetEntryType> _typeController = InputController(BudgetEntryType.defaultType());
  List<BudgetEntryType>? typeList;

  @override
  void initState() {
    super.initState();
    _nameController = InputController(widget.entry.entryName);    
    _priceController = InputController(widget.entry.price.value);    
    _currencyController = InputController(widget.entry.price.currency);    
    _typeController = InputController(typeList?[widget.entry.entryType] ?? BudgetEntryType.defaultType());
    _createDateController = InputController(widget.entry.entryTime);
  }

  Widget _buildTypeInputWidget(BuildContext context) {
    return PickerWrapper(
      text: _typeController.value.typeName, 
      picker: CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        onSelectedItemChanged: (int selectedItem) {
          _typeController.set(typeList![selectedItem]);
        },
        children: typeList!.map((type) => Center(
          child: Text(type.typeName),
        )).toList(),
      ),
    );
  }

  Widget _buildListener({required Widget Function(BuildContext, Widget?) builder, Widget? child}) {
    return ListenableBuilder(
      listenable: _nameController, 
      child: child,
      builder: (context, c) =>
        ListenableBuilder(
          listenable: _createDateController,
          builder: (context, _) => 
          ListenableBuilder(
            listenable: _currencyController,
            builder: (context, _) => 
            ListenableBuilder(
              listenable: _priceController,
              builder: (context, _) => 
              ListenableBuilder(
                listenable: _typeController,
                builder: (context, _) => builder(context, c),
              )
            )
          )
        )
    );
  }

  Widget _buildPreview(void Function() dismiss) {
     BudgetEntry newEntry = BudgetEntry.copy(widget.entry);
     newEntry = newEntry
      ..entryName = _nameController.value
      ..entryTime = _createDateController.value
      ..entryType = _typeController.value.id
      ..price.value = _priceController.value
      ..price.currency = _currencyController.value;


    return ChangedValuePreview(
      targets: [
        ChangedValue(name: "Name", oldValue: widget.entry.entryName, newValue: newEntry.entryName),
        ChangedValue(name: "Price", oldValue: widget.entry.price.value.toString(), newValue: newEntry.price.value.toString()),
        ChangedValue(name: "Currency", oldValue: widget.entry.price.currency.displayName, newValue: newEntry.price.currency.displayName),
        ChangedValue(name: "Create Time", oldValue: widget.entry.entryTime.formatToDisplay(), newValue: newEntry.entryTime.formatToDisplay()),
        ChangedValue(name: "Type", oldValue: typeList![widget.entry.entryType].typeName, newValue: typeList![newEntry.entryType].typeName),
      ],
      onConfirm:() async {
        await _updateEntry(newEntry);
        dismiss();
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      onReject: dismiss,
    );
  }

  Future<bool> _updateEntry(BudgetEntry newEntry) async {
    return ref.read(budgetEntriesProviderProvider.notifier).updateEntry(newEntry);
  }

  @override
  Widget build(BuildContext context) {
    typeList = ref.watch(budgetEntryTypeProviderProvider).value;
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          middle: Text(widget.entry.entryName),
        ),
        child: _buildListener(
          builder: (context, child) => FloatingBottomDrawerPage(
            heightPortion: 0.6,
            drawerChild: _buildPreview,
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
                        EntryAttributeRow<Currency>(attributeName: "Currency", attributeValueString: _currencyController.value.displayName.toUpperCase(), inputController: _currencyController, enumList:Currency.values),
                        EntryAttributeRow<DateTime>(attributeName: "Create Time", attributeValueString: _createDateController.value.formatToDisplay(), inputController: _createDateController),
                        EntryAttributeRow<BudgetEntryType>(attributeName: "Type", attributeValueString: _typeController.value.typeName, inputController: _typeController, customInput: _buildTypeInputWidget(context)),
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
          },
        ),
      ),
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
                ...target.isChange
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