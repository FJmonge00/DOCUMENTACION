# Joomla

## Deploy y Servicio (Joomla)

```yml
#############################
## Servicio de Joomla      ##
#############################
apiVersion: v1
kind: Service
metadata:
  name: joomla-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente  # Cambiar por SQL
spec:
  ports:
    - port: 80
  selector:
    app: joomla 
    cliente: elcliente # Cambiar por SQL
    tier: frontend
  type: NodePort
---
###############################
## Deployment de  Joomla    ##
###############################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: joomla-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: joomla
      cliente: elcliente # Cambiar por SQL
      tier: frontend
  # replicas: 4 # No sincronizacion con la B.D
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: joomla
        cliente: elcliente # Cambiar por SQL
        tier: frontend
    spec:
      containers:
      - image: joomla:3.9.25-apache
        name: joomla-id #Cambiar por SQL
        env:
        - name: JOOMLA_DB_HOST
          value: mysql-id #CAMBIAR  POR EL SQL
        - name: JOOMLA_DB_PASSWORD
          value: contrasena # CAMBIAR OA
        ports:
        - containerPort: 80
          name: joomla-id #Cambiar por SQL
        volumeMounts:
        - name: joomla-persistent-storage
          mountPath: /var/www/html
      volumes:
      - name: joomla-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-joomla-id # #Cambiar por SQL
```

## Deploy y Servicio (MySQL)

```yml
########################
## Servicio de MySQL  ##
#######################
apiVersion: v1
kind: Service
metadata:
  name: mysql-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente # Cambiar por SQL # Cambiar por SQL
spec:
  ports:
    - port: 3306
  selector:
    app: joomla
    tier: mysql
  clusterIP: None
---
###########################
## Deployment de MySQL   ##
###########################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: joomla
      cliente: elcliente # Cambiar por SQL
      tier: mysql
  #replicas: 2 # Replicas no sincronizacion
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: joomla
        cliente: elcliente # Cambiar por SQL
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql-id # Cambiar por SQL
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: contrasena # #Cambiar por OA
        ports:
        - containerPort: 3306
          name: mysql-id # Cambiar por SQL
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-mysql-id #Cambiar por SQL
```

## Volumenes: PV y PVC (Joomla)

```yml
#########################
## PV para Joomla     ##
########################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-joomla-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 15Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Delete
  storageClassName: joomla-id # Cambiar por SQL
  hostPath:
    path: /home/joomla-id # Cambiar por SQL
```

```yml
###########################
## CLAIM PARA  Joomla   ##
###########################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-joomla-id # cambio
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente #CAMBIAR
spec:
  storageClassName: joomla-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 15Gi
```

## Volumenes: PV y PVC (MySQL)

```yml
#####################
## PV para MySQL  ###
#####################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-mysql-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Delete
  storageClassName: mysql-id # Cambiar por SQL
  hostPath:
    path: /home/mysql-id
```

```yml
######################
## CLAIM PARA MYSQL ##
######################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-mysql-id
  labels:
    id: "1000" # Cambiar por SQL
    app: joomla
    cliente: elcliente # Cambiar por SQL
spec:
  storageClassName: mysql-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```