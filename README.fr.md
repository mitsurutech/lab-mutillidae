# Lab OWASP Mutillidae II avec Docker Compose : s’entraîner à l’injection SQL, au XSS et à l’injection LDAP sur une application web PHP volontairement vulnérable

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml)

Un **lab de sécurité des applications web** prêt à l’emploi pour la classe, issu de la [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning), où les écoles et les établissements donnent à chaque élève ses propres bases de données, ses propres conteneurs et son propre terminal dans le navigateur. Chaque élève reçoit sa propre copie d’**OWASP Mutillidae II**, un site PHP volontairement non sécurisé, avec sa **base de données MariaDB** et son **annuaire LDAP** déjà en place, pour s’entraîner à l’**injection SQL, au cross-site scripting, à l’injection de commandes, à l’injection LDAP** et plus encore à travers l’OWASP Top 10, à des niveaux de sécurité qui montrent ce que change chaque correctif. Il explique la faille et rend des preuves, sans rien installer et sans risque pour la machine de quelqu’un d’autre.

C’est un seul fichier `docker-compose`, `compose.yaml`, et il fonctionne de la même façon sur votre propre machine que sur la plateforme, où chaque élève dispose d’une copie privée sans aucune sortie vers Internet.

## La règle d’or

**Attaquez votre propre copie et rien d’autre.** Tout ce qui se trouve dans ce lab tourne à l’intérieur de votre propre copie privée, qui n’a aucune route vers Internet ni vers un autre élève : la seule chose que vous pouvez atteindre est l’application que le lab a démarrée pour vous. Ne dirigez jamais un outil vers un site web, un réseau ou une machine qui ne vous appartient pas, dans un lab comme ailleurs : au Royaume-Uni, c’est une infraction au titre du [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), et la plupart des pays ont une loi semblable. Apprendre comment fonctionnent les faiblesses, c’est apprendre à écrire des logiciels qui n’en ont pas, et une bonne première discussion en classe porte sur la raison d’être de cette règle et sur ce à quoi ressemble une divulgation responsable.

## Ce que contient le lab

