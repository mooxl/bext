FROM node:current-alpine AS base
WORKDIR /base
COPY ./ ./
RUN yarn install

FROM base AS build
ENV NODE_ENV=production
WORKDIR /build
COPY --from=base /base ./
RUN yarn build

FROM node:current-alpine AS prod
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /build/package.json ./
COPY --from=build /build/.next ./.next
COPY --from=build /build/public ./public
RUN yarn add next

EXPOSE 3000
