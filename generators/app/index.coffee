util = require 'util'
path = require 'path'
generators = require 'yeoman-generator'
handlebars = require 'handlebars'

module.exports = class AnsibleGenerator extends generators.NamedBase

	constructor: (args, options, config) ->
		generators.Base.apply(@, arguments)
		@name = @args[0]
		@option 'vagrant'

	askFor: ->
		cb = @async()
		
		prompts = []
		unless @name?
			prompts.push
				name: 'name'
				message: "What's the playbook named?"

		if prompts.length
			@prompt(prompts, (props) =>
				@name = props.name
				cb()
			)
		else
			cb()

	createPlaybook: ->
		# TODO: handle @name == '.' ?
		@playbookDir = @name
		@mkdir @playbookDir
		
		# Folders
		defaultFolders = [
			'roles'
			'host_vars'
			'group_vars'
		]
		
		# Example Files
		@mkdir "#{@playbookDir}/roles"
		@write "#{@playbookDir}/roles/.gitkeep", ''
		@mkdir "#{@playbookDir}/host_vars"
		@src.copy "host_vars_example", "#{@playbookDir}/host_vars/example"
		@mkdir "#{@playbookDir}/group_vars"
		@src.copy "group_vars_example", "#{@playbookDir}/group_vars/example"
		
		# Inventory Files
		@src.copy "production", "#{@playbookDir}/production"
		@src.copy "stage", "#{@playbookDir}/stage"
		
		# Main
		@src.copy "site.yml", "#{@playbookDir}/site.yml"
		
		if @options.vagrant
			@src.copy "Vagrantfile", "#{@playbookDir}/Vagrantfile"
			@src.copy "development", "#{@playbookDir}/development"
		
		# Ansiblefile for [librarian-ansible](https://github.com/bcoe/librarian-ansible)
		@src.copy "Ansiblefile", "#{@playbookDir}/Ansiblefile"
		
		# Create README
		template = handlebars.compile(@src.read('README.md.handlebars'))
		@write "#{@playbookDir}/README.md", template({name: @name})