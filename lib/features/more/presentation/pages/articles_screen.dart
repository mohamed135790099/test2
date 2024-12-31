import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/articles_appbar.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/get_data_loading_widget.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/article/articles_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColor.primaryBlue,
      backgroundColor: AppColor.white,
      child: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          return Stack(
            children: [
              const Scaffold(
                appBar: ArticlesAppbar(),
                body: ArticlesList(),
              ),
              state is GetOneArticleLoading || state is GetAllArticlesLoading
                  ? const Center(child: GetDataLoadingWidget())
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }

  Future<void> onRefresh() async {
    await context.read<MoreCubit>().getAllArticle();
  }
}
