# Stage 1: build stage  
FROM node:20-alpine AS build 
WORKDIR /app 
COPY index.html ./ 
# Stage 2: production image 
FROM nginx:alpine 
COPY --from=build /app /usr/share/nginx/html 
EXPOSE 80 
CMD ["nginx", "-g", "daemon off;"]
