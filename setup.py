import os, sys
import platform
import subprocess
import fnmatch
import ntpath

##################################
# User Variables need to change
envName = 'test'
##################################

debug = False

# Exit if windows
if platform.system == 'windows':
  exit

packageManager = 'rpm'

def osFedora():
  global packageManager
  packageManager = 'rpm'
def osCentos():
  global packageManager
  packageManager = 'rpm'
def osUnknown():
  print("Your Operation system is Unkown. Feel free to add support")
  exit

def prompGetEnvironment():
  env = input('Please enter the name of the environment[env_wtd]: ')
  if env == '':
    return 'env_wtd'
  return env

def osVersion(version):
  switcher = {  'fedora' : osFedora,
        'centos' : osCentos,
        '*' : osUnknown,
      }
  return switcher.get(version,"osUnkown")

def infoBanner(action):
  print('#####################################')
  print(action)
  print('#####################################')

def exec_command(cmd):
  p = subprocess.Popen(cmd, stdout=subprocess.PIPE,shell=True)
  if debug:
    print(p.communicate(cmd))
    p.wait()
  else:
    p.wait()
    return p.communicate(cmd)

def execCommandVirtualenv(cmd,precmd):
  p = subprocess.Popen(precmd + ";" + cmd, stdout=subprocess.PIPE,shell=True)
  if debug:
    print(p.communicate(cmd))
    p.wait()
  else:
    p.wait()
    return p.communicate(cmd)

def checkRequirements():
  requirements = ['docker',  "python" + platform.python_version_tuple()[0]+'-virtualenv']
  for req in requirements:
    try:
      subprocess.check_call([packageManager, "-qi", req], stdout=subprocess.PIPE)
    except subprocess.CalledProcessError as identifier:
      exit('The requirement ' + req + ' is not installed. Please install it.')
    
def findFile(pattern, path):
  result = []
  for root, dirs, files in os.walk(path):
    for name in files:
      if fnmatch.fnmatch(name,pattern):
        result.append(os.path.join(root,name))
  return result

def findFolder(head_dir, dir_name):
  outputList = []
  for root, dirs, files in os.walk(head_dir):
      for d in dirs:
          if d.upper() == dir_name.upper():
              outputList.append(os.path.join(root, d))
  return outputList

def setSymlinkSeLinux():
  infoBanner('Set Symlink')
  i = 0
  print('Please select the number of the source part of the symbolic link.')
  findings = findFile("*selinux*",'/usr/lib64')
  for f in findings:
    print(str(i) + ": " + f)
    i += 1
  choose = int(input('Your Choose system-selinux folder:'))
  pythonversion = platform.python_version_tuple()[0] + '.' + platform.python_version_tuple()[1]
  exec_command('cd ' + envName + '; ln -s /usr/lib64/python' + platform.python_version_tuple()[0] + '.'+ platform.python_version_tuple()[1] + '/site-packages/selinux' +  ' ' + './lib/python' + platform.python_version_tuple()[0] + '.'+ platform.python_version_tuple()[1] + '/site-packages/selinux')
  exec_command('cd ' + envName + '; ln -s ' + findings[choose] + ' ./lib/python' + platform.python_version_tuple()[0] + '.'+ platform.python_version_tuple()[1] + '/site-packages/' + ntpath.basename(findings[choose]))
  exec_command('setsebool -P container_manage_cgroup on')

ansibleConfig = [
  '[default]',
  'squash_actions = apk,apt,dnf,homebrew,package,pacman,pkgng,yum,zypper',
  'roles_path    = roles',
  'stdout_callback = yaml',
  'bin_ansible_callbacks = True',
  '[ssh_connection]',
  'pipelining = True',
  '[galaxy]',
  'role_skeleton = ansible-skeleton/role',
  'role_skeleton_ignore = ^.git$,^.*/.git_keep$']

def provideAnsibleConfig():
  infoBanner('Set Ansible Configuration')
  with open("./ansible.cfg", "w") as textFile:
    for line in ansibleConfig:
      textFile.write(line)
      textFile.write('\n')

def installMolecule():
  infoBanner('Install Molecule')
  execCommandVirtualenv('pip install molecule[docker]','source ' + envName + '/bin/activate')

def createAnsibleRole(role):
  infoBanner('Create Ansible Role')
  print(exec_command('pwd;ansible-galaxy init ' + role))
  exec_command('mv ' + role + ' while_true_do.' + role)
  #execCommandVirtualenv( 'cd while_true_do.' + role + ';' + 'molecule init scenario -r while_true_do.' + role,'source ' + envName + '/bin/activate')
  #execCommandVirtualenv('mv while_true_do.'+ role + '/molecule.yml while_true_do.' + role + 'molecule/default/molecule.yml','source ' + envName + '/bin/activate')

def lastSteps(role):
  infoBanner('Set last Steps')
  print('Please execute following last steps')
  print('Review and Modify all "TODO" steps')
  print('   ' + str(exec_command('grep -r "TODO" while_true_do.' + role)[0].decode("utf-8")))


# linux_distribution need to replace until Python 3.5 see https://docs.python.org/2/library/platform.html#unix-platforms

osVersion(platform.linux_distribution())
checkRequirements()
envName = prompGetEnvironment()
exec_command('git clone https://github.com/while-true-do/ansible-skeleton.git')
infoBanner("Erstelle Environment")
exec_command('virtualenv ' + envName)
exec_command('source ' + envName + "/bin/activate")
execCommandVirtualenv('pip install ansible','source ' + envName + "/bin/activate")
setSymlinkSeLinux()
provideAnsibleConfig()
installMolecule()
role = input('Enter the name of the ansible role: ')
createAnsibleRole(role)
lastSteps(role)