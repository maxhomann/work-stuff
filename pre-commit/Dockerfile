FROM python:3-bookworm

RUN apt install -y git &&  \
    apt clean && \
    pip install pre-commit && \
    git config --global safe.directory '*'

ADD .pre-commit-config.yaml /opt/pre-commit/

WORKDIR /opt/repo
RUN git init  \
    && pre-commit install-hooks --config /opt/pre-commit/.pre-commit-config.yaml \
    && rm -rf .git

ENTRYPOINT ["pre-commit", "run", "-v", "--all-files", "--config", "/opt/pre-commit/.pre-commit-config.yaml"]
