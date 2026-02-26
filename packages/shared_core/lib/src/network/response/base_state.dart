import 'package:equatable/equatable.dart';
import 'package:shared_core/shared_core.dart';

sealed class ViewState<T> extends Equatable {
  const ViewState();

  T? get dataOrNull => switch (this) {
        ViewInitial<T>() => null,
        ViewLoading<T>(:final data) => data,
        ViewData<T>(:final data) => data,
        ViewError<T>(:final data) => data,
      };

  @override
  List<Object?> get props => [];
}

final class ViewInitial<T> extends ViewState<T> {
  const ViewInitial();
}

final class ViewLoading<T> extends ViewState<T> {
  final T? data;
  const ViewLoading({this.data});

  @override
  List<Object?> get props => [data];
}

final class ViewData<T> extends ViewState<T> {
  final T data;
  const ViewData(this.data);

  @override
  List<Object?> get props => [data];
}

final class ViewError<T> extends ViewState<T> {
  final Failure failure;
  final T? data;
  final String? messageOverride;

  const ViewError({
    required this.failure,
    this.data,
    this.messageOverride,
  });

  @override
  List<Object?> get props => [failure, data, messageOverride];
}