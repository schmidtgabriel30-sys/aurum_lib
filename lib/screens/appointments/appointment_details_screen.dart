import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/appointment.dart';
import '../../services/api_client.dart';
import '../../services/appointment_service.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/danger_button.dart';
import '../../widgets/error_state.dart';
import '../../widgets/info_row.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

/// Detalhes de um agendamento, com as ações permitidas pela situação dele:
/// reagendar (pendente), cancelar (pendente/confirmado) e excluir.
class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  final int appointmentId;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  final AppointmentService _service = AppointmentService.instance;
  late Future<Appointment> _future = _service.fetchById(widget.appointmentId);
  bool _busy = false;
  bool _deleted = false;

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

  void _reload() {
    if (_deleted) return; // o registro acabou de ser apagado
    setState(() => _future = _service.fetchById(widget.appointmentId));
  }

  /// Executa uma ação na API mostrando o resultado num SnackBar.
  /// Reaproveitado por cancelar e excluir.
  Future<bool> _run(Future<void> Function() action, String success) async {
    setState(() => _busy = true);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      messenger.showSnackBar(SnackBar(content: Text(success)));
      return true;
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel() async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: AppStrings.cancelDialogTitle,
      message: AppStrings.cancelDialogMessage,
      confirmLabel: AppStrings.cancelDialogConfirm,
      cancelLabel: AppStrings.keep,
    );
    if (!confirmed || !mounted) return;

    await _run(
      () => _service.cancel(widget.appointmentId),
      AppStrings.appointmentCanceled,
    );
  }

  Future<void> _delete() async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: AppStrings.deleteDialogTitle,
      message: AppStrings.deleteDialogMessage,
      confirmLabel: AppStrings.delete,
    );
    if (!confirmed || !mounted) return;

    _deleted = true;
    final bool ok = await _run(
      () => _service.delete(widget.appointmentId),
      AppStrings.appointmentDeleted,
    );
    if (!ok) {
      _deleted = false;
      return;
    }
    if (mounted) context.goNamed(AppRoutes.appointments);
  }

  void _edit() => context.goNamed(
    AppRoutes.appointmentEdit,
    pathParameters: {AppRoutes.idParam: '${widget.appointmentId}'},
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.pageBackground,
    appBar: AppBar(title: const Text(AppStrings.appointmentDetailsTitle)),
    body: FutureBuilder<Appointment>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingState();
        }
        if (snapshot.hasError) {
          return ErrorState(message: '${snapshot.error}', onRetry: _reload);
        }

        final Appointment a = snapshot.data!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DetailsCard(appointment: a),
                  const SizedBox(height: AppSpacing.xl),
                  if (a.canEdit) ...[
                    PrimaryButton(
                      AppStrings.appointmentEditTitle,
                      icon: Icons.edit_calendar_outlined,
                      onPressed: _busy ? null : _edit,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  if (a.canCancel) ...[
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _cancel,
                      icon: const Icon(
                        Icons.event_busy_outlined,
                        size: AppSizes.iconMd,
                      ),
                      label: const Text(AppStrings.appointmentCancel),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  if (a.canDelete)
                    DangerButton(
                      AppStrings.delete,
                      icon: Icons.delete_outline,
                      onPressed: _busy ? null : _delete,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final Appointment a = appointment;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  a.service?.name ?? AppStrings.fieldService,
                  style: AppTextStyles.pageTitle,
                ),
              ),
              StatusBadge(status: a.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${Formatters.longDate(a.date)} • ${a.period.label}',
            style: AppTextStyles.body,
          ),
          const Divider(height: AppSpacing.xxl),
          if (a.vehicle != null)
            InfoRow(
              icon: Icons.directions_car_outlined,
              label: AppStrings.fieldVehicle,
              value: '${a.vehicle!.title} • ${a.vehicle!.plate}',
            ),
          if (a.service != null)
            InfoRow(
              icon: Icons.payments_outlined,
              label: AppStrings.fieldPrice,
              value: Formatters.currency(a.service!.price),
            ),
          InfoRow(
            icon: Icons.engineering_outlined,
            label: AppStrings.fieldMechanic,
            value: a.mechanic?.name ?? AppStrings.noMechanic,
          ),
          InfoRow(
            icon: Icons.notes,
            label: AppStrings.fieldNotes,
            value: a.notes.isEmpty ? AppStrings.noNotes : a.notes,
          ),
        ],
      ),
    );
  }
}
