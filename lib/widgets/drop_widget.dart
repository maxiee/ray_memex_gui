import 'package:flutter/material.dart';

class DropWidget extends StatelessWidget {
  const DropWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade300,
        border:
            Border.all(color: Colors.grey, style: BorderStyle.solid, width: 2),
      ),
      child: const Center(child: Text('请将文件拖拽到此处')),
    );
  }
}
