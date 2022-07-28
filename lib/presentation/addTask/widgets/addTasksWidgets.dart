import 'package:flutter/material.dart';

Widget MainTextFormField({
  required String hintText,
  required String validatorMessage,
  required context,
  required MainTextInputType,
  TextEditingController? TextFormFieldMainController,
  VoidCallback? onTapFunction,
  double? hintTextSize,
  Widget? icon,
}) =>
    TextFormField(
      keyboardType: MainTextInputType,
      onTap: onTapFunction,
      controller: TextFormFieldMainController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        //to change border style before any click
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: hintTextSize,
        ),
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        //must to change tff color
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        suffixIcon: icon,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );

Future MainShowTimePicker({required context , required TextEditingController controller}) => showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
).then((value) {
  controller.text = value!.format(context).toString();
});

//to be used
Widget MainDropDownMenu ({required String initialValue , required List<DropdownMenuItem<String>>? list , required VoidCallback function(String? value)?}) =>Container(
  clipBehavior: Clip.antiAliasWithSaveLayer,
  height: 58.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.0),
    color: Colors.grey.withOpacity(0.1),
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: DropdownButtonHideUnderline(
      child: DropdownButton(
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        value: initialValue,
        icon: RotatedBox(
          quarterTurns: 1,
          child: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.grey.withOpacity(0.5),
            size: 22,
          ),
        ),
        isExpanded: true,
        items: list,
        onChanged: function,
      ),
    ),
  ),
);