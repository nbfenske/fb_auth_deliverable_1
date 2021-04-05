# fb_auth

As part of our main project for our CIS 454: Software Implementation course at Syracuse University, taught by Prof. Chilukuri K. Mohan

An in-progress Flutter Android application which will allow university students to easily manage their classes
in a calendar application centered around college life. Special features *will* include options to add external links like Zoom classes,
notifications for when a class or call is upcoming, and the ability to add office hours.

All of the code which we actually wrote for this project (i.e. not generated simply by creating a new flutter app) are contained inside
of the lib folder. If you are unfamiliar with the structure of Flutter applications, main.dart will be the file to go to if you want to
see the main screen/code for this application.

## Authors
Nathan Fenske, 
Timothy Nkata, 
Konstantinos Chrysoulous, 
Gaeun Lee, 
Kelvin Chen, 
and Jonathan Deiss

### Setup Instructions

This projects has been primarily coded using Flutter/Dart, so you will need to install those packages to your IDE of choice. If you haven't worked with these before, we would reccomend Visual Studio Code or Android Studio. You can find a tutorial for this here: https://flutter.dev/docs/get-started. The command 'flutter doctor' will be your greatest tool in this stage as it will tell you about what dependencies/agreements/etc. you are missing.

Once you are set up, be sure to run 'flutter pub get' and/or 'flutter packages get' in the terminal to download project dependencies. To run the code, you will either need an Android device of your own to run a test build (should be recognized by Android Studio when plugged in via USB), or you will need to run a virtual device. Running a virtual device may require you to enable that setting in your BIOS. This is specific system to system, so I would reccomend troubleshooting via Google or YouTube for that.

Finally, if you would like to make use of the database and the Google sign-in features we have to offer, I will need to add you as a user to our Firebase application. You can send me your Android debug SHA1 key (please include your name and why you would like to be added) at my email (nbfenske@syr.edu) and I will try to auhtorize you as soon as possible. If you do not know how to find your SHA1 key, I will again refer to Google or YouTube as this is a individual-setup related task.

## Notes for External Users

This is a work-in-progress, meaning that some code (like Google Sign-in) is associated with our specific computers. As such, Google Sign-in will
NOT work on your computer unless I have added your SHA1 debug key to our Firebase account. If you would like to test our code, you will have to modify the
main.dart file to open to the HomeScreen as opposed to the LoginPage. Otherwise, you will not be able to do anything besides looks at our beautiful login screen.

Additionally, assuming you do not work with Android applications, this will require you to install and set up Flutter/Android dependencies on your computer.
Once that is done, please run "flutter pub get" and "flutter packages get" in the terminal (while in the directory for this application, of course) to install
all of the packages we have used in this application thus far.
