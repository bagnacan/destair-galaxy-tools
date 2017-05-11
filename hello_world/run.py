#! /usr/bin/env python
import sys
import argparse
import subprocess
import re
from bioblend import galaxy

parser = argparse.ArgumentParser(description='run hello world via galaxy api')
parser.add_argument('-i','--input', nargs='?', default='hello world',help='input')
parser.add_argument('-u','--user', nargs='?', help='username') # required=True
parser.add_argument('-p','--password', nargs='?', help='password')
parser.add_argument('-port','--port', nargs='?', help='port', required=True)
args = parser.parse_args() #wrap into vars() to get a dict

print 'in: '+args.input

key = re.search('api_key":\s+"([^"]+)',
	subprocess.Popen(
		['curl','--user',"%s:%s"%(args.user,args.password),'http://127.0.0.1:'+args.port+'/api/authenticate/baseauth'],
		stdout=subprocess.PIPE, 
		stderr=subprocess.PIPE
	).stdout.read()
)
key = key.group(1)
gi = galaxy.GalaxyInstance(url='http://127.0.0.1:'+args.port, key=key)
gi.jobs.get_jobs()

for history in gi.histories.get_histories():
	gi.histories.delete_history(history['id'], purge=True)

# user = filter(lambda x: x['email'] == username, gi.users.get_users())[0] # grep
# print gi.users.create_user_apikey(user['id'])
# GET -C "%s:%s"%(args.user,args.password) http://127.0.0.1:+args.port/api/libraries/
# curl --user "%s:%s"%(args.user,args.password) http/api/libraries?key=key

def run_app():
	history = gi.histories.create_history(name='hello world (app)') # gi.histories.get_most_recently_used_history()
	upload = gi.tools.paste_content(args.input,history['id']) # gi.tools.upload_file('hello_world.in',history['id'])
	input = upload['outputs'][0]
	tool = gi.tools.get_tools(name='hello world')[0]
	results = gi.tools.run_tool(history['id'],tool['id'],{'id' : input['id']})
	out = gi.datasets.download_dataset(results['outputs'][0]['id'],wait_for_completion=True)
	print 'app: '+out.rstrip('\r\n')

def run_wf(): #use purged=false because db is permanent, but object store needs to be purged
	for workflow in gi.workflows.get_workflows(): # gi.workflows.get_workflows(name='hello world')
		#gi.workflows.export_workflow_to_local_path(workflow['id'],'hello_world.workflow',use_default_filename=False)
		gi.workflows.delete_workflow(workflow['id'])
	workflow = gi.workflows.import_workflow_from_local_path('hello_world.workflow')

	history = gi.histories.create_history(name='hello world (wf)') # gi.histories.get_most_recently_used_history()
	upload = gi.tools.paste_content(args.input,history['id']) # gi.tools.upload_file('hello_world.in',history['id'])

	input = gi.workflows.get_workflow_inputs(workflow['id'], label='upload')
	if len(input) == 0:
		input = list(gi.workflows.show_workflow(workflow['id'])['inputs'].keys())

	datamap = dict()
	datamap[input[0]] = { 'src':'hda', 'id':upload['outputs'][0]['id'] } # LibraryDatasetDatasetAssociation (ldda) LibraryDataset (ld) HistoryDatasetAssociation (hda)
	
	results = gi.workflows.run_workflow(workflow['id'], datamap, history_id=history['id']) # gi.workflows.run_workflow(workflow['id'], datamap, history_name='hello world')
	out = gi.datasets.download_dataset(results['outputs'][0],wait_for_completion=True)
	print 'wf: '+out.rstrip('\r\n')

def run_wf_lib():
	for workflow in gi.workflows.get_workflows(): # gi.workflows.get_workflows(name='hello world')
		#gi.workflows.export_workflow_to_local_path(workflow['id'],'hello_world.workflow',use_default_filename=False)
		gi.workflows.delete_workflow(workflow['id'])
	workflow = gi.workflows.import_workflow_from_local_path('hello_world.workflow')
	for library in gi.libraries.get_libraries(deleted=False):
		for folder in gi.libraries.get_folders(library['id']):
			gi.folders.delete_folder(folder['id'])
		gi.libraries.delete_library(library['id'])

	library = gi.libraries.create_library('hello world') # only possible if user is admin
	upload = gi.libraries.upload_file_contents(library['id'],args.input)[0] # gi.libraries.upload_file_from_local_path(library['id'],'hello_world.in')

	input = gi.workflows.get_workflow_inputs(workflow['id'], label='upload')
	if len(input) == 0:
		input = list(gi.workflows.show_workflow(workflow['id'])['inputs'].keys())

	datamap = dict()
	datamap[input[0]] = { 'src':'ld', 'id':upload['id'] } # LibraryDatasetDatasetAssociation (ldda) LibraryDataset (ld) HistoryDatasetAssociation (hda)
	
	history = gi.histories.create_history(name='hello world (wf lib)') # gi.histories.get_most_recently_used_history()

	results = gi.workflows.run_workflow(workflow['id'], datamap, history_id=history['id'], import_inputs_to_history=True) # gi.workflows.run_workflow(workflow['id'], datamap, history_name='hello world')
	out = gi.datasets.download_dataset(results['outputs'][0],wait_for_completion=True)
	print 'wf lib: '+out.rstrip('\r\n')

run_app()
run_wf()
run_wf_lib()
sys.exit(0)