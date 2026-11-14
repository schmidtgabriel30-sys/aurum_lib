import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/phone_input_formatter.dart';
import '../../core/utils/validators.dart';
import '../../models/appointment.dart';
import '../../services/api_client.dart';
import '../../services/appointment_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/error_state.dart';
import '../../widgets/field_label.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/primary_button.dart';

/// Formulário de agendamento: cria (o "C") ou edita (o "U") um registro.
///
/// Sem [appointmentId] a tela cria um agendamento novo. Com ele, busca o
/// registro na API e preenche os campos para edição.
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

  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _vehicle = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  DateTime? _selectedDate;
  AppointmentPeriod? _period;
  bool _consent = false;

  bool _loading = false;
  String? _loadError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _load();
    } else {
      _name.text = AuthService.instance.currentUser?.name ?? '';
    }
  }

  @override
  void dispose() {
    for (final TextEditingController c in [
      _name,
      _phone,
      _vehicle,
      _date,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Na edição, busca o agendamento e preenche o formulário.
  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final Appointment a = await _service.fetchById(widget.appointmentId!);
      _name.text = a.name;
      _phone.text = Formatters.phone(a.phone);
      _vehicle.text = a.vehicle;
      _notes.text = a.notes;
      _setDate(a.preferredDate);
      _period = a.period;
      _consent = a.contactConsent;
    } on ApiException catch (e) {
      _loadError = e.message;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _setDate(DateTime date) {
    _selectedDate = date;
    _date.text = Formatters.fullDate(date);
  }

  Future<void> _pickDate() async {
    final DateTime today = DateTime.now();
    final DateTime first = DateTime(today.year, today.month, today.day);
    final DateTime? initial = _selectedDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial != null && !initial.isBefore(first)
          ? initial
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
      name: _name.text.trim(),
      phone: _phone.text.replaceAll(RegExp(r'\D'), ''),
      vehicle: _vehicle.text.trim(),
      preferredDate: _selectedDate!,
      period: _period!,
      notes: _notes.text.trim(),
      contactConsent: _consent,
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
                const Text(
                  AppStrings.appointmentFormIntro,
                  style: AppTextStyles.body,
                ),
                AppTextField(
                  label: AppStrings.fieldName,
                  required: true,
                  controller: _name,
                  hint: AppStrings.hintName,
                  textInputAction: TextInputAction.next,
                  validator: Validators.fullName,
                ),
                AppTextField(
                  label: AppStrings.fieldPhone,
                  required: true,
                  controller: _phone,
                  hint: AppStrings.hintPhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneInputFormatter()],
                  textInputAction: TextInputAction.next,
                  validator: Validators.phone,
                ),
                AppTextField(
                  label: AppStrings.fieldVehicle,
                  required: true,
                  controller: _vehicle,
                  hint: AppStrings.hintVehicle,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      Validators.required(v, field: AppStrings.fieldVehicle),
                ),
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
                  // Na edição, aceita manter uma data que já passou.
                  validator: (_) => widget.isEditing
                      ? Validators.requiredSelection(
                          _selectedDate,
                          field: AppStrings.fieldDate,
                        )
                      : Validators.futureDate(_selectedDate),
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
                const SizedBox(height: AppSpacing.md),
                _ConsentField(
                  initialValue: _consent,
                  onChanged: (v) => _consent = v,
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  widget.isEditing
                      ? AppStrings.appointmentUpdate
                      : AppStrings.appointmentSave,
                  loading: _saving,
                  loadingLabel: AppStrings.appointmentSaving,
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

/// Caixa de "autorizo o contato" que participa da validação do formulário.
class _ConsentField extends FormField<bool> {
  _ConsentField({
    required bool initialValue,
    required ValueChanged<bool> onChanged,
  }) : super(
         initialValue: initialValue,
         validator: Validators.consent,
         builder: (state) => Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(
                   width: AppSizes.checkboxWidth,
                   child: Checkbox(
                     value: state.value ?? false,
                     visualDensity: VisualDensity.compact,
                     onChanged: (v) {
                       state.didChange(v ?? false);
                       onChanged(v ?? false);
                     },
                   ),
                 ),
                 const SizedBox(width: AppSpacing.sm),
                 const Expanded(
                   child: Padding(
                     padding: EdgeInsets.only(top: AppSpacing.xs),
                     child: Text(
                       AppStrings.appointmentConsent,
                       style: AppTextStyles.caption,
                     ),
                   ),
                 ),
               ],
             ),
             if (state.hasError)
               Text(
                 state.errorText!,
                 style: AppTextStyles.caption.copyWith(color: AppColors.danger),
               ),
           ],
         ),
       );
}
