// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'دلّالة';

  @override
  String get appTagline => 'سوق كردفان في جيبك';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCategories => 'الأقسام';

  @override
  String get navChats => 'المحادثات';

  @override
  String get navProfile => 'حسابي';

  @override
  String get navAddAd => 'أضف إعلان';

  @override
  String get actionRetry => 'حاول تاني';

  @override
  String get actionTryAgain => 'حاول مرة تانية';

  @override
  String get actionNext => 'التالي';

  @override
  String get actionSkip => 'تخطّي';

  @override
  String get actionStart => 'يلّا نبدأ';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionConfirm => 'تأكيد';

  @override
  String get actionEdit => 'تعديل';

  @override
  String get actionClear => 'مسح';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionCall => 'اتصال';

  @override
  String get actionMessage => 'رسالة';

  @override
  String get actionWhatsapp => 'واتساب';

  @override
  String get actionReport => 'بلّغ';

  @override
  String get actionShare => 'شارك';

  @override
  String get actionFilters => 'الفلاتر';

  @override
  String get actionTopUp => 'اشحن';

  @override
  String get badgeFeatured => 'مميّز';

  @override
  String get badgeVerified => 'موثّق';

  @override
  String get badgePending => 'قيد المراجعة';

  @override
  String get badgeRejected => 'مرفوض';

  @override
  String get badgeSold => 'اتباع';

  @override
  String get badgePriceDropped => 'نزل السعر';

  @override
  String get badgeMostPopular => 'الأكثر طلباً';

  @override
  String get searchHint => 'ابحث عن عربية، خروف، بيت…';

  @override
  String get negotiable => 'قابل للتفاوض';

  @override
  String get stateOfflineBanner => 'أنت غير متصل بالإنترنت';

  @override
  String get stateOfflineTitle => 'الشبكة قاطعة شوية';

  @override
  String get stateOfflineBody =>
      'تقدر تتصفح الإعلانات المحفوظة والمفضلة لحدي ما يرجع الاتصال. مسوداتك محفوظة وبتترسل تلقائياً.';

  @override
  String get actionOpenFavorites => 'افتح المفضلة';

  @override
  String get stateErrorTitle => 'حصلت مشكلة';

  @override
  String get stateErrorBody => 'ما قدرنا نحمّل البيانات. حاول تاني بعد شوية.';

  @override
  String get stateEmptyTitle => 'مافي حاجة هنا لسه';

  @override
  String get stateEmptyBody => 'لمّا يكون في إعلانات جديدة حتظهر هنا.';

  @override
  String unreadCount(String count) {
    return '$count غير مقروءة';
  }

  @override
  String adsCount(String count) {
    return '$count إعلان';
  }

  @override
  String timeAgoHours(String count) {
    return 'قبل $count س';
  }

  @override
  String locationLine(String locality, String neighborhood) {
    return '$locality · $neighborhood';
  }

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'حسب الجهاز';

  @override
  String get phaseStubOnboarding => 'شاشات التعريف (المرحلة ٣)';

  @override
  String get phaseStubHome => 'الرئيسية (المرحلة ٤)';

  @override
  String get openComponentGallery => 'معرض المكوّنات';

  @override
  String get galleryTitle => 'معرض المكوّنات';

  @override
  String get gallerySectionColors => 'الألوان';

  @override
  String get gallerySectionTypography => 'الخطوط';

  @override
  String get gallerySectionButtons => 'الأزرار';

  @override
  String get gallerySectionInputs => 'حقول الإدخال';

  @override
  String get gallerySectionChips => 'الشرائح';

  @override
  String get gallerySectionBadges => 'الشارات';

  @override
  String get gallerySectionCards => 'البطاقات';

  @override
  String get gallerySectionCategories => 'الأقسام';

  @override
  String get gallerySectionListings => 'بطاقات الإعلانات';

  @override
  String get gallerySectionLists => 'القوائم';

  @override
  String get gallerySectionIcons => 'الأيقونات';

  @override
  String get gallerySectionSkeletons => 'التحميل';

  @override
  String get gallerySectionStates => 'الحالات';

  @override
  String get gallerySectionSheets => 'النوافذ السفلية';

  @override
  String get gallerySectionNav => 'شريط التنقل';

  @override
  String get galleryButtonPrimary => 'زر أساسي';

  @override
  String get galleryButtonSecondary => 'زر ثانوي';

  @override
  String get galleryButtonSoft => 'زر ناعم';

  @override
  String get galleryButtonDanger => 'تسجيل الخروج';

  @override
  String get galleryButtonSuccess => 'اتصل بالبائع';

  @override
  String get galleryButtonText => 'رابط نصي';

  @override
  String get galleryButtonLoading => 'جاري الإرسال';

  @override
  String get galleryButtonDisabled => 'غير متاح';

  @override
  String get galleryInputLabel => 'عنوان الإعلان';

  @override
  String get galleryInputHint => 'مثلاً: تويوتا هايلكس ٢٠١٨';

  @override
  String get galleryInputError => 'اكتب عنوان الإعلان';

  @override
  String get galleryInputPhoneLabel => 'رقم الموبايل';

  @override
  String get galleryChipLocality1 => 'الأبيض';

  @override
  String get galleryChipLocality2 => 'بارا';

  @override
  String get galleryChipLocality3 => 'أم روابة';

  @override
  String get galleryChipMake => 'الماركة';

  @override
  String get galleryChipYear => 'سنة الصنع';

  @override
  String get galleryChipAttr1 => '١٢٠ ألف كم';

  @override
  String get galleryChipAttr2 => 'عادي';

  @override
  String get galleryChipAttr3 => 'ديزل';

  @override
  String get galleryCardTitle => 'رصيدي';

  @override
  String get galleryCardBody =>
      'الرصيد للتمييز بس، ونشر الإعلانات العادية مجاني.';

  @override
  String get galleryCatCars => 'سيارات';

  @override
  String get galleryCatLivestock => 'مواشي';

  @override
  String get galleryCatRealEstate => 'عقارات';

  @override
  String get galleryListingTitle1 => 'تويوتا هايلكس ٢٠١٨ — دبل كابينة';

  @override
  String get galleryListingTitle2 => 'خروف حمري للأضحية';

  @override
  String get galleryListingLocality => 'الأبيض';

  @override
  String get galleryListingNeighborhood => 'القبة';

  @override
  String get galleryListPhone => 'رقم الهاتف والتوثيق';

  @override
  String get galleryListLocality => 'المحلية الافتراضية';

  @override
  String get galleryListDataSaver => 'توفير البيانات';

  @override
  String get galleryListDataSaverSub => 'صور أخف لمّا الشبكة ضعيفة';

  @override
  String get gallerySheetOpen => 'افتح النافذة السفلية';

  @override
  String get gallerySheetTitle => 'بلّغ عن الإعلان';

  @override
  String get gallerySheetBody => 'اختار سبب البلاغ وحنراجعه بسرعة.';

  @override
  String get galleryThemeToggle => 'بدّل الوضع';
}
