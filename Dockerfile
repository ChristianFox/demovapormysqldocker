FROM swift

# First, ensure you have the latest packages on your system:
RUN apt-get clean
RUN apt-get update && apt-get upgrade -y && apt-get -y install \
libssl-dev \
zlib1g-dev

# Fix Python2.7 dist-packages/site-packages issue
RUN mv /usr/lib/python2.7/site-packages /usr/lib/python2.7/dist-packages; ln -s dist-packages /usr/lib/python2.7/site-packages

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . ./

# Prep and Build Swift app
# RUN swift package update
# RUN swift package clean
RUN swift build -c release

# Expose port and Run app
EXPOSE 8080
ENTRYPOINT sleep 20 && .build/release/Run serve -e prod -b 0.0.0.0

