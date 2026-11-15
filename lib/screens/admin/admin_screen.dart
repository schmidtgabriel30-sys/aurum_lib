import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/appointment.dart';
import '../../services/appointment_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/admin_scaffold.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/list_tile_card.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/status_badge.dart';
import 'status_counter.dart';

/// Painel do administrador: todos os agendamentos, com quem solicitou,
/// contadores por situação e filtro.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  /// Quantos agendamentos o painel busca de uma vez (máximo da API).
  static const int _perPage = 50;

  final AppointmentService _service = AppointmentService.instance;
  late Future<List<Appointment>> _future = _fetch();

  /// `null` = todos.
  AppointmentStatus? _filter;

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

  Future<List<Appointment>> _fetch() => _service.fetchAll(perPage: _perPage);

  void _reload() => setState(() => _future = _fetch());

  Future<void> _signOut() async {
    await AuthService.instance.signOut();
    if (mounted) context.goNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) => AdminScaffold(
    title: AppStrings.adminTitle,
    actions: [
      IconButton(
        tooltip: AppStrings.adminSignOut,
        icon: const Icon(Icons.logout),
        onPressed: _signOut,
      ),
    ],
    body: FutureBuilder<List<Appointment>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingState();
        }
        if (snapshot.hasError) {
          return ErrorState(message: '${snapshot.error}', onRetry: _reload);
        }

        final List<Appointment> all = snapshot.data!;
        final List<Appointment> visible = _filter == null
            ? all
            : all.where((a) => a.status == _filter).toList();

        return RefreshIndicator(
          onRefresh: () async {
            _reload();
            await _future.catchError((_) => <Appointment>[]);
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
            children: [
              _Header(
                appointments: all,
                selected: _filter,
                onSelect: (s) => setState(() => _filter = s),
              ),
              _FilterChips(
                selected: _filter,
                onSelect: (s) => setState(() => _filter = s),
              ),
              if (visible.isEmpty)
                const EmptyState(
                  message: AppStrings.adminEmpty,
                  icon: Icons.inbox_outlined,
                )
              else
                for (final Appointment a in visible)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                    ),
                    child: ListTileCard(
                      icon: Icons.person_outline,
                      title: a.clientName ?? AppStrings.adminClient,
                      lines: [
                        a.service?.name ?? AppStrings.fieldService,
                        '${Formatters.fullDate(a.date)} • ${a.period.label}',
                        if (a.vehicle != null)
                          '${a.vehicle!.title} • ${a.vehicle!.plate}',
                      ],
                      trailing: StatusBadge(status: a.status),
                      onTap: () => context.goNamed(
                        AppRoutes.adminAppointment,
                        pathParameters: {AppRoutes.idParam: '${a.id}'},
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    ),
  );
}

/// Faixa escura com saudação e contadores por situação.
class _Header extends StatelessWidget {
  const _Header({
    required this.appointments,
    required this.selected,
    required this.onSelect,
  });

  /// Situações que aparecem nos contadores (as que pedem ação da oficina).
  static const List<AppointmentStatus> _counted = [
    AppointmentStatus.pending,
    AppointmentStatus.confirmed,
    AppointmentStatus.inService,
    AppointmentStatus.completed,
  ];

  final List<Appointment> appointments;
  final AppointmentStatus? selected;
  final ValueChanged<AppointmentStatus?> onSelect;

  @override
  Widget build(BuildContext context) {
    final String name = AuthService.instance.currentUser?.name ?? '';
    return Container(
      color: AppColors.adminBackground,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xl,
        AppSpacing.screenPadding,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.adminGreeting} $name',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.adminText,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.adminSubtitle,
            style: AppTextStyles.body.copyWith(color: AppColors.adminMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (final (index, status) in _counted.indexed) ...[
                if (index > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatusCounter(
                    status: status,
                    count: appointments.where((a) => a.status == status).length,
                    selected: selected == status,
                    onTap: () => onSelect(selected == status ? null : status),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Linha de filtros: "Todos" e uma opção por situação.
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelect});

  final AppointmentStatus? selected;
  final ValueChanged<AppointmentStatus?> onSelect;

  Widget _chip(String label, AppointmentStatus? value) => Padding(
    padding: const EdgeInsets.only(right: AppSpacing.sm),
    child: ChoiceChip(
      label: Text(label),
      labelStyle: AppTextStyles.label.copyWith(
        color: selected == value ? AppColors.white : AppColors.ink,
      ),
      selected: selected == value,
      selectedColor: AppColors.gold,
      backgroundColor: AppColors.white,
      showCheckmark: false,
      side: const BorderSide(color: AppColors.line),
      onSelected: (_) => onSelect(value),
    ),
  );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenPadding,
      vertical: AppSpacing.lg,
    ),
    child: Row(
      children: [
        _chip(AppStrings.adminFilterAll, null),
        for (final AppointmentStatus s in AppointmentStatus.values)
          _chip(s.label, s),
      ],
    ),
  );
}
