import 'package:dr_mohamed_salah_admin/core/widgets/form_fields/search_form_field.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController searchController = TextEditingController();
  String? searchValue;

  @override
  Widget build(BuildContext context) {
    return SearchFormField(
        hintText: " البحث",
        searchController: searchController,
        onChanged: (v) {
          setState(() {
            searchValue = v;
          });
        });
  }
}
