import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/l10n.dart';
import '../models/museum.dart';
import '../models/exhibition.dart';
import '../repositories/museum_repository.dart';

class MuseumDetailScreen extends StatefulWidget {
  final Museum museum;

  const MuseumDetailScreen({super.key, required this.museum});

  @override
  State<MuseumDetailScreen> createState() => _MuseumDetailScreenState();
}

class _MuseumDetailScreenState extends State<MuseumDetailScreen> {
  late Future<List<Exhibition>> _exhibitionsFuture;

  @override
  void initState() {
    super.initState();
    _exhibitionsFuture =
        context.read<MuseumRepository>().getExhibitionsByMuseum(widget.museum.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.read<L10n>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.museum.getName(l10n.locale)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.museum,
                              size: 48, color: Colors.blue),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.museum.getName(l10n.locale),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.museum.getAddress(l10n.locale),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.museum.getDescription(l10n.locale),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('exhibitionsTitle'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Exhibition>>(
              future: _exhibitionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text('${snapshot.error}'),
                      ],
                    ),
                  );
                }
                final exhibitions = snapshot.data ?? [];
                if (exhibitions.isEmpty) {
                  return Center(
                    child: Text(l10n.translate('noExhibitions')),
                  );
                }
                return Column(
                  children: exhibitions
                      .map((e) => _buildExhibitionCard(context, e, l10n))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExhibitionCard(
      BuildContext context, Exhibition exhibition, L10n l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exhibition.getName(l10n.locale),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(exhibition.getDescription(l10n.locale)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.date_range, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${l10n.translate('from')} ${exhibition.startDate} ${l10n.translate('to')} ${exhibition.endDate}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.monetization_on,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  exhibition.price == 0
                      ? l10n.translate('free')
                      : '${l10n.translate('price')}: ${exhibition.price.toStringAsFixed(2)} BYN',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
