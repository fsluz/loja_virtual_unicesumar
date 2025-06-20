import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Obx(() => Card(
      child: ListTile(
        leading: Icon(
          themeController.getThemeModeIcon(themeController.themeMode),
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Tema do Aplicativo'),
        subtitle: Text(themeController.getThemeModeName(themeController.themeMode)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showThemeDialog(context, themeController),
      ),
    ));
  }

  void _showThemeDialog(BuildContext context, ThemeController themeController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolher Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                context,
                themeController,
                ThemeMode.light,
                'Claro',
                Icons.wb_sunny,
                'Usar tema claro',
              ),
              const SizedBox(height: 8),
              _buildThemeOption(
                context,
                themeController,
                ThemeMode.dark,
                'Escuro',
                Icons.nightlight_round,
                'Usar tema escuro',
              ),
              const SizedBox(height: 8),
              _buildThemeOption(
                context,
                themeController,
                ThemeMode.system,
                'Sistema',
                Icons.settings_system_daydream,
                'Seguir configuração do sistema',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeController themeController,
    ThemeMode mode,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = themeController.themeMode == mode;
    
    return InkWell(
      onTap: () {
        themeController.changeThemeMode(mode);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
            ? Border.all(color: Theme.of(context).colorScheme.primary)
            : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
} 