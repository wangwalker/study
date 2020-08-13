## Git global setup

```bash
git config --global user.name "Yapeng Wang"
git config --global user.email "330722864@qq.com"
```

## Create a new repository

```bash
git clone https://url-of-your-git-account/project-name.git 
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
git remote add origin git@url-of-your-git-account.project-name.git
git add .
git commit -m "Initial commit"
git push -u origin master
```

## Push an existing Git repository

```bash
cd existing_repo
git remote rename origin old-origin
git remote add origin git@url-of-your-git-account.project-name.git
git push -u origin --all
git push -u origin --tags
```