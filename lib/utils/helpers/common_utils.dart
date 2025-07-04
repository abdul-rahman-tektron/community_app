import 'package:community_app/utils/enums.dart';

mixin CommonUtils {

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String getLocalizedString({
    required String currentLang,
    required String? Function() getArabic,
    required String? Function() getEnglish,
    String fallback = 'Unknown',
  }) {
    if (currentLang == LanguageCode.ar.name) {
      return getArabic() ?? fallback;
    } else {
      return getEnglish() ?? fallback;
    }
  }
}