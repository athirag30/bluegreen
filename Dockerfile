# Use official Node.js image
FROM node:18

# Create working directory inside container
WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files to container
COPY . .

# Expose port
EXPOSE 3000

# Run app
CMD ["node", "app.js"]
