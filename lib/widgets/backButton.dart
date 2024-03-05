import 'package:flutter/material.dart';

import '../colors.dart';

class backButton extends StatelessWidget {
  const backButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(
        top: 8,
        left: 8,   
      ),
      decoration:  BoxDecoration(
        color: Colours.scaffoldBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed:(){
          Navigator.pop(context);
        } ,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
           );
  }
}