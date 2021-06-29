ARG ARCH=


FROM ${ARCH}node:16.3-alpine3.12
RUN npm install --global wscat
##COPY --from=builder /go/bin/terraform /bin/terraform

CMD ["wscat"]

