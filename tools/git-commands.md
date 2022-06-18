# Settings
## global setup

```bash
git config --global user.name "Yapeng Wang"
git config --global user.email "330722864@qq.com"
```

## ssl
自签名证书的涉及到认证异常时：
```bash
git config --global http.sslVerify false
```

# Init repository
## Create a new repository

```bash
# 以下二选一
git clone git@gitlab.com:wangwalker/demo.git
git clone git@url-of-your-git-account.project-name.git
cd pistachio-admin-web
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
```

## Push an existing folder

```bash
cd existing_folder
git init
# 以下二选一
git remote add origin https://gitlab.com/wangwalker/demo.git
git remote add origin git@gitlab.com:wangwalker/demo.git
git add .
git commit -m "Initial commit"
git push -u origin master
```

## Push an existing Git repository

```bash
cd existing_repo
git remote rename origin old-origin
# 以下二选一
git remote add origin https://gitlab.com/wangwalker/demo.git
git remote add origin git@gitlab.com:wangwalker/demo.git
git push -u origin --all
git push -u origin --tags
```

# Branch分支
## Create a new branch
```bash
git branch your_branch_name
```
## Switch to another branch
```bash
git checkout branch_name
# 注意：如果当前分支被修改了，则需要先提交commit，然后才可进行后续操作。
```
## Create a new branch and switch to it
```bash
git checkout -b new_branch_name

# 实际上，这是下面两个操作的简写：
git branch new_branch_name
git checkout new_branch_name
```
## Delete a branch
```bash
git branch -d branch_name
```
## Merge a branch to master
```bash
git checkout master
git merge branch_to_be_merged
```
如果在合并过程中出现冲突，例如如下
```bash
Auto-merging index.html
CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.
```
可以根据提示信息手动删除一个冲突区域，然后再对每个文件使用 `git add` 命令来将其标记为冲突已解决。

也可以运行 git mergetool，用可视化合并工具帮助解决冲突问题。
