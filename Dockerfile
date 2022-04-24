FROM nginx:stable

# install config files
COPY nginx/conf.d/* /etc/nginx/conf.d/
