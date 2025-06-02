// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart'; // Pastikan path ini benar

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final TextStyle? titleTextStyle; // Parameter ini bersifat nullable
  final IconThemeData? iconTheme; // Parameter ini bersifat nullable
  final IconThemeData? actionsIconTheme; // Parameter ini bersifat nullable
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0.0,
    this.titleTextStyle,
    this.iconTheme,
    this.actionsIconTheme,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = theme.appBarTheme;

    // Menggunakan TextStyle dari parameter jika ada, jika tidak dari tema,
    // jika tidak ada juga, gunakan default text style dari Flutter.
    final TextStyle effectiveTitleTextStyle = titleTextStyle ??
        appBarTheme.titleTextStyle ??
        const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.headlineText, // Fallback color
            fontFamily: 'Montserrat' // Fallback font, pastikan konsisten
            );

    final IconThemeData effectiveIconTheme = iconTheme ??
        appBarTheme.iconTheme ??
        const IconThemeData(color: AppColors.iconColor); // Fallback icon theme

    final IconThemeData effectiveActionsIconTheme = actionsIconTheme ??
        appBarTheme.actionsIconTheme ??
        effectiveIconTheme; // Fallback ke icon theme utama jika actionsIconTheme tidak ada

    return AppBar(
      title: Text(
        this.title, // Menggunakan this.title untuk kejelasan
        style: effectiveTitleTextStyle,
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ??
          appBarTheme.backgroundColor ??
          AppColors.cardBackground,
      elevation: elevation,
      leading: leading,
      actions: actions,
      iconTheme: effectiveIconTheme,
      actionsIconTheme: effectiveActionsIconTheme,
      bottom: bottom,
    ).animate().fadeIn(duration: 400.ms);
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
