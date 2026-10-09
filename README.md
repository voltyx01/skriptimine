# GitHowTo - Praktiline Giti õppeprojekt

## Projekti kirjeldus
Selle projekti eesmärk oli läbida **GitHowTo** praktilised harjutused ning õppida versioonihaldussüsteemi **Git** põhitõdesid ja igapäevast töövoogu. Projekti käigus loodi kohalik repositoorium, teostati muudatusi, hallati harusid ning ühendati need GitHubi kaughoidlaga.

---

## Mida ma selle projekti käigus õppisin?

Õppisin kasutusse võtma põhilisi Giti käske, mõistma failide staatuseid (untracked, staged, committed) ning lahendama lihtsamaid harude ühendamise töövõtteid.

### Õpitud teemad:
* Repositooriumi algatamine ja failide jälgimine
* Muudatusete salvestamine (commit) ja ajaloo vaatamine
* Harude (branches) loomine, vahetamine ja liitmine (merge)
* Kaughoidla (GitHub) ühendamine ja andmete edastamine (push/pull)

---

## Põhilised Git käsud

Igapäevases töövoos kasutati järgmisi käske:

* `git status` — kontrollib failide hetkeseisu hoidlas.
* `git add` — lisab muudatused indeksisse (*staging area*).
* `git commit` — salvestab indeksis olevad muudatused ajaloosse.
* `git log` — kuvab sooritatud commit-ide ajaloo.
* `git branch` — kuvab või loob uusi harusid.
* `git switch` — vahetab aktiivset haru (või `git checkout`).
* `git merge` — liidab valitud haru muudatused aktiivse haruga.

### Näide tüüpilisest Git töövoost:

```bash
# 1. Kontrolli failide olekut
git status

# 2. Lisa muudetud failid staging alale
git add .

# 3. Tee commit koos selgitava teatega
git commit -m "Täiendatud README.md faili"

# 4. Saada muudatused GitHubi
git push origin main
