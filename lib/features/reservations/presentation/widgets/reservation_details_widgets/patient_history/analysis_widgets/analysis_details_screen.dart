import 'dart:io';

import 'package:dr_mohamed_salah_admin/config/style/app_color.dart';
import 'package:dr_mohamed_salah_admin/config/style/text_styles.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/appbars/default_appbar_actions.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_image_view.dart';
import 'package:dr_mohamed_salah_admin/core/widgets/components/app_toaster.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/data/models/get_one_analysis.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/cubit.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/manager/state.dart';
import 'package:dr_mohamed_salah_admin/features/reservations/presentation/widgets/reservation_details_widgets/patient_history/analysis_widgets/add_new_analysis.dart';
import 'package:dr_mohamed_salah_admin/generated/assets.dart';
import 'package:dr_mohamed_salah_admin/utils/extentions/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:widget_zoom/widget_zoom.dart';

class AnalysisDetailsScreen extends StatefulWidget {
  final String analysisId;

  const AnalysisDetailsScreen({super.key, required this.analysisId});

  @override
  State<AnalysisDetailsScreen> createState() => _AnalysisDetailsScreenState();
}

class _AnalysisDetailsScreenState extends State<AnalysisDetailsScreen> {
  int _currentPage = 0;
  int _totalPages = 0;
  late PDFViewController _pdfViewController;

  Future<String> downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void _onPageChanged(int page, int total) {
    setState(() {
      _currentPage = page;
      _totalPages = total;
    });
  }

  void _nextPage() {
    if (_currentPage > 0) {
      _pdfViewController.setPage(_currentPage - 1);
    }
  }

  void _previousPage() {
    if (_currentPage < _totalPages - 1) {
      _pdfViewController.setPage(_currentPage + 1);
    }
  }

  void _navigateToEditAnalysis(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddNewAnalysis(analysisId: widget.analysisId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<ReservationCubit>().getOneAnalysis(widget.analysisId);

    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        final GetOneAnalysis? getOneAnalysis =
            ReservationCubit.get(context).getUserAnalysis;
        if (state is DeleteAnalysisSuccess) {
          AppToaster.show("تم الحذف بنجاح");
        }
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColor.white,
              appBar: DefaultAppbarActions(
                title: "Analysis Details",
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_calendar_rounded),
                    onPressed: () {
                      _navigateToEditAnalysis(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: AppColor.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                ],
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                children: [
                  if (getOneAnalysis?.image != null &&
                      (getOneAnalysis?.image?.isNotEmpty ?? false))
                    Column(
                      children: getOneAnalysis!.image!.map((imageUrl) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: WidgetZoom(
                            heroAnimationTag: 'tag',
                            zoomWidget: AppImageView(
                              url: imageUrl,
                              height: 175.h,
                              width: 300.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Center(
                      child: Text(
                        'لا توجد صور متاحة',
                        style: AppTextStyle.font14black500,
                      ),
                    ),
                  12.hs,
                  if (getOneAnalysis?.pdfUrl != null &&
                      getOneAnalysis!.pdfUrl!.isNotEmpty)
                    FutureBuilder<String>(
                      future: downloadPdf(getOneAnalysis!.pdfUrl!.first),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColor.primaryBlue, width: 2),
                                ),
                                padding: const EdgeInsetsDirectional.all(12),
                                height: 420.h,
                                child: PDFView(
                                  filePath: snapshot.data,
                                  enableSwipe: true,
                                  swipeHorizontal: true,
                                  autoSpacing: false,
                                  pageSnap: true,
                                  preventLinkNavigation: true,
                                  onPageChanged: (int? page, int? total) {
                                    _onPageChanged(page ?? 0, total ?? 0);
                                  },
                                  onViewCreated:
                                      (PDFViewController pdfViewController) {
                                    _pdfViewController = pdfViewController;
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: _previousPage,
                                    color: AppColor.primaryBlue,
                                  ),
                                  Text(
                                    'Page ${_currentPage + 1} of $_totalPages',
                                    style: AppTextStyle.font14black500,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward),
                                    onPressed: _nextPage,
                                    color: AppColor.primaryBlue,
                                  ),
                                ],
                              )
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Failed to load PDF',
                              style: AppTextStyle.font14black500,
                            ),
                          );
                        }
                      },
                    )
                  else
                    Center(
                      child: Text(
                        'لا توجد ملفات متاحة',
                        style: AppTextStyle.font14black500,
                      ),
                    ),
                  12.hs,
                  Row(
                    children: [
                      AppImageView(
                        svgPath: Assets.svgPen,
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.scaleDown,
                      ),
                      10.ws,
                      Text(
                        'Title',
                        style: AppTextStyle.font14black500,
                      ),
                    ],
                  ),
                  12.hs,
                  Container(
                    width: 335.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      getOneAnalysis?.title ?? 'No Title available',
                      style: AppTextStyle.font14black500,
                    ),
                  ),
                  Row(
                    children: [
                      AppImageView(
                        svgPath: Assets.svgDetails,
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.scaleDown,
                      ),
                      10.ws,
                      Text(
                        'Details',
                        style: AppTextStyle.font14black500,
                      ),
                    ],
                  ),
                  12.hs,
                  Container(
                    width: 335.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(
                        color: AppColor.primaryBlueTransparent,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      getOneAnalysis?.terms ?? 'No details available',
                      style: AppTextStyle.font14black500,
                    ),
                  ),
                ],
              ),
            ),
            state is DeleteAnalysisLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColor.primaryBlue,
                  ))
                : const SizedBox()
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    final GetOneAnalysis? getOneAnalysis =
        ReservationCubit.get(context).getUserAnalysis;
    final ReservationCubit cubit = ReservationCubit.get(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التحليل'),
        content: const Text('هل انت متأكد من حذف هذا التحليل ؟'),
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
              Navigator.of(context).pop();
              cubit.deleteAnalysis(
                  getOneAnalysis?.sId ?? "", cubit.getUserDetail?.sId ?? "");
              Navigator.of(context).pop();
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
}
