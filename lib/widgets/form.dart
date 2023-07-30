import 'package:flutter/material.dart';

Row formItem(String label, TextEditingController controller, String initValue,
    {editable = true,
    IconButton? suffixIcon,
    int minLines = 1,
    int maxLines = 1}) {
  controller.text = initValue;
  return Row(
    children: [
      SizedBox(width: 60, child: Text(label)),
      Flexible(
        fit: FlexFit.loose,
        child: SizedBox(
          child: TextField(
            enabled: editable,
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      if (suffixIcon != null) suffixIcon,
    ],
  );
}
