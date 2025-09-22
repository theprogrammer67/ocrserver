FROM debian:bullseye-slim AS builder
LABEL maintainer="theprogrammer67 <igor@stovpets.com>"

RUN apt update \
    && apt install -y \
      ca-certificates \
      golang=2:1.15~1 \
      libtesseract-dev=4.1.1-2.1 \
      libleptonica-dev

ENV GO111MODULE=on
ENV HOME=/root
ENV GOPATH=${HOME}/go
ENV PATH=${PATH}:${GOPATH}/bin

ADD . $GOPATH/src/github.com/otiai10/ocrserver
WORKDIR $GOPATH/src/github.com/otiai10/ocrserver
RUN go get -v ./... && go install .

# --- runtime stage ---
FROM debian:bullseye-slim
ARG LOAD_LANG=rus

RUN apt update \
    && apt install -y \
      ca-certificates \
      wget \
      libtesseract-dev=4.1.1-2.1 \
      tesseract-ocr=4.1.1-2.1 \
      tesseract-ocr-rus

COPY --from=builder /root/go/bin/ocrserver /usr/local/bin/ocrserver
COPY --from=builder /root/go/src/github.com/otiai10/ocrserver/app /root/go/src/github.com/otiai10/ocrserver/app


RUN wget https://raw.githubusercontent.com/Shreeshrii/tessdata_ocrb/master/ocrb.traineddata -P /usr/share/tesseract-ocr/4.00/tessdata

# Load languages
RUN if [ -n "${LOAD_LANG}" ]; then apt-get install -y tesseract-ocr-${LOAD_LANG}; fi

ENV PORT=7080
CMD ["ocrserver"]

