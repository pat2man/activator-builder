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
# The standard name for this image is ticketfly/sbt-0.13.5-scala-0.9.2-builder
#

FROM openshift/origin-base

ENV SBT_VERSION 0.13.5

ADD https://get.docker.com/builds/Linux/x86_64/docker-latest /buildroot/docker
ADD bintray-sbt-rpm.repo /etc/yum.repos.d/
RUN yum upgrade -y
RUN yum install -y java-sdk sbt-${SBT_VERSION} git

ADD bin/build.sh /buildroot/build.sh

EXPOSE 9000

WORKDIR /buildroot

CMD ["/buildroot/build.sh"]