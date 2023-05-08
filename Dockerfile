# syntax = docker/dockerfile:1

# Adjust NODE_VERSION as desired
ARG NODE_VERSION=16.20.0
FROM node:${NODE_VERSION}-slim as base

LABEL fly_launch_runtime="NodeJS"

# NodeJS app lives here
WORKDIR /app

# Set production environment
ENV NODE_ENV=production


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build node modules
RUN apt-get update -qq && \
    apt-get install -y python pkg-config build-essential 
        



# Install node modules
COPY --link package.json package-lock.json .
RUN npm install --production=false

# Copy application code
COPY --link . .

# Build application
RUN npm run build

# Remove development dependencies
RUN npm prune --production


# Final stage for app image
FROM base

# Copy built application
COPY --from=build /app /app

#Install curl

RUN apt-get -y update; apt-get -y install curl

#chmod script

RUN chmod +x /app/health_check.sh

# Start the server by default, this can be overwritten at runtime
CMD [ "npm", "run", "start" ]
