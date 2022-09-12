
import 'package:flutter/material.dart';

import '../widgets/welcome_widgets.dart';


class Welcome_screen extends StatelessWidget {
  const Welcome_screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Welcome_widgets()
    );
  }
}


