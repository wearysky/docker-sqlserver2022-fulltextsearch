FROM mcr.microsoft.com/mssql/server:2022-latest

# Define build-time arguments with default values
ARG SA_PASSWORD=YourStrong(!)Passw0rd
ARG SSID_PID=Developer

# Set environment variables based on the arguments
ENV SA_PASSWORD=${SA_PASSWORD}
ENV ACCEPT_EULA=Y
ENV SSID_PID=${SSID_PID}
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Switch to root to install fulltext - apt-get won't work unless you switch users!
USER root

# Install dependencies - these are required to make changes to apt-get below
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -yq gnupg gnupg2 gnupg1 curl apt-transport-https && \
# Install SQL Server package links - why aren't these already embedded in the image?  How weird.
    curl https://packages.microsoft.com/keys/microsoft.asc -o /var/opt/mssql/ms-key.cer && \
    gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg /var/opt/mssql/ms-key.cer && \
    curl https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list -o /etc/apt/sources.list.d/mssql-server-2022.list && \
    apt-get update && \
# Install SQL Server full-text-search - this only works if you add the packages references into apt-get above
    apt-get install -y mssql-server-fts && \
# Cleanup - remove the links to Microsoft packages that we added earlier
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Run SQL Server process
ENTRYPOINT [ "/opt/mssql/bin/sqlservr" ]