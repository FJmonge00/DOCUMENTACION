# Drupal

## Deploy y Servicio (Drupal)


```yml
#############################
## SERVICIO PARA drupal ##
#############################
apiVersion: v1
kind: Service
metadata:
  name: drupal-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente  # Cambiar por SQL
spec:
  ports:
    - port: 80
  selector:
    app: drupal
    cliente: elcliente # Cambiar por SQL
    tier: frontend
  type: NodePort
---
###############################
## DEPLOYMENT PARA drupal    ##
###############################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: drupal-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: drupal
      cliente: elcliente # Cambiar por SQL
      tier: frontend
  # replicas: 4 # Por defecto, No sincronizacion con la B.D
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: drupal
        cliente: elcliente # Cambiar por SQL
        tier: frontend
    spec:
      containers:
      - image: drupal:9.1.8-php8.0-apache-buster # Versiones de apache
        name: drupal-id # Cambiar por SQL
        env:
        - name: POSTGRES_PASSWORD
          value: contrasena #Cambiar por SQL
        ports:
        - containerPort: 80
          name: drupal-id #Cambiar por SQL
        volumeMounts:
        - name: drupal-persistent-storage
          mountPath: /var/www/html/modules
          # subPath: modules
        - name: drupal-persistent-storage
          mountPath: /var/www/html/profiles
          # subPath: profiles
        - name: drupal-persistent-storage
          mountPath: /var/www/html/themes
          # subPath: themes
      volumes:
      - name: drupal-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-drupal-id # Cambiar respecto al fichero de PVC
```

## Deploy y Servicio (PostgreSQL)

> Drupal esta disponible tanto con MySQL-MariaDB como con PostgreSQL, en el caso de drupal su funcionamiento es mejor con PostgreSQL, por lo que el POD de la base de datos contendra un contenedor de PostgreSQL 13.2 en vez de MySQL 5.6. (Sigue siendo unas base de datos del tipo `SQL`)

```yml
#####################
## SERVICIO postgres  ##
#####################
apiVersion: v1
kind: Service
metadata:
  name: postgres-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente # Cambiar por SQL # Cambiar por SQL
spec:
  ports:
    - port: 5432
  selector:
    app: drupal
    tier: postgres
  clusterIP: None
---
###########################
## DEPLOYMENT  postgres  ##
###########################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: drupal
      cliente: elcliente # Cambiar por SQL
      tier: postgres
  #replicas: 2 # Por defecto 2 Replicas
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: drupal
        cliente: elcliente # Cambiar por SQL
        tier: postgres
    spec:
      containers:
      - image: postgres:13.2
        name: postgres-id # Cambiar por SQL
        env:
        - name: POSTGRES_USER
          value: drupal
        - name: POSTGRES_DB
          value: dbdrupal
        - name: POSTGRES_PASSWORD
          value: contrasena #Cambio por OA
        ports:
        - containerPort: 5432
          name: postgres-id # Cambiar por SQL
        volumeMounts:
        - name: postgres-persistent-storage
          mountPath: /var/lib/postgres
      volumes:
      - name: postgres-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-postgres-id # Cambiar por SQL
```

## Volumenes: PV y PVC (Drupal)

```yml
#######################
## PV para drupal    ##
#######################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-drupal-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente # Cambiar por SQL
spec:
  capacity:
    storage: 15Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Delete
  storageClassName: drupal-id # Cambiar por SQL
  hostPath:
    path: /home/drupal-id # Cambiar por SQL
```

```yml
#########################
## CLAIM PARA drupal  ##
#########################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-drupal-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente # Cambiar por SQL
spec:
  storageClassName: drupal-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 15Gi
```

## Volumenes: PV y PVC (PostgreSQL)

```yml
#######################
## PV para postgres  ##
#######################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-postgres-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Delete
  storageClassName: postgres-id # Cambiar por SQL
  hostPath:
    path: /home/postgres-id # Cambiar por SQL
```

```yml
#########################
## CLAIM PARA postgres ##
#########################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-postgres-id
  labels:
    id: "1000" # Cambiar por SQL
    app: drupal
    cliente: elcliente # Cambiar por SQL
spec:
  storageClassName: postgres-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```