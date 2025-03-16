FROM alpine:3.21

ENV USER=sops-user
ENV GROUPNAME=$USER



RUN  adduser \
	--disabled-password \
	--gecos "" \
	--home "$(pwd)" \
	--no-create-home \
	$USER

ARG PRODUCT=vault
ARG VERSION=1.18.5

RUN apk add --update --virtual .deps --no-cache gnupg && \
	cd /tmp && \
	wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_amd64.zip && \
	wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS && \
	wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig && \
	wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
	gpg --verify ${PRODUCT}_${VERSION}_SHA256SUMS.sig ${PRODUCT}_${VERSION}_SHA256SUMS && \
	grep ${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS | sha256sum -c && \
	unzip /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip -d /tmp && \
	mv /tmp/${PRODUCT} /usr/local/bin/${PRODUCT} && \
	rm -f /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS ${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig && \
	apk del .deps

USER $USER

ENTRYPOINT ["vault"]

