import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/get_data_loading_widget.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/admin_name_form_field.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/password_form_field.dart';
import 'package:dr_mohamed_salah_admin/features/auth/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/auth/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/app_utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        final AuthCubit authCubit = AuthCubit.get(context);
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.docBack),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  AppStrings.login,
                  style: AppTextStyle.font22primary700,
                ),
              ),
              body: Form(
                  onChanged: () {
                    isValid = _formKey.currentState?.validate() ?? false;
                    setState(() {});
                  },
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.symmetric(
                            horizontal: 20.w, vertical: 30.h),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "إبدأ الان بتسجيل دخولك ",
                            style: AppTextStyle.font22primary700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsetsDirectional.all(10.h),
                            margin: EdgeInsetsDirectional.all(10.h),
                            decoration: BoxDecoration(
                                color: AppColor.blueTransparent,
                                borderRadius: BorderRadius.circular(12)),
                            width: 225.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 250.w,
                                  child: AdminNameFormField(
                                      nameController: nameController),
                                ),
                                SizedBox(height: 16.h),
                                SizedBox(
                                    width: 250.w,
                                    child: PasswordFormField(
                                        controller: passwordController)),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 40.h),
                          child: AppButton3(
                            isValid: isValid,
                            title: AppStrings.login,
                            onPressed: () async {
                              final isSignedIn = await authCubit.signInAdmin(
                                nameController.text.toLowerCase(),
                                passwordController.text,
                              );

                              if (isSignedIn) {
                                // await ReservationCubit.get(context).getAllReservations();
                                await ReservationCubit.get(context).getAllUsers();
                                AppCubit.get(context).currentIndex == 5;
                              }
                            },
                          )),
                    ],
                  )),
            ),
            if (state is SignInLoading) const GetDataLoadingWidget(),
          ],
        );
      },
    );
  }
}
