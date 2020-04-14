# Kubernetes

## Get Kubernetes Dasboard Token

```kubectl describe sa dashboard-admin -n kube-system```

```kubectl describe  secret dashboard-admin-token-bdd4z -n kube-system```

```kubectl taint nodes --all node-role.kubernetes.io/master-```

## Główne komponenty Kubernetes

### ETCD - rozproszona baza danych key - value

Przechowuje informację na tenam wszystkich objektów Kubernetes

Port: 2379

Klient ETCD:
```etcdctl```

```etcdctl set key1 value1``` - dodaje wpis do bazy danych

```etcdctl get key1``` - pobiera wartość podanego klucza

```etcdclt``` - wyświetla help

```etcdctl snapshot save <nazwa_pliku>``` - tworzy snapshot bazy danych ETCD

```etcdctl snapshot status <nazwa_pliku>``` - pokazuje status snapshotu w podanym pliku

### KubeAPI-Server - Glówny komponent Kubernetesa odpowiedzialny za zarządzanie klastrem

Przetwarza wszystkie zapytania kierowane przez ```kubectl```, weryfikuje uprawnienia, sprawdza ich poprawność, pobiera i aktualizuje informacje w ETCD, komunikuje się kube-schedulerem oraz kubelet na poszczególnych nodach i uruchamia requestowane objekty na odpowiedniach nodach

```/etc/kubernetes/manifests/kube-apiserver.yaml``` - plik konfiguracyjny kube-apiserver

### Kube-Controller Manager

Monitoruje status elementów składających się na kaster oraz dba o to aby elementy skadowe klastra znajdowały się w zdefiniowanym staninie.

Elementy Controller Managera

- Node-Controller - dba o prawidłowy stan nodów. Przy pomocy kuber-apiserver monitoruje status nodów co 5 sekund
- Replication-Controller - monitoruje status objektów typu ReplicaSets, czy utworzonych jest odpowiednia, zdefiniowana liczba podów w każdym ReplicaSet. Jeżeli pod z jakiś względów umiera towrzy kolejny który go zastąpi.

```/etc/kubernetes/manifests/kube-controller-manager.yaml``` - plik konfiguracyjny kube-controller-manager

### Kube-Scheduler

Jest odpowiedzialny za decydowanie który z podów powinien trafić na który node, w zależności od właściwości danego poda i noda.

```/etc/kubernetes/manifests/kube-scheduler.yaml``` - plik konfiguracyjny kube-scheduler

### Kubelet

Serwis wystawiony na każdym z nodów. Tworzy odpowieniednie pody bazując na informacjach przesłanych przez kube-apiserver. Przesyła informacje o statusie noda i poda na którym się znajduje do kube-apiserver'a

### Kube-proxy

Tworzy sieć przez którą pody komunikują się ze sobą. Znajduje się na każdym nodzie klastra. Monitoruje status objektów typu Service i towrzy odpowiednie reguły na każdym z nodów aby pody mogły sie komunikować ze sobą.

## Typy objektów Kubernetes

### Pod

Najmnniejsza objekt składowy klastra Kubernetes. W tym objekcie uruchamiane są kontenery. W każdym podzie uruchomione może być jeden lub więcej kontenerów, ale nie mogą to być kontenery tego samego typu. Najczęście w jednym podzie dodaje się kontenery pomocniczne, wspierające główną aplikację. Kontenery w tym samym podzie mają ten sam adres ip i mogą komunikować się po localhost, jednakże usługi muszą być wystawione na innych portach

Polecenia:

```kubectl run <nazwa_poda> --image <nazwa_image>``` - tworzy instancje kontenera o podanej nazwie z podanego obrazu

```kubectl get pods``` - wyświetla uruchomionych podów

```kubectl describe pod <nazwa_poda>``` - wyswietla właściwości podanego poda

### ReplicaSets / Replication Controller

Replication controller oraz ReplicaSet są to dwa różnie obiekty które realizują to samo zadanie. Replication Controller został zastąpiony przez ReplicaSet i nie jest rekomendowanie używanie go.

ReplicaSet dba o to by dana aplikacja miała zawsze uruchomionych tyle podów ile zostało zdefiniowanych w manifeście. Jeżeli pod w ReplicaSet z jakiś względów zostanie utracowny, ReplicaSet uruchomi dodatkowe pody by uruchomionych było zawsze odpowiednia ilość podów danej aplikacji.

```kubectl get replicaset <nazwa_replicaSet>```

```kubectl scale --replicas=x replicaset <nazwa_replicaset>``` redefiniuje liczbę uruchomionych podów w podanym replica set

### Deployments

