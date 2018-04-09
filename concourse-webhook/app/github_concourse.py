#!/bin/python3

import configparser
from flask import Flask, request
from concourse_helpers import ResponseHelper, GithubHelper

config = configparser.ConfigParser()
config.read('/webhook/github_concourse.ini')

app = Flask(__name__)

app.config.update(dict(
  PORT=config['DEFAULT'].getint('port', 8080),
  TOKEN=config['DEFAULT']['gh_token'],
  SECRET=config['DEFAULT']['gh_secret'],
  ORG=config['DEFAULT']['gh_org'],
  CONCOURSE=config['DEFAULT']['concourse']
))

responseHelper = ResponseHelper.ResponseHelper()
githubHelper = GithubHelper.GithubHelper(
  app.config.get('SECRET'),
  app.config.get('TOKEN'),
  app.config.get('ORG'),
  app.config.get('CONCOURSE')
)

@app.route('/health', methods=['GET'])
def health_check():
  return responseHelper.create_response('OK', 200)  

@app.route('/webhook', methods=['POST'])
def webhook():
  header_sig = request.headers.get('X-Hub-Signature')
  auth = githubHelper.check_auth(request.get_data(), header_sig, responseHelper)
  if(auth):
    return auth
  event = request.headers.get('X-GitHub-Event')
  if event == 'ping':
    return responseHelper.create_response('pong', 200)
  proc = githubHelper.process_event(event, request.get_json(), responseHelper)
  if(proc):
    return proc
  return responseHelper.create_response("doesn't look like a Github event", 501)

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=app.config.get('PORT'), debug=False, threaded=True)
