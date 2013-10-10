Workflow for CodeIgniter and GitHub
===================================

This is my simple Git workflow for CodeIgniter. I never work on the master branch, instead I like to make a branch for every single issue/bug/feature so I always start a new branch for each and all my commits are in the working branch, never in the master branch. This gives me the ability to:

- always have deployable code in the master branch.
- be able to abandon branches that turn out wrong and always head back to master.
- apply quick bug fixes to the master without affecting branches with work in progress.

## Fork and clone

Go to https://github.com/EllisLab/CodeIgniter and press fork button.

Clone your GitHub repository into your PC

	git clone git@github.com:Stolz/CodeIgniter.git codeigniter
	cd  codeigniter

Register EllisLab's CodeIgniter repository as "upstream"

	git remote add upstream git://github.com/EllisLab/CodeIgniter.git

## Working on a new issue/bug/feature

Before doing anything make sure you're up to date with all the changes made by other developers on the remote master branch of your forked repository

	git checkout master
	git pull

So for creating a branch to work on a new issue/bug/feature

	git branch my_new_branch
	git checkout my_new_branch

A shortcut for the above commands is

	git checkout -b my_new_branch

Do your changes and commit them early and often to your working branch

	git add path/to/filename.php
	git commit

When you are happy with the changes you made, push them to your remote for other developers be able to see them

	git push

## Moving changes from your working branch to master branch

When the issue/bug/feature you are working on is done, it's time to merge the changes to the master branch.

Before merging the changes of your working branch to the master branch, it's a good practice to to integrate any commits to master branch into my current branch. That's done using `git rebase`. Rebasing your working branch before putting into master is really important because it allows you to make sure your new code still works and if it doesn't, you can can deal with any merge issues before the code goes to your master branch.

	git checkout master
	git pull
	git checkout my_new_branch
	git rebase master

A shortcut for the above commands is

	git fetch origin master
	git rebase origin/master

`rebase` integrate any commits to master branch into my current branch but keeping your changes on top of the changes made to the master branch. You can also use __rebase -i__ to to group several of your commits into a single commit (read further for more details).

After deailing with any possible conflicts and making sure your new code works, it's time to merge your branch into master.

	git checkout master
	git merge my_new_branch

Optionally, delete the finsihed branch

	git checkout master
	git branch -d my_new_branch

And finally push to the remote

	git push

## Grouping commits

Frequent commits are great to manage your own work and give many checkpoints to roll back to if needed. But adding dozens of commits to the project for a simple feature can be overwhelming for other developers. You can use the -i (or --interactive) option of rebase in order to squash several (or all) of your commits into a single commit, or to organize your changes as a reduced number of commits.

	git rebase -i master

Git will display an editor window with a list of the commits to be modified. For the commit messages you want to keep, leave the word "pick" intact. For the commit messages you want to ignore replace the word "pick" with "fixup". For the commit messages you want to squash together, replace the word "pick" with "squash". Save and close the file and a new editor window will ask for the new common commit message.


## Gettign changes from upstream

	git checkout master
	git fetch upstream
	git merge upstream/master

¿conflicts?

	git mergetool


http://reinh.com/blog/2009/03/02/a-git-workflow-for-agile-teams.html
http://gweezlebur.com/2009/01/19/my-git-workflow.html
http://blog.hasmanythrough.com/2008/12/18/agile-git-and-the-story-branch-pattern