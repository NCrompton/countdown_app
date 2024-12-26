// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_thread_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetThreadProviderHash() =>
    r'7c9e0e25245ac4b04459c43d63ca4c74cfe5143c';

/// See also [BudgetThreadProvider].
@ProviderFor(BudgetThreadProvider)
final budgetThreadProviderProvider = AutoDisposeAsyncNotifierProvider<
    BudgetThreadProvider, List<BudgetThread>>.internal(
  BudgetThreadProvider.new,
  name: r'budgetThreadProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetThreadProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetThreadProvider = AutoDisposeAsyncNotifier<List<BudgetThread>>;
String _$targetThreadHash() => r'228e20b29c4f85038e50ce3f0d239451ecbba18f';

/// See also [TargetThread].
@ProviderFor(TargetThread)
final targetThreadProvider =
    AutoDisposeAsyncNotifierProvider<TargetThread, Id?>.internal(
  TargetThread.new,
  name: r'targetThreadProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$targetThreadHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TargetThread = AutoDisposeAsyncNotifier<Id?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
