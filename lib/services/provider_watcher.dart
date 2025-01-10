import 'package:calendar/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    // Log().log('Provider $provider was initialized with $value');
    Log().log('Provider $provider was initialized');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    Log().log('Provider $provider was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Log().log('Provider $provider updated from $previousValue to $newValue');
    Log().log('Provider $provider updated');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    Log().log('Provider $provider threw $error at $stackTrace');
  }
}