Objekt pozwalający aktualizowanie aplikacji do nowej wersji, który wspiera mechanizmy rolling update oraz wycowywanie wprowadznaych zmian. Deployment w swojej definicji nie różni się od definicji ReplicaSet. Podczas stworzenia objektu Deployment automatycznie tworzy się ReplicaSet

Deployments snippets:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: <Image>
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
        - containerPort: <Port>
```

### Namespaces

Zapewnia logiczny podział zasobów klastra. Pozwala na logiczne odseparowanie jednych objektów od drugich. Pozwala na dodawanie różnego rodzaju reguł za pomocą których można ognazniczać dostęp oraz dostępne zasoby.

```--namespace=<nazwa_namespace>``` - parametr który pozwala uruchomić polecnie w namespace innym niż Default.

```--all-namespaces``` - parametr który pozwala uruchomić polecenie które zastosowane będzie dla wszystkich namespace

```kubectl create namespace <nazwa_namespace>``` - tworzy namespace o podanej nazwie

```kubectl config set-context <nazwa_odecnego_namespace> --namespace=<nazwa_nowego_namespace>``` - polecenie pozwala na zmiane domyślnego namespace

```kubectl config current-context``` - wyświetla namespace w którym obecnie pracujemy

Namespace snippset:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name:  name
```

### Service

Pozwala na utworznie pojedyńczego punktu odniesienia dla jednego lub więcej podów świadczących tą samą usługę. Jego rolą jest pośredniczenie w ruchu z poza klastra lub w wewnątrz klastra do poda lub podów.

Typy objektu Service:

- NodePort - otwiera port o podanym numerze na każdym nodzie klastra prowadząc do usułgi. Zakres portów jakie mogą być użyte w nodeport to 30000 - 32767. Ruch przychodzący do servisu rozdzilany jest ranodomowo pomiędzy pody
- ClusterIP - adres ip dostępny tylko w wewnętrznej komunikacji w klastrze. Ruch przychodzący do servisu rozdzilany jest ranodomowo pomiędzy pody
- LoadBalander - adres ip dostępny z poza klastra, służący do publikowania usług. Służący do rozdzielania ruchu sieciowego i obciążenia na poszczególne pody usługi

```kubectl get services``` - wyswietla listę uruchomionych objektów typu service

```service_name.namespace_name.svc.cluster.local```

Service snippset:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp
spec:
  selector:
    app: myapp
  ports:
  - port: <Port>
    targetPort: <Target Port>
