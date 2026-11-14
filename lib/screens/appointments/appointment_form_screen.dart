import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../models/appointment.dart';
import '../../models/service_item.dart';
import '../../models/vehicle.dart';
import '../../services/api_client.dart';
import '../../services/appointment_service.dart';
import '../../services/service_item_service.dart';
import '../../services/vehicle_service.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/field_label.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/primary_button.dart';

/// Formulário de agendamento: cria (o "C") ou reagenda (o "U").
///
/// Ao abrir, busca na API os veículos do usuário e o catálogo de serviços
/// (e, na edição, o próprio agendamento) para preencher as listas.
class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({super.key, this.appointmentId});

  final int? appointmentId;

  bool get isEditing => appointmentId != null;

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  static const int _maxDaysAhead = 180;

  final AppointmentService _service = AppointmentService.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  List<Vehicle> _vehicles = [];
  List<ServiceItem> _services = [];
  int? _vehicleId;
  int? _serviceId;
  DateTime? _selectedDate;
  AppointmentPeriod? _period;

  bool _loading = true;
  String? _loadError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _date.dispose();
    _notes.dispose();
    super.dispose();
  }

  /// Busca, em paralelo, tudo o que o formulário precisa.
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      // As três buscas rodam ao mesmo tempo; o Future.wait espera todas.
      final List<Object?> results = await Future.wait<Object?>([
        VehicleService.instance.fetchAll(),
        ServiceItemService.instance.fetchAll(),
        if (widget.isEditing) _service.fetchById(widget.appointmentId!),
      ]);

      _vehicles = results[0]! as List<Vehicle>;
      _services = results[1]! as List<ServiceItem>;
      if (widget.isEditing) _fill(results[2]! as Appointment);
    } on ApiException catch (e) {
      _loadError = e.message;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Na edição, preenche os campos com o agendamento vindo da API.
  void _fill(Appointment a) {
    _vehicleId = a.vehicleId;
    _serviceId = a.serviceId;
    _period = a.period;
    _notes.text = a.notes;
    _setDate(a.date);

    // Garante que o veículo/serviço atual aparece na lista, mesmo se tiver
    // sido desativado depois.
    if (a.vehicle != null && _vehicles.every((v) => v.id != a.vehicleId)) {
      _vehicles = [..._vehicles, a.vehicle!];
    }
    if (a.service != null && _services.every((s) => s.id != a.serviceId)) {
      _services = [..._services, a.service!];
    }
  }

  void _setDate(DateTime date) {
    _selectedDate = date;
    _date.text = Formatters.fullDate(date);
  }

  Future<void> _pickDate() async {
    final DateTime today = DateTime.now();
    final DateTime first = DateTime(today.year, today.month, today.day);
    final DateTime? current = _selectedDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current != null && !current.isBefore(first)
          ? current
          : first.add(const Duration(days: 1)),
      firstDate: first,
      lastDate: first.add(const Duration(days: _maxDaysAhead)),
    );
    if (picked != null) setState(() => _setDate(picked));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final Appointment appointment = Appointment(
      id: widget.appointmentId,
      vehicleId: _vehicleId!,
      serviceId: _serviceId!,
      date: _selectedDate!,
      period: _period!,
      notes: _notes.text.trim(),
    );

    setState(() => _saving = true);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      if (widget.isEditing) {
        await _service.update(appointment);
      } else {
        await _service.create(appointment);
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? AppStrings.appointmentUpdated
                : AppStrings.appointmentCreated,
          ),
        ),
      );
      if (!mounted) return;
      if (widget.isEditing) {
        context.goNamed(
          AppRoutes.appointmentDetails,
          pathParameters: {AppRoutes.idParam: '${widget.appointmentId}'},
        );
      } else {
        context.goNamed(AppRoutes.appointments);
      }
    } on ApiException catch (e) {
      // Regras da API (período lotado, veículo já agendado...) chegam aqui.
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.isEditing
            ? AppStrings.appointmentEditTitle
            : AppStrings.appointmentNewTitle,
      ),
    ),
    body: _buildBody(),
  );

  Widget _buildBody() {
    if (_loading) return const LoadingState();
    if (_loadError != null) {
      return ErrorState(message: _loadError!, onRetry: _load);
    }
    if (_vehicles.isEmpty) {
      return EmptyState(
        message: AppStrings.noVehicleYet,
        icon: Icons.directions_car_outlined,
        action: OutlinedButton.icon(
          onPressed: () => context.goNamed(AppRoutes.vehicleNew),
          icon: const Icon(Icons.add, size: AppSizes.iconMd),
          label: const Text(AppStrings.goToNewVehicle),
        ),
      );
    }

    final bool editing = widget.isEditing;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  editing
                      ? AppStrings.appointmentEditIntro
                      : AppStrings.appointmentFormIntro,
                  style: AppTextStyles.body,
                ),
                const FieldLabel(AppStrings.fieldVehicle, required: true),
                DropdownButtonFormField<int>(
                  initialValue: _vehicleId,
                  isExpanded: true,
                  style: AppTextStyles.input,
                  decoration: const InputDecoration(
                    hintText: AppStrings.hintVehicle,
                  ),
                  items: [
                    for (final Vehicle v in _vehicles)
                      DropdownMenuItem(
                        value: v.id,
                        child: Text('${v.title} • ${v.plate}'),
                      ),
                  ],
                  // Na edição a API não permite trocar o veículo.
                  onChanged: editing
                      ? null
                      : (v) => setState(() => _vehicleId = v),
                  validator: (v) => Validators.requiredSelection(
                    v,
                    field: AppStrings.fieldVehicle,
                  ),
                ),
                const FieldLabel(AppStrings.fieldService, required: true),
                DropdownButtonFormField<int>(
                  initialValue: _serviceId,
                  isExpanded: true,
                  style: AppTextStyles.input,
                  decoration: const InputDecoration(
                    hintText: AppStrings.hintService,
                  ),
                  items: [
                    for (final ServiceItem s in _services)
                      DropdownMenuItem(
                        value: s.id,
                        child: Text(
                          '${s.name} • ${Formatters.currency(s.price)}',
                        ),
                      ),
                  ],
                  onChanged: editing
                      ? null
                      : (v) => setState(() => _serviceId = v),
                  validator: (v) => Validators.requiredSelection(
                    v,
                    field: AppStrings.fieldService,
                  ),
                ),
                if (editing) ...[
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    AppStrings.lockedOnEdit,
                    style: AppTextStyles.caption,
                  ),
                ],
                AppTextField(
                  label: AppStrings.fieldDate,
                  required: true,
                  controller: _date,
                  hint: AppStrings.hintDate,
                  readOnly: true,
                  onTap: _pickDate,
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    size: AppSizes.iconMd,
                  ),
                  validator: (_) => Validators.futureDate(_selectedDate),
                ),
                const FieldLabel(AppStrings.fieldPeriod, required: true),
                DropdownButtonFormField<AppointmentPeriod>(
                  initialValue: _period,
                  style: AppTextStyles.input,
                  decoration: const InputDecoration(
                    hintText: AppStrings.hintPeriod,
                  ),
                  items: [
                    for (final AppointmentPeriod p in AppointmentPeriod.values)
                      DropdownMenuItem(value: p, child: Text(p.label)),
                  ],
                  onChanged: (v) => setState(() => _period = v),
                  validator: (v) => Validators.requiredSelection(
                    v,
                    field: AppStrings.fieldPeriod,
                  ),
                ),
                AppTextField(
                  label: AppStrings.fieldNotes,
                  controller: _notes,
                  hint: AppStrings.hintNotes,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  editing ? AppStrings.saveChanges : AppStrings.appointmentSave,
                  loading: _saving,
                  loadingLabel: AppStrings.saving,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.md),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: AppSizes.iconXs,
                      color: AppColors.gold,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        AppStrings.appointmentDisclaimer,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  AppStrings.requiredFields,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
