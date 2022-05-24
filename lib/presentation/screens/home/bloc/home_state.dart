part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class PricesLoadingState extends HomeState {
  const PricesLoadingState() : super();

  @override
  List<Object> get props => [];
}

class PricesLoadedState extends HomeState {
  final Prices prices;

  const PricesLoadedState({required this.prices}) : super();

  @override
  List<Object> get props => [prices];
}

class PricesErrorState extends HomeState {
  const PricesErrorState() : super();

  @override
  List<Object> get props => [];
}


