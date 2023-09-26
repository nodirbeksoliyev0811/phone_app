import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../utils/colors.dart';

class InputTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType? inputType;
  final TextEditingController? controller;

  const InputTextField({
    Key? key,
    required this.label,
    required this.hint,
    this.controller,
    this.inputType,
  }) : super(key: key);

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  var maskFormatter1 = MaskTextInputFormatter(
      mask: '+998 ## ### ## ##',
      filter: {"#": RegExp(r'\d')},
      type: MaskAutoCompletionType.lazy);

  var maskFormatter2 = MaskTextInputFormatter(
      mask: '####################',
      filter: {"#": RegExp(r'[a-z,A-Z\d]')},
      type: MaskAutoCompletionType.lazy);

  var maskFormatter3 = MaskTextInputFormatter(
      mask: '####################',
      filter: {"#": RegExp(r'[a-z,A-Z\d]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label),
            const SizedBox(height: 5),
            TextField(
              inputFormatters: widget.hint == "+998  _ _  _ _ _  _ _  _ _"
                  ? [maskFormatter1]
                  : widget.hint == "Enter name"
                      ? [maskFormatter2]
                      : widget.hint == "Enter surname"
                          ? [maskFormatter3]
                          : null,
              controller: widget.controller,
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                  hintText: widget.hint,
                  filled: true,
                  prefixStyle: const TextStyle(color: Colors.black),
                  fillColor: ColorsApp.c_FAFAFA,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: ColorsApp.c_D9D9D9),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: ColorsApp.c_454545),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
