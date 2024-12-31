import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/more/presentation/manager/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_zoom/widget_zoom.dart';

class DoctorCertificates extends StatefulWidget {
  const DoctorCertificates({super.key});

  @override
  State<DoctorCertificates> createState() => _DoctorCertificatesState();
}

class _DoctorCertificatesState extends State<DoctorCertificates> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit, MoreState>(
      builder: (context, state) {
        if (state is FetchDoctorInfoLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColor.primaryBlue,
          ));
        } else if (state is FetchDoctorInfoLoaded) {
          if (state.doctorInfo.isEmpty) {
            return const Center(
                child: Text("لا توجد معلومات متاحة عن الطبيب حاليا"));
          }
          final doctor = state.doctorInfo.last;
          return Container(
            height: 650.h,
            color: AppColor.grey7,
            padding: const EdgeInsets.all(12.0),
            child: _buildImageGrid(doctor.images),
          );
        } else if (state is AddDoctorInfoFailure) {
          return Center(
              child: Text("Failed to load doctor info: ${state.error}"));
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }

  Widget _buildImageGrid(List<String> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.h,
        mainAxisSpacing: 8.h,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return WidgetZoom(
          heroAnimationTag: 'tag',
          zoomWidget: Image.network(
            images[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
