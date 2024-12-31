import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/screens/webview_screen.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_actions.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/pages/articles_screen.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/article/add_new_article.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_zoom/widget_zoom.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final String articleId;

  const ArticleDetailsScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    context.read<MoreCubit>().getOneArticle(articleId);

    return Scaffold(
      appBar: DefaultAppbarActions(
        title: AppStrings.article,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.edit_calendar_rounded),
          //   onPressed: () {
          //     _navigateToEditArticle(context);
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: AppColor.red),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          if (state is GetOneArticleLoading ||
              state is EditArticleLoading ||
              state is DeleteArticleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryBlue),
            );
          } else if (state is GetOneArticleSuccess) {
            return _buildArticleDetails(state, context);
          } else if (state is GetOneArticleError) {
            return _buildErrorState(state);
          } else {
            return const Center(child: Text('No article details available.'));
          }
        },
      ),
    );
  }

  void _navigateToEditArticle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewArticle(articleId: articleId),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final MoreCubit moreCubit = MoreCubit.get(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الاعلان'),
        content: const Text('هل انت متأكد من حذف هذا الاعلان ؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'إلغاء',
              style: AppTextStyle.font14red500,
            ),
          ),
          TextButton(
            onPressed: () {
              moreCubit.deleteArticle(articleId);
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArticlesScreen(),
                ),
              );
            },
            child: Text(
              'حذف',
              style: AppTextStyle.font14red500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleDetails(
      GetOneArticleSuccess state, BuildContext context) {
    final articleDetailsModel = state.articleDetailsModel;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      children: [
        articleDetailsModel.image != null &&
                articleDetailsModel.image!.isNotEmpty
            ? WidgetZoom(
                heroAnimationTag: 'tag',
                zoomWidget: AppImageView(
                  url: articleDetailsModel.image!,
                  height: 400.h,
                  width: MediaQuery.sizeOf(context).width,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                height: 440.h,
                width: 335.w,
                color: AppColor.grey,
                child: const Center(child: Text('No image available')),
              ),
        SizedBox(height: 12.h),
        Text(
          articleDetailsModel.title ?? 'No title available',
          style: AppTextStyle.font16black700,
        ),
        SizedBox(height: 8.h),
        Container(
          width: 335.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            articleDetailsModel.content ?? 'No content available',
            style: AppTextStyle.font14black500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: 335.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectionArea(
            child: GestureDetector(
              onTap: () {
                final url = articleDetailsModel.link ?? "";
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(url: url),
                  ),
                );
              },
              child: Text(
                articleDetailsModel.link ?? 'No content available',
                style: AppTextStyle.font14black500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(GetOneArticleError state) {
    return Center(
      child: Text(
        'Error: Unable to fetch article details. ${state.error}',
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
