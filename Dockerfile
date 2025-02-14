# Gunakan Node.js 20 dengan Alpine Linux (ringan)
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy hanya package.json dan package-lock.json untuk memanfaatkan cache layer
COPY package*.json ./

# Install dependencies dengan npm ci (lebih cepat dan stabil)
RUN npm ci --frozen-lockfile

# Copy seluruh kode proyek
COPY . .

# Build aplikasi React (Vite)
RUN npm run build

# Gunakan image yang lebih kecil untuk menjalankan hasil build
FROM node:20-alpine AS runner

WORKDIR /app

# Copy hasil build dari stage sebelumnya
COPY --from=build /app/dist /app/dist
COPY --from=build /app/package.json /app/
COPY --from=build /app/node_modules /app/node_modules

# Expose port sesuai dengan vite preview (default: 4173)
EXPOSE 4173

# Jalankan aplikasi menggunakan vite preview
CMD ["npm", "run", "preview"]
