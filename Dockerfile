# Base image with Python
FROM python:3.12

# Install dependencies for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    curl \
    jq \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install the Google Chrome signing key
RUN wget https://dl-ssl.google.com/linux/linux_signing_key.pub -O /tmp/google.pub \
    && gpg --no-default-keyring --keyring /etc/apt/keyrings/google-chrome.gpg --import /tmp/google.pub \
    && echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get -y update \
    && apt-get install -y google-chrome-stable

# Fetch and install the latest ChromeDriver
ENV JSON_URL="https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json"
ENV PLATFORM="linux64"

RUN CHROMEDRIVER_URL=$(curl -sS ${JSON_URL} | jq -r --arg platform "$PLATFORM" '.channels.Stable.downloads.chromedriver[] | select(.platform==$platform) | .url') \
    && wget -O chromedriver-${PLATFORM}.zip "${CHROMEDRIVER_URL}" \
    && unzip -j chromedriver-${PLATFORM}.zip -d /opt/chrome \
    && rm chromedriver-${PLATFORM}.zip \
    && chmod +x /opt/chrome/chromedriver

# Set display port to avoid crash
ENV DISPLAY=:99

# Create and activate a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip and install Robot Framework with SeleniumLibrary
RUN pip install --upgrade pip \
    && pip install robotframework robotframework-seleniumlibrary

# Copy the Robot Framework test files
COPY SeleniumLab1.robot /workspace/SeleniumLab1.robot

# Set the working directory
WORKDIR /workspace

# Default command to run Robot Framework tests
CMD ["robot", "--outputdir", "output", "/workspace/SeleniumLab1.robot"]
