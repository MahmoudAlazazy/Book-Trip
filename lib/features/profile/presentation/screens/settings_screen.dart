import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool location = true;

  @override
  Widget build(BuildContext context) => ProfilePageScaffold(
    title: context.tr('Settings'),
    child: Column(
      children: [
        _SettingTile(
          title: context.tr('Location Services'),
          value: location,
          onChanged: (value) => setState(() => location = value),
        ),
        _LanguageSetting(),
        _InfoSetting(title: context.tr('App Version'), value: '1.0.0'),
      ],
    ),
  );
}

class _LanguageSetting extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(localeProvider).languageCode;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        context.tr('Language'),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Text(
        languageNames[languageCode] ?? languageCode,
        style: const TextStyle(color: Colors.blueGrey),
      ),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final code in supportedLanguageCodes)
                ListTile(
                  title: Text(languageNames[code] ?? code),
                  trailing: languageCode == code
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await ref.read(localeProvider.notifier).setLanguage(code);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    activeThumbColor: AppColors.teal,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    value: value,
    onChanged: onChanged,
  );
}

class _InfoSetting extends StatelessWidget {
  const _InfoSetting({required this.title, required this.value});
  final String title, value;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    trailing: Text(value, style: const TextStyle(color: Colors.blueGrey)),
  );
}
