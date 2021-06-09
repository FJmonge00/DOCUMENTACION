# MediaWiki
> El software ofrecido de manera oficial en la versión 1.35 no es compatible para su despliege automatización, es posible levantar contenedores con docker para pruebas en entornos de desarrollo. Pero no para automatizar el despliegue de este servicio, almenos para que sea computacionalemente hablando rentable y lo suficientemente sencillo para que valga la pena. 

Ademas no considero que sea un servicio extremadamente solicitado para su automatización.

_Ver en el punto de Conclusiones y dificultades encontradas_

## Deploy y Servicio (MediaWiki)

```yml
#############################
## SERVICIO PARA mediawiki ##
#############################
apiVersion: v1
kind: Service
metadata:
  name: mediawiki-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: mediawiki
    cliente: elcliente  # Cambiar por SQL
spec:
  ports:
    - port: 80
  selector:
    app: mediawiki
    cliente: elcliente # Cambiar por SQL
    tier: frontend
  type: NodePort
---
###############################
## DEPLOYMENT PARA mediawiki    ##
###############################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mediawiki-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: mediawiki
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: mediawiki
      cliente: elcliente # Cambiar por SQL
      tier: frontend
  # replicas: 4 # Por defecto, No sincronizacion con la B.D
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: mediawiki
        cliente: elcliente # Cambiar por SQL
        tier: frontend
    spec:
      containers:
      - image: mediawiki:1.35.1 # Versiones de apache no la lastest
        name: mediawiki-id #Cambiar por SQL
        ports:
        - containerPort: 80
          name: mediawiki-id #Cambiar por SQL
        volumeMounts:
        - name: mediawiki-persistent-storage
          mountPath: /var/www/html/images
      volumes:
      - name: mediawiki-persistent-storage
        persistentVolumeClaim:
          claimName: pvc-elcliente-mediawiki-id # Cambiar respecto al fichero de PVC
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
    app: mediawiki
    cliente: elcliente # Cambiar por SQL # Cambiar por SQL
spec:
  ports:
    - port: 3306
  selector:
    app: mediawiki
    tier: mysql
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
    app: mediawiki
    cliente: elcliente # Cambiar por SQL
spec:
  selector:
    matchLabels:
      id: "1000" # Cambiar por SQL
      app: mediawiki
      cliente: elcliente # Cambiar por SQL
      tier: mysql
  #replicas: 2 # Por defecto 2 Replicas
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        id: "1000" # Cambiar por SQL
        app: mediawiki
        cliente: elcliente # Cambiar por SQL
        tier: mysql
    spec:
      containers:
      - image: mysql:5.6
        name: mysql-id # Cambiar por SQL
        env:
        - name: MYSQL_DATABASE
          value: dbmiwiki # cambiar respecto al fichero de PVC y Cambiar por SQL
        - name: MYSQL_USER
          value: usuario # cambiar respecto al fichero de PVC y Cambiar por SQL
        - name: MYSQL_PASSWORD
          value: Coria21 # cambiar respecto al fichero de PVC y Cambiar por SQL
        - name: MYSQL_ROOT_PASSWORD
          value: Coria21 # cambiar respecto al fichero de PVC y Cambiar por SQL
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

## Volumenes: PV y PVC (MediaWiki)

```yml
#########################
## PV para MediaWiki  ###
########################
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elcliente-mediawiki-id #Cambiar por SQL
  labels:
    id: "1000" # Cambiar por SQL
    app: mediawiki
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 25Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: mediawiki-id # Cambiar por SQL
  hostPath:
    path: /home/mediawiki
```

```yml
###########################
## CLAIM PARA  mediawiki ##
###########################
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-elcliente-mediawiki-id # cambio
  labels:
    id: "1000" # Cambiar por SQL
    app: mediawiki
    cliente: elcliente #CAMBIAR
spec:
  storageClassName: mediawiki-id # Cambiar por SQL
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
    app: mediawiki
    cliente: elcliente #Cambiar por SQL
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: mysql-id # Cambiar por SQL
  hostPath:
    path: /home/mysql
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
    app: mediawiki
    cliente: elcliente #CAMBIAR
spec:
  storageClassName: mysql-id # Cambiar por SQL
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```