```

### Binding

## Labels

Właściwość która można dodać do każdego z obiektów w klastrze Kubernetes. Zapisywana jest w formie klucz, wartość. Może ona służyć do filtrowania obiektów z pośród reszty i dodawania im nowych funkjonalności. Np. filtrowanie podów które mają zostać dodane do servisu.

## Selectors

Jest to filtr który filtruje obiekty które posiadają odpowiedni label z odpowiednią wartością.

```--selector key=value``` - filtruje obiekty wyślwietlane przez polecenie ```get```

## Annotations

Metadane które można dodać do manifestów, nie mają one wpływu na działania obiektu. Służą one jedynie jako pola informacyjne

## Tainsts and Tolerations

Taint - właściwość nadawana na nody klastra która powoduje, że mogą tam być umieszczane tylko pody które mają odpowiednią wartość Tolerations

```kubectl taint nodes <nazwa_noda> key=value:taint-effect``` nadaje taint nodowi. Pole taint-effect definiuje co należy zrobić z podem który nie ma odpoweidniej tolerancji.

Typy taint-effect:

- NoSchedule - pod nie bedzie stawainy na danym nodzie
- PreferNoSchedule - Kubernetes bedzie starał się nie stawiać na tym nodzie podów, ale może to zrobić w ostateczności.
- NoExecute - nowe pody nie bedą ustawiane na noda, a te które są na nim i nie mają odpowiedniej tolerancji zostaną usunięte. 

## Node labels and selectors 

Mechanizm działający w taki sam sposób jak w przypadu podów czy innych obiektów Kubernetes, lecz definiowanych na nodzie.
Za pomocą nodeSelectors podanych w definicji poda możemy sterować na jaką pulę nodów ma zostać skierowany pod.

```kubectl label node <nazwa-noda> key=value``` - nadaje nodowi o podanej nazwie label o nazwie key i wartości value

## Affinity

Bardziej rozbudowana forma node labels and selectors. Pozwala ustalać w definicji poda warunki AND, OR jakie musi spełanić node aby został na nim umieszczony pod.

## Resource Requests and Limits

Definiowane w definicji poda, dzielą się na dwa typy:
Requests - minimalna wartość zasobów jakie wolne musi posiadać node aby mógł zostać położony tam pod. Defaultowo każdy z podów zadeklarowane ma 0.5 CPU oraz 256Mi RAM.
Limits - maksymalna ilość zasobów jakie pod może zająć na danym nodzie. Defaultowo każdy z podów zadeklarowane ma 1 CPU oraz 512Mi RAM. Jeżeli pod stale będzie przekraczał założony limit zostanie on zabity.

Wartości defaultowe resource and limits można zmienić za pomocą objektu LimitRange stosowanego definiowanego na poziomie namespace.

https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource

## DemonSets

Typ objektu podobny do ReplicaSet, jego głowną właściwością jest to, że tworzy po jednej kopii poda na każdym z nodów podłączonym do klastra.

```kubectl get deamonset``` - pokazuje objekty typu deamonset uruchomione na klastrze. 

## Static Pod 

Pod w całości stworzony oraz zarządzany przez kublet zainstalowany na nodzie, bez udziału kube-apiservice, ani żadnego z komponenetów zlokalizowanych na master nodzie. 
Aby uruchomić statyczny pod należy utworzyć jego manigest w katalogu ```/etc/kubernetes/manifest```. Kubelet co jakiś czas sprawdza zawartość tego katalogu i uruchamia zdefiniowane tam manifesty, a także sprawdza czy pod nadal jest uruchomiony. Nie możliwe jest uruchamianie innych objektów niż pod w ten sposób.
Wszystkie usuługi które uruchomione są na master nodzie, uruchamiane są w ten sposób.


# Monitoring

```kubectl logs -f <nazwa_poda> <nazwa_kontenera>``` - pokazuje logi poda które wyrzucane są stdout. Parametr -f pwoduje pokazywanie logów live. Jeżeli pod zawiera więcej niż jeden kontener należy zdefiniować który.  


# Lifecycle managment

```kubectl rollout status deployment/<deployment_name>``` - wskazuje status obecnych zmian w objekcie deployments

```kubectl rollout history deployment/<deployment_name>``` - wskazuje poprzednie zmiany w deploymcie

Deployment stratedy:
- recreate - polega na usunięciu podów z aplikacją w starej wersji oraz uruchomienie podów w nowej wersji. Powodować to może luki w funkcjonowaniu aplikacji w momecie przełączenia
- rollingupdate - polega na stopniowym usuwanie podów starszej wersji od razu zastępując je podami w wersji nowszej. Zaletą takie rozwiązania jest brak brak luk w funkcjonowaniu usługi.

Wykonanie polecenia ```kubectl apply -f <deployment_yaml>``` - wskazując na plik posiadający zmiany w już uruchomionym deploymencie spowoduje automatyczny process rolling update.

```kubectl rollout undo deployment/<nazwa_deploymentu>``` - spowoduje cofnięcie wprowadzonych przez update zmian


# ConfigMaps

```kubect get configmaps``` - wyswietla wszystkie ConfigMapy

# Secrets 

Sekrety kodowane są odwracalnym algorytmem base64

```echo -n 'secret_value' | base64``` - na systemach linux pozwala na kodowanie wartości typu string do wartości base64

```echo -n 'c2VjcmV0X3ZhbHVl' | base64 --decode``` - pozwala na dekodowanie wartości zakodowanych base64

```kubectl get secretes``` - wyświetla wszystkie objekty typu secret

Secret snippets:
```
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  secret_name: base64_value
```
# Zarządzanie klastrem

```kubectl drain <nazwa_noda>``` - ustawia status UNREACHABLE na nodzie i zabija wszystkie pody które na nim żyły. Jednocześnie rekreując je na innych dostępnych nodach. Pod nie musi być członkiem ReplicaSet by zostać zrekreowanym 

```kubectl uncordon <nazwa_noda>``` - usuwa stan UNREACHABLE z noda. Pozwala to na ponowne deployowanie podów na noda. Pody które były na nodzi przed uruchomieniem polecenia ```kubectl drain``` nie wracją


# Backup

```kubectl get all --all-namespaces -o yaml >> all-deploy-services.yaml``` - tworzy backup wszystkich usług i aplikacji które są uruchomione na serwerze, tych które powstały w sposób deklaratywny i imperatywny


# Storage

## PersistentVolume

Pula przestrzeni dyskowej dostępna z poziomu wszystkich nodów w klastrze. Wykorzystywana do przechowywania danych generowanych przez pody. Dane te nie są usuwane wraz ze śmiercia poda.

```kubectl get persistentvolume/pv``` - listuje wszystkie zkonfigurowane PV w klastrze 

## PersistenVolumeClaim

Zdefinionwe w definicji poda żądanie przyznania przestrzeni dyskowej z puli Persistent Volume

```kubectl get persistentvolumeclain/pvc``` - pokazuje listę i status pvc na klastrze 

# Networking







## DNS

```<service-name/pod-ip>.<namespace>.svc.cluster.local```