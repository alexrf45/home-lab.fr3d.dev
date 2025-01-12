#####################################################################
#                            Build Stage                            #
#####################################################################
FROM python:3.12-slim-bookworm AS builder

COPY . /blog

WORKDIR /blog

RUN apt-get update; apt-get install -y git

COPY mkdocs/requirements.txt ./
#RUN pip install --no-cache-dir -r requirements.txt
RUN pip install  -r mkdocs/requirements.txt

RUN mkdocs build -f mkdocs/mkdocs.yml

#####################################################################
#                            Final Stage                            #
#####################################################################
FROM nginx:alpine-slim

LABEL "project"="homelab"
LABEL "author"="fr3d"
LABEL "version"="v0.0.1"

# Copy the generated files to keep the image as small as possible.
COPY --from=builder /blog/mkdocs/public /usr/share/nginx/html

EXPOSE 80/tcp

CMD ["nginx", "-g", "daemon off;"]
