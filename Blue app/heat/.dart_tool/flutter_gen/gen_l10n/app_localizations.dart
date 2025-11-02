import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Harara - Heatwave Prediction'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to Harara'**
  String get signInToContinue;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinHarara.
  ///
  /// In en, this message translates to:
  /// **'Join Harara for personalized heat alerts'**
  String get joinHarara;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @selectTown.
  ///
  /// In en, this message translates to:
  /// **'Select Town'**
  String get selectTown;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get alreadyHaveAccount;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get nameRequired;

  /// No description provided for @validEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Valid email required'**
  String get validEmailRequired;

  /// No description provided for @validPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Valid phone required'**
  String get validPhoneRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @pleaseSelectTown.
  ///
  /// In en, this message translates to:
  /// **'Please select your town'**
  String get pleaseSelectTown;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @climateMonitor.
  ///
  /// In en, this message translates to:
  /// **'Climate Monitor'**
  String get climateMonitor;

  /// No description provided for @livePredictionSystem.
  ///
  /// In en, this message translates to:
  /// **'Live Prediction System'**
  String get livePredictionSystem;

  /// No description provided for @forecastPeriod.
  ///
  /// In en, this message translates to:
  /// **'Forecast Period'**
  String get forecastPeriod;

  /// No description provided for @activeAlerts.
  ///
  /// In en, this message translates to:
  /// **'Active Alerts'**
  String get activeAlerts;

  /// No description provided for @alertThreshold.
  ///
  /// In en, this message translates to:
  /// **'Alert Threshold'**
  String get alertThreshold;

  /// No description provided for @regionalRiskAssessment.
  ///
  /// In en, this message translates to:
  /// **'Regional Risk Assessment'**
  String get regionalRiskAssessment;

  /// No description provided for @runPrediction.
  ///
  /// In en, this message translates to:
  /// **'Run Prediction'**
  String get runPrediction;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running...'**
  String get running;

  /// No description provided for @testNotifications.
  ///
  /// In en, this message translates to:
  /// **'Test Notifications'**
  String get testNotifications;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @extremeRisk.
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get extremeRisk;

  /// No description provided for @highRisk.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highRisk;

  /// No description provided for @moderateRisk.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateRisk;

  /// No description provided for @lowRisk.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowRisk;

  /// No description provided for @riskLevel.
  ///
  /// In en, this message translates to:
  /// **'Risk Level'**
  String get riskLevel;

  /// No description provided for @heatwaveRiskElevated.
  ///
  /// In en, this message translates to:
  /// **'Heatwave risk elevated — take precautions'**
  String get heatwaveRiskElevated;

  /// No description provided for @normalConditionsExpected.
  ///
  /// In en, this message translates to:
  /// **'Normal conditions expected'**
  String get normalConditionsExpected;

  /// No description provided for @noPredictionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Predictions Available'**
  String get noPredictionsAvailable;

  /// No description provided for @runNewPrediction.
  ///
  /// In en, this message translates to:
  /// **'Run a new prediction to see heatwave forecasts'**
  String get runNewPrediction;

  /// No description provided for @predictionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Prediction completed successfully!'**
  String get predictionCompleted;

  /// No description provided for @failedToRunPrediction.
  ///
  /// In en, this message translates to:
  /// **'Failed to run prediction'**
  String get failedToRunPrediction;

  /// No description provided for @manualAlert.
  ///
  /// In en, this message translates to:
  /// **'MANUAL ALERT'**
  String get manualAlert;

  /// No description provided for @hararaHeatwaveAlert.
  ///
  /// In en, this message translates to:
  /// **'HARARA HEATWAVE ALERT'**
  String get hararaHeatwaveAlert;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @jubaArabic.
  ///
  /// In en, this message translates to:
  /// **'Juba Arabic'**
  String get jubaArabic;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
