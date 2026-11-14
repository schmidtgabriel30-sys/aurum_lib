import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../models/vehicle.dart';
import '../../services/api_client.dart';
import '../../services/vehicle_service.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/danger_button.dart';
import '../../widgets/error_state.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/primary_button.dart';

/// Cadastro e edição de veículo. Na edição também permite excluir.
class VehicleFormScreen extends StatefulWidget {
  const VehicleFormScreen({super.key, this.vehicleId});

  final int? vehicleId;

  bool get isEditing => vehicleId != null;

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  static const int _yearLength = 4;
  static const int _plateLength = 8;

  final VehicleService _service = VehicleService.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _model = TextEditingController();
  final TextEditingController _plate = TextEditingController();
  final TextEditingController _year = TextEditingController();

  bool _loading = false;
  String? _loadError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) _load();
  }

  @override
  void dispose() {
    for (final TextEditingController c in [_brand, _model, _plate, _year]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final Vehicle v = await _service.fetchById(widget.vehicleId!);
      _brand.text = v.brand;
      _model.text = v.model;
      _plate.text = v.plate;
      _year.text = '${v.year}';
    } on ApiException catch (e) {
      _loadError = e.message;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Salva ou exclui, mostrando o resultado e voltando para a lista.
  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() => _saving = true);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      messenger.showSnackBar(SnackBar(content: Text(success)));
      if (mounted) context.goNamed(AppRoutes.vehicles);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final Vehicle vehicle = Vehicle(
      id: widget.vehicleId,
      brand: _brand.text.trim(),
      model: _model.text.trim(),
      plate: Formatters.plate(_plate.text),
      year: int.parse(_year.text.trim()),
    );

    await _run(
      () => widget.isEditing
          ? _service.update(vehicle)
          : _service.create(vehicle),
      widget.isEditing ? AppStrings.vehicleUpdated : AppStrings.vehicleCreated,
    );
  }

  Future<void> _delete() async {
    final bool confirmed = await ConfirmDialog.show(
      context,
      title: AppStrings.vehicleDeleteTitle,
      message: AppStrings.vehicleDeleteMessage,
      confirmLabel: AppStrings.delete,
    );
    if (!confirmed || !mounted) return;

    await _run(
      () => _service.delete(widget.vehicleId!),
      AppStrings.vehicleDeleted,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.isEditing
            ? AppStrings.vehicleEditTitle
            : AppStrings.vehicleNewTitle,
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
                AppTextField(
                  label: AppStrings.fieldBrand,
                  required: true,
                  controller: _brand,
                  hint: AppStrings.hintBrand,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      Validators.required(v, field: AppStrings.fieldBrand),
                ),
                AppTextField(
                  label: AppStrings.fieldModel,
                  required: true,
                  controller: _model,
                  hint: AppStrings.hintModel,
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      Validators.required(v, field: AppStrings.fieldModel),
                ),
                AppTextField(
                  label: AppStrings.fieldPlate,
                  required: true,
                  controller: _plate,
                  hint: AppStrings.hintPlate,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(_plateLength),
                  ],
                  validator: Validators.plate,
                ),
                AppTextField(
                  label: AppStrings.fieldYear,
                  required: true,
                  controller: _year,
                  hint: AppStrings.hintYear,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(_yearLength),
                  ],
                  validator: Validators.year,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  widget.isEditing
                      ? AppStrings.saveChanges
                      : AppStrings.vehicleSave,
                  loading: _saving,
                  loadingLabel: AppStrings.saving,
                  onPressed: _submit,
                ),
                if (widget.isEditing) ...[
                  const SizedBox(height: AppSpacing.sm),
                  DangerButton(
                    AppStrings.vehicleDelete,
                    icon: Icons.delete_outline,
                    onPressed: _saving ? null : _delete,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
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
