# Arvestustöö raport



## Probleem 1
- Skript: `scripts/system_info.sh`
- Mida skript näiliselt tegi: Kuvas süsteemi üldinfot (masinanimi, jooksev kasutaja, kernel, tööaeg ja mälu).
- Mis oli tegelikult vale:
  1. `Hostname` ja `Kasutaja` olid vahetuses: `Hostname: $(whoami)` kuvas kasutajanime (`neko`), ja `Kasutaja: $(hostname)` kuvas masinanime (`debian`).
  2. `Kernel: $(uname -m)` kuvas protsessori arhitektuuri (`x86_64`), mitte kerneli versiooni (`uname -r`).
  3. `Uptime: $(date '+%H:%M:%S')` kuvas käesolevat kellaaega, mitte süsteemi tegelikku tööaega (uptime).
  4. `Mälu kokku: $(free -m | awk '/Swap:/ {print $2}') MB` luges saalemälu (Swap) mahtu, mitte füüsilist RAM operatiivmälu (`Mem:` rida).
- Kuidas vea avastasin: Käivitasin skripti ja võrdlesin kuvatud väärtusi süsteemi standardkäskude väljundiga.
- Millise käsuga kontrollisin:
  ```bash
  bash scripts/system_info.sh
  whoami; hostname; uname -r; uptime -p; free -m
  ```
- Parandus: Asendasin väljakutsed ja filtrid õigetega:
  - `echo "Hostname: $(hostname)"`
  - `echo "Kasutaja: $(whoami)"`
  - `echo "Kernel: $(uname -r)"`
  - `echo "Uptime: $(uptime -p)"`
  - `echo "Mälu kokku: $(free -m | awk '/^Mem:/ {print $2}') MB"`
- Kuidas kontrollisin pärast parandust: Käivitasin `bash scripts/system_info.sh` ja veendusin, et väljund kattub tegeliku süsteemi infoga.
- Vajadusel exit code enne / pärast: Exit code oli mõlemal juhul `0`, kuid kuvatavad andmed olid enne parandust valed ja vahetuses.

## Probleem 2
- Skript: `scripts/disk_check.sh`
- Mida skript näiliselt tegi: Kontrollis juurketta (`/`) kasutusprotsenti ja võrdles seda piirmääraga `DISK_LIMIT=80`.
- Mis oli tegelikult vale: Käsk `df -h / | awk 'NR==2 {print $4}' | tr -dc '0-9'` loeb `df` väljundist 4. veeru (*Available* ehk vaba kettaruum), mitte 5. veeru (*Use%* ehk kasutusprotsent). Mõõtühik 'G' eemaldati numbrite seast, tekitades suvalise väärtuse (nt vabast mahust 27G tehti 27%), mis pole kasutusprotsent. Kui kettal oleks vaba ruumi 85G, oleks skript andnud valehäire, et kettakasutus on 85%, kuigi tegelik kasutus oli vaid 8%.
- Kuidas vea avastasin: Vaatasin käsu `df -h /` ja `df -P /` tabelipäiseid ja veergude sisu.
- Millise käsuga kontrollisin:
  ```bash
  df -h /
  df -P / | awk 'NR==2 {print $5}'
  bash scripts/disk_check.sh
  ```
- Parandus: Kasutasin POSIX standardformaati `df -P /` (mis hoiab väljundi ühel real), võtsin 5. veeru (`Use%`) ja eemaldasin protsendimärgi:
  `usage=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')`
- Kuidas kontrollisin pärast parandust: Käivitasin `bash scripts/disk_check.sh` ning kontrollisin, et kuvatav kasutusprotsent (8%) vastab täpselt käsule `df -P /`.
- Vajadusel exit code enne / pärast: Exit code mõlemal juhul `0` (kuna mõlemad numbrid jäid alla 80), kuid mõõdetud parameeter enne parandust oli vale (vaba ruum vs tegelik kasutus).

## Probleem 3
- Skript: `scripts/user_check.sh`
- Mida skript näiliselt tegi: Kontrollis, kas etteantud kasutajanimi eksisteerib operatsioonisüsteemis.
- Mis oli tegelikult vale:
  1. Skript otsis kasutajat failist `/etc/group`, mis on gruppide nimekiri, mitte kasutajakontode fail (`/etc/passwd`).
  2. Tingimus `[ "$matches" -ge 0 ]` on alati tõene, sest `grep -c` tagastab alati numbri $\ge 0$ (olematu kasutaja puhul 0). Tulemusena väitis skript iga olematu kasutaja puhul, et kasutaja eksisteerib.
  3. Sisendikontroll puudus: tühja argumendi korral väideti samuti, et tühi kasutaja eksisteerib.
