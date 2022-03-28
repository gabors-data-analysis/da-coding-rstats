# Help to connect RStudio to your GitHub account

In this class, we not only learn how to use R and Rstudio but would like to create a good habit for programming.
One main feature of this is to use actively **version control**. Github is a great example of this. RStudio allows a built-in direct connection for GitHub. 
In the following, I give help on how to establish this direct connection.

## 1) Create a **Personal Access Token** at *GitHub*
  To get access RStudio to your GitHub account you need to create a token.
  
  1. Sign in to GitHub
  2. Click on your personal icon button and select [**Settings**](https://github.com/settings/profile) (Note: not the Settings button for one of your repos)
  3. In the left options panel, select [**Developer Settings**](https://github.com/settings/apps)
  4. Select [**Personal Access Tokens**](https://github.com/settings/tokens)
  5. Select **Generate New Token**. This will ask for your GitHub password.
    5.1. You shall give a note of what is this token good for such as *RStudio access* or something similar
    5.2. Set the **Expiration** to **No Expiration**.
    5.3. You should check all **Scopes** boxes. You can safely check all, but at least you need to check: *repo, workflow, write:package, delete:package, notification,  write:discussion*
  6. Click on **Generate Token** at the bottom of the page.
  7. You get your **key**, that **NEED TO SAVE to a temporary file or note**.
      7.1. In case you have not saved the key, you can regenerate it by clicking on your already existing token, but then you will need to update all your apps using this key

Some of these steps are nicely summarized and showed in [Ginny Fahs's blog](https://ginnyfahs.medium.com/github-error-authentication-failed-from-command-line-3a545bfd0ca8).

## 2) Create a new repo on your GitHub

 Good idea to create your own Coding_in_R repo. You can use this repo throughout the course.

## 3) Creating a version-controlled project in RStudio

  1. Open RStudio.
  2. Create a new project (File/New project)
    2.1. Select **Version Control**
    2.2. Select **Git**
    2.3. Add your **repo's url** to clone it by RStudio and select your **path** in your computer, where your repo will be. Click **create project**.
    2.4. A window will pop up and ask for your **GitHub account** then for the **token key**.
    2.5. You have your first GitHub-controlled RStudio project!
    
## 4) Working with version-controlled project in RStudio

  1. Open and work on your created version-controlled project.
  2. You can commit your work by:
      2.1. Going to Tools/Version Control/Commit and a window comes up:
      2.2. Upper left panel you can select files to commit.
      2.3. Upper right panel you must specify your commit message.
      2.4. Lower panel shows the changes in your files.
      2.5. You can Push/Pull with the arrows in the upper-right section of the window.
      2.6. You can follow your history, by changing to *History* from *Changes* button on the top.
      2.7. You can select branches by switching from *master* on the top as well.
  3. You can Push/Pull within the commit window or by clicking on Tools/Version Control/Push or Pull
  4. Now your work has been updated.

## 5) Additional comments

- Try to create a good habit with version control: not only save to your computer but push it to your repo.
- It is good practice to save, commit and push your project after each working session or even more frequently.
- Pay attention to your folder structure.
- Always add readme.md files to your folders, you can add them by *File/New File/Text File* and save them as readme.md.
- You do not need to use RStudio for version control, you can use the *Shell/Terminal* or specific programs as *GitHub Desktop*. RStudio makes the same as these but in a compact way.
- If you are interested in more on this topic, I highly recommend to check out https://happygitwithr.com/ .
