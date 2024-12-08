// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_entry_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetEntriesProviderHash() =>
    r'4ba26204d10ee37a5831e746a2c752b8e150bf91';

/// See also [BudgetEntriesProvider].
@ProviderFor(BudgetEntriesProvider)
final budgetEntriesProviderProvider = AutoDisposeAsyncNotifierProvider<
    BudgetEntriesProvider, List<BudgetEntry>>.internal(
  BudgetEntriesProvider.new,
  name: r'budgetEntriesProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetEntriesProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetEntriesProvider = AutoDisposeAsyncNotifier<List<BudgetEntry>>;
String _$budgetThreadEntryProviderHash() =>
    r'105c8839265e696ec20187960e229f47d6d7b7c3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$BudgetThreadEntryProvider
    extends BuildlessAutoDisposeAsyncNotifier<List<BudgetEntry>> {
  late final int threadId;

  FutureOr<List<BudgetEntry>> build(
    int threadId,
  );
}

/// See also [BudgetThreadEntryProvider].
@ProviderFor(BudgetThreadEntryProvider)
const budgetThreadEntryProviderProvider = BudgetThreadEntryProviderFamily();

/// See also [BudgetThreadEntryProvider].
class BudgetThreadEntryProviderFamily
    extends Family<AsyncValue<List<BudgetEntry>>> {
  /// See also [BudgetThreadEntryProvider].
  const BudgetThreadEntryProviderFamily();

  /// See also [BudgetThreadEntryProvider].
  BudgetThreadEntryProviderProvider call(
    int threadId,
  ) {
    return BudgetThreadEntryProviderProvider(
      threadId,
    );
  }

  @override
  BudgetThreadEntryProviderProvider getProviderOverride(
    covariant BudgetThreadEntryProviderProvider provider,
  ) {
    return call(
      provider.threadId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'budgetThreadEntryProviderProvider';
}

/// See also [BudgetThreadEntryProvider].
class BudgetThreadEntryProviderProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BudgetThreadEntryProvider,
        List<BudgetEntry>> {
  /// See also [BudgetThreadEntryProvider].
  BudgetThreadEntryProviderProvider(
    int threadId,
  ) : this._internal(
          () => BudgetThreadEntryProvider()..threadId = threadId,
          from: budgetThreadEntryProviderProvider,
          name: r'budgetThreadEntryProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$budgetThreadEntryProviderHash,
          dependencies: BudgetThreadEntryProviderFamily._dependencies,
          allTransitiveDependencies:
              BudgetThreadEntryProviderFamily._allTransitiveDependencies,
          threadId: threadId,
        );

  BudgetThreadEntryProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
  }) : super.internal();

  final int threadId;

  @override
  FutureOr<List<BudgetEntry>> runNotifierBuild(
    covariant BudgetThreadEntryProvider notifier,
  ) {
    return notifier.build(
      threadId,
    );
  }

  @override
  Override overrideWith(BudgetThreadEntryProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: BudgetThreadEntryProviderProvider._internal(
        () => create()..threadId = threadId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BudgetThreadEntryProvider,
      List<BudgetEntry>> createElement() {
    return _BudgetThreadEntryProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetThreadEntryProviderProvider &&
        other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BudgetThreadEntryProviderRef
    on AutoDisposeAsyncNotifierProviderRef<List<BudgetEntry>> {
  /// The parameter `threadId` of this provider.
  int get threadId;
}

class _BudgetThreadEntryProviderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BudgetThreadEntryProvider,
        List<BudgetEntry>> with BudgetThreadEntryProviderRef {
  _BudgetThreadEntryProviderProviderElement(super.provider);

  @override
  int get threadId => (origin as BudgetThreadEntryProviderProvider).threadId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
