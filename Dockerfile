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

# Install Android (https://developer.android.com/studio/#downloads)

ENV ANDROID_BUILD_TOOLS_VERSION=32.0.0
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip"
ENV ANT_HOME="/usr/share/ant"
ENV MAVEN_HOME="/usr/share/maven"
ENV GRADLE_HOME="/usr/share/gradle"
ENV ANDROID_SDK_ROOT="/opt/android"
ENV ANDROID_HOME="/opt/android/android-sdk-linux"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

WORKDIR /opt

RUN apt-get -qq update && \
      apt-get -qq install -y wget curl maven ant gradle

# Installs Android SDK
RUN mkdir android && cd android && \
      wget -O tools.zip ${ANDROID_SDK_URL} && \
      unzip tools.zip && rm tools.zip

RUN mkdir /root/.android && touch /root/.android/repositories.cfg && \
      while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" && \
      while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "build-tools;30.0.3" && \
      while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-25" "platforms;android-26" "platforms;android-27" && \
      while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-28" "platforms;android-29" "platforms;android-30" && \
      while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platforms;android-31" "platforms;android-32" "platforms;android-33" && \
      while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "extras;android;m2repository" "extras;google;google_play_services" "extras;google;instantapps" "extras;google;m2repository" &&  \
      while true; do echo 'y'; sleep 2; done | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "add-ons;addon-google_apis-google-22" "add-ons;addon-google_apis-google-23" "add-ons;addon-google_apis-google-24" "skiaparser;1"

RUN chmod a+x -R $ANDROID_SDK_ROOT && \
      chown -R root:root $ANDROID_SDK_ROOT && \
      rm -rf /opt/android/licenses && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
      apt-get autoremove -y && \
      apt-get clean && \
      mvn -v && gradle -v && java -version && ant -version

# Install Fastlane
RUN apt-get -qq update && \
  apt-get install -qqy --no-install-recommends build-essential ruby-full && \
  gem install bundler fastlane
