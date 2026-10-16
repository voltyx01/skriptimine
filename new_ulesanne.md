Kasutajate haldus
Ettevalmistus: kuna kasutajad saab hallata ainult root, kõige mõistlik viis, selle praktikumi teostamiseks on seadistada sudo ja kasutada olemas oleva repositooriumi ja git-i,  ehk allasuvaid 4 punktid mitte teha!  
Loo root kodukataloogis kataloog bash_skriptimine
Initsialiseeri bash_skriptimine kataloogis lokaalne git repositoorium oma skriptide muudatuste salvestamiseks
Loo github repositoorium nimega bash_skriptimine
Tekita lokaalses repositooriumis remote ühendus github repositooriumiga - siis saad oma lokaalsed muudatused pushida github repositooriumi
Ülesanded
Ülesanne 1 - kasutaja loomine käsurealise parameetrite abil
Koosta skript nimega lisa_kasutaja, mis võtab parameetrina kasutajanimi ja loob antud nimega kasutajat (ilma paroolita)  ning lisab antud kasutajale kodukataloog antud kasutaja nimega /home kausta sisse. NB! Kodukataloogis peab tekkima kindlasti ka vajalik struktuur peidetud failidest.

Vihje lahendamiseks: katseta kõigepealt kasutaja loomist käsitsi, pane kirja kõik käsud, mis rakendasid koos tulemuste kontrolliga (uuri, millised sisse kanded on /etc/passwd, /etc/shadow, /etc/group failides ja milline on sisu /home/kasutajanimi kataloogis

Näiteks katsetasin nii ja sain sellise tulemuse useradd käsu abil:



Kui katsetamine on teostatud, mõtle, kuidas saaks kõik loomiseks kasutatud käsud kokku panna, et oleks võimalik antud töö skriptina teostada. Tegu on bash skriptiga




Kui skript on valmis, tuleb selle ära kontrollida:
------------------------------------------------------------------
Kontrollimine:

chmod +x lisa_kasutaja
sh lisa_kasutaja soovitav_kasutajanimi
cat /etc/passwd | grep soovitav_kasutajanimi
cat /etc/shadow | grep soovitav_kasutajanimi

------------------------------------------------------------------
Kuna lisamise kontroll on juba skripti lisatud, siis piisab ainult 1-sest reast:


Skripti loomise protsessi mitte unustada committida oma tegevused, et skripti loomise protsess oleks kajastatud ka githubi repositooriumis.

Ülesanne 2 - kasutajad failist
Koosta skript nimega kasutajad_failist, mis võtab parameetrina failinimi, kus iga rida on kasutajanimi, ja kutsub lisa_kasutaja skripti antud kasutaja lisamiseks


Antud skripti korrektse töö eelduseks on kasutajanimedega faili olemasolu, paneme näiteks nimega kasutajad ning eelmises ülesannes koostatud skripti olemasolu nimega lisa_kasutaja:
 

------------------------------------------------------------

faili nimega kasutajad sisu on toodud lilla värviga:
NB! peale viimast rida reavahetust pole!!!
------------------------------------
kasutaja1
kasutaja2
kasutaja3

------------------------------------



Skript ise võiks olla näiteks selline:




Ja tulemuse kontrollimiseks 

Kontrollimine:

chmod +x kasutajad_failist
sh kasutajad_failist kasutajad
cat /etc/passwd | grep kasutaja
cat /etc/shadow | grep kasutaja

------------------------------------------------------------

Pilt tulemusest, mis näitab, et kõik kolm kasutajad on lisatud


Skripti loomise protsessi mitte unustada committida oma tegevused, et skripti loomise protsess oleks kajastatud ka githubi repositooriumis.

Ülesanne 3 - kasutajad paroolidega failist
Taienda eelmine skript nii, et kui faili iga rida on kujul kasutajanimi:parool siis skript lisab kasutajale parooli shadow faili sisse 
NB! Failis parool on avatud kujul!

Kontrollime, et hetkel kasutajad lisatakse ilma paroolita


------------------------------------
faili nimega kasutajad_paroolid sisu:
------------------------------------
kasutaja1:parool1
kasutaja2:parool2
kasutaja3:parool3

------------------------------------


Skript ise:


Kontroll:

ennem kustuta olemasolevad kasutajaN kasutajad ara
kui ei viitsi kasitsi - tee skriptike ;)

