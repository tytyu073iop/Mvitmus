import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import '../bloc/map_bloc.dart';
import '../models/district.dart';

class DistrictMarkerLayer extends StatelessWidget {
  final List<District> districts;
  final District? selectedDistrict;
  final String locale;

  const DistrictMarkerLayer({
    super.key,
    required this.districts,
    this.selectedDistrict,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: districts.map((d) {
        final isSelected = selectedDistrict?.id == d.id;
        return Marker(
          point: d.center,
          width: isSelected ? 100 : 80,
          height: isSelected ? 100 : 80,
          child: GestureDetector(
            onTap: () => context.read<MapBloc>().add(SelectDistrict(d)),
            child: AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.8,
                duration: const Duration(milliseconds: 300),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.location_on
                          : Icons.location_on_outlined,
                      color: isSelected ? Colors.red : Colors.blue,
                      size: isSelected ? 40 : 32,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.red.shade700
                            : Colors.blue.shade700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        d.getName(locale),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
