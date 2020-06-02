FROM jetbrains/teamcity-agent

ENV ANDROID_HOME /opt/android-sdk-linux

# Download Android SDK into $ANDROID_HOME and unzip it.
# You can find the URL to the current Android SDK version at: https://developer.android.com/studio/index.html

USER root

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    chown -R buildagent:buildagent ${ANDROID_HOME}

USER buildagent

RUN cd ${ANDROID_HOME}/cmdline-tools && \
    curl -L https://dl.google.com/android/repository/commandlinetools-linux-6514223_latest.zip -o android_tools.zip && \
    unzip android_tools.zip && \
    rm android_tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Accept Android SDK licenses

RUN yes | sdkmanager --licenses

USER root

RUN set -x && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    sudo apt-get update -y && \
    sudo apt-get install -y yarn

RUN yarn global add n

RUN sudo n stable

RUN yarn global add @angular/cli

RUN ng --version