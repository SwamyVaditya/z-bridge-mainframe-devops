# Step 1: Use a lightweight, official Python runtime as a parent image
FROM python:3.11-slim

# Step 2: Set metadata to align with Mainframe Modernization roles
LABEL maintainer="Mainframe DevOps Specialist"
LABEL description="Z-Bridge: Simulated Git-to-z/OS Mainframe CI/CD and DBB Automation Container"

# Step 3: Install system dependencies required for Ansible and DevOps tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libffi-dev \
    libssl-dev \
    openssh-client \
    sshpass \
    git \
    && rm -rf /var/lib/apt/lists/*

# Step 4: Install Ansible via pip to ensure a modern, lightweight installation
RUN pip install --no-cache-dir ansible

# Step 5: Set the working directory inside the container
WORKDIR /app

# Step 6: Copy your local project assets into the container workspace
COPY cobol/ ./cobol
COPY jcl/ ./jcl
COPY dbb_zowe_pipeline.py .
COPY deploy_to_zos.yml .
COPY hosts.ini .

# Step 7: Create the target directories to simulate z/OS Unix System Services (USS)
# This allows the container to run entirely self-contained out-of-the-box
RUN mkdir -p /tmp/mock_zos/uss

# Step 8: Set execution command to run your entire Mainframe DevOps pipeline sequence
# First, it parses dependencies (Python), then triggers the deployment orchestration (Ansible)
CMD ["sh", "-c", "python dbb_zowe_pipeline.py && ansible-playbook -i hosts.ini deploy_to_zos.yml"]
