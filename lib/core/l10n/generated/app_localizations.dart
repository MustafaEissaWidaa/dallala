import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar')];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'دلّالة'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In ar, this message translates to:
  /// **'سوق كردفان في جيبك'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navCategories.
  ///
  /// In ar, this message translates to:
  /// **'الأقسام'**
  String get navCategories;

  /// No description provided for @navChats.
  ///
  /// In ar, this message translates to:
  /// **'المحادثات'**
  String get navChats;

  /// No description provided for @navProfile.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navProfile;

  /// No description provided for @navAddAd.
  ///
  /// In ar, this message translates to:
  /// **'أضف إعلان'**
  String get navAddAd;

  /// No description provided for @actionRetry.
  ///
  /// In ar, this message translates to:
  /// **'حاول تاني'**
  String get actionRetry;

  /// No description provided for @actionTryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة تانية'**
  String get actionTryAgain;

  /// No description provided for @actionNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get actionNext;

  /// No description provided for @actionSkip.
  ///
  /// In ar, this message translates to:
  /// **'تخطّي'**
  String get actionSkip;

  /// No description provided for @actionStart.
  ///
  /// In ar, this message translates to:
  /// **'يلّا نبدأ'**
  String get actionStart;

  /// No description provided for @actionCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get actionConfirm;

  /// No description provided for @actionEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get actionEdit;

  /// No description provided for @actionClear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get actionClear;

  /// No description provided for @actionBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get actionBack;

  /// No description provided for @actionCall.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get actionCall;

  /// No description provided for @actionMessage.
  ///
  /// In ar, this message translates to:
  /// **'رسالة'**
  String get actionMessage;

  /// No description provided for @actionWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'واتساب'**
  String get actionWhatsapp;

  /// No description provided for @actionReport.
  ///
  /// In ar, this message translates to:
  /// **'بلّغ'**
  String get actionReport;

  /// No description provided for @actionShare.
  ///
  /// In ar, this message translates to:
  /// **'شارك'**
  String get actionShare;

  /// No description provided for @actionFilters.
  ///
  /// In ar, this message translates to:
  /// **'الفلاتر'**
  String get actionFilters;

  /// No description provided for @actionTopUp.
  ///
  /// In ar, this message translates to:
  /// **'اشحن'**
  String get actionTopUp;

  /// No description provided for @badgeFeatured.
  ///
  /// In ar, this message translates to:
  /// **'مميّز'**
  String get badgeFeatured;

  /// No description provided for @badgeVerified.
  ///
  /// In ar, this message translates to:
  /// **'موثّق'**
  String get badgeVerified;

  /// No description provided for @badgePending.
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get badgePending;

  /// No description provided for @badgeRejected.
  ///
  /// In ar, this message translates to:
  /// **'مرفوض'**
  String get badgeRejected;

  /// No description provided for @badgeSold.
  ///
  /// In ar, this message translates to:
  /// **'اتباع'**
  String get badgeSold;

  /// No description provided for @badgePriceDropped.
  ///
  /// In ar, this message translates to:
  /// **'نزل السعر'**
  String get badgePriceDropped;

  /// No description provided for @badgeMostPopular.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر طلباً'**
  String get badgeMostPopular;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن عربية، خروف، بيت…'**
  String get searchHint;

  /// No description provided for @negotiable.
  ///
  /// In ar, this message translates to:
  /// **'قابل للتفاوض'**
  String get negotiable;

  /// No description provided for @stateOfflineBanner.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل بالإنترنت'**
  String get stateOfflineBanner;

  /// No description provided for @stateOfflineTitle.
  ///
  /// In ar, this message translates to:
  /// **'الشبكة قاطعة شوية'**
  String get stateOfflineTitle;

  /// No description provided for @stateOfflineBody.
  ///
  /// In ar, this message translates to:
  /// **'تقدر تتصفح الإعلانات المحفوظة والمفضلة لحدي ما يرجع الاتصال. مسوداتك محفوظة وبتترسل تلقائياً.'**
  String get stateOfflineBody;

  /// No description provided for @actionOpenFavorites.
  ///
  /// In ar, this message translates to:
  /// **'افتح المفضلة'**
  String get actionOpenFavorites;

  /// No description provided for @stateErrorTitle.
  ///
  /// In ar, this message translates to:
  /// **'حصلت مشكلة'**
  String get stateErrorTitle;

  /// No description provided for @stateErrorBody.
  ///
  /// In ar, this message translates to:
  /// **'ما قدرنا نحمّل البيانات. حاول تاني بعد شوية.'**
  String get stateErrorBody;

  /// No description provided for @stateEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'مافي حاجة هنا لسه'**
  String get stateEmptyTitle;

  /// No description provided for @stateEmptyBody.
  ///
  /// In ar, this message translates to:
  /// **'لمّا يكون في إعلانات جديدة حتظهر هنا.'**
  String get stateEmptyBody;

  /// No description provided for @unreadCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} غير مقروءة'**
  String unreadCount(String count);

  /// No description provided for @adsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} إعلان'**
  String adsCount(String count);

  /// No description provided for @timeAgoHours.
  ///
  /// In ar, this message translates to:
  /// **'قبل {count} س'**
  String timeAgoHours(String count);

  /// No description provided for @locationLine.
  ///
  /// In ar, this message translates to:
  /// **'{locality} · {neighborhood}'**
  String locationLine(String locality, String neighborhood);

  /// No description provided for @themeLight.
  ///
  /// In ar, this message translates to:
  /// **'فاتح'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In ar, this message translates to:
  /// **'داكن'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In ar, this message translates to:
  /// **'حسب الجهاز'**
  String get themeSystem;

  /// No description provided for @phaseStubOnboarding.
  ///
  /// In ar, this message translates to:
  /// **'شاشات التعريف (المرحلة ٣)'**
  String get phaseStubOnboarding;

  /// No description provided for @phaseStubHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية (المرحلة ٤)'**
  String get phaseStubHome;

  /// No description provided for @openComponentGallery.
  ///
  /// In ar, this message translates to:
  /// **'معرض المكوّنات'**
  String get openComponentGallery;

  /// No description provided for @galleryTitle.
  ///
  /// In ar, this message translates to:
  /// **'معرض المكوّنات'**
  String get galleryTitle;

  /// No description provided for @gallerySectionColors.
  ///
  /// In ar, this message translates to:
  /// **'الألوان'**
  String get gallerySectionColors;

  /// No description provided for @gallerySectionTypography.
  ///
  /// In ar, this message translates to:
  /// **'الخطوط'**
  String get gallerySectionTypography;

  /// No description provided for @gallerySectionButtons.
  ///
  /// In ar, this message translates to:
  /// **'الأزرار'**
  String get gallerySectionButtons;

  /// No description provided for @gallerySectionInputs.
  ///
  /// In ar, this message translates to:
  /// **'حقول الإدخال'**
  String get gallerySectionInputs;

  /// No description provided for @gallerySectionChips.
  ///
  /// In ar, this message translates to:
  /// **'الشرائح'**
  String get gallerySectionChips;

  /// No description provided for @gallerySectionBadges.
  ///
  /// In ar, this message translates to:
  /// **'الشارات'**
  String get gallerySectionBadges;

  /// No description provided for @gallerySectionCards.
  ///
  /// In ar, this message translates to:
  /// **'البطاقات'**
  String get gallerySectionCards;

  /// No description provided for @gallerySectionCategories.
  ///
  /// In ar, this message translates to:
  /// **'الأقسام'**
  String get gallerySectionCategories;

  /// No description provided for @gallerySectionListings.
  ///
  /// In ar, this message translates to:
  /// **'بطاقات الإعلانات'**
  String get gallerySectionListings;

  /// No description provided for @gallerySectionLists.
  ///
  /// In ar, this message translates to:
  /// **'القوائم'**
  String get gallerySectionLists;

  /// No description provided for @gallerySectionIcons.
  ///
  /// In ar, this message translates to:
  /// **'الأيقونات'**
  String get gallerySectionIcons;

  /// No description provided for @gallerySectionSkeletons.
  ///
  /// In ar, this message translates to:
  /// **'التحميل'**
  String get gallerySectionSkeletons;

  /// No description provided for @gallerySectionStates.
  ///
  /// In ar, this message translates to:
  /// **'الحالات'**
  String get gallerySectionStates;

  /// No description provided for @gallerySectionSheets.
  ///
  /// In ar, this message translates to:
  /// **'النوافذ السفلية'**
  String get gallerySectionSheets;

  /// No description provided for @gallerySectionNav.
  ///
  /// In ar, this message translates to:
  /// **'شريط التنقل'**
  String get gallerySectionNav;

  /// No description provided for @galleryButtonPrimary.
  ///
  /// In ar, this message translates to:
  /// **'زر أساسي'**
  String get galleryButtonPrimary;

  /// No description provided for @galleryButtonSecondary.
  ///
  /// In ar, this message translates to:
  /// **'زر ثانوي'**
  String get galleryButtonSecondary;

  /// No description provided for @galleryButtonSoft.
  ///
  /// In ar, this message translates to:
  /// **'زر ناعم'**
  String get galleryButtonSoft;

  /// No description provided for @galleryButtonDanger.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get galleryButtonDanger;

  /// No description provided for @galleryButtonSuccess.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بالبائع'**
  String get galleryButtonSuccess;

  /// No description provided for @galleryButtonText.
  ///
  /// In ar, this message translates to:
  /// **'رابط نصي'**
  String get galleryButtonText;

  /// No description provided for @galleryButtonLoading.
  ///
  /// In ar, this message translates to:
  /// **'جاري الإرسال'**
  String get galleryButtonLoading;

  /// No description provided for @galleryButtonDisabled.
  ///
  /// In ar, this message translates to:
  /// **'غير متاح'**
  String get galleryButtonDisabled;

  /// No description provided for @galleryInputLabel.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الإعلان'**
  String get galleryInputLabel;

  /// No description provided for @galleryInputHint.
  ///
  /// In ar, this message translates to:
  /// **'مثلاً: تويوتا هايلكس ٢٠١٨'**
  String get galleryInputHint;

  /// No description provided for @galleryInputError.
  ///
  /// In ar, this message translates to:
  /// **'اكتب عنوان الإعلان'**
  String get galleryInputError;

  /// No description provided for @galleryInputPhoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الموبايل'**
  String get galleryInputPhoneLabel;

  /// No description provided for @galleryChipLocality1.
  ///
  /// In ar, this message translates to:
  /// **'الأبيض'**
  String get galleryChipLocality1;

  /// No description provided for @galleryChipLocality2.
  ///
  /// In ar, this message translates to:
  /// **'بارا'**
  String get galleryChipLocality2;

  /// No description provided for @galleryChipLocality3.
  ///
  /// In ar, this message translates to:
  /// **'أم روابة'**
  String get galleryChipLocality3;

  /// No description provided for @galleryChipMake.
  ///
  /// In ar, this message translates to:
  /// **'الماركة'**
  String get galleryChipMake;

  /// No description provided for @galleryChipYear.
  ///
  /// In ar, this message translates to:
  /// **'سنة الصنع'**
  String get galleryChipYear;

  /// No description provided for @galleryChipAttr1.
  ///
  /// In ar, this message translates to:
  /// **'١٢٠ ألف كم'**
  String get galleryChipAttr1;

  /// No description provided for @galleryChipAttr2.
  ///
  /// In ar, this message translates to:
  /// **'عادي'**
  String get galleryChipAttr2;

  /// No description provided for @galleryChipAttr3.
  ///
  /// In ar, this message translates to:
  /// **'ديزل'**
  String get galleryChipAttr3;

  /// No description provided for @galleryCardTitle.
  ///
  /// In ar, this message translates to:
  /// **'رصيدي'**
  String get galleryCardTitle;

  /// No description provided for @galleryCardBody.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد للتمييز بس، ونشر الإعلانات العادية مجاني.'**
  String get galleryCardBody;

  /// No description provided for @galleryCatCars.
  ///
  /// In ar, this message translates to:
  /// **'سيارات'**
  String get galleryCatCars;

  /// No description provided for @galleryCatLivestock.
  ///
  /// In ar, this message translates to:
  /// **'مواشي'**
  String get galleryCatLivestock;

  /// No description provided for @galleryCatRealEstate.
  ///
  /// In ar, this message translates to:
  /// **'عقارات'**
  String get galleryCatRealEstate;

  /// No description provided for @galleryListingTitle1.
  ///
  /// In ar, this message translates to:
  /// **'تويوتا هايلكس ٢٠١٨ — دبل كابينة'**
  String get galleryListingTitle1;

  /// No description provided for @galleryListingTitle2.
  ///
  /// In ar, this message translates to:
  /// **'خروف حمري للأضحية'**
  String get galleryListingTitle2;

  /// No description provided for @galleryListingLocality.
  ///
  /// In ar, this message translates to:
  /// **'الأبيض'**
  String get galleryListingLocality;

  /// No description provided for @galleryListingNeighborhood.
  ///
  /// In ar, this message translates to:
  /// **'القبة'**
  String get galleryListingNeighborhood;

  /// No description provided for @galleryListPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف والتوثيق'**
  String get galleryListPhone;

  /// No description provided for @galleryListLocality.
  ///
  /// In ar, this message translates to:
  /// **'المحلية الافتراضية'**
  String get galleryListLocality;

  /// No description provided for @galleryListDataSaver.
  ///
  /// In ar, this message translates to:
  /// **'توفير البيانات'**
  String get galleryListDataSaver;

  /// No description provided for @galleryListDataSaverSub.
  ///
  /// In ar, this message translates to:
  /// **'صور أخف لمّا الشبكة ضعيفة'**
  String get galleryListDataSaverSub;

  /// No description provided for @gallerySheetOpen.
  ///
  /// In ar, this message translates to:
  /// **'افتح النافذة السفلية'**
  String get gallerySheetOpen;

  /// No description provided for @gallerySheetTitle.
  ///
  /// In ar, this message translates to:
  /// **'بلّغ عن الإعلان'**
  String get gallerySheetTitle;

  /// No description provided for @gallerySheetBody.
  ///
  /// In ar, this message translates to:
  /// **'اختار سبب البلاغ وحنراجعه بسرعة.'**
  String get gallerySheetBody;

  /// No description provided for @galleryThemeToggle.
  ///
  /// In ar, this message translates to:
  /// **'بدّل الوضع'**
  String get galleryThemeToggle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
