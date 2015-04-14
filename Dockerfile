# This image is intended for testing purposes, it has the same behavior as
# the origin-docker-builder image, but does so as a custom image so it can
# be used with Custom build strategies.  It expects a set of
# environment variables to parameterize the build:
#
#   OUTPUT_REGISTRY - the Docker registry URL to push this image to
#   OUTPUT_IMAGE - the name to tag the image with
#   SOURCE_URI - a URI to fetch the build context from
#   SOURCE_REF - a reference to pass to Git for which commit to use (optional)
#
# This image expects to have the Docker socket bind-mounted into the container.
# If "/root/.dockercfg" is bind mounted in, it will use that as authorization 
# to a Docker registry.
#
# The standard name for this image is openshift/origin-custom-docker-builder
#

FROM openshift/base-centos7

ENV ACTIVATOR_VERSION 1.3.2
ENV ACTIVATOR_EDITION ${ACTIVATOR_VERSION}
ENV HOME /root

ADD typesafe.repo /etc/yum.repos.d/
ADD ./typesafe-repo-public.asc /tmp/typesafe-repo-public.asc
RUN rpm --import /tmp/typesafe-repo-public.asc
RUN yum upgrade -y
RUN yum install -y java-sdk sbt unzip

ENV ACTIVATOR_ZIP typesafe-activator-${ACTIVATOR_EDITION}.zip

ADD http://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VERSION}/${ACTIVATOR_ZIP} /tmp/${ACTIVATOR_ZIP}
ADD ./build.sh /tmp/build.sh

RUN unzip /tmp/${ACTIVATOR_ZIP} -d /opt
EXPOSE 9000

# CMD ["/tmp/build.sh"]