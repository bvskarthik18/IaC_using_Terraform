# Configure GIT
## CloudShell comes with git preinstalled  

1. Verify if **git** is installed or not:
    ```bash
    git --version
    ```
2. Go to your directory  
   First, make sure you’re inside the directory that contains your code:
   ```bash
   ls
   pwd
   ```
   If needed, move into it:
   ```bash
   cd your-project-folder
   ```
3. Initialize Git
   ```bash
   git init
   ```
4. Set your identity (required for commits):

    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your-email@example.com"
    ```
5. Check if your identity is configured correctly:

    ```bash
    git config --global --list
    ```
6. Add and Commit your code
   ``` bash
   git add .
   git commit -m "Initial Commit"
   ```
7. Create a new Git Repository
   - Go to your Git provider (e.g., GitHub)
   - Create a "New Repository"
   - Don't initialize with README, .gitignore, or license
   - Copy the repository URL (HTTPS or SSH)
8. Connect Local Repository to GitHub
   ```bash
   git remote add origin https://github.com/username/your-new-repo.git
   ```
   Confirm:
   ``` bash
   git remote -v
   ```
9. Push to the repo  
    If your default branch is `main`:
    ```bash
    git branch -M main
    git push -u origin main
    ```
    If it's `master`:
    ```bash
    git push -u origin master
    ```
    When prompted:
    - Username -> Your Git username
    - Password -> a Personal Access Token (PAT) (not your Git password)
    - To store credentials permanently, run below command
      ```bash
      git config --global credential.helper store
      ```
    - Follow step 10, if you have not created Personal Access Token
10. Create GitHub Personal Access Token:
    - Go to `GitHub.com` → `Settings` → `Developer settings`
    - Click "Personal access tokens" → "Tokens (classic)"
    - Click "Generate new token"
    - Give it a descriptive name
    - Select scopes (at minimum: repo)
    - Copy the token immediately (won't be shown again!)
    
