FROM ubuntu:20.04

LABEL maintainer="joaopopedrosa@gmail.com" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.name="docker-android-fastlane" \
      org.label-schema.description="Image base on Ubuntu 20.04." \
      org.label-schema.vendor="João Pedro Pedrosa" \
      org.label-schema.url="https://github.com/joaoppedrosa/docker-android-fastlane" \
      org.label-schema.usage="https://github.com/joaoppedrosa/docker-android-fastlane/blob/master/README.md" \
      org.label-schema.vcs-url="https://github.com/joaoppedrosa/docker-android-fastlane.git" \
      org.label-schema.license="MIT" \
      org.opencontainers.image.title="docker-android-fastlane" \
      org.opencontainers.image.description="Image base on Ubuntu 20.04." \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.authors="João Pedro Pedrosa" \
      org.opencontainers.image.vendor="João Pedro Pedrosa" \
      org.opencontainers.image.url="https://github.com/joaoppedrosa/docker-android-fastlane" \
      org.opencontainers.image.documentation="https://github.com/joaoppedrosa/docker-android-fastlane/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/joaoppedrosa/docker-android-fastlane.git"

ENV DEBIAN_FRONTEND=noninteractive \
      TERM=xterm

RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Install Java
RUN apt-get update && \
    apt-get -y install openjdk-11-jdk-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    java -version

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Install Android
ENV ANDROID_COMPILE_SDK=31
ENV ANDROID_BUILD_TOOLS=31.0.0
ENV ANDROID_COMMAND_LINE_TOOLS=7583922

RUN apt-get --quiet update --yes && \
  apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 && \
  mkdir -p android-sdk-linux/cmdline-tools && \
  export ANDROID_SDK_ROOT=$PWD/android-sdk-linux && \
  cd android-sdk-linux/cmdline-tools && \
  wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_COMMAND_LINE_TOOLS}_latest.zip && \
  unzip android-sdk.zip && \
  rm android-sdk.zip && \
  mv cmdline-tools version && \
  echo y | version/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null && \
  echo y | version/bin/sdkmanager "platform-tools" >/dev/null && \
  echo y | version/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null && \
  export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/ && \
  set +o pipefail && \
  yes | version/bin/sdkmanager --licenses && \
  set -o pipefail && \
  cd ../../ && \
  apt-get -qq update && \
  apt-get install -qqy --no-install-recommends build-essential ruby-full && \
  gem install bundler fastlane && \
  export GRADLE_USER_HOME=$(pwd)/.gradle && \
  chmod +x ./gradlew
