FROM alpine:3.21

ENV USER=sops-user
ENV GROUPNAME=$USER

RUN apk --no-cache add --update \
    curl \
    bash \
	sops

RUN  adduser \
	--disabled-password \
	--gecos "" \
	--home "$(pwd)" \
	--no-create-home \
	$USER



USER $USER

ENTRYPOINT ["sops"]