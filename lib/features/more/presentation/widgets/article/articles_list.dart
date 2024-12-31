import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/search_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/more/data/models/article_model.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/article/articles_card.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticlesList extends StatefulWidget {
  const ArticlesList({super.key});

  @override
  State<ArticlesList> createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MoreCubit>().getAllArticle();
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      context.read<MoreCubit>().getAllArticle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(builder: (context, moreState) {
      return RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColor.primaryBlue,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.all(8.0),
                child: SearchFormField(
                  hintText: AppStrings.searchByArticleTitle,
                  searchController: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              BlocBuilder<MoreCubit, MoreState>(
                builder: (context, state) {
                  final List<ArticleModel> allArticles =
                      MoreCubit.get(context).allArticles;
                  final List<ArticleModel> filteredArticles =
                      allArticles.where((article) {
                    final String articleTitle =
                        article.title?.toLowerCase() ?? "";
                    final String searchTerm =
                        searchController.text.toLowerCase();
                    return articleTitle.contains(searchTerm);
                  }).toList();
                  return SizedBox(
                    height: 600.h,
                    child: ListView.separated(
                        padding: EdgeInsets.only(bottom: 30.h, top: 20.h),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ArticlesCard(
                              index: index,
                              allArticles: filteredArticles,
                            ),
                        separatorBuilder: (context, index) => 12.hs,
                        itemCount: filteredArticles.length),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
