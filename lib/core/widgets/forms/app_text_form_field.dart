import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.textInputAction,
    required this.labelText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.textColor,
    this.inputFormatters,
    this.maxLines,
    this.autovalidateMode,
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String labelText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final FloatingLabelBehavior floatingLabelBehavior;
  final Color? textColor;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onChanged: onChanged,
        autofocus: autofocus ?? false,
        validator: validator,
        autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
        obscureText: obscureText ?? false,
        obscuringCharacter: '*',
        onEditingComplete: onEditingComplete,
        inputFormatters: inputFormatters,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: labelText,
          floatingLabelBehavior: floatingLabelBehavior,
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
            .copyWith(fontWeight: FontWeight.w500, color: textColor),
      ),
    );
  }
}
