import 'package:dr_mohamed_salah_admin/config/routes/app_routes.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/app_shadows.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/models/article_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticlesCard extends StatelessWidget {
  final int index;
  final List<ArticleModel> allArticles;

  const ArticlesCard({
    super.key,
    required this.index,
    required this.allArticles,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onCardTap(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        height: 60.h,
        width: 335.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppShadows.shadow2,
          color: AppColor.white,
        ),
        child: Row(
          children: [
            Text(
              allArticles[index].title ?? "No Title",
              style: AppTextStyle.font12black700,
            ),
            const Spacer(),
            AppImageView(
              svgPath: Assets.svgArrow,
              height: 12.h,
              width: 12.w,
              fit: BoxFit.scaleDown,
            ),
          ],
        ),
      ),
    );
  }

  void _onCardTap(BuildContext context) {
    final articleId = allArticles[index].sId ?? "";
    if (articleId.isNotEmpty) {
      MoreCubit.get(context).getOneArticle(articleId).then((value) {
        RouterApp.pushNamed(RouteName.articleDetailsScreen,
            arguments: articleId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article ID is invalid.')),
      );
    }
  }
}
