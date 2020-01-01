FROM maven:3-alpine

# variable "VERSION" must be passed as docker environment variables during the image build
# docker build --no-cache --build-arg VERSION=2.12.0 -t alpine/helm:2.12.0 .

ENV HELM_VERSION=v2.14.3
ENV KUBE__VERSION=v1.14.7
ENV user=root

# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
#ENV BASE_URL="https://get.helm.sh"
#ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN apk add --update --no-cache curl ca-certificates  \
#    curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
#    mv linux-amd64/helm /usr/bin/helm && \
#    chmod +x /usr/bin/helm && \
#    chmod +x /usr/local/bin/jenkins-agent && \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE__VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -L https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -xvz \
    && mv linux-amd64/helm  /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave  \
    && chmod +x /usr/local/bin/jenkins-agent  \
    && rm -rf linux-amd64  \
    && apk del curl  \
    && rm -f /var/cache/apk/*

USER ${user}

ENV PATH $PATH:/usr/local/bin
