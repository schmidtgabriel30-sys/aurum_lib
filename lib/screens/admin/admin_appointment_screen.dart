import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../models/appointment.dart';
import '../../models/mechanic.dart';
import '../../services/api_client.dart';
import '../../services/appointment_service.dart';
import '../../services/mechanic_service.dart';
import '../../widgets/admin_scaffold.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/danger_button.dart';
import '../../widgets/error_state.dart';
import '../../widgets/field_label.dart';
import '../../widgets/info_row.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

/// Atendimento de um agendamento pelo admin: vê quem solicitou e conduz o
/// fluxo pendente → confirmado → em atendimento → concluído (ou recusa).
class AdminAppointmentScreen extends StatefulWidget {
  const AdminAppointmentScreen({super.key, required this.appointmentId});

  final int appointmentId;

  @override
  State<AdminAppointmentScreen> createState() => _AdminAppointmentScreenState();
}

class _AdminAppointmentScreenState extends State<AdminAppointmentScreen> {
  final AppointmentService _service = AppointmentService.instance;

  Appointment? _appointment;
  List<Mechanic> _mechanics = [];
  int? _mechanicId;

  bool _loading = true;
  String? _loadError;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Busca o agendamento e a lista de mecânicos ao mesmo tempo.
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final List<Object?> results = await Future.wait<Object?>([
        _service.fetchById(widget.appointmentId),
        MechanicService.instance.fetchAll(),
      ]);
      _appointment = results[0]! as Appointment;
      _mechanics = results[1]! as List<Mechanic>;
      _mechanicId = _appointment!.mechanic?.id;

      // Mantém o mecânico atual na lista, mesmo se tiver sido desativado.
      final Mechanic? current = _appointment!.mechanic;
      if (current != null && _mechanics.every((m) => m.id != current.id)) {
        _mechanics = [..._mechanics, current];
      }
    } on ApiException catch (e) {
      _loadError = e.message;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Muda a situação na API e recarrega a tela.
  Future<void> _changeStatus(AppointmentStatus status) async {
    setState(() => _busy = true);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      await _service.updateStatus(
        widget.appointmentId,
        status,
        // O mecânico só pode ser definido antes do atendimento terminar.
        mechanicId: status == AppointmentStatus.canceled ? null : _mechanicId,
      );
      messenger.showSnackBar(
        SnackBar(content: Text('${AppStrings.adminUpdated} ${status.label}')),
      );
      await _load();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reject() async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: AppStrings.adminRejectTitle,
      message: AppStrings.adminRejectMessage,
      confirmLabel: AppStrings.adminReject,
      cancelLabel: AppStrings.keep,
    );
    if (confirmed && mounted) await _changeStatus(AppointmentStatus.canceled);
  }

  /// Texto do botão principal conforme o próximo passo do fluxo.
  static String _nextLabel(AppointmentStatus next) => switch (next) {
    AppointmentStatus.confirmed => AppStrings.adminAccept,
    AppointmentStatus.inService => AppStrings.adminStart,
    _ => AppStrings.adminFinish,
  };

  static IconData _nextIcon(AppointmentStatus next) => switch (next) {
    AppointmentStatus.confirmed => Icons.check_circle_outline,
    AppointmentStatus.inService => Icons.build_circle_outlined,
    _ => Icons.task_alt,
  };

  @override
  Widget build(BuildContext context) =>
      AdminScaffold(title: AppStrings.adminDetailsTitle, body: _buildBody());

  Widget _buildBody() {
    if (_loading && _appointment == null) return const LoadingState();
    if (_loadError != null) {
      return ErrorState(message: _loadError!, onRetry: _load);
    }

    final Appointment a = _appointment!;
    final AppointmentStatus? next = a.nextStatus;
    final bool canChooseMechanic =
        a.status == AppointmentStatus.pending ||
        a.status == AppointmentStatus.confirmed;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Card(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          a.clientName ?? AppStrings.adminClient,
                          style: AppTextStyles.pageTitle,
                        ),
                      ),
                      StatusBadge(status: a.status),
                    ],
                  ),
                  if (a.clientEmail != null)
                    Text(a.clientEmail!, style: AppTextStyles.body),
                  const Divider(height: AppSpacing.xxl),
                  InfoRow(
                    icon: Icons.build_outlined,
                    label: AppStrings.adminRequestedService,
                    value: a.service == null
                        ? '-'
                        : '${a.service!.name} • '
                              '${Formatters.currency(a.service!.price)}',
                  ),
                  if (a.vehicle != null)
                    InfoRow(
                      icon: Icons.directions_car_outlined,
                      label: AppStrings.fieldVehicle,
                      value: '${a.vehicle!.title} • ${a.vehicle!.plate}',
                    ),
                  InfoRow(
                    icon: Icons.event_outlined,
                    label: AppStrings.fieldDate,
                    value: '${Formatters.longDate(a.date)} • ${a.period.label}',
                  ),
                  InfoRow(
                    icon: Icons.notes,
                    label: AppStrings.fieldNotes,
                    value: a.notes.isEmpty ? AppStrings.noNotes : a.notes,
                  ),
                  if (!canChooseMechanic)
                    InfoRow(
                      icon: Icons.engineering_outlined,
                      label: AppStrings.adminMechanic,
                      value: a.mechanic?.name ?? AppStrings.noMechanic,
                    ),
                ],
              ),
              if (canChooseMechanic) ...[
                const FieldLabel(AppStrings.adminMechanic),
                DropdownButtonFormField<int>(
                  initialValue: _mechanicId,
                  isExpanded: true,
                  style: AppTextStyles.input,
                  decoration: const InputDecoration(
                    hintText: AppStrings.adminMechanicHint,
                  ),
                  items: [
                    for (final Mechanic m in _mechanics)
                      DropdownMenuItem(
                        value: m.id,
                        child: Text(
                          m.specialty.isEmpty
                              ? m.name
                              : '${m.name} • ${m.specialty}',
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() => _mechanicId = v),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              if (next == null)
                const Text(
                  AppStrings.adminDone,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                )
              else
                PrimaryButton(
                  _nextLabel(next),
                  icon: _nextIcon(next),
                  loading: _busy,
                  loadingLabel: AppStrings.saving,
                  onPressed: () => _changeStatus(next),
                ),
              if (a.canCancel) ...[
                const SizedBox(height: AppSpacing.sm),
                DangerButton(
                  a.status == AppointmentStatus.pending
                      ? AppStrings.adminReject
                      : AppStrings.adminCancel,
                  icon: Icons.block,
                  onPressed: _busy ? null : _reject,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}
