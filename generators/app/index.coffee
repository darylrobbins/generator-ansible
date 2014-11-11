util = require 'util'
path = require 'path'
generators = require 'yeoman-generator'

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
		for folder in defaultFolders
			@mkdir "#{@playbookDir}/#{folder}"
			@write "#{@playbookDir}/#{folder}/.gitkeep", ''
		
		# Inventory Files
		@write "#{@playbookDir}/production", "# file: production\n# Add your production servers to the inventory here."
		@write "#{@playbookDir}/stage", "# file: stage\n# Add your staging servers to the inventory here."
		
		# Main
		@write "#{@playbookDir}/site.yml", "# file: site.yml\n---"
		
		if @options.vagrant
			@write "#{@playbookDir}/Vagrantfile", "TODO"
		
		# Ansiblefile for [librarian-ansible](https://github.com/bcoe/librarian-ansible)
		@write "#{@playbookDir}/Ansiblefile", "#!/usr/bin/env ruby\n#^syntax detection\n\nsite \"https://galaxy.ansible.com/api/v1\""
		
		# Create README
		@write "#{@playbookDir}/README.md", "# #{@name}\n`#{@name}` is a great ansible playbook.\n\n# Setup\n`gem install librarian-ansible`\n`librarian-ansible install`\n\n# Usage\n## Development (if you used `--vagrant` flag: `vagrant up`\nWhen you make changes, run `vagrant provision` to update your vms.\n## Production\n`ansible-playbook -i production site.yml`"