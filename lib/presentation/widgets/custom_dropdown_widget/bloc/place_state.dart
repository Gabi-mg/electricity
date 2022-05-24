part of 'place_bloc.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();
}

class PlaceLoadingState extends PlaceState {
  const PlaceLoadingState() : super();

  @override
  List<Object> get props => [];
}

class PlaceLoadedState extends PlaceState {
  final GeoId geoId;

  const PlaceLoadedState({required this.geoId}) : super();

  @override
  List<Object> get props => [geoId];
}
