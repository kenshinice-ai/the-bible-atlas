FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json tsconfig.base.json ./
COPY apps/api/package.json apps/api/package.json
RUN npm install --workspace @literary-atlas/api
COPY apps/api apps/api
RUN npm run build -w @literary-atlas/api
# Drop devDependencies (typescript, vitest, tsx, ...) from the runtime image.
RUN npm prune --omit=dev
FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/apps/api/package.json ./package.json
COPY --from=build /app/apps/api/dist ./dist
COPY db ./db
EXPOSE 4000
CMD ["node", "dist/index.js"]
