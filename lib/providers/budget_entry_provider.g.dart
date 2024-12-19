// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_entry_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$budgetEntriesProviderHash() =>
    r'de181f6f54848002309e397295af4eb94cc88280';

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

abstract class _$BudgetEntriesProvider
    extends BuildlessAutoDisposeAsyncNotifier<List<BudgetEntry>> {
  late final int? threadId;

  FutureOr<List<BudgetEntry>> build(
    int? threadId,
  );
}

/// See also [BudgetEntriesProvider].
@ProviderFor(BudgetEntriesProvider)
const budgetEntriesProviderProvider = BudgetEntriesProviderFamily();

/// See also [BudgetEntriesProvider].
class BudgetEntriesProviderFamily
    extends Family<AsyncValue<List<BudgetEntry>>> {
  /// See also [BudgetEntriesProvider].
  const BudgetEntriesProviderFamily();

  /// See also [BudgetEntriesProvider].
  BudgetEntriesProviderProvider call(
    int? threadId,
  ) {
    return BudgetEntriesProviderProvider(
      threadId,
    );
  }

  @override
  BudgetEntriesProviderProvider getProviderOverride(
    covariant BudgetEntriesProviderProvider provider,
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
  String? get name => r'budgetEntriesProviderProvider';
}

/// See also [BudgetEntriesProvider].
class BudgetEntriesProviderProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BudgetEntriesProvider,
        List<BudgetEntry>> {
  /// See also [BudgetEntriesProvider].
  BudgetEntriesProviderProvider(
    int? threadId,
  ) : this._internal(
          () => BudgetEntriesProvider()..threadId = threadId,
          from: budgetEntriesProviderProvider,
          name: r'budgetEntriesProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$budgetEntriesProviderHash,
          dependencies: BudgetEntriesProviderFamily._dependencies,
          allTransitiveDependencies:
              BudgetEntriesProviderFamily._allTransitiveDependencies,
          threadId: threadId,
        );

  BudgetEntriesProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
  }) : super.internal();

  final int? threadId;

  @override
  FutureOr<List<BudgetEntry>> runNotifierBuild(
    covariant BudgetEntriesProvider notifier,
  ) {
    return notifier.build(
      threadId,
    );
  }

  @override
  Override overrideWith(BudgetEntriesProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: BudgetEntriesProviderProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<BudgetEntriesProvider,
      List<BudgetEntry>> createElement() {
    return _BudgetEntriesProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetEntriesProviderProvider && other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BudgetEntriesProviderRef
    on AutoDisposeAsyncNotifierProviderRef<List<BudgetEntry>> {
  /// The parameter `threadId` of this provider.
  int? get threadId;
}

class _BudgetEntriesProviderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BudgetEntriesProvider,
        List<BudgetEntry>> with BudgetEntriesProviderRef {
  _BudgetEntriesProviderProviderElement(super.provider);

  @override
  int? get threadId => (origin as BudgetEntriesProviderProvider).threadId;
}

String _$budgetEntryTypeProviderHash() =>
    r'2dc2974a92ea49d7ffaa57470665526f7005767b';

/// See also [BudgetEntryTypeProvider].
@ProviderFor(BudgetEntryTypeProvider)
final budgetEntryTypeProviderProvider = AutoDisposeAsyncNotifierProvider<
    BudgetEntryTypeProvider, List<BudgetEntryType>>.internal(
  BudgetEntryTypeProvider.new,
  name: r'budgetEntryTypeProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$budgetEntryTypeProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BudgetEntryTypeProvider
    = AutoDisposeAsyncNotifier<List<BudgetEntryType>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
