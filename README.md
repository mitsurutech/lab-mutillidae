# OWASP Mutillidae II lab with Docker Compose: practise SQL injection, XSS and LDAP injection on a deliberately vulnerable PHP web application

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml)

A ready-made **web application security lab** for classrooms, from the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning), where schools and colleges give every student their own databases, containers and terminal in the browser. Each student gets their own copy of **OWASP Mutillidae II**, a PHP website that is insecure on purpose, with its **MariaDB database** and its **LDAP directory** already made, to practise **SQL injection, cross-site scripting, command injection, LDAP injection** and more across the OWASP Top 10, at security levels that show what each fix changes. They explain the flaw, and hand in evidence, with nothing installed and no risk to anybody else's machine.

It is one `docker-compose` file, `compose.yaml`, and it runs the same on your own machine as it does on the platform, where every student gets a private copy with no way out to the internet.

## The one rule

**Attack your own copy and nothing else.** Everything in this lab runs inside your own private copy, which has no route to the internet and none to any other student, so the only thing you can reach is the application the lab started for you. Never point a tool at a website, a network or a machine you do not own, in a lab or anywhere else: in the UK that is an offence under the [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), and most countries have a law like it. Learning how weaknesses work is how you build software that does not have them, and a good first conversation in a class is why this rule exists and what responsible disclosure looks like.

## What is in it

