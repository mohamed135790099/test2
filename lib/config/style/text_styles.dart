import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  ///FontSize
  static final TextStyle _fontSize32 = TextStyle(fontSize: 32.sp);
  static final TextStyle _fontSize24 = TextStyle(fontSize: 24.sp);
  static final TextStyle _fontSize20 = TextStyle(fontSize: 20.sp);
  static final TextStyle _fontSize18 = TextStyle(fontSize: 18.sp);
  static final TextStyle _fontSize16 = TextStyle(fontSize: 16.sp);
  static final TextStyle _fontSize14 = TextStyle(fontSize: 14.sp);
  static final TextStyle _fontSize13 = TextStyle(fontSize: 13.sp);
  static final TextStyle _fontSize12 = TextStyle(fontSize: 12.sp);
  static final TextStyle _fontSize8 = TextStyle(fontSize: 8.sp);

  ///FontWeight
  static const TextStyle _fontWeight900 =
      TextStyle(fontWeight: FontWeight.w900);
  static const TextStyle _fontWeight700 =
      TextStyle(fontWeight: FontWeight.w700);
  static const TextStyle _fontWeight600 =
      TextStyle(fontWeight: FontWeight.w600);
  static const TextStyle _fontWeight500 =
      TextStyle(fontWeight: FontWeight.w500);
  static const TextStyle _fontWeight400 =
      TextStyle(fontWeight: FontWeight.w400);
  static const TextStyle _fontWeight300 =
      TextStyle(fontWeight: FontWeight.w300);

  ///Font Family
  static const TextStyle _fontDMSans =
      TextStyle(fontFamily: "DMSans", height: 1.5);

  ///FontStyle
  static TextStyle font20blue700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize20)
      .copyWith(color: AppColor.blue);
  static TextStyle font20red700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize20)
      .copyWith(color: AppColor.red);
  static TextStyle font24white700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize24)
      .copyWith(color: AppColor.white);
  static TextStyle font24black700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize24)
      .copyWith(color: AppColor.black);
  static TextStyle font20black900 = _fontDMSans
      .merge(_fontWeight900)
      .merge(_fontSize20)
      .copyWith(color: AppColor.black);
  static TextStyle font20blue400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize20)
      .copyWith(color: AppColor.blue);
  static TextStyle font20yellow400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize20)
      .copyWith(color: AppColor.yellow);
  static TextStyle font18primaryBlue400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize18)
      .copyWith(color: AppColor.primaryBlue);
  static TextStyle font18blue700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize18)
      .copyWith(color: AppColor.blue);
  static TextStyle font16primaryBlue600 = _fontDMSans
      .merge(_fontWeight600)
      .merge(_fontSize16)
      .copyWith(color: AppColor.primaryBlue);
  static TextStyle font18white700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize18)
      .copyWith(color: AppColor.white);
  static TextStyle font18black3700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize18)
      .copyWith(color: AppColor.black3);
  static TextStyle font18black700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize18)
      .copyWith(color: AppColor.black);
  static TextStyle font16white500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize16)
      .copyWith(color: AppColor.white);
  static TextStyle font16black700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize16)
      .copyWith(color: AppColor.black);
  static TextStyle font16black400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize16)
      .copyWith(color: AppColor.black);
  static TextStyle font16blue500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize16)
      .copyWith(color: AppColor.blue);
  static TextStyle font16black2400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize16)
      .copyWith(color: AppColor.black2);
  static TextStyle font16black3400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize16)
      .copyWith(color: AppColor.black3);
  static TextStyle font16white400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize16)
      .copyWith(color: AppColor.white);
  static TextStyle font16grey400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize16)
      .copyWith(color: AppColor.grey);

  static TextStyle font14black400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize14)
      .copyWith(color: AppColor.black);
  static TextStyle font14black3300 = _fontDMSans
      .merge(_fontWeight300)
      .merge(_fontSize14)
      .copyWith(color: AppColor.black3);

  static TextStyle font14blue400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize14)
      .copyWith(color: AppColor.blue);
  static TextStyle font14grey400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize14)
      .copyWith(color: AppColor.grey);
  static TextStyle font14primaryBlue500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize14)
      .copyWith(color: AppColor.primaryBlue);
  static TextStyle font14red500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize14)
      .copyWith(color: AppColor.red);
  static TextStyle font14black500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize14)
      .copyWith(color: AppColor.black);
  static TextStyle font14white400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize14)
      .copyWith(color: AppColor.white);
  static TextStyle font13grey500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize13)
      .copyWith(color: AppColor.grey);
  static TextStyle font13primaryBlue500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize13)
      .copyWith(color: AppColor.primaryBlue);
  static TextStyle font13black2500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize13)
      .copyWith(color: AppColor.black2);
  static TextStyle font13black700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize13)
      .copyWith(color: AppColor.black);
  static TextStyle font13white500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize13)
      .copyWith(color: AppColor.white);
  static TextStyle font13grey300 = _fontDMSans
      .merge(_fontWeight300)
      .merge(_fontSize13)
      .copyWith(color: AppColor.grey);
  static TextStyle font12grey400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize12)
      .copyWith(color: AppColor.grey);
  static TextStyle font12grey2400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize12)
      .copyWith(color: AppColor.grey2);
  static TextStyle font12primaryBlue400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize12)
      .copyWith(color: AppColor.primaryBlue);
  static TextStyle font12black400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize12)
      .copyWith(color: AppColor.black);
  static TextStyle font12grey5400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize12)
      .copyWith(color: AppColor.grey5);
  static TextStyle font12red500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize12)
      .copyWith(color: AppColor.red);
  static TextStyle font12grey3500 = _fontDMSans
      .merge(_fontWeight500)
      .merge(_fontSize12)
      .copyWith(color: AppColor.grey3);
  static TextStyle font12black700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize12)
      .copyWith(color: AppColor.black);
  static TextStyle font12white400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize12)
      .copyWith(color: AppColor.white);
  static TextStyle font8primaryBlue700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize8)
      .copyWith(color: AppColor.primaryBlue);
  static TextStyle font8black400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize8)
      .copyWith(color: AppColor.black);
  static TextStyle font8grey400 = _fontDMSans
      .merge(_fontWeight400)
      .merge(_fontSize8)
      .copyWith(color: AppColor.grey);
  static TextStyle font22primary700 = _fontDMSans
      .merge(_fontWeight700)
      .merge(_fontSize24)
      .copyWith(color: AppColor.primaryBlue);
}
