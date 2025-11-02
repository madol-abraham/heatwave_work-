import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import 'app_logo.dart';

class HeatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showDrawer;
  const HeatAppBar({super.key, required this.title, this.actions, this.showDrawer = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLogo(size: 18),
          const SizedBox(width: 8),
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700, color: Colors.white)),
        ],
      ),
      actions: actions,
      leading: showDrawer ? Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ) : null,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
      ),
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
