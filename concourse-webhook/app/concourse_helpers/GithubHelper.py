from github import Github
import hmac, json
from hashlib import sha1
import subprocess
import tempfile
import re

class GithubHelper(object):
  def __init__(self, secret, token, org, concourse):
    self.secret = secret
    self.token = token
    self.org = org
    self.concourse = concourse

  def check_auth(self, message, header, responseHelper):
    sha_name, sig = header.split('=')
    if sha_name != 'sha1':
      return responseHelper.create_response('must have sha1 secret', 403)
    mac = hmac.new(bytes(self.secret, 'latin-1'), msg=message, digestmod='sha1')
    if not hmac.compare_digest(str(mac.hexdigest()), str(sig)):
      return responseHelper.create_response('wrong secret', 403)

  def process_event(self, event, message, responseHelper):
    if(event == 'push'):
      branch = message['ref'].split('/', 2)[2]
      repo = message['repository']['name']
      try:
        g = Github(self.token)
        r = g.get_repo("{}/{}".format(self.org,repo))
        f = r.get_file_contents('/Concoursefile.yaml', ref=branch)
      except:
        return responseHelper.create_response('you need a Concoursefile.yaml', 400)
      c = self.post_to_concourse(f.decoded_content, repo, branch, responseHelper)
      if(c):
        return c
      return responseHelper.create_response('this was a push to {} in {}'.format(branch,repo), 200)
    return responseHelper.create_response("we don't do event {} yet".format(event), 501)

  def fix_fly_out(self, line):
    ansi_escape = re.compile(r'(\x9B|\x1B\[)[0-?]*[ -/]*[@-~]|\n')
    line = ansi_escape.sub('', line)
    return line

  def post_to_concourse(self, yaml, repo, branch, responseHelper):
    with tempfile.NamedTemporaryFile() as temp:
      temp.write(yaml)
      temp.flush()
      (err, out) = subprocess.getstatusoutput("echo y | /root/fly -t demo set-pipeline -p {}-{} -c {}".format(repo, branch, temp.name))
      out = self.fix_fly_out(out)
      temp.close()
      if(err):
        return responseHelper.create_response('Concourse didn\'t like this: {}'.format(out), 400)
    out = subprocess.getoutput("/root/fly -t demo unpause-pipeline -p {}-{}".format(repo, branch))
    return responseHelper.create_response('Posted to Concourse: {}'.format(out), 200)
