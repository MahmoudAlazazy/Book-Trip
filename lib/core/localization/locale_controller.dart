import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

const supportedLanguageCodes = <String>[
  'af',
  'sq',
  'ar',
  'be',
  'bn',
  'bg',
  'ca',
  'zh',
  'hr',
  'cs',
  'da',
  'nl',
  'en',
  'et',
  'fi',
  'fr',
  'de',
  'el',
  'he',
  'hi',
  'hu',
  'id',
  'it',
  'ja',
  'ko',
  'ms',
  'fa',
  'pl',
  'pt',
  'ro',
  'ru',
  'sk',
  'sl',
  'es',
  'sw',
  'sv',
  'ta',
  'te',
  'th',
  'tr',
  'uk',
  'ur',
  'vi',
  'cy',
];

// Build this once instead of allocating a new Locale list on every app build.
final supportedLocales = [
  for (final code in supportedLanguageCodes) Locale(code),
];

const languageNames = <String, String>{
  'af': 'Afrikaans',
  'sq': 'Albanian',
  'ar': 'العربية',
  'be': 'Belarusian',
  'bn': 'Bengali',
  'bg': 'Bulgarian',
  'ca': 'Catalan',
  'zh': 'Chinese',
  'hr': 'Croatian',
  'cs': 'Czech',
  'da': 'Danish',
  'nl': 'Dutch',
  'en': 'English',
  'et': 'Estonian',
  'fi': 'Finnish',
  'fr': 'French',
  'de': 'German',
  'el': 'Greek',
  'he': 'Hebrew',
  'hi': 'Hindi',
  'hu': 'Hungarian',
  'id': 'Indonesian',
  'it': 'Italian',
  'ja': 'Japanese',
  'ko': 'Korean',
  'ms': 'Malay',
  'fa': 'Persian',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sk': 'Slovak',
  'sl': 'Slovenian',
  'es': 'Spanish',
  'sw': 'Swahili',
  'sv': 'Swedish',
  'ta': 'Tamil',
  'te': 'Telugu',
  'th': 'Thai',
  'tr': 'Turkish',
  'uk': 'Ukrainian',
  'ur': 'Urdu',
  'vi': 'Vietnamese',
  'cy': 'Welsh',
};

final localeProvider = StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(),
);

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('en')) {
    _restore();
  }
  static const _preferenceKey = 'selected_language';
  bool _hasUserSelectedLanguage = false;

  Future<void> _restore() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(_preferenceKey);
    if (!_hasUserSelectedLanguage && supportedLanguageCodes.contains(code)) {
      state = Locale(code!);
    }
  }

  Future<void> setLanguage(String code) async {
    if (!supportedLanguageCodes.contains(code)) return;
    _hasUserSelectedLanguage = true;
    if (code != 'en') await _translateCatalogue(code);
    state = Locale(code);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_preferenceKey, code);
  }

  Future<void> _translateCatalogue(String code) async {
    TranslateLanguage? target;
    for (final language in TranslateLanguage.values) {
      if (language.bcpCode == code) target = language;
    }
    if (target == null) return;
    final modelManager = OnDeviceTranslatorModelManager();
    try {
      await modelManager.downloadModel(target.bcpCode, isWifiRequired: false);
    } catch (_) {
      return;
    }
    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: target,
    );
    try {
      final result = <String, String>{};
      for (final key in AppLocalizations.translationKeys) {
        result[key] = await translator.translateText(key);
      }
      AppLocalizations.setTranslations(code, result);
    } catch (_) {
      // ML Kit is mobile-only; unsupported platforms keep the English labels.
    } finally {
      await translator.close();
    }
  }
}
