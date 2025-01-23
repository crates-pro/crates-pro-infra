FROM jenkins/inbound-agent:3283.v92c105e0f819-6-jdk17

USER root

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.28.12/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Install Docker
RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io \
    && rm -rf /var/lib/apt/lists/*

# Add Jenkins user to the docker group
RUN usermod -aG docker jenkins

USER jenkins
