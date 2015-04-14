##Activator Builder
This project can be used two ways:

* As an Openshift source to image builder.
* As an Openshift custom builder.

The source to image builder will wrap all the code and artifacts for a play application into a Docker image and run `play run`.
The custom builder will checkout a play app, run `activator docker:stage` and then build a docker image with the contents of `target/docker`.

You can import the source to image version by running `osc create -f buildConfig.json`