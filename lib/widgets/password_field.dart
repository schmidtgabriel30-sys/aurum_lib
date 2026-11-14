import 'package:flutter/material.dart';
import '../core/theme.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  const PasswordField({super.key, required this.controller, this.hint = '••••••••'});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) => TextField(
        controller: widget.controller,
        obscureText: _hidden,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          suffixIcon: IconButton(
            splashRadius: 16,
            icon: Icon(_hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: 16, color: C.muted),
            onPressed: () => setState(() => _hidden = !_hidden),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.line)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: C.ink)),
        ),
      );
}