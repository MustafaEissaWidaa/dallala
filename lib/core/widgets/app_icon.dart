import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Names of the outline icons in `assets/03-Icons/svg` (1.75 stroke, 24 grid).
enum AppIcons {
  adminDashboard('admin-dashboard'),
  arrowBack('arrow-back', directional: true),
  arrowDown('arrow-down'),
  backspace('backspace', directional: true),
  bankCard('bank-card'),
  bell('bell'),
  call('call'),
  camera('camera'),
  car('car'),
  chat('chat'),
  checkCircle('check-circle'),
  check('check'),
  chevronDown('chevron-down'),
  chevronForward('chevron-forward', directional: true),
  clock('clock'),
  close('close'),
  crops('crops'),
  dataSaver('data-saver'),
  document('document'),
  download('download'),
  edit('edit'),
  electronics('electronics'),
  filter('filter'),
  furniture('furniture'),
  heartFilled('heart-filled'),
  info('info'),
  jobs('jobs'),
  list('list'),
  livestock('livestock'),
  locationOutline('location-outline'),
  location('location'),
  logout('logout', directional: true),
  mobileCredit('mobile-credit'),
  navCategories('nav-categories'),
  navHome('nav-home'),
  plus('plus'),
  priceDrop('price-drop'),
  realEstate('real-estate'),
  refresh('refresh'),
  reportFlag('report-flag'),
  rickshaw('rickshaw'),
  search('search'),
  send('send', directional: true),
  services('services'),
  settings('settings'),
  share('share'),
  shieldAlert('shield-alert'),
  shieldCheck('shield-check'),
  shield('shield'),
  smsPhone('sms-phone'),
  starFilled('star-filled'),
  tire('tire'),
  user('user'),
  users('users'),
  verifiedBadgeLight('verified-badge-light', multicolor: true),
  verifiedBadge('verified-badge', multicolor: true),
  viewsEye('views-eye'),
  whatsapp('whatsapp');

  const AppIcons(this.file, {this.directional = false, this.multicolor = false});

  final String file;

  /// The SVGs are drawn for RTL; directional ones are mirrored under LTR.
  final bool directional;

  /// Multicolour icons keep their own colours and are never tinted.
  final bool multicolor;

  String get asset => 'assets/03-Icons/svg/$file.svg';
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.icon, {super.key, this.size = AppSizes.icon, this.color});

  final AppIcons icon;
  final double size;

  /// Defaults to the ambient [IconTheme] colour (ink).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? IconTheme.of(context).color ?? context.colors.ink;
    Widget svg = SvgPicture.asset(
      icon.asset,
      width: size,
      height: size,
      colorFilter:
          icon.multicolor ? null : ColorFilter.mode(tint, BlendMode.srcIn),
    );
    if (icon.directional &&
        Directionality.of(context) == TextDirection.ltr) {
      svg = Transform.flip(flipX: true, child: svg);
    }
    return ExcludeSemantics(child: svg);
  }
}
