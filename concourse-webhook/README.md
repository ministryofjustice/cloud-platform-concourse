# Concourse webhook
Receives push events from Github and passes them to Concourse

 * app is completely stateless, a basic `docker run` starts it, Helm chart in the chart/ subfolder
 * Uses the 'fly' CLI tool, TODO move root's .flyrc out of the image
 * Github config by going to repo settings->webhooks, put the same address and secret as in github_concourse.ini
