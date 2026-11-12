# Varundamine ja Varukoopiate Kontroll

Käesolev kaust sisaldab kahe varundamise ülesande lahendusi:

---

## 1. Kasutajate kodukataloogide varundamine (`varunda_kodukataloogid.sh`)

Skript arhiveerib ja pakib kasutajate kodukataloogid kuupäevatempliga kujul:
`<kasutajanimi>.<PP.KK.AAAA>.tar.gz`

### Omadused:
- **Töötab sõltumata käivitamise asukohast** (`tar -C` ja absoluutsed teed).
- Sihtkataloogiks on vaikimisi `/home_bcp` (kui õigused puuduvad, kasutab automaatselt `~/home_bcp`).
- Toetab nii kõigi kasutajate kui ka konkreetse kasutaja varundamist (`-u`).
- Välistab rekursiooni ja süsteemsed erikaustad (`lost+found`, peidetud failid).

### Käivitamine:
```bash
# Varunda kõik kasutajad (vaikimisi /home -> /home_bcp või ~/home_bcp):
./varunda_kodukataloogid.sh

# Määratud sihtkaustaga:
./varunda_kodukataloogid.sh -d ~/home_bcp

# Ainult ühe kindla kasutaja varundamine:
./varunda_kodukataloogid.sh -u kasutajanimi -d ~/home_bcp
```

---

## 2. Varukoopia kuupäevaga ja kontrolliga (`backupexec.sh`)

Terviklik automatiseeritud varundusskript (12 sammu / nõuet), mis varundab `~/praks2/src` kausta `~/praks2/backup/` kausta.

### Realiseeritud etapid:
1. **Lihtne varukoopia .tar.zst** — `tar -I 'zstd -19 -T0' -cf ... -C ~/praks2 src` kuupäeva ja kellaajaga failinimes.
2. **Arhiivi kontrollimine** — kontrollib arhiivi terviklikkust ja avatavust (`tar -tf`), kuvades esimesed 5 kirjet.
3. **Varukoopia suurus** — kuvab arhiivi suuruse inimloetaval kujul (`du -h`).
4. **Ainult viimaste koopiate hoidmine** — rotatsioonipoliitika hoiab alles ainult viimased 3 arhiivi (eemaldab vanemad arhiivid ja nende `.sha256` failid).
5. **Failide välistamine** — toetab reegleid piltide, binaarfailide jms välistamiseks.
6. **„Kuiv jooks“ (`-d` / `--dry-run`)** — kuvab lisatavad failid ilma arhiivi tegelikult loomata (`tar -cf - ... | tar -tvf -`).
7. **Logimine** — kirjutab alguse, lõpu ja kõik teated ajatempliga logifaili (`~/praks2/logs/backup.log`).
8. **Vaba ruumi kontroll** — võrdleb lähtekausta mahtu (`du -sb`) ja sihtketta vaba ruumi (`df -B1`). Ebapiisava ruumi korral katkestab veaga.
9. **SHA-256 kontrollsumma** — arvutab iga arhiivi jaoks `.sha256` kontrollfaili, verifitseerib selle (`sha256sum -c`) ning uuendab koondfaili `checksums.txt`.
10. **Kompressori valik (`-c zstd|gzip|xz`)** — toetab `zstd` (.tar.zst), `gzip` (.tar.gz) ja `xz` (.tar.xz) kompressoreid.
11. **`.backupignore` kasutamine** — kui lähtekaustas eksisteerib `.backupignore`, rakendatakse reeglid automaatselt arhiveerimisel.
12. **Terviklik skript** — kasutab ajutist kataloogi (`mktemp -d`), automaatset puhastust (`trap cleanup EXIT`) ja põhjalikku veahaldust.

### Käivitamine:
```bash
# Tavamoodus (zstd kompressioon):
./backupexec.sh

# Kuiv jooks (dry-run):
./backupexec.sh -d

# Gzip või XZ kompressiooniga:
./backupexec.sh -c gzip
./backupexec.sh -c xz

# Abiinfo kuvamine:
./backupexec.sh --help
```