chmod +x kasutajad_failist_parooliga
sh kasutajad_failist_parooliga kasutajad_paroolid
cat /etc/passwd | grep kasutaja
cat /etc/shadow | grep kasutaja

-------------------------------------

Tulemuse kontroll:



Skripti loomise protsessi mitte unustada committida oma tegevused, et skripti loomise protsess oleks kajastatud ka githubi repositooriumis.

Ülesanne 4 - kasutajad ja paroolid on eraldatud
Koosta skript, mis kasutab parameetritena kaks faili - ühes on kasutajad, teises on antud kasutajate paroolid.
Igas failis üks rida vastab ühele sissekannele kasutaja kohta. Skript peab lisama kasutajad vastava parooliga süsteemile. Kõik vajalik selleks peab olema antud skripti sisu sisse lisatud, mingit lisaskripti kutsumine ei ole lubatud.

Antud ülesanne lahendamiseks tuleb kokku võtta kõik eelmised skriptid ja proovida need ühendada suureks skriptiks.

Skripti loomise protsessi mitte unustada committida oma tegevused, et skripti loomise protsess oleks kajastatud ka githubi repositooriumis.
Ülesanne 5 - paroolide genereerimine ja logimine
Koosta skript, mis kasutab parameetritena faili, milles on kasutajad.
Igas failis üks rida vastab ühele sissekannele kasutaja kohta. Parooli kasutaja jaoks tuleb genereerida, kasutades sobiva linuxi käsu (näiteks pwgen).
Skript peab lisama kasutajad vastava parooliga süsteemile. Kõik vajalik selleks peab olema antud skripti sisu sisse lisatud, mingit lisaskripti kutsumine ei ole lubatud.
Selleks, et kasutajat saaks teavitada tema paroolist, kasutaja nimi ja parool tuleb salvestada nö logifaili, kus sissekanne võiks olla organiseeritud sarnaselt eelmise ülesannega - näiteks kasutaja:parool kujul.

18.03 täiendused

Parooli genereerimise käsu kasutamisest saab lugeda näiteks siit: https://linuxconfig.org/how-to-use-a-command-line-random-password-generator-pwgen-on-linux

Süsteemis on võimalik kontrollida, kas olemas parooli genereerimise käsk või mitte ja puudumise korral saab selle paigaldada:


Nüüd antud käsk süsteemis on olemas ja selle on võimalik kasutada. Katsetame näiteks ühe parooli loomine, mille pikkus on 8 sümbolit ja ta koosneb ainult tähtedest:


Skripti realiseerimiseks võib võta kasutajate failist loomise skripti, täiendates parooli genereerimisega:


Antud skriptis genereerime kasutajale parooli pikkusega 8 sümbolit ning määrame ta loodud kasutajale ja salvestame ka faili nimega loodud_kasutajad_paroolidega. 

Katsetame skripti tööd ka:



Ja kontrollime genereeritud paroolide faili:



Skripti loomise protsessi mitte unustada committida oma tegevused, et skripti loomise protsess oleks kajastatud ka githubi repositooriumis.

Selleks kontrollime tehtud muudatused, lisame vajalik fail jälgimisele ja koostame sellele commiti:



Ülesanne 6 - root kasutaja õiguste kontrollimine

Lisa antud skriptile kontroll, et skripti käivitav kasutaja on root, kui skripti käivitamine proovitakse sudo kaudu, siis kasutamine keelatakse ja lõpetatakse skripti tööd.

Täiendus 18.03

Kuna Linuxis on võimalik ka lubada teistele kasutajatele töötada root õiguste alt, siis me võime panna tignimuse sisse, et ikka ainult root kasutaja võib skripti tööle lasta. Kasutajat saab Linuxix kontrollida nii:



Paneme vastav täiendus ka skriptile:



Ja kontrollime skripti tööd:



Skripti loomise protsessi mitte unustada committida oma tegevused, et skripti loomise protsess oleks kajastatud ka githubi repositooriumis.
