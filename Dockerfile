ARG VERSION=latest
FROM hashicorp/tfc-agent:$VERSION

# Create the hooks directory and change the owner
RUN mkdir /home/tfc-agent/.tfc-agent
COPY --chown=tfc-agent:tfc-agent hooks /home/tfc-agent/.tfc-agent/hooks
USER root

# Create a directory we will later save our identity token to
RUN mkdir /.aws-workload \
  && chown -R tfc-agent:tfc-agent /.aws-workload \
  && mkdir /.gcp-workload \
  && chown -R tfc-agent:tfc-agent /.gcp-workload \
  && mkdir /.vault-workload \
  && chown -R tfc-agent:tfc-agent /.vault-workload

USER tfc-agent

ENV GOOGLE_APPLICATION_CREDENTIALS=/.gcp-workload/app-credentials
