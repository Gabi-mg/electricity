part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadingEvent extends HomeEvent {
  const LoadingEvent();

  @override
  List<Object?> get props => [];
}
