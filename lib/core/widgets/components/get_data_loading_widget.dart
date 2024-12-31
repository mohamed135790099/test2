import 'package:dr_mohamed_salah_admin/core/widgets/components/loading_widget.dart';
import 'package:flutter/material.dart';

class GetDataLoadingWidget extends StatelessWidget {
  const GetDataLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(child: LoadingWidget()),
    );
  }
}
