import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/article_details_form_field.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/article_name_form_field.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/link_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/widgets/article/uploadArticleImage.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewArticle extends StatefulWidget {
  final String? articleId;

  const AddNewArticle({super.key, this.articleId});

  @override
  State<AddNewArticle> createState() => _AddNewArticleState();
}

class _AddNewArticleState extends State<AddNewArticle> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController articleDetailsController =
      TextEditingController();
  final TextEditingController articleNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  String? articleImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.articleId != null) {
      final cubit = MoreCubit.get(context);
      cubit.getOneArticle(widget.articleId!).then((_) {
        final article = cubit.articleDetailsModel;
        if (article != null) {
          setState(() {
            linkController.text = article.link ?? '';
            articleDetailsController.text = article.content ?? '';
            articleNameController.text = article.title ?? '';
            articleImageUrl = article.image;
          });
        }
      });
    }
  }

  void _validateForm() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      isValid = isFormValid &&
          (MoreCubit.get(context).articleImage != null ||
              articleImageUrl != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        final MoreCubit moreCubit = MoreCubit.get(context);
        final isSubmitting =
            state is CreateArticlesLoading || state is EditArticleLoading;
        if (isSubmitting == true) {
          AppToaster.show("برجاء الإنتظار يتم تحميل الملف", duration: 4000);
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  onChanged: _validateForm,
                  key: _formKey,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: AppColor.white,
                    ),
                    child: ListView(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.articleId == null
                                  ? AppStrings.addNewArticle
                                  : 'Edit Article',
                              style: AppTextStyle.font18black700,
                            ),
                            16.hs,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                articleImageUrl != null
                                    ? Image.network(
                                        articleImageUrl!,
                                        height: 180.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 30.h,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Text('No Image Available'),
                                        ),
                                      ),
                                16.hs,
                                UploadArticleImage(
                                  height: 180.h,
                                  image: moreCubit.articleImage,
                                  title: AppStrings.uploadFileOfArticle,
                                  onPressed: () {
                                    if (moreCubit.articleImage != null) {
                                      moreCubit.removeArticleImage();
                                    }
                                    moreCubit.getArticleImage(context);
                                  },
                                  onPressedRemove: () {
                                    moreCubit.removeArticleImage();
                                    _validateForm();
                                  },
                                ),
                                16.hs,
                                ArticleNameFormField(
                                    articleNameController:
                                        articleNameController),
                                16.hs,
                                ArticleDetailsFormField(
                                    articleDetailsController:
                                        articleDetailsController),
                                16.hs,
                                LinkFormField(linkController: linkController),
                              ],
                            ).withHorizontalPadding(16),
                            22.hs,
                            AppButton3(
                              isValid: isValid && !isSubmitting,
                              title: widget.articleId == null
                                  ? AppStrings.add
                                  : 'Update',
                              onPressed: () async {
                                if (widget.articleId == null) {
                                  moreCubit.createArticle(
                                    linkController.text.isEmpty
                                        ? null
                                        : linkController.text,
                                    articleDetailsController.text,
                                    articleNameController.text,
                                  );
                                  moreCubit.removeArticleImage();
                                  Navigator.pop(context);
                                } else {
                                  await moreCubit
                                      .editArticle(
                                    widget.articleId ?? "",
                                    linkController.text.isEmpty
                                        ? "www.safehandappps.com"
                                        : linkController.text,
                                    articleDetailsController.text,
                                    articleNameController.text,
                                  )
                                      .then((value) {
                                    moreCubit.getOneArticle(widget.articleId!);
                                    Navigator.pop(context);
                                    moreCubit.removeArticleImage();
                                  }).catchError((error) {
                                    print("Error editing article: $error");
                                  });
                                  Navigator.pop(context);
                                }
                              },
                            )
                          ],
                        ).withVerticalPadding(20),
                      ],
                    ),
                  ),
                ),
              ),
              if (isSubmitting)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
