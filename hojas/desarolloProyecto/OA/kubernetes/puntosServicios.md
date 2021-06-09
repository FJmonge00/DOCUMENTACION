# Puntos de un Servicio en Kubernetes

Cada uno de los servicios que se desplegen en cluster tendrán cada uno de los siguientes puntos o entidades.

## Deploy

```bash
kubectl get deploy -l cliente=ayesa
```

![servicio](../imagenes/servi1.jpg)

## Pods

```bash
kubectl get pods -l cliente=ayesa
```

![servicio](../imagenes/servi5.jpg)

## Servicios

```bash
kubectl get svc -l cliente=ayesa
```

![servicio](../imagenes/servi2.jpg)

## Volumenes (pv)

```bash
kubectl get pv -l cliente=ayesa
```

![servicio](../imagenes/servi3.jpg)

## Volumenes (pvc)

```bash
kubectl get pvc -l cliente=ayesa
```

![servicio](../imagenes/servi4.jpg)