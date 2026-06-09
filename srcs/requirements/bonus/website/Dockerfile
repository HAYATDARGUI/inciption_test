FROM nginx:alpine

# Simple website served by nginx. Keeps things easy to read and extend.
COPY ./html /usr/share/nginx/html:ro

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
