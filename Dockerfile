# Use the extended version of Hugo to support SCSS/SASS
FROM klakegg/hugo:ext-alpine AS build

# Set the working directory
WORKDIR /src

# Copy all files from the current directory to the container
COPY . .

# Run Hugo to build the static site
RUN hugo --gc --minify

# --- Production Stage ---
# Use a lightweight Nginx image to serve the content
FROM nginx:alpine

# Copy the built site from the build stage to Nginx's default directory
COPY --from=build /src/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
