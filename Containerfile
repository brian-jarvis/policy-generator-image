FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

WORKDIR /root
## install kustomize
RUN microdnf install tar gzip findutils -y && microdnf clean all
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" --output ./install_kustomize.sh
RUN bash ./install_kustomize.sh
RUN ln -s ${HOME}/kustomize \
  /usr/local/bin/

## install the policy generator
RUN mkdir -p ${HOME}/.config/kustomize/plugin/policy.open-cluster-management.io/v1/policygenerator && \
  mkdir -p ${HOME}/kustomize-plugins/policygenerator

RUN curl -s https://api.github.com/repos/stolostron/policy-generator-plugin/releases/latest \
  | grep "browser_download_url.*linux-amd64-PolicyGenerator" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | xargs curl --output ${HOME}/kustomize-plugins/policygenerator/linux-amd64-PolicyGenerator 

RUN ln -s ${HOME}/kustomize-plugins/policygenerator/linux-amd64-PolicyGenerator \
  ${HOME}/.config/kustomize/plugin/policy.open-cluster-management.io/v1/policygenerator/
