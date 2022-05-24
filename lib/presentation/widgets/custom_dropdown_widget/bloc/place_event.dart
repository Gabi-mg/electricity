part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();
}

class LoadingPlaceEvent extends PlaceEvent {
  const LoadingPlaceEvent();

  @override
  List<Object?> get props => [];
}
