<http://kate-editor.org/2012/11/02/using-the-projects-plugin-in-kate/>

To define a single project, create the file `.kateproject` in the the project directory:


	{
		"name": "Laravel",
		"files": [{"git": 1}]
	}

To create a project with multiple subprojects, create the file `.kateproject` in the the project **parent** directory:

	{
		"name": "Web projects",
		"projects": [
			{
				"name": "Laravel",
				"files": [{"directory": "laravel", "git": 1}]
			},
			{
				"name": "Codeigniter",
				"files": [{"directory": "codeigniter", "git": 1}]
			}
		]
	}

To navigate prohect files use `CTRL + ALT + o`.
