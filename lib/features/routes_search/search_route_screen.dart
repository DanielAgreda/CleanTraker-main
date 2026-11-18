import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/route_address_model.dart';
import '../auth/tracker_provider.dart';

class SearchRouteScreen extends StatefulWidget {
  const SearchRouteScreen({super.key});

  @override
  State<SearchRouteScreen> createState() => _SearchRouteScreenState();
}

class _SearchRouteScreenState extends State<SearchRouteScreen> {
  final _searchController = TextEditingController();
  RouteAddressModel? _highlightedAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final results = context.read<TrackerProvider>().searchResults;
      if (results.isNotEmpty) {
        setState(() => _highlightedAddress = results.first);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmRoute() async {
    if (_highlightedAddress == null) return;
    await context.read<TrackerProvider>().selectAndSaveAddress(_highlightedAddress!);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrackerProvider>();
    final results = provider.searchResults;

    return Scaffold(
      backgroundColor: AppTheme.mintBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera menta superior
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        provider.logout();
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: AppTheme.forestDark, size: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Encuentra tu ruta',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Escribe tu dirección para conocer la ruta y los horarios del camión de basura.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.forestMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Contenedor blanco redondeado inferior
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tu dirección',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.forestDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController,
                      onChanged: (val) => provider.searchAddress(val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: AppTheme.forestMuted),
                        hintText: 'Ej: Carrera 15 # 85',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.forestDark, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Lista de sugerencias con borde y resaltado crema
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.borderLight),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (_, __) => const Divider(height: 1, color: AppTheme.borderLight),
                            itemBuilder: (context, index) {
                              final item = results[index];
                              final isSelected = _highlightedAddress?.id == item.id;

                              return InkWell(
                                onTap: () => setState(() => _highlightedAddress = item),
                                child: Container(
                                  color: isSelected ? AppTheme.creamHighlight : Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: AppTheme.forestDark,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.street,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.forestDark,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              item.zone,
                                              style: const TextStyle(
                                                color: AppTheme.forestMuted,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Selecciona tu dirección para ver la ruta y los horarios del camión.',
                      style: TextStyle(
                        color: AppTheme.forestMuted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _highlightedAddress != null
                              ? AppTheme.forestDark
                              : AppTheme.buttonMintDisabled,
                          foregroundColor: _highlightedAddress != null
                              ? Colors.white
                              : AppTheme.forestMuted,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _highlightedAddress != null ? _confirmRoute : null,
                        child: const Text(
                          'Ver ruta y horarios',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
