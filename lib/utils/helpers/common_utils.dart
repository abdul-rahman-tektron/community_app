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

  static JobStatusCategory jobStatusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'tracking':
        return JobStatusCategory.tracking;
      case 'inprogress':
      case 'in_progress':
      case 'in progress':
        return JobStatusCategory.inProgress;
      case 'completed':
        return JobStatusCategory.completed;
      default:
        return JobStatusCategory.unknown;
    }
  }
}