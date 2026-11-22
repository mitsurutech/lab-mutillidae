# OWASP-Mutillidae-II-Lab mit Docker Compose: SQL-Injection, XSS und LDAP-Injection an einer absichtlich verwundbaren PHP-Webanwendung üben

[English](README.md) | [Français](README.fr.md) | [Español](README.es.md) | [日本語](README.ja.md) | [Deutsch](README.de.md)

[![check](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-mutillidae/actions/workflows/check.yml)

Ein fertiges **Lab zur Sicherheit von Webanwendungen** für den Unterricht, von der [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning), auf der Schulen und Colleges allen Lernenden eigene Datenbanken, Container und ein Terminal im Browser geben. Alle Lernenden erhalten eine eigene Kopie von **OWASP Mutillidae II**, einer absichtlich unsicheren PHP-Website, deren **MariaDB-Datenbank** und **LDAP-Verzeichnis** bereits angelegt sind, um **SQL-Injection, Cross-Site-Scripting, Command Injection, LDAP-Injection** und mehr aus den OWASP Top 10 zu üben, auf Sicherheitsstufen, die zeigen, was jede Korrektur ändert. Sie erklären den Fehler und geben Nachweise ab, ohne Installation und ohne Risiko für den Rechner anderer.

Es besteht aus einer einzigen `docker-compose`-Datei, `compose.yaml`, und läuft auf Ihrem eigenen Rechner genauso wie auf der Plattform, wo alle Lernenden eine private Kopie ohne Weg ins Internet erhalten.

## Die eine Regel

**Greifen Sie Ihre eigene Kopie an und nichts anderes.** Alles in diesem Lab läuft in Ihrer eigenen privaten Kopie, die keinen Weg ins Internet und keinen zu anderen Lernenden hat. Erreichen können Sie also nur die Anwendung, die das Lab für Sie gestartet hat. Richten Sie nie ein Werkzeug auf eine Website, ein Netzwerk oder eine Maschine, die Ihnen nicht gehört, weder in einem Lab noch anderswo: Im Vereinigten Königreich ist das eine Straftat nach dem [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), und die meisten Länder haben ein ähnliches Gesetz. Wer lernt, wie Schwachstellen funktionieren, lernt, Software ohne sie zu bauen, und ein gutes erstes Gespräch in einer Klasse dreht sich darum, warum es diese Regel gibt und wie eine verantwortungsvolle Offenlegung aussieht.

## Was enthalten ist

| Dienst | Image | Speicher | Was er ist |
| --- | --- | --- | --- |
| `www` | [`webpwnized/mutillidae:www-2.12.7`](https://hub.docker.com/r/webpwnized/mutillidae) | 512 MB | Apache und PHP mit Mutillidae, die Website, die Sie öffnen |
| `database` | `webpwnized/mutillidae:database-2.12.7` | 384 MB | die MariaDB-Datenbank, in der Mutillidae seine Konten, seinen Blog und seine Logs speichert |
| `directory` | `webpwnized/mutillidae:ldap-2.12.7` | 256 MB | das OpenLDAP-Verzeichnis, das die LDAP-Übungen lesen |

Jedes Image ist über sein Versions-Tag und seinen Digest festgelegt, sodass ein Neubau unter demselben Tag kein Lab unter einer Klasse verändern kann. Zusammen sind die drei auf 1152 MB begrenzt, und im Leerlauf brauchen sie etwa 210 MB. Das Lab ist auf einem Laptop nach etwa zehn Sekunden bereit. Die Datenbank wird für Sie angelegt: Das Lab bittet die eigene Einrichtungsseite von Mutillidae, sie zu erzeugen, sobald die Datenbank läuft, und meldet sich erst dann bereit. „Bereit“ heißt also, dass die Website funktioniert, und es gibt keine Warnseite beim ersten Start, die weggeklickt werden müsste.

Die Images sind Programme von Drittanbietern, unverändert aus den eigenen öffentlichen Images des Projekts ausgeführt. Hier wird also nichts gebaut, und nichts aus diesem Repository wird darin verteilt. Sie werden für 64-Bit-Rechner mit Intel und AMD (amd64) veröffentlicht, auf denen auch die Plattform läuft; auf einem Laptop mit Apple Silicon führt Docker sie in einer Emulation aus, was funktioniert, aber langsamer ist.

## Auf der Plattform verwenden

Die [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning) gibt allen Lernenden eine eigene Kopie eines Labs, im Browser, mit einem Terminal daneben.

**Zum Ausprobieren:** Öffnen Sie die [Container-Seite](https://mitsurutech.co.uk/de/container), suchen Sie dieses Lab unter **Beispiel-Labs** und klicken Sie auf „Starten“. Zum Ausprobieren ist kein Konto nötig.

**Um es einer Klasse als Aufgabe zu stellen:**

1. Erstellen Sie in Ihrem Modul eine Aufgabe vom Typ **Lab** und wählen Sie **In einem GitHub-Repository**.
2. Geben Sie `https://github.com/mitsurutech/lab-mutillidae` mit dem Branch `main` an. Die Compose-Datei ist die Standarddatei, `compose.yaml`. Forken Sie das Repository zuerst, wenn Sie die Datei ändern möchten.
3. Veröffentlichen Sie. Jede Kopie der Lernenden startet von dem Commit, den Sie veröffentlicht haben, sodass eine spätere Änderung hier kein bereits gestelltes Lab verändert.
4. Schreiben Sie in die Aufgabe, was abzugeben ist (siehe [Für Lehrkräfte](#für-lehrkräfte)), und weisen Sie sie zu wie jede andere Aufgabe.

Der [Leitfaden zu diesem Lab](https://mitsurutech.co.uk/de/help/lab-mutillidae) im Hilfehandbuch, sein [Leitfaden zu den Sicherheits-Labs](https://mitsurutech.co.uk/de/help/security-labs) und sein [Leitfaden zu Container-Labs](https://mitsurutech.co.uk/de/help/labs) erklären den Rest: was in einer Compose-Datei stehen darf, wie viel Speicher eine Kopie erhält und wie eine Lehrkraft die Kopie von Lernenden öffnet, beobachtet und bewertet.

Noch kein Konto für Ihr College? [Ihr erstes Jahr ist kostenlos](https://mitsurutech.co.uk/de/pricing) für bis zu 50 Lernende, und für die [Registrierung](https://mitsurutech.co.uk/de/signup) genügt eine E-Mail-Adresse.

## Auf dem eigenen Rechner ausführen

Sie brauchen Docker mit dem Compose-Plugin. Beim ersten Start werden die Images heruntergeladen, und sie sind groß (etwa 250 MB, 130 MB und 90 MB zum Herunterladen).

```bash
docker compose -f compose.yaml -f local.yaml up
```

Öffnen Sie <http://localhost:8080>.

`local.yaml` veröffentlicht den Port nur auf `127.0.0.1`, sodass das Lab von Ihrem eigenen Rechner aus erreichbar ist und von nirgendwo sonst. Beenden Sie es mit `Ctrl-C` und entfernen Sie es mit `docker compose -f compose.yaml -f local.yaml down -v`. Führen Sie es auf einem Rechner aus, von dem aus Sie unbesorgt angreifen können: Die Anwendung ist absichtlich unsicher.

## Das Lab durcharbeiten

1. **Öffnen Sie die Website.** Die Datenbank ist bereits angelegt, es gibt also nichts einzurichten. Oben auf jeder Seite stehen die Sicherheitsstufe (sie beginnt bei 0) und ob Hinweise eingeschaltet sind.
2. **Melden Sie sich an**, als `admin` mit dem Passwort `adminpass` für die Seiten, die ein Konto verlangen, oder legen Sie auf der Seite **Login/Register** ein eigenes an.
3. **Wählen Sie eine Übung.** Das Menü links sind die OWASP Top 10 mit den Schwachstellen darunter: SQL-Injection (Daten auslesen, Authentifizierung umgehen, blind und über Zeitmessung), HTML- und JavaScript-Injection, Command Injection, LDAP-Injection, Cross-Site-Scripting, File Inclusion, schwache Sitzungen und mehr. **Toggle Hints** zeigt auf jeder Seite Hinweise an.
4. **Erhöhen Sie die Stufe.** **Toggle Security** im Menü schaltet von 0 auf 1 und dann auf 5 und wieder zurück auf 0. Machen Sie dieselbe Übung erneut: Der eingeschleuste Name, der auf Stufe 0 alle vierzig Konten findet, findet auf Stufe 5 keines. Das zeigt, was jede Korrektur ändert.
5. **Beginnen Sie neu, wann Sie wollen.** Das Lab zu stoppen und wieder zu starten ergibt ein frisches Mutillidae, genau wie **Reset DB** im Menü.

## Für Lehrkräfte

Nichts in diesem Lab wird automatisch bewertet. Die Lernenden geben Nachweise ab, und Sie bewerten sie, so wie jedes andere Lab.

**Verlangen Sie Nachweise in zwei Teilen.** Erstens den Beleg für die Arbeit: einen Screenshot jeder gelösten Übung, auf dem die eigene Adresse des Labs im Browser sichtbar ist, sodass klar ist, dass es die eigene Kopie ist. Zweitens das Verständnis: zu jeder Übung eine schriftliche Erklärung in eigenen Worten, was die Schwachstelle ist, welche Eingabe genau verwendet wurde und warum sie funktioniert hat, was ein Angreifer damit tun könnte und wie der Code hätte geschrieben werden sollen. Der zweite Teil zeigt Ihnen, ob es verstanden oder aus einer Lösungsanleitung abgeschrieben wurde. Für eine anspruchsvollere Arbeit verlangen Sie dieselbe Übung zusätzlich auf Stufe 5 und eine Erklärung, was der Code dort anders macht.

**Wo es in einen Kurs passt.** Mutillidae eignet sich für eine Einführung in die Sicherheit von Webanwendungen und sicheres Programmieren, weil dieselbe Übung auf verschiedenen Stufen dieselbe Seite ist, erst unsicher und dann korrigiert: Eingabevalidierung, Ausgabekodierung, parametrisierte Abfragen und Authentifizierung. Es unterstützt auch die rechtliche und ethische Seite einer Einheit: Autorisierung und Umfang, den Computer Misuse Act 1990 und verantwortungsvolle Offenlegung. Prüfen Sie den genauen Wortlaut in der Einheit Ihrer eigenen Prüfungsstelle; hier wird keine zitiert.

**Wer was sieht.** Diese Labs werden oft mit Lernenden im Alter von 16 und 17 Jahren genutzt. Eine Kopie ist privat für die Person, die sie gestartet hat. Ein Mitglied des Personals, das das Modul unterrichtet, kann sie öffnen, um zu sehen, was die Person getan hat, und das Öffnen der Arbeit von Lernenden wird im Zugriffsprotokoll festgehalten, das die Lernenden lesen können.

## Was in einem Lab nicht funktioniert

Das Lab hat überhaupt keinen Weg ins Internet. Alles in Mutillidae, was eine Seite von einer anderen Website abruft oder einen Namen im Internet nachschlägt, kann daher nichts erreichen. Für die Lernenden wird nur der Webport geöffnet, nicht die Datenbank oder das Verzeichnis, wobei das Terminal neben dem Lab jeden Dienst über seinen Namen erreicht (`www`, `database`, `directory`). Die Website erhält 512 MB, ihre Datenbank 384 MB und ihr Verzeichnis 256 MB.

## Fehlerbehebung

- **Die Website erscheint nicht direkt nach dem Start.** Warten Sie einige Sekunden und klicken Sie erneut auf „Öffnen“: Das Lab meldet sich erst bereit, wenn die Datenbank angelegt ist.
- **Die Website meldet ein Problem mit der Datenbank.** Stoppen Sie das Lab und starten Sie es neu, um eine frische Kopie zu erhalten, oder wählen Sie **Reset DB** im Menü.
- **Auf Ihrem eigenen Rechner ist Port 8080 schon belegt.** Ändern Sie die linke Zahl in `local.yaml`, zum Beispiel in `127.0.0.1:8081:80`, und öffnen Sie stattdessen diesen Port.

## Das Lab prüfen

`test/check.sh` startet das Lab so, wie der Runner der Plattform jeden Dienst startet (alle Capabilities entfernt, `no-new-privileges`, eine Prozessgrenze, Speichergrenzen und kein Weg ins Internet), und prüft dann aus seinem Netzwerk heraus, was diese Seite verspricht: Die Website antwortet, admin kann sich anmelden, ein eingeschleuster Name findet auf Stufe 0 jedes Konto und auf Stufe 5 keines, und das Verzeichnis läuft. Es braucht Docker und läuft bei jedem Push, das ist das Abzeichen oben.

```bash
test/check.sh
```

## Versionen und Lizenzen

[OWASP Mutillidae II](https://github.com/webpwnized/mutillidae) steht unter der Lizenz GPL-3.0, mit seinen [Docker-Images](https://github.com/webpwnized/mutillidae-docker) aus demselben Projekt; die Images enthalten außerdem MariaDB (GPL-2.0), OpenLDAP (OpenLDAP Public License) sowie PHP, Apache, Debian und ihre übrigen Bestandteile unter ihren eigenen Lizenzen. Die Images sind `webpwnized/mutillidae:www-2.12.7`, `:database-2.12.7` und `:ldap-2.12.7`, jedes in `compose.yaml` über seinen Digest festgelegt.

## Lizenz

Dieses Werk steht unter der Lizenz [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Sie dürfen es zum Lernen und Lehren weitergeben und bearbeiten, wenn Sie Mitsuru Technologies Ltd nennen, es nicht kommerziell nutzen und alles, was Sie daraus machen, unter derselben Lizenz weitergeben. Der vollständige Text steht in der Datei `LICENSE`.

Die Anwendung darin behält die Lizenz ihres eigenen Projekts, oben verlinkt.

## Über uns

Erstellt von [Mitsuru Technologies](https://mitsurutech.co.uk/de) für die [MitsuruTech Learning Platform](https://mitsurutech.co.uk/de/learning): Python, Java, Go, Node, SQL und Linux im Browser für Schulen und Colleges, mit Container-Labs, aus GitHub bereitgestellten Web-Apps und Quizzen, die sich selbst bewerten. Probieren Sie Code ohne Konto im [Playground](https://mitsurutech.co.uk/de/playground) aus.

Weitere Labs vom selben Ort: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) und [lab-sample](https://github.com/mitsurutech/lab-sample).
