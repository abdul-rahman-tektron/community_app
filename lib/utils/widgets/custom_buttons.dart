import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/helpers/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool iconOnLeft;
  final bool isLoading;
  final bool fullWidth;
  final double? height;
  final double? radius;
  final Color? borderColor;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.icon,
    this.iconOnLeft = false,
    this.isLoading = false,
    this.fullWidth = true,
    this.height,
    this.radius,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedBgColor = onPressed == null
        ? (backgroundColor ?? AppColors.primary).withOpacity(0.5)
        : backgroundColor ?? AppColors.primary;

    final resolvedTextColor =
    (backgroundColor ?? AppColors.primary) == AppColors.primary
        ? Colors.white
        : AppColors.primary;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height ?? (MediaQuery.of(context).devicePixelRatio >= 3.0 ? 40 : 45),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBgColor,
          foregroundColor: resolvedTextColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: isLoading
            ? const DotCircleSpinner(size: 40, dotSize: 3)
            : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && iconOnLeft) ...[
              Icon(icon, size: 20, color: resolvedTextColor),
              5.horizontalSpace,
            ],
            FittedBox(
              child: Text(
                text,
                style: textStyle ?? AppFonts.text16.semiBold.white.style,
              ),
            ),
            if (icon != null && !iconOnLeft) ...[
              5.horizontalSpace,
              Icon(icon, size: 20, color: resolvedTextColor),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomUploadButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final IconData? icon;
  final double? radius;

  const CustomUploadButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.icon,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 50),
          side: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? LucideIcons.paperclip, color: AppColors.primary),
          5.horizontalSpace,
          Text(text, style: textStyle ?? AppFonts.text14.medium.white.style),
        ],
      ),
    );
  }
}
