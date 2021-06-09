# Wordpress

## Deploy y Servicio (Wordpress)


```yml
#############################
## SERVICIO PARA wordpress ##
#############################
apiVersion: v1
kind: Service
metadata:
  name: wordpress-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: wordpress
    cliente: elcliente  # Cambiar por SQL
spec:
  ports:
    - port: 80
  selector:
    app: wordpress
    cliente: elcliente # Cambiar por SQL
    tier: frontend
  type: NodePort
---
###############################
## DEPLOYMENT PARA wordpress    ##
###############################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: wordpress
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: wordpress
      cliente: elcliente # Cambiar por SQL
      tier: frontend
  # replicas: 4 # Por defecto, No sincronizacion con la B.D
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: wordpress
        cliente: elcliente # Cambiar por SQL
        tier: frontend
    spec:
      containers:
      - image: wordpress:4.8-apache # Versiones de apache no la lastest
        name: wordpress-id #Cambiar por SQL
        env:
        - name: WORDPRESS_DB_HOST
          value: mysql-id #CAMBIAR  POR EL SQL
        - name: WORDPRESS_DB_PASSWORD
          value: contrasena # CAMBIAR POR SQL B.D
        ports:
        - containerPort: 80
          name: wordpress-id #Cambiar por SQL
        volumeMounts:
        - name: wordpress-persistent-storage
          mountPath: /var/www/html
      volumes:
      - name: wordpress-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-wordpress-id # Cambiar respecto al fichero de PVC
```

## Deploy y Servicio (MySQL)

```yml
#####################
## SERVICIO MYSQL  ##
#####################
apiVersion: v1
kind: Service
metadata:
  name: mysql-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: wordpress
    cliente: elcliente # Cambiar por SQL # Cambiar por SQL
spec:
  ports:
    - port: 3306
  selector:
    id: "1000"
    #app: wordpress
    #tier: mysql
  clusterIP: None
---
########################
## DEPLOYMENT  MYSQL  ##
########################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: wordpress
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      # app: wordpress
      # cliente: elcliente # Cambiar por SQL
      # tier: mysql
  #replicas: 2  # Por defecto, No sincronizacion con la B.D
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: wordpress
        cliente: elcliente # Cambiar por SQL
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql-id # Cambiar por SQL
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: contrasena # cambiar respecto al fichero de PVC y Cambiar por SQL
        ports:
        - containerPort: 3306
          name: mysql-id # Cambiar por SQL
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-mysql-id # cambiar respecto al fichero de PVC y Cambiar por SQL
```

## Volumenes: PV y PVC (Wordpress)

```yml
#########################
## PV para WORDPRESS  ###
########################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-wordpress-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: wordpress
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 25Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Delete
  storageClassName: wordpress-id # Cambiar por SQL
  hostPath:
    path: /home/wordpress-id
```

```yml
###########################
## CLAIM PARA  wordpress ##
###########################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-wordpress-id # Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: wordpress
    cliente: elcliente #CAMBIAR
spec:
  storageClassName: wordpress-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 20Gi
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
    app: wordpress
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
    app: wordpress
    cliente: elcliente #CAMBIAR
spec:
  storageClassName: mysql-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```