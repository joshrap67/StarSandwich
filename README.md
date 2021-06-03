# Star Sandwich

Mobile app for determining what star is directy above and below you at a given time and location on Earth. The application interacts with a Node.js web service hosted on AWS.

The user can either use their GPS to determine their location, or can manually enter an address (currently only supported for users in U.S. or Canada).

[Demo of Star Sandwich version 1.0.0](https://www.youtube.com/watch?v=CX3EDMHIjb4)

Refer to the Wiki for details on the application logic.

## Prerequisites

This application is currently only published for Android devices. The minimum SDK version that this application can run on is: 16. The targeted SDK for this application is: 30.

An internet connection is required to run this application.

GPS location is required if not using the manual mode.

If pulling from this repository, Flutter is required in order to run the application.

## Deployment

If downloading from the [Google Play Store](https://play.google.com/store/apps/details?id=com.joshrap.star_sandwich), simply download it and ensure enough space is available on the device.

If pulling from this repository, open the project and run it using Flutter (can be done via CLI). If doing it this way, you may need to ensure that you have developer options enabled on your device.

## Built With

- [Flutter](https://flutter.dev/) - Framework that the frontend was built with.

- [Node.js](https://nodejs.org/en/) - Framework that the backend was built with.

- [Android Studio](https://developer.android.com/studio) - IDE that was used to build the frontend.

- [WebStorm](https://www.jetbrains.com/webstorm/) - IDE that was used to build the backend.

## Authors

- Joshua Rapoport - _Creator and Lead Software Developer_

## Acknowledgments

App logo drawn by Mike O. Sexton.

[Source of background image for app and feature graphic](https://unsplash.com/photos/uhjiu8FjnsQ)

[Selected data found from AstroNexus repository](https://github.com/astronexus/HYG-Database)

[Source for formula used to obtain Greenwich mean sidereal time](https://www2.mps.mpg.de/homes/fraenz/systems/systems3art/node10.html)

[API used to determine lat/long for a given address in the U.S. and Canada](https://www.geocod.io/)