- Kuidas vea avastasin: Käivitasin skripti olematu kasutajanimega ja tühja sisendiga, mõlemal juhul väitis skript kasutaja olemasolu ning lõppes staatusega 0.
- Millise käsuga kontrollisin:
  ```bash
  bash scripts/user_check.sh olematu_kasutaja_xyz
  echo $?
  bash scripts/user_check.sh ""
  echo $?
  ```
- Parandus: Lisasin tühja argumendi kontrolli (`[ -z "$username" ]`), mis annab selge veateate ja väljub staatusega 2. Kasutaja tuvastamiseks asendasin grupiotsingu kindla käsuga `id "$username" &>/dev/null`.
- Kuidas kontrollisin pärast parandust:
  ```bash
  bash scripts/user_check.sh root                  # Väljastab: Kasutaja root eksisteerib. (exit 0)
  bash scripts/user_check.sh olematu_kasutaja_xyz  # Väljastab: Kasutajat olematu_kasutaja_xyz ei leitud. (exit 1)
  bash scripts/user_check.sh ""                    # Väljastab vea ja kasutusjuhise (exit 2)
  ```
- Vajadusel exit code enne / pärast:
  - Olematu kasutaja: enne `0`, pärast `1`
  - Tühi sisend: enne `0`, pärast `2`

## Probleem 4
- Skript: `scripts/service_check.sh`
- Mida skript näiliselt tegi: Kontrollis, kas etteantud teenus töötab süsteemis.
- Mis oli tegelikult vale: `systemctl list-unit-files --type=service` kontrollib ainult seda, kas teenuse unit-fail on kettal olemas (paigaldatud), mitte seda, kas teenus hetkel aktiivselt töötab. Seiskunud või passiivne teenus (näiteks `apt-daily.service`) raporteeriti ekslikult töötavaks. Lisaks puudus tühja argumendi kontroll.
- Kuidas vea avastasin: Käivitasin skripti passiivse teenusega `apt-daily`, mis ei tööta (`systemctl is-active` annab `inactive`), kuid skript teatas `"Teenus apt-daily töötab."`.
- Millise käsuga kontrollisin:
  ```bash
  systemctl is-active apt-daily
  bash scripts/service_check.sh apt-daily
  echo $?
  ```
- Parandus: Lisasin tühja argumendi kontrolli (exit code 2). Asendasin unit-failide otsingu käsuga `systemctl is-active --quiet "$service"`.
- Kuidas kontrollisin pärast parandust:
  ```bash
  bash scripts/service_check.sh cron               # Töötav teenus: väljastab "Teenus cron töötab." (exit 0)
  bash scripts/service_check.sh apt-daily          # Mitteaktiivne teenus: väljastab "Teenus apt-daily ei tööta." (exit 1)
  bash scripts/service_check.sh olematu_teenus     # Olematu teenus: väljastab "Teenus olematu_teenus ei tööta." (exit 1)
  bash scripts/service_check.sh ""                 # Tühi sisend: väljastab veateate (exit 2)
  ```
- Vajadusel exit code enne / pärast:
  - Mitteaktiivne teenus (`apt-daily`): enne `0`, pärast `1`
  - Tühi sisend: enne `1` (ilma kontrollita), pärast `2`

## Probleem 5
- Skript: `scripts/backup.sh`
- Mida skript näiliselt tegi: Lõi varukoopia arhiivifaili `backup_KUUPÄEV.tar.gz`.
- Mis oli tegelikult vale: Käsk `find "$BACKUP_SOURCE" -type f > "$ARCHIVE"` kirjutas arhiivifaili sisse pelgalt failide tekstilise nimekirja. Faililaiendiks pandi petlikult `.tar.gz`, kuid tegelikult ei olnud see gzip- ega tar-arhiiv. Failide sisu ei varundatud ja arhiivi avamine käsuga `tar -tzf` ebaõnnestus täielikult veateatega.
- Kuidas vea avastasin: Uurisin tekkinud faili käskudega `file` ja `tar -tzf`.
- Millise käsuga kontrollisin:
  ```bash
  file backups/backup_*.tar.gz
  tar -tzf backups/backup_*.tar.gz
  echo $?
  ```
