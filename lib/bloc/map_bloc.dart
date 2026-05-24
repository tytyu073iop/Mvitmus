import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/district.dart';
import '../models/museum.dart';
import '../repositories/museum_repository.dart';

// Events
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class LoadDistricts extends MapEvent {
  const LoadDistricts();
}

class SelectDistrict extends MapEvent {
  final District district;

  const SelectDistrict(this.district);

  @override
  List<Object?> get props => [district];
}

class LoadMuseums extends MapEvent {
  final int districtId;

  const LoadMuseums(this.districtId);

  @override
  List<Object?> get props => [districtId];
}

// States
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {
  const MapInitial();
}

class MapLoading extends MapState {
  const MapLoading();
}

class DistrictsLoaded extends MapState {
  final List<District> districts;
  final District? selectedDistrict;
  final List<Museum>? museums;

  const DistrictsLoaded({
    required this.districts,
    this.selectedDistrict,
    this.museums,
  });

  @override
  List<Object?> get props => [districts, selectedDistrict, museums];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class MapBloc extends Bloc<MapEvent, MapState> {
  final MuseumRepository _repository;

  MapBloc(this._repository) : super(const MapInitial()) {
    on<LoadDistricts>(_onLoadDistricts);
    on<SelectDistrict>(_onSelectDistrict);
    on<LoadMuseums>(_onLoadMuseums);
  }

  Future<void> _onLoadDistricts(LoadDistricts event, Emitter<MapState> emit) async {
    emit(const MapLoading());
    try {
      final districts = await _repository.getDistricts();
      emit(DistrictsLoaded(districts: districts));
    } catch (e) {
      emit(MapError('Failed to load districts: $e'));
    }
  }

  Future<void> _onSelectDistrict(SelectDistrict event, Emitter<MapState> emit) async {
    final current = state;
    if (current is DistrictsLoaded) {
      emit(current.copyWith(selectedDistrict: event.district, museums: null));
    }
  }

  Future<void> _onLoadMuseums(LoadMuseums event, Emitter<MapState> emit) async {
    final current = state;
    if (current is DistrictsLoaded) {
      try {
        final museums = await _repository.getMuseumsByDistrict(event.districtId);
        emit(current.copyWith(museums: museums));
      } catch (e) {
        emit(MapError('Failed to load museums: $e'));
      }
    }
  }
}

extension on DistrictsLoaded {
  DistrictsLoaded copyWith({
    District? selectedDistrict,
    List<Museum>? museums,
  }) {
    return DistrictsLoaded(
      districts: districts,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      museums: museums ?? this.museums,
    );
  }
}
