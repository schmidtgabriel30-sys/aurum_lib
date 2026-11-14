import 'package:flutter/material.dart';
import '../../../core/api.dart';
import '../../../core/theme.dart';
import '../../../widgets/common.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _nome = TextEditingController();
  final _cel = TextEditingController();
  final _veiculo = TextEditingController();
  final _obs = TextEditingController();
  final _data = TextEditingController();
  String? _periodo;
  bool _aceite = false;
  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_nome, _cel, _veiculo, _obs, _data]) {
      c.dispose();
    }
    super.dispose();
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.gold)),
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(t, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
      );

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
    );
    if (d != null) {
      _data.text =
          '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }
  }

  Future<void> _submit() async {
    if (_nome.text.isEmpty || _cel.text.isEmpty || _veiculo.text.isEmpty ||
        _data.text.isEmpty || _periodo == null || !_aceite) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Preencha os campos obrigatórios.')));
      return;
    }
    setState(() => _loading = true);
    final ok = await Api.agendar({
      'nome': _nome.text,
      'celular': _cel.text,
      'veiculo': _veiculo.text,
      'data_preferencia': _data.text,
      'periodo': _periodo,
      'observacoes': _obs.text,
      'aceite_contato': _aceite,
    });
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? 'Solicitação enviada! Entraremos em contato.' : 'Erro ao enviar. Tente novamente.')));
  }

  @override
  Widget build(BuildContext context) => Section(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('Seu próximo passo'),
          const SizedBox(height: 12),
          const H2('Dê ao seu carro\na atenção que ele merece.'),
          const SizedBox(height: 8),
          const Text(
              'Solicite sua revisão preventiva. Deixe suas dúvidas e nossa equipe entrará em contato para confirmar os detalhes.',
              style: TextStyle(fontSize: 10, color: C.muted, height: 1.5)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: C.beige, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(8)),
            child: const Row(children: [
              Icon(Icons.inventory_2_outlined, size: 14, color: C.gold),
              SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Revisão preventiva completa',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                  SizedBox(height: 2),
                  Text('R\$ 249,90 à vista ou em até 3x sem juros',
                      style: TextStyle(fontSize: 8, color: C.muted)),
                ]),
              ),
            ]),
          ),
          _label('Nome completo *'),
          TextField(controller: _nome, decoration: _dec('Como podemos chamar você?')),
          _label('Celular com DDD *'),
          TextField(
              controller: _cel, keyboardType: TextInputType.phone, decoration: _dec('(00) 00000-0000')),
          _label('Veículo *'),
          TextField(controller: _veiculo, decoration: _dec('Marca, modelo e ano')),
          _label('Dia de preferência *'),
          TextField(
              controller: _data,
              readOnly: true,
              onTap: _pickDate,
              decoration: _dec('dd/mm/aaaa').copyWith(
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 14))),
          _label('Período *'),
          DropdownButtonFormField<String>(
            value: _periodo,
            decoration: _dec('Selecione'),
            style: const TextStyle(fontSize: 10, color: C.ink),
            items: const ['Manhã', 'Tarde', 'Noite']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _periodo = v),
          ),
          _label('Observações (opcional)'),
          TextField(
              controller: _obs, maxLines: 3, decoration: _dec('Quer nos contar algo sobre o carro?')),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 24,
              child: Checkbox(
                value: _aceite,
                activeColor: C.gold,
                visualDensity: VisualDensity.compact,
                onChanged: (v) => setState(() => _aceite = v ?? false),
              ),
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text('Autorizo o contato da Aurum Automotive para dar continuidade a esta solicitação.',
                    style: TextStyle(fontSize: 8, color: C.muted)),
              ),
            ),
          ]),
          const SizedBox(height: 14),
          GoldButton(_loading ? 'Enviando...' : 'Solicitar agendamento',
              icon: null, onPressed: _loading ? null : _submit),
          const SizedBox(height: 10),
          const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.info_outline, size: 11, color: C.gold),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                  'O envio é uma solicitação, não uma reserva. O dia e o horário dependem da confirmação da equipe.',
                  style: TextStyle(fontSize: 8, color: C.muted)),
            ),
          ]),
          const SizedBox(height: 6),
          const Text('* Campos obrigatórios', style: TextStyle(fontSize: 8, color: C.muted)),
        ]),
      );
}
