ARG UCD_LIB_SERVER_REPO_TAG
FROM ucdlib/fin-ucd-lib-server:${UCD_LIB_SERVER_REPO_TAG}

COPY app-services.js /etc/fin/app-services.js

ARG APP_VERSION
ARG CORE_SERVER_REPO_HASH
ARG CORE_SERVER_REPO_TAG
ARG UCD_LIB_SERVER_REPO_HASH
ARG UCD_LIB_SERVER_REPO_TAG
ARG TESSERACT_SERVICE_REPO_HASH
ARG TESSERACT_SERVICE_REPO_TAG
ARG CAS_SERVICE_REPO_HASH
ARG CAS_SERVICE_REPO_TAG
ARG LORIS_SERVICE_REPO_HASH
ARG LORIS_SERVICE_REPO_TAG

ENV FIN_APP_VERSION ${APP_VERSION}
ENV FIN_CORE_SERVER_REPO_HASH ${CORE_SERVER_REPO_HASH}
ENV FIN_CORE_SERVER_REPO_TAG ${CORE_SERVER_REPO_TAG}
ENV FIN_UCD_LIB_SERVER_REPO_HASH ${UCD_LIB_SERVER_REPO_HASH}
ENV FIN_UCD_LIB_SERVER_REPO_TAG ${UCD_LIB_SERVER_REPO_TAG}
ENV FIN_TESSERACT_SERVICE_REPO_HASH ${TESSERACT_SERVICE_REPO_HASH}
ENV FIN_TESSERACT_SERVICE_REPO_TAG ${TESSERACT_SERVICE_REPO_TAG}
ENV FIN_CAS_SERVICE_REPO_HASH ${CAS_SERVICE_REPO_HASH}
ENV FIN_CAS_SERVICE_REPO_TAG ${CAS_SERVICE_REPO_TAG}
ENV FIN_LORIS_SERVICE_REPO_HASH ${LORIS_SERVICE_REPO_HASH}
ENV FIN_LORIS_SERVICE_REPO_TAG ${LORIS_SERVICE_REPO_TAG}