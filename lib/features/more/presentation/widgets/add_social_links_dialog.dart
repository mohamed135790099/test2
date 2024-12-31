import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/buttons/button_3.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/text_field.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:dr_mohamed_salah_admin/utils/helpers/validation_form.dart';
import 'package:flutter/material.dart';

class AddSocialLinksBottomSheet extends StatefulWidget {
  final Function(
      String facebook, String instagram, String twitter, String youtube) onSave;

  const AddSocialLinksBottomSheet({super.key, required this.onSave});

  @override
  _AddSocialLinksBottomSheetState createState() =>
      _AddSocialLinksBottomSheetState();
}

class _AddSocialLinksBottomSheetState extends State<AddSocialLinksBottomSheet> {
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController youtubeController = TextEditingController();

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update isValid state when text changes
    facebookController.addListener(_checkFormValidity);
    instagramController.addListener(_checkFormValidity);
    twitterController.addListener(_checkFormValidity);
    youtubeController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isValid = facebookController.text.isNotEmpty ||
          instagramController.text.isNotEmpty ||
          twitterController.text.isNotEmpty ||
          youtubeController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    facebookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: AppColor.white,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
                child: Text('إضافة مواقع التواصل الإجتماعي',
                    style: AppTextStyle.font18black700)),
            30.hs,
            AppTextField(
              labelText: 'Facebook',
              hintText: 'Enter Facebook URL',
              controller: facebookController,
              validator: ValidationForm.websiteValidator,
            ),
            20.hs,
            AppTextField(
              labelText: 'Instagram',
              hintText: 'Enter Instagram URL',
              controller: instagramController,
              validator: ValidationForm.websiteValidator,
            ),
            20.hs,
            AppTextField(
              labelText: 'Twitter',
              hintText: 'Enter Twitter URL',
              controller: twitterController,
              validator: ValidationForm.websiteValidator,
            ),
            20.hs,
            AppTextField(
              labelText: 'YouTube',
              hintText: 'Enter YouTube URL',
              controller: youtubeController,
              validator: ValidationForm.websiteValidator,
            ),
            42.hs,
            AppButton3(
              title: 'إضافة',
              isValid: isValid, // Use the state variable
              onPressed: isValid
                  ? () {
                      widget.onSave(
                        facebookController.text,
                        instagramController.text,
                        twitterController.text,
                        youtubeController.text,
                      );
                      Navigator.of(context).pop();
                    }
                  : null, // Disable button if not valid
            )
          ],
        ),
      ),
    );
  }
}
