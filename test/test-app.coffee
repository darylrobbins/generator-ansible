path = require("path")
assert = require("yeoman-generator").assert
helpers = require("yeoman-generator").test
os = require("os")
fs = require("fs")

describe "ansible-generator:app", ->
	
	it "works with prompt", (done) ->
		name = "test-playbook"
		
		helpers.run(path.join(__dirname, "../generators/app"))
		.inDir(path.join(os.tmpdir(), "./test-dir"))
		.withPrompt({
			name: name
		})
		.on "end", ->
		
			assert.file [
				"#{name}/production"
				"#{name}/stage"
				"#{name}/group_vars/.gitkeep"
				"#{name}/host_vars/.gitkeep"
				"#{name}/site.yml"
				"#{name}/roles/.gitkeep"
				"#{name}/README.md"
				"#{name}/Ansiblefile"
			]
			
			assert.noFile [
				"#{name}/Vagrantfile"
			]
			
			done()
		true
	
	it "works with argument", (done) ->
		name = "test-playbook"
		
		helpers.run(path.join(__dirname, "../generators/app"))
		.inDir(path.join(os.tmpdir(), "./test-dir"))
		.withArguments([name])
		.on "end", ->
			
			assert.file [
				"#{name}/production"
				"#{name}/stage"
				"#{name}/group_vars/.gitkeep"
				"#{name}/host_vars/.gitkeep"
				"#{name}/site.yml"
				"#{name}/roles/.gitkeep"
				"#{name}/README.md"
				"#{name}/Ansiblefile"
			]
			
			assert.noFile [
				"#{name}/Vagrantfile"
			]
			
			done()
		true
	
	it "works with vagrant", (done) ->
		name = "test-playbook"
		
		helpers.run(path.join(__dirname, "../generators/app"))
		.inDir(path.join(os.tmpdir(), "./test-dir"))
		.withArguments([name])
		.withOptions({ "vagrant": true })
		.on "end", ->
		
			assert.file [
				"#{name}/production"
				"#{name}/stage"
				"#{name}/group_vars/.gitkeep"
				"#{name}/host_vars/.gitkeep"
				"#{name}/site.yml"
				"#{name}/roles/.gitkeep"
				"#{name}/README.md"
				"#{name}/Ansiblefile"
				"#{name}/Vagrantfile"
			]
			
			done()
		true
	
	true