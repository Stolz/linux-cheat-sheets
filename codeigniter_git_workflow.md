Codeigniter workflow for pull requests
======================================

(source and credits: http://d.hatena.ne.jp/Kenji_s/20110828/1314495301)

## Fork and clone

Go to https://github.com/EllisLab/CodeIgniter and press fork button.

Clone your GitHub repository into your PC

	git clone git@github.com:Stolz/CodeIgniter.git stolz_ci
	cd  stolz_ci

Resister EllisLab's CodeIgniter repository as "upstream"

	git remote add upstream git://github.com/EllisLab/CodeIgniter.git

## Working in local

Create a branch for working in your PC

	git branch my_personal_branch
	git checkout my_personal_branch

Commit your change to your working branch in your PC

	git add path/to/filename.php
	git commit

## Get upstream changes

Get changes of EllisLab's repository into your repository. CI develop must be always done in the develop branch, so we have to move to that branch first

	git checkout develop
	git pull upstream develop

Move changes of the develop branch into your working branch

	git checkout my_personal_branch
	git rebase develop my_personal_branch

If you've got any conflicts, edit involved files (is recommended to use git mergetool)

	git add file_name
	git rebase --contiune

# Create a branch for pull request

	git checkout my_personal_branch
	git checkout -b branch_for_pull_request

Squash your multiple commits in branch_for_pull_request branch into one commit. Use "git rebase -i"

	git rebase -i develop

Your editor will be fired up, then replace "pick" for the second and subsequent commits with "squash".

# Push your changes into your GitHub repository

	git push origin branch_for_pull_request

# Send pull request to EllisLab

Go to your repository page on GitHub. Confirm that the branch is right, then click "Pull Request" button.


