# react-native-nurse
run react-native on simulators without opening xcode and android avd

## Introduction

Are you opening `xCode`, `Android avd`, `iOS simulator`, `Android emulator`, etc to just writing to just develop for `React-Native`? Are you frustrated about how many window needs to be opened before you can start writing code?

The wait is Over, introducing `react-native-nurse` script which helps you compile and run on iOS and Android simulators without opening `xcode` and `android avd`.

`react-native-nurse` is a collection of commands which binds together to open your app on both simulators with ease.

## Installation

- download the script `nurse` and put it in your bin folder
- make it executable by running `chmod +x <my bin path>/nurse`

## Usage

before you can use it in your app, you need to know couple of things:
  - iOS simulator:
    - obviously you need to have a mac
    - xCode must be installed
    - [xctool](https://github.com/facebook/xctool) must be installed

  - Android
    - make sure that you have done all of the android configuration described [here](https://facebook.github.io/react-native/releases/0.48/docs/getting-started.html#android-development-environment)

So now you are ready to use `nurse`

- go to one of your react-native project
- make sure you know the `Bundle Id` of your app for ios
- make sure you have already created an android vm and written the name of it
- run `nurse -h` to see if nurse can be executed
- run `nurse -i "iPhone 6" -b "org.reactjs.native.example" -a awesome`

> the above command runs the project on iPhone 6 simulator and opens android vm assigned to `awesome`.


Here's the full demo:

<p align="center">
  <img src="https://raw.githubusercontent.com/pressly/react-native-nurse/master/demo/demo.gif" />
</p>

cheers :)
