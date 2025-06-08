import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../views/base/custom_image.dart';
import 'theme.dart';

class CustomDecoration {
  static InputDecoration inputDecoration({
    Widget? icon,
    String? prefixText,
    String? label,
    String? hint,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    Widget? suffix,
    bool floating = false,
    Color borderColor = Colors.black,
    Color bgColor = Colors.transparent,
    double borderRadius = 12.0,
    double borderWidth = .5,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.fromLTRB(20, 10, 20, 13),
  }) {
    assert(prefixText == null || icon == null, "Strings are equal So this message is been displayed!!");

    return InputDecoration(
      fillColor: bgColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor, width: borderWidth),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.red, width: 0.6),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.red, width: 0.6),
      ),
      errorStyle: GoogleFonts.montserrat(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: Colors.red,
      ),
      prefixIcon: (icon != null || prefixText != null)
          ? Builder(
              builder: (context) {
                if (icon != null) {
                  return icon;
                } else if (prefixText != null) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 10.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          prefixText,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          : null,
      suffixIcon: suffix,
      label: label != null
          ? Text(
              label,
              style:labelStyle!=null ? labelStyle: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textPrimary,
              ),
            )
          : null,
      hintText: hint,
      hintStyle: hintStyle ??
          GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
      floatingLabelBehavior: floating ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
      contentPadding: contentPadding,
    );
  }

  static InputDecoration dropdown(
    BuildContext context, {
    String? icon,
    String? label,
    bool filled = true,
    TextStyle? hintStyle,
    bool floating = false,
  }) {
    return InputDecoration(
      fillColor: Colors.white,
      filled: filled,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 0.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 0.4),
      ),
      prefixIcon: icon != null
          ? SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: CustomImage(
                  path: icon,
                  height: 16,
                  width: 16,
                ),
              ),
            )
          : null,
      label: label != null
          ? Text(
              label,
              // textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textPrimary,
              ),
            )
          : null,
      hintText: label,
      hintStyle: hintStyle ??
          GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
      floatingLabelBehavior: floating ? FloatingLabelBehavior.always : FloatingLabelBehavior.never,
      // contentPadding: const EdgeInsets.fromLTRB(12, 25, 12, 20),
    );
  }
}
