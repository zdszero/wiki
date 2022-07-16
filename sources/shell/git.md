% Git

## CONCEPTS

### areas

```
                            index
           push     commit /      \ stage/unstage
remote repo ⇆  local repo     ←    workspace
					 fetch
```

### variables

- `HEAD` names the commit on which you based the changes in the working tree.
- `FETCH_HEAD` records the branch which you fetched from a remote repository with your last git fetch invocation.
- `ORIG_HEAD` is created by commands that move your `HEAD` in a drastic way, to record the position of the `HEAD` before their operation, so that you can easily change the tip of the branch back to the state before you ran them.
- `MERGE_HEAD` records the commit(s) which you are merging into your branch when you run git merge.
- `REBASE_HEAD` records the commit(s) which you are merging into your branch when you run git merge.
- `CHERRY_PICK_HEAD` records the commit which you are cherry-picking when you run git cherry-pick.

### reflog

### stash

## UNDOING CHANGES

### restore

restore working tree files

### revert

revert a previous commit and record a new revert commit

```
# cancel certain commit
git revert HEAD
git revert HEAD~1
```

### reset

reset to certain commit, the latter commits are all deleted 

```
git reset <mode> <commit>
<mode>
	--soft
		Doesn't touch your index file and working tree, leave all your changes to files
"Changes to be committed", git status can show
	--mixed
		Reset the index and the other action is just like soft
	--hard
		Reset the index and working tree, discard all the changes
	--merge
		Reset the merge
```

use with other variables

### checkout

move HEAD to certain commit

```
git checkout [--detach] <commit>
```

### restore

restore working tree files

```
# restore unstaged part, staged part unchanged
git restore -W path
git restore --worktree path
# unstage all the staged part
git restore [-S|--staged]  path
```

using with `git reflog`

qq

## REMOTE

### clone

- git clone origin-url (non-bare)

Clone a local branch `master(HEAD)` tracking a remote branch `origin/master`

- git clone –bare origin-url

Clone a local branch which is totally independent, with no expectations of fetching again.

- git clone –mirror origin-url

Make your local repo identical to the origin every time you use `git remote update`, and all the refs will be overwritten from origin.

### push

`git push [<options>] [<repository> [<refspec>]]`

__-u --set-upstream__

used by argument-less git-pull

### pull

`git push [<options>] [<repository> [<refspec>]]`

## BRANCH

### branch

```
# display all local repos
git branch
# display all remote repos
git branch -r
# display all repos
git branch -a

# rename
git branch -m <old-br> <new-b
```

### checkout

switch branch 

```
# change workspace to <br> and create <br> if it doesn't exist
git checkout <br>
```

### merge

merge another branch into current branch

**what if conflict happens**

1. use git status to see the conflicted files
2. use your text editor (merge tool) to resolve the merge
3. git add <file>
4. git merge —continue

### rebase

switch to upstream, and applies all the commits in current branch into the upstream

```
      D---E test
     /
A---B---C---F master

git merge test
      D--------E
     /          \
A---B---C---F----G   test, master

after git rebase on test branch
A---B---D---E---C'---F'   test ← HEAD
						master
```

**transplant**
