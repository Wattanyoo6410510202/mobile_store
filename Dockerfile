# Stage 1: Build the Vue application
FROM node:18-alpine as build-stage

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# กำหนด Argument สำหรับรับค่า API URL ตอน Build
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

# Build the project for production
RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:alpine as production-stage

# Copy the built assets from the previous stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
