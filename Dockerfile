FROM node:lts-alpine3.22 AS base
ENV NEXT_TELEMETRY_DISABLED=1

FROM base AS deps

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* .npmrc* ./
RUN  corepack enable pnpm && pnpm i --frozen-lockfile --force

# Rebuild the source code only when needed ---------------------------------------------------------------

FROM base AS builder

WORKDIR /app
COPY --from=deps /app/node_modules ./
COPY . .

RUN corepack enable pnpm && pnpm run build
RUN rm -rf node_modules \
  && pnpm install --frozen-lockfile \
  && pnpm prune --prod
# ------------------------------------------------------------------------------------------------------  

FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT=3000

ENV HOSTNAME='0.0.0.0'
CMD ["node", "server.js"]


