import 'package:calendar/model/budget_schema.dart';
import 'package:calendar/providers/budget_entry_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

void main() {
  test('Some description', () async {
    // Create a ProviderContainer for this test.
    // DO NOT share ProviderContainers between tests.
    final container = createContainer();

    // container.listen<List<BudgetEntry>>(
    //   budgetEntriesProviderProvider,
    //   (previous, next) {
    //     print('The provider changed from $previous to $next');
    //   },
    // );

    // TODO: use the container to test your application.
    // print(container.read(budgetEntriesProviderProvider));
    // await expectLater(
    //   container.read(budgetEntriesProviderProvider.future),
    //   completion(5)
    // );
  });
}