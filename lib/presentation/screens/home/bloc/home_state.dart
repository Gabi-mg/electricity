part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final Prices? prices;
  final bool isError;

  const HomeState({required this.prices, this.isError = false});
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState() : super(prices: null);

  @override
  List<Object> get props => [];
}

class HomeLoadedState extends HomeState {
  final Prices newPrices;

  const HomeLoadedState({required this.newPrices}) : super(prices: newPrices);

  @override
  List<Object> get props => [newPrices];
}

class HomeErrorState extends HomeState {
  const HomeErrorState() : super(prices: null, isError: true);

  @override
  List<Object> get props => [];
}
