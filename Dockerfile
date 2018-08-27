FROM jrnold/rstan
COPY . /app
WORKDIR /app
RUN install2.r --error --deps TRUE \
    forecast \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN Rscript model.R
