import 'package:secure_note/core/constants/dimension_theme.dart';
import 'package:secure_note/core/extensions/ex_build_context.dart';
import 'package:secure_note/core/extensions/ex_expanded.dart';
import 'package:secure_note/core/extensions/ex_padding.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// ✏️🔒 WTextField
/// A feature-rich and flexible text input field:
/// 🏷️ Optional label and hint
/// 🔐 Secure input support via `.obsecureText` constructor
/// ✅ Required field support via `.requiredField`
/// 🧠 Custom validator and input format
/// 👀 Optional prefix/suffix widgets or icons (e.g., SVG)
/// 🎯 Auto/manual focus support, controller lifecycle
/// 📲 Keyboard type control for input specificity
/// 🎉 Comes with built-in error handling, label styling, and optional visibility toggle for passwords
class WTextField extends StatefulWidget {
  final String? initialText;
  final String? label;
  final String? hintText;
  final String? prefixIconPath;
  final Widget? prefix;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obsecureText;
  final bool enable;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool autoDispose;
  final TextInputType? keyboardType;
  final bool isRequired;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool? expands;
  final AutovalidateMode? autovalidateMode;
  final TextAlignVertical? textAlignVertical;
  const WTextField({
    super.key,
    this.label,
    this.hintText,
    this.prefixIconPath,
    this.prefix,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.enable = true,
    this.onTap,
    this.onChanged,
    this.autoDispose = true,
    this.keyboardType,
    this.initialText,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.next,
    this.expands,
    this.autovalidateMode,
    this.textAlignVertical,
  }) : obsecureText = false,
       isRequired = false;

  const WTextField.obsecureText({
    super.key,
    this.label,
    this.hintText,
    this.prefixIconPath,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.prefix,
    this.enable = true,
    this.onTap,
    this.onChanged,
    this.autoDispose = true,
    this.keyboardType,
    this.initialText,
    this.focusNode,
    this.isRequired = true,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.next,
    this.expands,
    this.autovalidateMode,
    this.textAlignVertical,
  }) : obsecureText = true;
  const WTextField.requiredField({
    super.key,
    this.label,
    this.hintText,
    this.prefixIconPath,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.prefix,
    this.enable = true,
    this.onTap,
    this.onChanged,
    this.autoDispose = true,
    this.keyboardType,
    this.initialText,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.next,
    this.expands,
    this.autovalidateMode,
    this.textAlignVertical,
  }) : obsecureText = false,
       isRequired = true;

  @override
  State<WTextField> createState() => _WTextFieldState();
}

class _WTextFieldState extends State<WTextField> {
  late final ValueNotifier<bool> obsecureText = ValueNotifier<bool>(
    widget.obsecureText,
  );
  TextEditingController? _controller;
  bool _isControllerOwner = false; // 🔹 tracking ownership

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller;
    } else {
      _controller = TextEditingController(text: widget.initialText);
      _isControllerOwner = true;
    }
  }

  @override
  void dispose() {
    if (_isControllerOwner) {
      _controller?.dispose(); // ✅ only dispose if we created it
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget constant = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNotNull(widget.label))
          Row(
            children: [
              Text(widget.label!, style: context.textTheme?.labelMedium),
              if (widget.isRequired)
                Text(
                  " *",
                  style: context.textTheme?.labelMedium?.copyWith(
                    color: context.redColor,
                  ),
                ),
            ],
          ).pB(),
        ValueListenableBuilder<bool>(
          valueListenable: obsecureText,
          builder: (_, value, __) {
            return _textField();
          },
        ).expd(value: widget.expands ?? false ? 1 : 0),
        gapX(10),
      ],
    );
    return widget.expands ?? false ? constant.expd() : constant;
  }

  Widget _textField() {
    return TextFormField(
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
      validator: (v) {
        final validation = widget.validator?.call(v);

        if (validation != null) {
          return validation;
        }

        if (widget.isRequired && (v == null || v.isEmpty)) {
          return "Please enter ${widget.label}";
        }
        return null;
      },
      expands: widget.expands ?? false,
      obscureText: obsecureText.value,
      controller: _controller,
      readOnly: !widget.enable,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      focusNode: widget.focusNode,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      autovalidateMode:
          widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
      textInputAction: widget.textInputAction,
      style: context.textTheme?.titleLarge?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: context.fillColor,
        prefixIconConstraints: BoxConstraints(maxHeight: 17),
        errorStyle: context.textTheme?.labelSmall?.copyWith(
          color: context.redColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: widget.prefixIconPath == null ? 10 : 0.0,
        ),
        hintText:
            widget.hintText ??
            (widget.label == null ? null : "Enter ${widget.label}"),
        prefixIcon: widget.prefix != null
            ? widget.prefix!
            : widget.prefixIconPath == null
            ? null
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: PTheme.paddingX - 5),
                child: SvgPicture.asset(
                  widget.prefixIconPath!,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                    context.primaryTextColor!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
        suffixIcon: widget.obsecureText
            ? InkWell(
                onTap: () {
                  obsecureText.value = !obsecureText.value;
                },
                child: Icon(
                  obsecureText.value ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}
