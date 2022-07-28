import 'package:flutter/material.dart';

import '../../components/page_header.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        PageHeader(
          title: 'Saved sounds',
          requireSearchBar: true,
          requireUserDetails: true,
        ),
      ],
    );
  }
}
