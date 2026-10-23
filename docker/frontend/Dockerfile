ARG NODE_VERSION=24
FROM node:${NODE_VERSION}-alpine

WORKDIR /app

# Script de arranque
COPY entrypoint.sh /usr/local/bin/react-entrypoint
RUN sed -i 's/\r$//' /usr/local/bin/react-entrypoint \
    && chmod +x /usr/local/bin/react-entrypoint

EXPOSE 5173

ENTRYPOINT ["react-entrypoint"]
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]
