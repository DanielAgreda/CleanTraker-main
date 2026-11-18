import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../auth/tracker_provider.dart';

class HomeTrackerScreen extends StatelessWidget {
  const HomeTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TrackerProvider>();
    final user = provider.currentUser;
    final address = provider.selectedAddress;

    return Scaffold(
      backgroundColor: AppTheme.mintBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Cabecera usuario con avatar crema + iniciales
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: AppTheme.creamHighlight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      user?.initials ?? 'CR',
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppTheme.forestDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Camila Rojas',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'camila.rojas@correo.com',
                          style: const TextStyle(
                            color: AppTheme.forestMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar sesión',
                    onPressed: () async {
                      await provider.logout();
                      if (context.mounted) context.go('/auth');
                    },
                    icon: const Icon(Icons.logout, color: AppTheme.forestDark),
                  ),
                ],
              ),
            ),

            // Cuerpo blanco redondeado con información de tracking
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
                    // Tarjeta MI DIRECCIÓN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderLight),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 16, color: AppTheme.forestMuted),
                              SizedBox(width: 6),
                              Text(
                                'MI DIRECCIÓN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: AppTheme.forestMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            address?.street ?? 'Carrera 15 # 85-32',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.forestDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address?.zone ?? 'Chapinero, Bogotá',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.forestMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    Text(
                      'Tu camión de basura',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 16),

                    // Dos tarjetas de métricas lado a lado (Menta y Crema)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.mintBackground,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Faltan',
                                  style: TextStyle(
                                    color: AppTheme.forestMuted,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  address?.distanceKm ?? '2,4 km',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 28),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'para llegar a tu casa',
                                  style: TextStyle(
                                    color: AppTheme.forestMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.creamHighlight,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Llega en',
                                  style: TextStyle(
                                    color: AppTheme.forestMuted,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${address?.estimatedMinutes ?? 12} min',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 28),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'tiempo estimado',
                                  style: TextStyle(
                                    color: AppTheme.forestMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      'Ubicación estimada del camión · actualizada hace 15 s',
                      style: TextStyle(
                        color: AppTheme.forestMuted,
                        fontSize: 13,
                      ),
                    ),

                    const Spacer(),

                    // Botón inferior con borde oscuro
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.forestDark,
                          side: const BorderSide(color: AppTheme.forestDark, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => context.push('/search-route'),
                        child: const Text(
                          'Cambiar dirección',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
