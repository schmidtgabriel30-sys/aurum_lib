import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_service.dart';
import '../../widgets/list_screen_body.dart';
import '../../widgets/list_tile_card.dart';

/// Lista dos veículos do usuário. Tocar num veículo abre a edição.
class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final VehicleService _service = VehicleService.instance;
  late Future<List<Vehicle>> _future = _service.fetchAll();

  @override
  void initState() {
    super.initState();
    _service.changes.addListener(_reload);
  }

  @override
  void dispose() {
    _service.changes.removeListener(_reload);
    super.dispose();
  }

  void _reload() => setState(() => _future = _service.fetchAll());

  Future<void> _refresh() async {
    _reload();
    await _future.catchError((_) => <Vehicle>[]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.pageBackground,
    appBar: AppBar(
      leading: IconButton(
        tooltip: AppStrings.backHome,
        icon: const Icon(Icons.home_outlined),
        onPressed: () => context.goNamed(AppRoutes.home),
      ),
      title: const Text(AppStrings.vehiclesTitle),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => context.goNamed(AppRoutes.vehicleNew),
      icon: const Icon(Icons.add),
      label: const Text(AppStrings.appointmentsNew),
    ),
    body: ListScreenBody<Vehicle>(
      future: _future,
      onRetry: _reload,
      onRefresh: _refresh,
      emptyMessage: AppStrings.vehiclesEmpty,
      emptyIcon: Icons.directions_car_outlined,
      itemBuilder: (context, vehicle) => ListTileCard(
        icon: Icons.directions_car_outlined,
        title: '${vehicle.brand} ${vehicle.model}',
        lines: ['${vehicle.plate} • ${vehicle.year}'],
        onTap: () => context.goNamed(
          AppRoutes.vehicleEdit,
          pathParameters: {AppRoutes.idParam: '${vehicle.id}'},
        ),
      ),
    ),
  );
}