- Parandus: Asendasin `find` ümbersuunamise tõelise arhiivikäsuga:
  `tar -czf "$ARCHIVE" -C "$BACKUP_SOURCE" .`
  Kontrollisin eelnevalt, et `$BACKUP_SOURCE` kaust eksisteerib. Arhiivis olevate failide arvu tuvastamiseks kasutasin `tar -tzf "$ARCHIVE" | grep -v '/$' | wc -l`.
- Kuidas kontrollisin pärast parandust:
  ```bash
  bash scripts/backup.sh
  file backups/backup_*.tar.gz
  tar -tzf backups/backup_*.tar.gz
  ```
- Vajadusel exit code enne / pärast:
  - Enne: `tar -tzf` andis vea `gzip: stdin: not in gzip format` (exit code `2`)
  - Pärast: `tar -tzf` kuvab failide nimekirja korrektselt (exit code `0`)

## Probleem 6
- Skript: `scripts/backup.sh` ja `lib/common.sh`
- Mida skript näiliselt tegi: Pidi tagama failide (sh tühikutega nimedega failide nagu `important data.txt`) säilimise ning toetama logimist.
- Mis oli tegelikult vale:
  1. Failide tegelik sisu ja kataloogistruktuur (nt `testdata/source/subdir/nested.txt`) ei jõudnud varukoopiasse.
  2. Kuigi projektis oli defineeritud logimisfunktsioon `log_message` failis `lib/common.sh` ja konfiguratsioon `LOG_FILE` failis `config/settings.conf`, ei kasutanud `backup.sh` (ega teised skriptid) seda funktsiooni ning faili `logs/toolkit.log` ei kirjutatud ühtegi kirjet.
- Kuidas vea avastasin: Uurisin `setup.sh` loodud testfailide struktuuri, `lib/common.sh` sisu ning kontrollisin logifaili olemasolu ja sisu.
- Millise käsuga kontrollisin:
  ```bash
  cat lib/common.sh
  cat logs/toolkit.log
  tar -tzvf backups/backup_*.tar.gz
  ```
- Parandus: `tar -czf` arhiveerib korrektselt tühikutega failinimed ja alamkataloogide sisu. Lisasin `source "$BASE_DIR/lib/common.sh"` ning lisasin `log_message` väljakutsed varundamise õnnestumise ja vigade kohta.
- Kuidas kontrollisin pärast parandust: Käivitasin `setup.sh`, seejärel `scripts/backup.sh`, vaatasin arhiivi sisu (`tar -tzvf`, kus `important data.txt` oli olemas) ning kontrollisin, et `cat logs/toolkit.log` sisaldab ajatempliga logikannet.

## Uus funktsionaalsus
- Mida lisasin: Lõin varukoopia taastamise skripti `scripts/restore.sh` ja lisasin selle peamenüüsse `main.sh` (valik 6: "Varukoopia taastamine"). Skript võimaldab taastada kas viimati loodud varukoopia või etteantud arhiivifaili sihtkausta (`testdata/restore`), valideerib arhiivi terviklikkuse enne lahtipakkimist (`tar -tzf`) ning logib tulemuse faili `logs/toolkit.log`.
- Kuidas käivitada:
  - Menüüst: käivita `bash main.sh` ja vali `6`
  - Käsitsi viimase koopia taastamine: `bash scripts/restore.sh`
  - Käsitsi kindla arhiivi taastamine sihtkausta: `bash scripts/restore.sh <arhiiv.tar.gz> <sihtkaust>`
- Kuidas kontrollisin, et tulemus on õige:
  1. Käivitasin `bash setup.sh` ja tegin varukoopia: `bash scripts/backup.sh`
  2. Käivitasin taastamise: `bash scripts/restore.sh`
  3. Kontrollisin taastatud faile: `cat "testdata/restore/important data.txt"` ja `cat "testdata/restore/subdir/nested.txt"` (failide sisu oli identne algsega).
  4. Kontrollisin logifaili: `cat logs/toolkit.log` (kirje taastamise kohta oli olemas).
