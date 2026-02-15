
# Jenkins Freestyle Job with GitHub Integration

This guide outlines the process of creating a Jenkins Freestyle job that compiles and executes a simple Java script, then commits and pushes the changes to a GitHub repository using Execute Shell commands.

## 1. Java Script

The following Java script, `HelloWorld.java`, demonstrates a basic application that prints a message to the console and appends a timestamp to a file named `activity.log`.

```java
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;

public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello from Jenkins Java Script!");
        try {
            FileWriter writer = new FileWriter("activity.log", true);
            writer.write("Job executed at: " + LocalDateTime.now() + "\n");
            writer.close();
            System.out.println("Successfully updated activity.log");
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }
}
```

## 2. Jenkins Execute Shell Commands

The Jenkins Freestyle job will utilize an "Execute Shell" build step to perform the following actions:

1.  **Compile the Java script**: `javac HelloWorld.java`
2.  **Run the Java script**: `java HelloWorld` (This will create or update `activity.log`)
3.  **Stage changes**: `git add .` (Adds `activity.log` to the staging area)
4.  **Commit changes**: `git commit -m "Jenkins Auto-update: $(date)" || echo "No changes to commit"` (Commits the changes with a timestamped message. The `|| echo "No changes to commit"` part prevents the job from failing if there are no new changes to commit.)
5.  **Push to GitHub**: `git push origin HEAD:main` (Pushes the committed changes to the `main` branch of the remote GitHub repository. Ensure your Jenkins agent has appropriate GitHub credentials configured, either via SSH keys or a credential helper.)

Here is the complete shell script to be used in the Jenkins "Execute Shell" build step:

```bash
#!/bin/bash

# 1. Compile the Java script
echo "Compiling HelloWorld.java..."
javac HelloWorld.java

# 2. Run the Java script
echo "Running HelloWorld..."
java HelloWorld

# 3. Configure Git (Optional if already configured globally on Jenkins agent)
# git config --global user.email "your-email@example.com"
# git config --global user.name "Jenkins Job"

# 4. Stage changes (e.g., the activity.log file updated by Java)
echo "Staging changes..."
git add .

# 5. Commit changes
# Use || true to prevent job failure if there are no changes to commit
echo "Commiting changes..."
git commit -m "Jenkins Auto-update: $(date)" || echo "No changes to commit"

# 6. Push to GitHub
# Note: This assumes Jenkins has credentials configured (SSH or Credential Helper)
echo "Pushing to GitHub..."
git push origin HEAD:main
```

## 3. Setting up the Jenkins Freestyle Job

Follow these steps to configure your Jenkins Freestyle job:

1.  **Create a New Item**: In Jenkins, click on "New Item" on the left-hand side.
2.  **Enter Item Name and Select Freestyle Project**: Provide a name for your job (e.g., `GitHub-Java-Updater`) and select "Freestyle project", then click "OK".
3.  **General Section**: (Optional) Add a description for your job.
4.  **Source Code Management**: Select "Git".
    *   **Repository URL**: Enter the URL of your GitHub repository (e.g., `https://github.com/your-username/your-repo.git` or `git@github.com:your-username/your-repo.git`).
    *   **Credentials**: Add or select appropriate credentials for Jenkins to access your GitHub repository. This could be a username/password for HTTPS or an SSH private key.
    *   **Branches to build**: Specify `*/main` (or `*/master` if your default branch is `master`).
5.  **Build Triggers**: Configure how you want the job to be triggered (e.g., "Poll SCM" to periodically check for changes, or "Build periodically" to run at fixed intervals).
6.  **Build Steps**: Click "Add build step" and select "Execute shell".
    *   Paste the shell script provided in Section 2 into the "Command" text area.
7.  **Post-build Actions**: (Optional) Configure any post-build actions, such as email notifications.
8.  **Save**: Click "Save" to create your Jenkins job.

## 4. GitHub Repository Setup

Before running the Jenkins job, ensure your GitHub repository is set up correctly:

1.  **Create a new repository**: If you don't have one, create a new public or private GitHub repository.
2.  **Initial Commit**: Clone the repository locally, add the `HelloWorld.java` file to it, commit, and push it to the `main` branch. This ensures the Jenkins job has the Java file to compile.
    ```bash
    git clone https://github.com/your-username/your-repo.git
    cd your-repo
    # Copy HelloWorld.java into this directory
    git add HelloWorld.java
    git commit -m "Add initial HelloWorld.java"
    git push origin main
    ```

## References

*   [Jenkins Freestyle Project](https://www.jenkins.io/doc/book/pipeline/getting-started/#freestyle-project) [1]
*   [Git SCM Plugin for Jenkins](https://plugins.jenkins.io/git/)[2]
*   [Java FileWriter Class](https://docs.oracle.com/javase/8/docs/api/java/io/FileWriter.html)[3]
