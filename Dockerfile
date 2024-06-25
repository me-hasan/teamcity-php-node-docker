# Use the official TeamCity agent image as the base
FROM jetbrains/teamcity-agent

# Ensure the /opt/buildagent/conf directory exists
RUN mkdir -p /opt/buildagent/conf

# Set environment variables if needed
ENV SERVER_URL=http://teamcity-server:8111

# Temporarily switch to root for administrative tasks
USER root

# Add Ondřej Surý's PPA for PHP
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php

# Install necessary packages: PHP 8.2, PHP extensions, Node.js 20.x, and other tools
RUN apt-get update && \
    apt-get install -y \
        php8.2 \
        php8.2-cli \
        php8.2-xml \
        php8.2-curl \
        php8.2-mbstring \
        php8.2-zip \
        php8.2-intl \
        curl \
        git \
        unzip \
        gnupg \
        wget \
        # Install Node.js 20.x
        && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
        && apt-get install -y nodejs \
        # Clean up
        && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Switch back to buildagent user and ensure correct permissions if needed
USER buildagent
RUN chown -R buildagent:buildagent /opt/buildagent/conf

# Any additional setup or dependencies can be added here