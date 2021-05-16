import 'package:flutter/material.dart';

void hideKeyboard(BuildContext context) {
	FocusScope.of(context).requestFocus(new FocusNode());
}