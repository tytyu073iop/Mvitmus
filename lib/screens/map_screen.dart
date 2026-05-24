import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../bloc/map_bloc.dart';
import '../l10n/l10n.dart';
import '../widgets/district_marker.dart';
import '../widgets/weather_widget.dart';
import 'museum_list_screen.dart';

class MapScreen extends StatefulWidget {
  final void Function(String locale) onLocaleChanged;

  const MapScreen({super.key, required this.onLocaleChanged});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    context.read<MapBloc>().add(const LoadDistricts());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.read<L10n>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('appName')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: widget.onLocaleChanged,
            itemBuilder: (_) => [
              PopupMenuItem(value: 'ru', child: const Text('Русский')),
              PopupMenuItem(value: 'en', child: const Text('English')),
              PopupMenuItem(value: 'be', child: const Text('Беларуская')),
            ],
          ),
        ],
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is DistrictsLoaded && state.selectedDistrict != null) {
            _animController.forward(from: 0);
          }
          if (state is MapError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DistrictsLoaded) {
            return _buildMap(context, state, l10n);
          }
          if (state is MapError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<MapBloc>().add(const LoadDistricts()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context, DistrictsLoaded state, L10n l10n) {
    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(55.1904, 30.2049),
            initialZoom: 12.0,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.vitmus.vitmus',
            ),
            DistrictMarkerLayer(
              districts: state.districts,
              selectedDistrict: state.selectedDistrict,
              locale: l10n.locale,
            ),
            if (state.selectedDistrict != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: state.selectedDistrict!.center,
                    width: 30,
                    height: 30,
                    child: const Icon(Icons.my_location,
                        color: Colors.red, size: 24),
                  ),
                ],
              ),
          ],
        ),
        if (state.selectedDistrict != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildDistrictPanel(context, state, l10n),
              ),
            ),
          ),
        if (state.selectedDistrict == null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.translate('selectDistrict'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDistrictPanel(
      BuildContext context, DistrictsLoaded state, L10n l10n) {
    final district = state.selectedDistrict!;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              district.getName(l10n.locale),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            WeatherWidget(
              lat: district.center.latitude,
              lng: district.center.longitude,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<MapBloc>().add(LoadMuseums(district.id));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<MapBloc>(),
                        child: const MuseumListScreen(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.museum),
                label: Text(l10n.translate('museumsTitle')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
