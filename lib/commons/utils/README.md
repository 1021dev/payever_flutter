# Utils Description

- Util are all the Extra things that the app will need in order to run properly.

- env.dart
    * The functionality of the env file its to adapt the env.json that manage all the platfrom's urls. They will not be change but for the automation and to create an easy way to change the dev environment(test->staging->production).

- common-utils.dart
    * mainly it containt the constants to parse all the json
    * also the switcher as a simple map of strings to move between accounts(Passwords and Emails) and environments.

- translations.dart
    * A custom implementation to manage the platform laguage.
    