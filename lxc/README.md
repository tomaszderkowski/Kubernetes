# LXD/LXC
## lxd init

```
config: {}
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  description: ""
  managed: false
  name: lxdbr0
  type: ""
storage_pools:
- config: {}
  description: ""
  name: LXD
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: lxdbr0
      type: nic
    root:
      path: /
      pool: LXD
      type: disk
  name: default
cluster: null
```

## lxc remote
``` lxc remote list ``` - wskazuje listę dostępnych repozytoriów z obrazami systemów
```
+-----------------+------------------------------------------+---------------+-----------+--------+--------+
|      NAME       |                   URL                    |   PROTOCOL    | AUTH TYPE | PUBLIC | STATIC |
+-----------------+------------------------------------------+---------------+-----------+--------+--------+
| images          | https://images.linuxcontainers.org       | simplestreams |           | YES    | NO     |
+-----------------+------------------------------------------+---------------+-----------+--------+--------+
| local (default) | unix://                                  | lxd           | tls       | NO     | YES    |
+-----------------+------------------------------------------+---------------+-----------+--------+--------+
| ubuntu          | https://cloud-images.ubuntu.com/releases | simplestreams |           | YES    | YES    |
+-----------------+------------------------------------------+---------------+-----------+--------+--------+
| ubuntu-daily    | https://cloud-images.ubuntu.com/daily    | simplestreams |           | YES    | YES    |
+-----------------+------------------------------------------+---------------+-----------+--------+--------+
```

## lxc image
```lxc image list``` - wskazuje wszystkie obrazy systemów dostępne na maszynie lokalnej

```lxc image list <nazwa_repozytorium>:``` - wyszukuje wszystkie obrazy systemów w danym repozytorium

```lxc image list <nazwa_repozytorium>:<nazwa_systemu>``` - wyszukuję obrazy systemu z podanego repozytroium o podanej nazwie

```lxc launch <nazwa_reposytorium>:<nazwa_obrazu_systemu> <nazwa_maszyny>``` - tworzy maszynę o podanej nazwie na podstawie wskazanego obrazu systemu

```
lxc image list images:ubuntu/18.04
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
|             ALIAS             | FINGERPRINT  | PUBLIC |              DESCRIPTION               |  ARCH   |   SIZE   |         UPLOAD DATE          |
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
| ubuntu/18.04 (7 more)         | 78c84d6bc987 | yes    | Ubuntu bionic amd64 (20190502_07:42)   | x86_64  | 122.15MB | May 2, 2019 at 12:00am (UTC) |
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
| ubuntu/18.04/arm64 (3 more)   | 02351c956d57 | yes    | Ubuntu bionic arm64 (20190502_07:43)   | aarch64 | 115.91MB | May 2, 2019 at 12:00am (UTC) |
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
| ubuntu/18.04/armhf (3 more)   | 5bf8790e1a27 | yes    | Ubuntu bionic armhf (20190502_07:42)   | armv7l  | 112.99MB | May 2, 2019 at 12:00am (UTC) |
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
| ubuntu/18.04/i386 (3 more)    | b0b4cab1eea1 | yes    | Ubuntu bionic i386 (20190502_07:42)    | i686    | 123.40MB | May 2, 2019 at 12:00am (UTC) |
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
| ubuntu/18.04/ppc64el (3 more) | 0906327f2cdc | yes    | Ubuntu bionic ppc64el (20190502_07:42) | ppc64le | 129.89MB | May 2, 2019 at 12:00am (UTC) |
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
| ubuntu/18.04/s390x (3 more)   | b976d4f78567 | yes    | Ubuntu bionic s390x (20190502_07:42)   | s390x   | 119.77MB | May 2, 2019 at 12:00am (UTC) |
+-------------------------------+--------------+--------+----------------------------------------+---------+----------+------------------------------+
```
## lxc launch 
```lxc launch <nazwa_maszyny>```

```lxc launch <nazwa_maszyny> --profile <nazwa_profilu>``` - tworzy maszynę o podanej nazwie używając podanego profilu

## lxc list

## lxc delete 
```lxc delete <nazwa_maszyny>``` - usuwa maszynę o podanej nazwie. Maszyna przed usunięciem musi zostać zastopowana
```lxc delete <nazwa_maszyny> --force``` - usuwa maszyne o podanej nazwie nawet jeśli maszyna wciąż jest uruchomione 

## lxc stop 
```lxc stop <nazwa_maszyny>``` - zatrzymuje maszyne o podanej nazwie

## lxc start
```lxc start <nazwa_maszyny>``` - uruchamia maszynę o podanej nazwie

## lxc copy
```lxc copy <nazwa_maszyny_źródłowej> <nazwa_maszyny_decelowej>``` - kopiuje istniejącą maszynę. Nowa maszyna jest zatrzymana po utworzeniu

## lxc move
Polecenie może przenosić maszyny pomiędzy hostami w klastrze LVC 

```lxc move <nazwa_maszyny> <nowa_nazwa> ``` - zmienia nazwę wskazanej maszyny. Zmiana nazwy maszyny nie jest możiwe jeśli maszyna jest utuchomiona 

## lxc exec
```lxc exec <nazwa_maszyny> <polecenie>``` - uruchamia program/polecenie na wskazanej maszynie. Używa się do uruchamiana powłoki shell na maszynie np.: ```lxc exec <nazwa_maszyny> bash```

## lxc info
```lxc info <nazwa_maszyny>``` - pokazuje informację na temat podanej maszyny 

## lxc config
```lxc config show <nazwa_maszyny>``` - pokazuje konfigurację wskazanej maszyny 

##lxc profile
```lxc profile list``` - pokazuję listę dostępnych profili
```lxc profile show <nazwa_profilu>``` - pokazuje parametry i informację na temat wskazanego prfilu

```
lxc profile show default
config: {}
description: Default LXD profile
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: lxdbr0
    type: nic
  root:
    path: /
    pool: LXD
    type: disk
name: default
used_by: []
```

```lxc profile copy <nazwa_profilu> <nazwa_nowego_profilu>``` - kopiuje wskazany profil i tworzy nowy o podanej nazwie

## lxc network
```lxc network show <nazwa_interfajsu_lxc>``` - pokazuje konfiguracje interfejsu sieciowego lxc

```
config:
  ipv4.address: 10.69.185.1/24
  ipv4.nat: "true"
  ipv6.address: fd42:1100:5c6b:8412::1/64
  ipv6.nat: "true"
description: ""
name: lxdbr0
type: bridge
used_by:
- /1.0/containers/kubernetes-master
- /1.0/containers/kubernetes-worker1
managed: true
status: Created
locations:
- none
```

## lxc file
```lxc file edit <nazwa_maszny><scieka_do_pliku>``` -- pozwala na edycje pliku z konenera za pomocą domyślnego edytora tekstu hosta np.: ```lxc file edit web/etc/fstab```

# Ustawienie rozwiązywania nazw DNS maszyn lxc na hoście
https://blog.simos.info/how-to-use-lxd-container-hostnames-on-the-host-in-ubuntu-18-04/