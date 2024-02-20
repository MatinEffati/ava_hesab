import 'package:flutter/material.dart';

ShapeBorder bottomSheetShapeStyle() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(12),
    ),
  );
}

class HeaderOfBottomSheet extends StatelessWidget {
  const HeaderOfBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      margin: const EdgeInsets.only(bottom: 12),
      width: 30,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0XFFD7D7DA),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

ScrollPhysics defaultScrollPhysics(){
  return const BouncingScrollPhysics();
}