| Service | Image | Mémoire | Ce que c’est |
| --- | --- | --- | --- |
| `www` | [`webpwnized/mutillidae:www-2.12.7`](https://hub.docker.com/r/webpwnized/mutillidae) | 512 Mo | Apache et PHP exécutant Mutillidae, le site que vous ouvrez |
| `database` | `webpwnized/mutillidae:database-2.12.7` | 384 Mo | la base de données MariaDB où Mutillidae conserve ses comptes, son blog et ses journaux |
| `directory` | `webpwnized/mutillidae:ldap-2.12.7` | 256 Mo | l’annuaire OpenLDAP que lisent les exercices LDAP |

Chaque image est figée par son étiquette de version et par son empreinte (digest), si bien qu’une reconstruction sous la même étiquette ne peut pas changer un lab sous les pieds d’une classe. Les trois ensemble sont limités à 1152 Mo, et au repos ils utilisent environ 210 Mo. Le lab est prêt en une dizaine de secondes sur un ordinateur portable. La base de données est créée pour vous : le lab demande à la page d’installation de Mutillidae de la construire une fois la base démarrée, et ne se déclare prêt qu’ensuite ; « prêt » signifie donc que le site fonctionne et qu’il n’y a pas de page d’avertissement de premier lancement à franchir.

Les images sont des programmes tiers, exécutés sans modification à partir des images publiques du projet : rien n’est construit ici et rien de ce dépôt n’y est distribué. Elles sont publiées pour les machines Intel et AMD 64 bits (amd64), ce sur quoi tourne la plateforme ; sur un ordinateur portable Apple silicon, Docker les exécute en émulation, ce qui fonctionne mais plus lentement.

## L’utiliser sur la plateforme

La [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) donne à chaque élève sa propre copie d’un lab, dans le navigateur, avec un terminal à côté.

**Pour l’essayer :** ouvrez la [page des conteneurs](https://mitsurutech.co.uk/fr/container), trouvez ce lab dans **Laboratoires d’exemple** et appuyez sur Démarrer. Aucun compte n’est nécessaire pour en essayer un.

**Pour le donner comme travail à une classe :**

1. Dans votre module, créez une tâche de type **Lab** et choisissez **Dans un dépôt GitHub**.
2. Indiquez `https://github.com/mitsurutech/lab-mutillidae` avec la branche `main`. Le fichier compose est celui par défaut, `compose.yaml`. Faites d’abord un fork du dépôt si vous voulez modifier le fichier.
3. Publiez. La copie de chaque élève part du commit que vous avez publié : une modification ultérieure ici ne change donc pas un lab déjà donné.
4. Dites dans la tâche ce qu’il faut rendre (voir [Pour les enseignants](#pour-les-enseignants)), et distribuez-la comme n’importe quelle autre tâche.

Le [guide de ce lab](https://mitsurutech.co.uk/fr/help/lab-mutillidae), le [guide des labs de sécurité](https://mitsurutech.co.uk/fr/help/security-labs) et le [guide des labs de conteneurs](https://mitsurutech.co.uk/fr/help/labs) du manuel d’aide disent le reste : ce qu’un fichier compose peut contenir, combien de mémoire reçoit une copie, et comment un enseignant ouvre, observe et corrige la copie d’un élève.

Pas encore de compte d’établissement ? [La première année est gratuite](https://mitsurutech.co.uk/fr/pricing) pour 50 élèves au plus, et [s’inscrire](https://mitsurutech.co.uk/fr/signup) ne demande qu’une adresse e-mail.

## L’exécuter sur votre propre machine

Il vous faut Docker avec le plugin Compose. Le premier démarrage télécharge les images, qui sont volumineuses (environ 250 Mo, 130 Mo et 90 Mo à télécharger).

```bash
docker compose -f compose.yaml -f local.yaml up
```

Ouvrez <http://localhost:8080>.

`local.yaml` ne publie le port que sur `127.0.0.1`, si bien que le lab est accessible depuis votre propre ordinateur et nulle part ailleurs. Arrêtez-le avec `Ctrl-C`, et supprimez-le avec `docker compose -f compose.yaml -f local.yaml down -v`. Lancez-le sur une machine depuis laquelle vous acceptez d’attaquer : l’application est volontairement non sécurisée.

## Pas à pas

1. **Ouvrez le site.** La base de données est déjà créée, il n’y a donc rien à configurer. Le haut de chaque page indique le niveau de sécurité (il commence à 0) et si les indices sont activés.
2. **Connectez-vous** en tant que `admin` avec le mot de passe `adminpass` pour les pages qui demandent un compte, ou créez le vôtre sur la page **Login/Register**.
3. **Choisissez un exercice.** Le menu de gauche est l’OWASP Top 10 avec les faiblesses sous chacun : injection SQL (extraction de données, contournement de l’authentification, en aveugle et par mesure du temps), injection HTML et JavaScript, injection de commandes, injection LDAP, cross-site scripting, inclusion de fichiers, sessions faibles et plus encore. **Toggle Hints** affiche des indices sur chaque page.
4. **Montez le niveau.** **Toggle Security** dans le menu passe de 0 à 1 puis à 5, et revient à 0. Refaites le même exercice : le nom injecté qui trouve les quarante comptes au niveau 0 n’en trouve aucun au niveau 5, ce qui montre ce que change chaque correctif.
5. **Recommencez quand vous voulez.** Arrêter puis démarrer le lab donne un Mutillidae tout neuf, comme **Reset DB** dans le menu.

## Pour les enseignants

Rien dans ce lab n’est corrigé automatiquement. L’élève rend des preuves et vous les corrigez, comme pour n’importe quel autre lab.

**Demandez des preuves en deux moitiés.** D’abord, la preuve du travail : une capture d’écran de chaque exercice résolu, avec l’adresse du lab visible dans le navigateur pour qu’il soit clair que c’est sa copie. Ensuite, la compréhension : pour chacun, une explication écrite avec ses propres mots de ce qu’est la faiblesse, de l’entrée exacte utilisée et de la raison pour laquelle elle a fonctionné, de ce qu’un attaquant pourrait en faire et de la façon dont le code aurait dû être écrit. La seconde moitié vous dit si cela a été compris ou recopié d’une solution pas à pas. Pour un travail plus poussé, demandez aussi le même exercice au niveau 5, et ce que fait le code différemment.

**Sa place dans un cours.** Mutillidae convient à une introduction à la sécurité des applications web et au développement sécurisé, parce que le même exercice à différents niveaux est la même page, vulnérable puis corrigée : validation des entrées, encodage des sorties, requêtes paramétrées et authentification. Il soutient aussi le volet juridique et éthique d’une unité : autorisation et périmètre, Computer Misuse Act 1990 et divulgation responsable. Vérifiez le libellé exact dans l’unité de votre propre organisme certificateur ; aucun n’est cité ici.

**Qui voit quoi.** Ces labs sont souvent utilisés avec des élèves de 16 et 17 ans. Une copie est privée pour l’élève qui l’a démarrée. Un membre du personnel qui enseigne le module peut l’ouvrir pour voir ce que l’élève a fait, et l’ouverture du travail d’un élève est inscrite dans le journal d’accès, que l’élève peut lire.

## Ce qui ne marche pas dans un lab

Le lab n’a aucune sortie vers Internet : tout ce qui, dans Mutillidae, récupère une page sur un autre site web ou résout un nom sur Internet n’a donc rien à atteindre. Seul le port web est ouvert pour l’élève, pas la base de données ni l’annuaire, bien que le terminal à côté du lab atteigne chaque service par son nom (`www`, `database`, `directory`). Le site reçoit 512 Mo, sa base de données 384 Mo et son annuaire 256 Mo.

## Dépannage

- **Le site n’apparaît pas juste après Démarrer.** Attendez quelques secondes et appuyez de nouveau sur Ouvrir : le lab ne se déclare prêt qu’une fois la base de données créée.
- **Le site signale un problème de base de données.** Arrêtez le lab et redémarrez-le pour obtenir une copie neuve, ou choisissez **Reset DB** dans le menu.
- **Sur votre propre machine, le port 8080 est déjà utilisé.** Changez le nombre de gauche dans `local.yaml`, par exemple `127.0.0.1:8081:80`, et ouvrez plutôt ce port.

## Vérification du lab

`test/check.sh` démarre le lab comme le runner de la plateforme démarre chaque service (toutes les capacités retirées, `no-new-privileges`, une limite de processus, des limites de mémoire et aucune sortie vers Internet), puis vérifie depuis l’intérieur de son réseau ce que cette page promet : le site répond, admin se connecte, un nom injecté trouve tous les comptes au niveau 0 et aucun au niveau 5, et l’annuaire est en marche. Il a besoin de Docker et s’exécute à chaque push, ce qu’indique le badge en haut.

```bash
test/check.sh
```

## Versions et licences

[OWASP Mutillidae II](https://github.com/webpwnized/mutillidae) est sous licence GPL-3.0, avec ses [images Docker](https://github.com/webpwnized/mutillidae-docker) issues du même projet ; les images contiennent aussi MariaDB (GPL-2.0), OpenLDAP (OpenLDAP Public License) ainsi que PHP, Apache, Debian et leurs autres composants sous leurs propres licences. Les images sont `webpwnized/mutillidae:www-2.12.7`, `:database-2.12.7` et `:ldap-2.12.7`, chacune figée par son empreinte dans `compose.yaml`.

## Licence

Cette œuvre est sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Vous pouvez la partager et l’adapter pour apprendre et enseigner, à condition de citer Mitsuru Technologies Ltd, de ne pas l’utiliser commercialement et de partager tout ce que vous en tirez sous la même licence. Le texte complet est dans le fichier `LICENSE`.

L’application qu’elle contient garde la licence de son propre projet, indiquée plus haut.

## À propos

Réalisé par [Mitsuru Technologies](https://mitsurutech.co.uk/fr) pour la [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) : Python, Java, Go, Node, SQL et Linux dans le navigateur pour les écoles et les établissements, avec des labs de conteneurs, des applications web déployées depuis GitHub et des quiz qui se corrigent tout seuls. Essayez du code sans compte dans le [bac à sable](https://mitsurutech.co.uk/fr/playground).

D’autres labs du même endroit : [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) et [lab-sample](https://github.com/mitsurutech/lab-sample).
