# Development Tools Setup
This repository provides an automated setup for configuring development tools for local software development. It includes scripts, configuration files, and guidelines to streamline the installation of essential tools, ensuring a consistent and efficient development environment.

---
## Install Development Tools

```bash
sudo sh execute.sh install jdk
sudo sh execute.sh install maven
sudo sh execute.sh install gradle
sudo sh execute.sh install go
sudo sh execute.sh install docker
sudo sh execute.sh install minikube
```

---
## Remove Development Tools

```bash
sudo sh execute.sh remove jdk
sudo sh execute.sh remove maven
sudo sh execute.sh remove gradle
sudo sh execute.sh remove go
sudo sh execute.sh remove minikube
sudo sh execute.sh remove docker
```

---
## Setting PATH variables for development tools

```bash
# Identify shell type
if [[ ${SHELL} = "/usr/bin/zsh" || ${SHELL} = "/bin/zsh" ]]; then
  BASH_PROFILE_FILE=~/.zprofile
else
  BASH_PROFILE_FILE=~/.bash_profile
fi
echo "Development tools environment variables configuration will be added on '${BASH_PROFILE_FILE}' file"

# Identify if is MacOS
if [ "$(uname)" "==" "Darwin" ]; then
  # Java for MacOS
  echo '# Java environment variables for MacOS' >> ${BASH_PROFILE_FILE}
  echo 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/$(ls /Library/Java/JavaVirtualMachines | head)/Contents/Home"' >> ${BASH_PROFILE_FILE}
  echo 'export PATH="${JAVA_HOME}/bin:${PATH}"' >> ${BASH_PROFILE_FILE}
else
  # Java for Linux
  echo '# Java environment variables for Linux' >> ${BASH_PROFILE_FILE}
  echo 'export JAVA_HOME="/opt/$(ls /opt | grep jdk- | head)"' >> ${BASH_PROFILE_FILE}
  echo 'export PATH="${JAVA_HOME}/bin:${PATH}"' >> ${BASH_PROFILE_FILE}
  # Minikube for Linux
  echo '# Minikube environment variables for Linux' >> ${BASH_PROFILE_FILE}
  echo 'alias kubectl="minikube kubectl --"' >> ${BASH_PROFILE_FILE}
fi

# Maven
echo '# Maven environment variables' >> ${BASH_PROFILE_FILE}
echo 'export M2_HOME="/opt/$(ls /opt | grep apache-maven | head)"' >> ${BASH_PROFILE_FILE}
echo 'export PATH="${M2_HOME}/bin:${PATH}"' >> ${BASH_PROFILE_FILE}
echo 'alias maven="mvn"' >> ${BASH_PROFILE_FILE}

# Gradle
echo '# Gradle environment variables' >> ${BASH_PROFILE_FILE}
echo 'export GRADLE_HOME="/opt/$(ls /opt | grep gradle | head)"' >> ${BASH_PROFILE_FILE}
echo 'export PATH="${GRADLE_HOME}/bin:${PATH}"' >> ${BASH_PROFILE_FILE}

# Go
echo '# Go environment variables' >> ${BASH_PROFILE_FILE}
echo 'export GO_HOME="/usr/local/go"' >> ${BASH_PROFILE_FILE}
echo 'export PATH="${GO_HOME}/bin:${PATH}"' >> ${BASH_PROFILE_FILE}
```

---
## Test Development Tools

```bash
java --version
mvn --version
maven --version
gradle --version
go version
docker --version
minikube version
```