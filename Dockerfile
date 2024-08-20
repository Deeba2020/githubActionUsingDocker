# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Install dependencies required for fetching and parsing JSON, and for installing ChromeDriver
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    curl \
    jq \
    wget \
    unzip \
    gnupg \
    libgconf-2-4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libasound2 \
    libdbus-1-3 \
    libu2f-udev \
    fonts-liberation \
    libappindicator3-1 \
    libgtk-3-0 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable

# Fetch and install ChromeDriver
ENV JSON_URL="https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json"
ENV PLATFORM="linux64"
RUN set -eux; \
    CHROMEDRIVER_URL=$(curl -sS ${JSON_URL} | \
    jq -r --arg platform "$PLATFORM" '.channels.Stable.downloads.chromedriver[] | select(.platform==$platform) | .url'); \
    wget -O chromedriver-${PLATFORM}.zip "${CHROMEDRIVER_URL}"; \
    unzip -j chromedriver-${PLATFORM}.zip -d /usr/local/bin; \
    rm chromedriver-${PLATFORM}.zip

# Set display port to avoid crash
ENV DISPLAY=:99

# Set up virtual Python environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN python -m pip install --upgrade pip && \
    pip install robotframework robotframework-seleniumlibrary

# Set the working directory
WORKDIR /workspace

# Copy your test files into the Docker image
COPY SeleniumLab1.robot /workspace/

# Default command to run Robot Framework tests with Xvfb
CMD ["sh", "-c", "Xvfb :99 -screen 0 1280x1024x24 & robot --loglevel DEBUG --outputdir output SeleniumLab1.robot"]
