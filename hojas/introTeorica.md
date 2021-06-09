# Introducción Teórica

## Contenedores y los Servicios

Cuando contenerizamos los servicios conseguimos unas pérdidas mínimas virtualización, ya que no virtualizamos un sistema operativo completo por cada servicio sinó que unicamente tendremos la apliacción o servicio con el conjunto de librerias necesarias y como sistema opertivo el propio kernel de linux que hospeda los contenedores.
Se Consigue:

- Aislamiento
- Seguridad
- Escalabilidad de los servicios 
- Facilidades para Automatización y despliegue.

## KVM Hipervisor Tipo 1

KVM (Máquina Virtual Basada en Kernel) está integrado en el Kernel de Linux como una funcionalidad adicional de este. Permite convertir el kernel de Linux en un hipervisor. A veces se confunde con ser un hipervisor tipo 2. Pero realmente, tiene acceso directo al hardware junto a las máquinas virtuales que aloja. Cuando instalamos los diferentes paquetes y librerías activamos parte de modulos de kernel de linux.

## /dev/random y urandom

/dev/random es un archivo especial que sirve como un generador de caracteres aleatorios, o un generador de números seudo-aleatorios. Permite el acceso a ruido ambiental recogido de dispositivos y otras fuentes. /dev/urandom que reutiliza la fuente interna para producir más bits seudoaleatorios. Esto implica que llamadas de lectura nunca se bloquearán, pero la salida puede contener menos entropía que una lectura de /dev/random.

Podemos generar contraseñas aletorias sin necesidad de un software especial:

```bash
cat /dev/urandom | tr -dc [:upper:][:lower:][:digit:] | head -c32
```

## Bus Virtio

El controlador virtio de Linux también forma parte núcleo de Linux. El uso del bus virtio, ya que es un bus nativo que permitirá velocidades de casi bare-metal en las máquinas virtuales. (Un funcionamiento prácticamente igual que la máquina física)
