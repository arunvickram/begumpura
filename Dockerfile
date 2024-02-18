FROM croservices/cro-http:0.8.9
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN zef install --deps-only . && perl6 -c -Ilib service.raku
ENV BEGUMPURA_PORT="10000" BEGUMPURA_HOST="0.0.0.0"
EXPOSE 10000
CMD perl6 -Ilib service.raku
