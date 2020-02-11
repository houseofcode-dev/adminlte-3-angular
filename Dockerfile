FROM node:12.13.0 as base
EXPOSE 4200
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json .
RUN npm install 
RUN npm install -g @angular/cli@7.3.9
CMD ["ng","serve","--host","0.0.0.0"]

FROM base as build
COPY . .
RUN ng build --prod --optimization --build-optimizer --vendor-chunk --common-chunk --extract-licenses --extract-css --source-map=false

FROM nginx:1.17.0 as final
WORKDIR /usr/src/app
COPY nginx.conf /etc/nginx/conf.d/nginx.conf
COPY --from=build /usr/src/app/dist .