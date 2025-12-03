# Base python image
FROM mcr.microsoft.com/devcontainers/python:3.11-bookworm

# Install uv
RUN pip install uv

# Install dbt-databricks using uv
RUN uv pip install --system dbt-databricks==1.10.0

USER vscode

WORKDIR /workspaces