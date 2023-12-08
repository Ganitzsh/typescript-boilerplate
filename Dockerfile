# Use an official Node runtime as a parent image
FROM node:20.9.0 AS builder

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install production dependencies.
RUN npm install --only=production

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Use a smaller node image to run the application
FROM node:20.9.0-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy built assets from the builder stage
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules

# Start the application
CMD ["npm", "run", "start"]
