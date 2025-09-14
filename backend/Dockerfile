# Stage 1: build stage  
FROM node:20-alpine AS build 
WORKDIR /app 
COPY db.json . 
# Stage 2: production image 
FROM node:20-alpine 
WORKDIR /app 
RUN npm install -g json-server 
COPY --from=build /app/db.json ./db.json 
EXPOSE 3000 
CMD ["json-server", "--watch", "db.json", "--host", "0.0.0.0", "--port", "3000"]
