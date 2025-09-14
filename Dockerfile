# Stage 1: Build React frontend
FROM node:18-alpine AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install --only=production && npm cache clean --force
COPY frontend/ ./
RUN npm run build

# Stage 2: Build Node.js backend
FROM node:18-alpine AS backend-builder
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install --only=production && npm cache clean --force
COPY backend/ ./

# Stage 3: Production runtime with Nginx
FROM nginx:alpine
# Install Node.js runtime (minimal for backend)
RUN apk add --no-cache nodejs npm
# Copy React build artifacts
COPY --from=frontend-builder /app/frontend/build /usr/share/nginx/html
# Copy Node.js backend
COPY --from=backend-builder /app/backend /usr/src/app
# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S -u 1001 nextjs && \
    chown -R nextjs:nodejs /usr/src/app /usr/share/nginx/html /var/cache/nginx
USER nextjs
WORKDIR /usr/src/app
# Start Node.js in background (use PM2 or similar in production)
CMD sh -c "node server.js & nginx -g 'daemon off;'"
EXPOSE 80
