import 'package:flutter/material.dart';
import 'package:star_sandwich/models/responses/star_response.dart';

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

void showSnackbar(String message, BuildContext context, {int secondsMs = 1500}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(milliseconds: secondsMs),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

bool isStringNullOrEmpty(String? value) {
  return value?.isEmpty ?? true;
}

String getFormattedRightAscension(double rightAscension) {
  var hours = rightAscension.toInt();
  var minutes = ((rightAscension - hours) * 60).toInt();
  var seconds = ((((rightAscension - hours) * 60) - minutes) * 60).toInt();
  var hoursFormatted;
  var minutesFormatted;
  var secondsFormatted;

  if (hours < 10) {
    hoursFormatted = '0$hours';
  } else {
    hoursFormatted = '$hours';
  }
  if (minutes < 10) {
    minutesFormatted = '0$minutes';
  } else {
    minutesFormatted = '$minutes';
  }
  if (seconds < 10) {
    secondsFormatted = '0$seconds';
  } else {
    secondsFormatted = '$seconds';
  }
  return '$hoursFormatted\u02b0 $minutesFormatted\u1d50 $secondsFormatted\u02e2';
}

String getFormattedDeclination(double declination) {
  var sign = declination > 0 ? '+' : '-';
  declination = declination.abs();
  var degrees = declination.toInt();
  var minutes = ((declination - degrees) * 60).toInt();
  var seconds = ((((declination - degrees) * 60) - minutes) * 60).toInt();
  var degreesFormatted;
  var minutesFormatted;
  var secondsFormatted;

  if (degrees < 10) {
    degreesFormatted = '0$degrees';
  } else {
    degreesFormatted = '$degrees';
  }
  if (minutes < 10) {
    minutesFormatted = '0$minutes';
  } else {
    minutesFormatted = '$minutes';
  }
  if (seconds < 10) {
    secondsFormatted = '0$seconds';
  } else {
    secondsFormatted = '$seconds';
  }

  return '$sign$degreesFormatted\u00B0 $minutesFormatted\' $secondsFormatted"';
}

String getStarDisplayTitle(StarResponse star) {
  var msg = '';
  if (!isStringNullOrEmpty(star.properName)) {
    msg = star.properName!;
  } else if (!isStringNullOrEmpty(star.bfDesignation)) {
    msg = star.bfDesignation!;
  } else if (!isStringNullOrEmpty(star.hdId)) {
    msg = 'HD ${star.hdId}';
  } else if (!isStringNullOrEmpty(star.hrId)) {
    msg = 'HR ${star.hrId}';
  } else if (!isStringNullOrEmpty(star.hipId)) {
    msg = 'HIP ${star.hipId}';
  } else if (!isStringNullOrEmpty(star.glId)) {
    msg = '${star.glId}';
  }
  return msg;
}
