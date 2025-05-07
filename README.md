# 🚀 Beginner-Friendly CI/CD Pipeline for Website Deployment

This repository provides a step-by-step guide and working code/scripts to implement a basic **CI/CD pipeline** that:

* Monitors a GitHub repository for commits
* Automatically pulls updated files to your server
* Updates your website content via `rsync`
* Restarts the Nginx web server to reflect changes

---

## 📁 Project Structure

```
.
├── check_github.py          # Python script to check for GitHub changes
├── ci_cd_wrapper.sh         # Wrapper script that ties Python + Bash
├── update_website.sh        # Bash script to pull, sync, restart nginx
├── last_commit.txt          # Tracks last GitHub commit SHA
├── html/                    # Folder containing website HTML/CSS content
│   └── index.html           # Example website home page
```

---

## 🧑‍💻 STEP-BY-STEP SETUP GUIDE

### ✅ STEP 1: Launch EC2 and Clone the Repository inside EC2 instance 

```bash
ssh ubuntu@your-server-ip
git clone https://github.com/XXRadeonXFX/my-website.git
cd my-website
```

### ✅ STEP 2: Install Required Tools

```bash
source updater.sh
```
 OR run commands manually to update server

```bash
# Install Nginx
sudo apt update
sudo apt install nginx
sudo systemctl start nginx


# Install Python and Required Packages
sudo apt install python3 python3-pip
pip3 install requests
```

### ✅ STEP 3: Configure Nginx Root Directory

Change the default web root:

```bash
sudo nano /etc/nginx/sites-available/default
```

Replace:

```nginx
root /var/www/html;
```

With:

```nginx
root /var/www/my-website;
```

Then restart Nginx:

```bash
sudo systemctl restart nginx
```

### ✅ STEP 4: Create Web Directory ( This step is optional in case cronjob throws error )

```bash
sudo mkdir -p /var/www/my-website/html
sudo chown -R ubuntu:www-data /var/www/my-website
```

### ✅ STEP 5: Make Scripts Executable

```bash
chmod +x update_website.sh
chmod +x ci_cd_wrapper.sh
```

---

## ⚙️ Script Behavior

### `check_github.py`

* Uses GitHub API to fetch the latest commit
* Compares it with `last_commit.txt`
* Exits with `0` if there's a new commit (trigger update)

### `update_website.sh`

* Pulls the latest files from GitHub
* Syncs `html/` folder content to `/var/www/my-website/html` using `rsync`
* Restarts Nginx

### `ci_cd_wrapper.sh`

* Runs the Python script
* If `check_github.py` exits with code `0`, it runs `update_website.sh`

---

## ⏲️ STEP 6: Schedule Cron Job (Every 5 Minutes)

```bash
crontab -e
```

Add this line:

```cron
*/5 * * * * /home/ubuntu/my-website/ci_cd_wrapper.sh >> /home/ubuntu/my-website/ci_cd.log 2>&1
```

---

## 🧪 STEP 7: Testing the Pipeline

1. Make a change to `html/index.html` in your GitHub repo
2. Wait for 5 minutes or run the wrapper script manually:

3. Watch log output:

```bash
tail -f /home/ubuntu/my-website/ci_cd.log
```

4. Visit `http://<your-ec2-public-ip>` and verify updates

---

## 🛠️ Useful Commands

```bash
sudo nano /etc/nginx/sites-available/default
systemctl status cron
grep CRON /var/log/syslog
```

---

## 🙌 Credit

This guide was inspired by Hero Vired CI/CD Assignment and adjusted for beginner DevOps engineers.

---

## 📎 License

MIT License

---

## 🤝 Contributions

PRs welcome if you'd like to extend it with GitHub Webhooks, Docker support, or advanced monitoring!
