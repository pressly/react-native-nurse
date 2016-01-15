#!/bin/bash

getProjectName ()
{
  echo ${PWD##*/}
}

getProjectPath ()
{
  echo ${PWD}
}

usage ()
{
  echo "React Native Nurse v1.0.0"
  echo "Usage:"
  echo ""
  echo " Options:"
  echo "    -h                        show usage/help"
  echo "    -p <project's name>       default is project's folder name"
  echo ""
  echo " ios flags:"
  echo "    -i <ios simulator type>"
  echo "    -b <bundle id> required"
  echo "    -t <temporary ios build>  default is 'ios/tmp'"
  echo ""
  echo " android flags"
  echo "    -a <android simulator name>"
  echo ""
}

PROJECT_NAME=`getProjectName`
IOS_SIM_TYPE=
IOS_BUNDLE_ID=
IOS_TMP_FOLDER="`getProjectPath`/ios/tmp"
ANDROID_SIM_TYPE=
while getopts "hp:i:b:a:t" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    p)
      PROJECT_NAME=$OPTARG
      ;;
    i)
      IOS_SIM_TYPE=$OPTARG
      ;;
    b)
      IOS_BUNDLE_ID=$OPTARG
      ;;
    t)
      IOS_TMP_FOLDER=$OPTARG
      ;;
    a)
      ANDROID_SIM_TYPE=$OPTARG
      ;;
    ?)
      usage
      exit
      ;;
  esac
done


#
# Android Specifics

open_android_simulator ()
{
  echo "opening Android's simulator..."
  emulator -wipe-data -scale 0.3 -avd "$ANDROID_SIM_TYPE" &
  echo "waiting for Android simulator becomes online..."
  while :
  do
    state=$(adb get-state)
    if [ "$state" == "device" ]
    then
      break
    fi
  done
  echo "stage 1 passed"
  while :
  do
    bootanim=$(adb shell getprop init.svc.bootanim)
    if [ "$bootanim" == $'stopped\r' ]
    then
      break
    fi
  done
  echo "Android simulator is online"
}

launch_app_android_simulator ()
{
  # you can do also react-native run-android
  # cd android && ./gradlew installDebug
  react-native run-android
}

#
# iPhone / iOS Sepecifics

build_ios ()
{
  local projectName=`getProjectName`
  local projectPath=`getProjectPath`

  xctool -project                                                              \
          ios/"$PROJECT_NAME".xcodeproj                                        \
          -scheme "$PROJECT_NAME"                                              \
          -sdk iphonesimulator                                                 \
          -destination "platform=iphonesimulator,name=$IOS_SIM_TYPE"           \
          build CONFIGURATION_BUILD_DIR="$IOS_TMP_FOLDER"
}

open_ios_simulator ()
{
  open -a Simulator
}

install_app_ios_simulator ()
{
  xcrun simctl install "$IOS_SIM_TYPE" "$IOS_TMP_FOLDER/$PROJECT_NAME.app"
}

launch_app_ios_simulator ()
{
  xcrun simctl launch "$IOS_SIM_TYPE" "$IOS_BUNDLE_ID.$PROJECT_NAME"
}


android ()
{
  open_android_simulator
  sleep 2
  launch_app_android_simulator
}

ios ()
{
  build_ios
  open_ios_simulator
  sleep 2 # we need this sleep to prevent the install happens too quickly.
  install_app_ios_simulator
  launch_app_ios_simulator
}

if [[ ! -z "$IOS_BUNDLE_ID" ]] && [[ ! -z "$IOS_SIM_TYPE" ]]
then
  ios
fi

if [[ ! -z "$ANDROID_SIM_TYPE" ]]
then
  android
fi
