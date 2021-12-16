import 'package:boarding_house_mapping_v2/tenant/widgets/rate.dart';
import 'package:boarding_house_mapping_v2/tenant/widgets/title_text.dart';
import 'package:flutter/material.dart';

import 'action_button.dart';

PreferredSizeWidget buildAppBar() {
  return AppBar(
    leading: Rate(),
    backgroundColor: Colors.transparent,
    actions: [actionButton(), SizedBox(width: 12)],
    elevation: 0,
    title: titleText(),
    centerTitle: true,
  );
}
