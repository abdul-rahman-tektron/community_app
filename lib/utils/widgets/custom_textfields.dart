import 'dart:ui';
import 'package:Xception/res/colors.dart';
import 'package:Xception/res/fonts.dart';
import 'package:Xception/res/styles.dart';
import 'package:Xception/utils/extensions.dart';
import 'package:Xception/utils/helpers/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String fieldName;
  final String? hintText;
  final bool isPassword;
  final bool skipValidation;
  final bool? isMaxLines;
  final bool? titleVisibility;
  final TextStyle? hintStyle;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onTapSuffix;
  final String? Function(String?)? validator;
  final Color? borderColor;
  final TextInputAction textInputAction;
  final Color? backgroundColor;
  final bool hidePassIcon;
  final bool isEditable;
  final bool isSmallFieldFont;
  final bool isEnable;
  final String? toolTipContent;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? initialDate;
  final bool needTime;
  final bool isAutoValidate;
  final bool showAsterisk;
  final Icon? prefix;
  final List<TextInputFormatter>? inputFormatters;

  // 👇 NEW
  final bool readOnly;                 // Force read-only (e.g., Address opens map)
  final VoidCallback? onTap;           // Handle tap (e.g., push map)
  final bool? showCursor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.fieldName,
    this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.onChanged,
    this.hintStyle,
    this.onTapSuffix,
    this.validator,
    this.titleVisibility = true,
    this.isMaxLines,
    this.skipValidation = false,
    this.borderColor,
    this.textInputAction = TextInputAction.done,
    this.backgroundColor,
    this.hidePassIcon = false,
    this.isEditable = true,
    this.isEnable = true,
    this.isSmallFieldFont = false,
    this.toolTipContent,
    this.startDate,
    this.endDate,
    this.initialDate,
    this.needTime = false,
    this.isAutoValidate = true,
    this.showAsterisk = true,
    this.prefix,
    this.inputFormatters,

    // 👇 NEW defaults
    this.readOnly = false,
    this.onTap,
    this.showCursor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  DateTime? _selectedDate;
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  bool get _effectiveReadOnly =>
      widget.readOnly ||
          !widget.isEditable ||
          widget.keyboardType == TextInputType.datetime;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay() {
    _removeOverlay();
    final overlay = Overlay.of(context);
    if (overlay != null) {
      _overlayEntry = _createOverlayEntry();
      overlay.insert(_overlayEntry!);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final fieldRect = offset & size;

    return OverlayEntry(
      builder: (_) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          if (!fieldRect.contains(event.position)) {
            _focusNode.unfocus();
            _removeOverlay();
          }
        },
        child: const SizedBox.expand(),
      ),
    );
  }

  void _toggleVisibility() => setState(() => _obscureText = !_obscureText);

  String _formatDateTime(DateTime? date) {
    if (date == null) return '';
    final pattern = widget.needTime ? 'dd/MM/yyyy h:mm a' : 'dd/MM/yyyy';
    return DateFormat(pattern).format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = _selectedDate ?? widget.initialDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.startDate ?? DateTime(1900),
      lastDate: widget.endDate ?? DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.primary,
            headerForegroundColor: AppColors.white,
          ),
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary)),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      DateTime finalDateTime = picked;

      if (widget.needTime) {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                hourMinuteTextColor: Colors.black,
                dayPeriodColor: AppColors.secondary,
                dialHandColor: AppColors.secondary,
                dialBackgroundColor: Colors.grey.shade200,
                entryModeIconColor: AppColors.secondary,
              ),
              colorScheme: ColorScheme.light(
                primary: AppColors.secondary,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ),
            child: child!,
          ),
        );

        if (time != null) {
          DateTime selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );

          final now = DateTime.now();

          // **If same day & time is in the past → set to current time**
          if (picked.year == now.year &&
              picked.month == now.month &&
              picked.day == now.day &&
              selectedDateTime.isBefore(now)) {
            selectedDateTime = now;
          }

          finalDateTime = selectedDateTime;
        }
      }

      setState(() {
        _selectedDate = finalDateTime;
        final text = _formatDateTime(_selectedDate);
        widget.controller.text = text;
        widget.onChanged?.call(text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = !widget.isEnable
        ? AppFonts.text14.regular.grey.style
        : AppFonts.text14.regular.style;

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.isPassword && _obscureText,
      obscuringCharacter: '*',
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      // 👇 Respect readOnly override + existing conditions
      readOnly: _effectiveReadOnly,
      enabled: widget.isEnable,

      // 👇 Route taps: custom onTap > datetime picker > default
      onTap: () async {
        // Always hide the keyboard if we're treating this like a picker
        if (_effectiveReadOnly || widget.onTap != null) {
          FocusScope.of(context).unfocus();
        }
        if (widget.onTap != null) {
          widget.onTap!.call();
        } else if (widget.keyboardType == TextInputType.datetime) {
          await _selectDate(context);
        }
      },

      // 👇 Hide caret if read-only unless explicitly forced true
      showCursor: widget.showCursor ?? !_effectiveReadOnly,
      onChanged: widget.onChanged,
      maxLines: widget.isMaxLines == true ? 3 : 1,
      style: textColor,
      autovalidateMode: widget.isAutoValidate ? AutovalidateMode.onUserInteraction : null,
      inputFormatters: widget.inputFormatters,
      validator: widget.skipValidation
          ? null
          : widget.validator ?? (value) => Validations.requiredField(context, value),
      decoration: _buildInputDecoration(),
    );
  }



  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Text(widget.fieldName,
            style: AppFonts.text14.regular.style ),
        if (!widget.skipValidation && widget.showAsterisk)
          const Text(" *", style: TextStyle(fontSize: 15, color: AppColors.error)),
        if (widget.toolTipContent != null)
          Tooltip(
            message: widget.toolTipContent!,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(Icons.info_outline, size: 20, color: AppColors.primary),
          ),
      ],
    );
  }

  InputDecoration _buildInputDecoration() {
    final color = widget.isEnable
        ? (widget.backgroundColor ?? AppColors.white.withOpacity(0.8))
        : Colors.black.withOpacity(0.04);

    return InputDecoration(
      filled: true,
      fillColor: color,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      labelText: widget.fieldName, // Floating label
      hintText: widget.hintText,
      labelStyle: AppFonts.text14.regular.grey.style,
      hintStyle: widget.hintStyle ?? AppFonts.text14.regular.grey.style,
      suffixIcon: widget.isPassword && !widget.hidePassIcon
          ? InkWell(
          onTap: _toggleVisibility,
          child: _obscureText
              ? Icon(LucideIcons.eye)
              : Icon(LucideIcons.eyeOff))
          : null,
      prefixIcon: widget.prefix,
      floatingLabelStyle: AppFonts.text16.regular.style,
      border: AppStyles.fieldBorder,
      alignLabelWithHint: true,
      enabledBorder: AppStyles.fieldBorder,
      disabledBorder: AppStyles.fieldBorder,
      errorBorder: AppStyles.errorFieldBorder,
      focusedBorder: AppStyles.focusedFieldBorder,
      focusedErrorBorder: AppStyles.errorFieldBorder,
      errorStyle: AppFonts.text14.regular.red.style,
    );
  }
}
