FROM registry.redhat.io/rhel8/go-toolset:1.17 as gobuilder

USER root
WORKDIR /work-bin

RUN git clone https://github.com/stolostron/policy-generator-plugin.git

RUN cd policy-generator-plugin && make build-release


# FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5 as builder

# WORKDIR /root
# ## install kustomize
# RUN microdnf install tar gzip findutils wget -y && microdnf clean all
# RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" --output ./install_kustomize.sh
# RUN bash ./install_kustomize.sh
# RUN ln -s ${HOME}/kustomize \
#   /usr/local/bin/

# ## install the policy generator
# RUN mkdir -p ${HOME}/kustomize-plugins/policygenerator

# RUN curl -s https://api.github.com/repos/stolostron/policy-generator-plugin/releases/latest \
#   | grep "browser_download_url.*linux-amd64-PolicyGenerator" \
#   | cut -d : -f 2,3 \
#   | tr -d \" \
#   | xargs wget -O ${HOME}/kustomize-plugins/policygenerator/linux-amd64-PolicyGenerator 

# RUN ls -l ${HOME}/kustomize-plugins/policygenerator/
# RUN chmod +x ${HOME}/kustomize-plugins/policygenerator/linux-amd64-PolicyGenerator

FROM registry.access.redhat.com/ubi8/ubi-micro:8.5
WORKDIR /root

RUN mkdir -p /root/.config/kustomize/plugin/policy.open-cluster-management.io/v1/policygenerator

COPY --from=gobuilder /work-bin/policy-generator-plugin/build_output/linux-amd64-PolicyGenerator /root/.config/kustomize/plugin/policy.open-cluster-management.io/v1/policygenerator/
# COPY --from=builder /root/kustomize-plugins/policygenerator/linux-amd64-PolicyGenerator /root/.config/kustomize/plugin/policy.open-cluster-management.io/v1/policygenerator/
# COPY --from=builder /root/kustomize /usr/local/bin/


