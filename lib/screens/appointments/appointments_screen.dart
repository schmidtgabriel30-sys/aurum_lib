import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';
import '../../widgets/list_screen_body.dart';
import '../../widgets/list_tile_card.dart';
import '../../widgets/status_badge.dart';

/// Lista de agendamentos do usuário (o "R" do CRUD).
///
/// Os estados de carregando, erro e lista vazia ficam no [ListScreenBody].
/// A lista recarrega sozinha quando um agendamento é criado, editado ou
/// excluído, escutando `AppointmentService.changes`.
class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final AppointmentService _service = AppointmentService.instance;
  late Future<List<Appointment>> _future = _service.fetchAll();

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
    await _future.catchError((_) => <Appointment>[]);
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
      title: const Text(AppStrings.appointmentsTitle),
    ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => context.goNamed(AppRoutes.appointmentNew),
      icon: const Icon(Icons.add),
      label: const Text(AppStrings.appointmentsNew),
    ),
    body: ListScreenBody<Appointment>(
      future: _future,
      onRetry: _reload,
      onRefresh: _refresh,
      emptyMessage: AppStrings.appointmentsEmpty,
      emptyIcon: Icons.event_available_outlined,
      itemBuilder: (context, item) => ListTileCard(
        icon: Icons.build_outlined,
        title: item.service?.name ?? AppStrings.fieldService,
        lines: [
          '${Formatters.fullDate(item.date)} • ${item.period.label}',
          if (item.vehicle != null) item.vehicle!.title,
        ],
        trailing: StatusBadge(status: item.status),
        onTap: () => context.goNamed(
          AppRoutes.appointmentDetails,
          pathParameters: {AppRoutes.idParam: '${item.id}'},
        ),
      ),
    ),
  );
}
