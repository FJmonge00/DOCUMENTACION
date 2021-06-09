# PrestaShop

## Deploy y Servicio (PrestaShop)


```yml
#############################
## Servicio de PrestaShop  ##
#############################
apiVersion: v1
kind: Service
metadata:
  name: prestashop-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente  # Cambiar por SQL
spec:
  ports:
    - port: 80
  selector:
    app: prestashop
    cliente: elcliente # Cambiar por SQL
    tier: frontend
  type: NodePort
---
###############################
## Deployment de PrestaShop  ##
###############################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prestashop-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: prestashop
      cliente: elcliente # Cambiar por SQL
      tier: frontend
  # replicas: 4 # No sincronizacion con la B.D
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: prestashop
        cliente: elcliente # Cambiar por SQL
        tier: frontend
    spec:
      containers:
      - image: prestashop/prestashop:1.7.7.2-apache # Version de apache propietario PrestaShop
        name: prestashop-id #Cambiar por SQL
        env:
        - name: DB_SERVER
          value: mysql-id #CAMBIAR  POR EL SQL
        - name: DB_PASSWORD
          value: contrasena # CAMBIAR POR OA
        - name: DB_PREFIX
          value: ps_ 
        - name: DB_NAME
          value: prestashop
        - name: PS_FOLDER_ADMIN
          value: admin-id
        ports:
        - containerPort: 80
          name: prestashop-id #Cambiar por SQL
        volumeMounts:
        - name: prestashop-persistent-storage
          mountPath: /var/www/html
      volumes:
      - name: prestashop-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-prestashop-id # Cambiar por SQL
```

## Deploy y Servicio (MySQL)

```yml
########################
## Servicio de MySQL  ##
########################
apiVersion: v1
kind: Service
metadata:
  name: mysql-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente # Cambiar por SQL
spec:
  ports:
    - port: 3306
  selector:
    app: prestashop
    tier: mysql
  clusterIP: None
---
########################
## Deployment  MySQL  ##
########################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: prestashop
      cliente: elcliente # Cambiar por SQL
      tier: mysql
  #replicas: 2 # Replicas No sincroniza BD
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: prestashop
        cliente: elcliente # Cambiar por SQL
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql-id # Cambiar por SQL
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: contrasena # Cambiar OA
        ports:
        - containerPort: 3306
          name: mysql-id # Cambiar por SQL
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-mysql-id # Cambiar por SQL
```

## Volumenes: PV y PVC (PrestaShop)

```yml
#########################
## PV de PrestaShop  ###
########################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-prestashop-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 15Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Delete
  storageClassName: prestashop-id # Cambiar por SQL
  hostPath:
    path: /home/prestashop-id #Cambiar por SQL
```

```yml
###########################
## Claim de  Prestashop ##
###########################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-prestashop-id # cambio
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente #Cambiar por SQL
spec:
  storageClassName: prestashop-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 15Gi
```

## Volumenes: PV y PVC (MySQL)

```yml
#####################
## PV de MySQL   ###
#####################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-mysql-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Delete
  storageClassName: mysql-id # Cambiar por SQL
  hostPath:
    path: /home/mysql-id #Cambiar por SQL
```

```yml
######################
## Claim de MySQL  ##
######################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-mysql-id
  labels:
    id: "1000" # Cambiar por SQL
    app: prestashop
    cliente: elcliente # Cambiar por SQL
spec:
  storageClassName: mysql-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```