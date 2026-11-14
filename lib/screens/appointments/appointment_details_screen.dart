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
import '../../widgets/loading_state.dart';
import '../../widgets/primary_button.dart';

/// Detalhes de um agendamento, com as ações de editar e excluir.
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
  bool _deleting = false;

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
    if (_deleting) return; // o registro acabou de ser apagado
    setState(() => _future = _service.fetchById(widget.appointmentId));
  }

  Future<void> _delete() async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: AppStrings.deleteDialogTitle,
      message: AppStrings.deleteDialogMessage,
      confirmLabel: AppStrings.appointmentDelete,
    );
    if (!confirmed || !mounted) return;

    setState(() => _deleting = true);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      await _service.delete(widget.appointmentId);
      messenger.showSnackBar(
        const SnackBar(content: Text(AppStrings.appointmentDeleted)),
      );
      if (mounted) context.goNamed(AppRoutes.appointments);
    } on ApiException catch (e) {
      if (mounted) setState(() => _deleting = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
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
        return _DetailsBody(
          appointment: snapshot.data!,
          deleting: _deleting,
          onEdit: _edit,
          onDelete: _delete,
        );
      },
    ),
  );
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({
    required this.appointment,
    required this.deleting,
    required this.onEdit,
    required this.onDelete,
  });

  final Appointment appointment;
  final bool deleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.screenPadding),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.vehicle, style: AppTextStyles.pageTitle),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    Formatters.longDate(appointment.preferredDate),
                    style: AppTextStyles.body,
                  ),
                  const Divider(height: AppSpacing.xxl),
                  _InfoRow(
                    icon: Icons.person_outline,
                    label: AppStrings.fieldName,
                    value: appointment.name,
                  ),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: AppStrings.fieldPhone,
                    value: Formatters.phone(appointment.phone),
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: AppStrings.fieldDate,
                    value: Formatters.fullDate(appointment.preferredDate),
                  ),
                  _InfoRow(
                    icon: Icons.schedule,
                    label: AppStrings.fieldPeriod,
                    value: appointment.period.label,
                  ),
                  _InfoRow(
                    icon: Icons.notes,
                    label: AppStrings.fieldNotes,
                    value: appointment.notes.isEmpty
                        ? AppStrings.noNotes
                        : appointment.notes,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              AppStrings.appointmentEdit,
              icon: Icons.edit_outlined,
              onPressed: deleting ? null : onEdit,
            ),
            const SizedBox(height: AppSpacing.sm),
            DangerButton(
              AppStrings.appointmentDelete,
              icon: Icons.delete_outline,
              onPressed: deleting ? null : onDelete,
            ),
          ],
        ),
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconMd, color: AppColors.gold),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                value,
                style: AppTextStyles.input.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
