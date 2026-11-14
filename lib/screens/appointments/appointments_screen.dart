import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_state.dart';
import 'appointment_card.dart';

/// Lista de agendamentos do usuário (o "R" do CRUD).
///
/// Usa um [FutureBuilder] para tratar os três estados: carregando, erro e
/// lista vazia. Recarrega sozinha quando um agendamento é criado, editado ou
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

  void _openNew() => context.goNamed(AppRoutes.appointmentNew);

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
      onPressed: _openNew,
      icon: const Icon(Icons.add),
      label: const Text(AppStrings.appointmentsNew),
    ),
    body: FutureBuilder<List<Appointment>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingState();
        }
        if (snapshot.hasError) {
          return ErrorState(message: '${snapshot.error}', onRetry: _reload);
        }

        final List<Appointment> items = snapshot.data!;
        if (items.isEmpty) {
          return const EmptyState(
            message: AppStrings.appointmentsEmpty,
            icon: Icons.event_available_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.lg,
              AppSpacing.screenPadding,
              AppSpacing.xxxl * 3,
            ),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final Appointment item = items[index];
              return AppointmentCard(
                appointment: item,
                onTap: () => context.goNamed(
                  AppRoutes.appointmentDetails,
                  pathParameters: {AppRoutes.idParam: '${item.id}'},
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
