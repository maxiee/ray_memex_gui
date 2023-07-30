import 'package:flutter/material.dart';

class WebpageToolsTab extends StatelessWidget {
  const WebpageToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('/webpage/upload'),
            child: const Text("上传归档网页"))
      ],
    );
  }
}