| Service | Image | Memory | What it is |
| --- | --- | --- | --- |
| `www` | [`webpwnized/mutillidae:www-2.12.7`](https://hub.docker.com/r/webpwnized/mutillidae) | 512 MB | Apache and PHP running Mutillidae, the site you open |
| `database` | `webpwnized/mutillidae:database-2.12.7` | 384 MB | the MariaDB database Mutillidae keeps its accounts, blog and logs in |
| `directory` | `webpwnized/mutillidae:ldap-2.12.7` | 256 MB | the OpenLDAP directory the LDAP exercises read |

Each image is pinned by its version tag and by its digest, so a rebuild under the same tag cannot change a lab under a class. The three together are limited to 1152 MB, and idle they use roughly 210 MB. The lab is ready in about ten seconds on a laptop. The database is created for you: the lab asks Mutillidae's own set-up page to build it once the database is up, and only then reports itself ready, so "ready" means the site works and there is no first-run warning page to click through.

The images are third-party programs, run unmodified from the project's own public images, so nothing is built here and nothing from this repository is distributed in them. They are published for 64-bit Intel and AMD machines (amd64), which is what the platform runs on; on an Apple silicon laptop Docker runs them under emulation, which works but is slower.

## Using it on the platform

The [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) gives every student their own copy of a lab, in the browser, with a terminal beside it.

**To try it:** open the [container page](https://mitsurutech.co.uk/container), find this lab in **Sample labs** and press Start. No account is needed to try one.

**To set it as work for a class:**

1. In your module, make a task of type **Lab** and choose **In a GitHub repository**.
2. Give `https://github.com/mitsurutech/lab-mutillidae` with the branch `main`. The compose file is the default, `compose.yaml`. Fork the repository first if you want to change the file.
3. Publish. Every student's copy starts from the commit you published, so a later change here does not alter a lab already set.
4. Say in the task what to hand in (see [For teachers](#for-teachers)), and assign it like any other task.

The help manual's [guide to this lab](https://mitsurutech.co.uk/help/lab-mutillidae), its [guide to the security labs](https://mitsurutech.co.uk/help/security-labs) and its [guide to container labs](https://mitsurutech.co.uk/help/labs) cover the rest: what a compose file may say, how much memory a copy gets, and how a teacher opens, watches and marks a student's copy.

No college account yet? [Your first year is free](https://mitsurutech.co.uk/pricing) for up to 50 students, and [signing up](https://mitsurutech.co.uk/signup) takes an email address.

## Running it on your own machine

You need Docker with the Compose plugin. The first start downloads the images, which are large (about 250 MB, 130 MB and 90 MB to download).

```bash
docker compose -f compose.yaml -f local.yaml up
```

Open <http://localhost:8080>.

`local.yaml` publishes the port on `127.0.0.1` only, so the lab is reachable from your own computer and from nowhere else. Stop it with `Ctrl-C`, and remove it with `docker compose -f compose.yaml -f local.yaml down -v`. Run it on a machine you are happy to attack from: the application is insecure on purpose.

## Working through it

1. **Open the site.** The database is already made, so there is nothing to set up. The top of every page says the security level (it starts at 0) and whether hints are on.
2. **Sign in** as `admin` with the password `adminpass` for the pages that ask for an account, or make your own on the **Login/Register** page.
3. **Pick an exercise.** The menu on the left is the OWASP Top 10 with the weaknesses under each: SQL injection (extracting data, bypassing authentication, blind and by timing), HTML and JavaScript injection, command injection, LDAP injection, cross-site scripting, file inclusion, weak sessions and more. **Toggle Hints** shows hints on each page.
4. **Raise the level.** **Toggle Security** in the menu steps from 0 to 1 and then 5, and back to 0. Do the same exercise again: the injected name that finds all forty accounts at level 0 finds none at level 5, which shows what each fix changes.
5. **Start again when you want to.** Stopping and starting the lab gives a fresh Mutillidae, the same as the menu's **Reset DB**.

## For teachers

Nothing in this lab is marked automatically. The student hands in evidence and you mark it, the way you mark any other lab.

**Ask for evidence in two halves.** First, proof of the work: a screenshot of each exercise solved, with the lab's own address visible in the browser so it is clearly their copy. Second, the understanding: for each one, a written explanation in their own words of what the weakness is, the exact input they used and why it worked, what an attacker could do with it, and how the code should have been written. The second half tells you whether it was understood or copied from a walkthrough. For stronger work ask for the same exercise at level 5 as well, and what the code does differently.

**Where it sits in a course.** Mutillidae suits an introduction to web application security and secure coding, because the same exercise at different levels is the same page, insecure and then fixed: input validation, output encoding, parameterised queries and authentication. It also supports the legal and ethical side of a unit: authorisation and scope, the Computer Misuse Act 1990 and responsible disclosure. Check your own awarding body's unit for the exact wording; none is quoted here.

**Who sees what.** These labs are often used with students aged 16 and 17. A copy is private to the student who started it. A member of staff who teaches the module can open it to see what the student has done, and opening a student's work is written to the access log, which the student can read.

## What does not work in a lab

The lab has no way out to the internet at all, so anything in Mutillidae that fetches a page from another website, or looks a name up on the internet, has nothing to reach. Only the web port is opened for the student, not the database or the directory, though the terminal beside the lab reaches every service by its name (`www`, `database`, `directory`). The site is given 512 MB, its database 384 MB and its directory 256 MB.

## Troubleshooting

- **The site does not appear straight after Start.** Wait a few seconds and press Open again: the lab reports itself ready only once the database has been made.
- **The site says something is wrong with the database.** Stop the lab and start it again for a fresh copy, or choose **Reset DB** in the menu.
- **On your own machine, port 8080 is already in use.** Change the left-hand number in `local.yaml`, for example `127.0.0.1:8081:80`, and open that port instead.

## Checking the lab

`test/check.sh` starts the lab the way the platform's runner starts every service (all capabilities dropped, `no-new-privileges`, a process limit, memory limits, and no way out to the internet) and then checks from inside its network what this page promises: the site answers, admin signs in, an injected name finds every account at level 0 and none at level 5, and the directory is up. It needs Docker and runs on every push, which is the badge at the top.

```bash
test/check.sh
```

## Versions and licences

[OWASP Mutillidae II](https://github.com/webpwnized/mutillidae) is GPL-3.0 licensed, with its [Docker images](https://github.com/webpwnized/mutillidae-docker) from the same project; the images also hold MariaDB (GPL-2.0), OpenLDAP (OpenLDAP Public License) and PHP, Apache, Debian and their other parts under their own licences. The images are `webpwnized/mutillidae:www-2.12.7`, `:database-2.12.7` and `:ldap-2.12.7`, each pinned by digest in `compose.yaml`.

## Licence

This work is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). You may share it and adapt it for learning and teaching, if you credit Mitsuru Technologies Ltd, do not use it commercially, and share anything you make from it under the same licence. The full text is in the `LICENSE` file.

The application inside keeps the licence of its own project, linked above.

## About

Made by [Mitsuru Technologies](https://mitsurutech.co.uk) for the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning): Python, Java, Go, Node, SQL and Linux in the browser for schools and colleges, with container labs, web apps deployed from GitHub, and quizzes that mark themselves. Try code with no account in the [playground](https://mitsurutech.co.uk/playground).

More labs from the same place: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) and [lab-sample](https://github.com/mitsurutech/lab-sample).
