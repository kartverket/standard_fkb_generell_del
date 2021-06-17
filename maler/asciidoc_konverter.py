# kladdebok for automatisering av adoc til pdf/html dokument

# pip install pygit2

import pygit2
import os, shutil, stat

def init_remote(repo, name, url):
    # Create the remote with a mirroring url
    remote = repo.remotes.create(name, url, "+refs/*:refs/*")
    # And set the configuration option to true for the push command
    mirror_var = "remote.{}.mirror".format(name.decode())
    repo.config[mirror_var] = True
    # Return the remote, which pygit2 will use to perform the clone
    return remote

def del_rw(action, name, exc):
    # hack som fjerner readonly filer ved stopp i shutil.rmtree
    os.chmod(name, stat.S_IWRITE)
    os.remove(name)    


#1 Clone Git Repo
repo_url = 'https://bitbucket.statkart.no/scm/prof/dokumentasjon_fkb.git'
repo_path = os.path.join(os.getcwd(),'gitrepo')
shutil.rmtree(repo_path, ignore_errors=False, onerror=del_rw) 
print('Cloning:')
print(repo_url)
print('..into:')
print(repo_path)
repo = pygit2.clone_repository(repo_url, repo_path) # Clones a non-bare repository

#2 @ *Produktspesifikasjon*adoc do:
for root, dirs, files in os.walk(repo_path, topdown=False):
   for name in files:
       filename, fileext = (os.path.splitext(os.path.join(root, name)))
       if fileext == '.adoc' and 'Produktspesifikasjon' in filename:
           print('Found: '+os.path.join(root, name))
           # do work

#Vurdert forskjellige metoder for å konvertere adoc til pdf/html

#1 adoc to something using asciidoctor docker image
# trolig enklest å vedlikeholde, men fordrer installasjon av docker miljø
# https://github.com/asciidoctor/docker-asciidoctor
# prerequisite: docker pull asciidoctor/docker-asciidoctor
# $ cd [directory to where my book.adoc is located]
# $ docker run --rm -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf mybook.adoc
# konverteringen kalles via via subprocess

#2 adoc to something using ASCIIDOCTOR installed in local ruby environment
# fordrer installasjon av choco pakkestyrer + ruby + asciidoctor rubygem
# konverteringen kalles via subprocess

#3 adoc to something using ASCIIDOCTORFX binary direkte.
# Har forespurt AsciidocFX chatroom om mulighet for å kalle AsciidocFX.exe med kall. 
# C:\_BIN\AsciidocFX_Windows\AsciidocFX>AsciidocFX.exe -i documentation.adoc -o documentation.pdf   
# konverteringen kan kalles via subprocess
