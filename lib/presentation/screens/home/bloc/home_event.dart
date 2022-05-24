part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadingPriceEvent extends HomeEvent {
  const LoadingPriceEvent();

  @override
  List<Object?> get props => [];
}
