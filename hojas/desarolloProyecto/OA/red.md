# Red

```xml
<network>
  <name>default</name>
  <uuid>33c83f80-c6ea-4b44-8d22-a3de52ad90f8</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='lamac'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

________________________________________
*[Volver al atrás...](./kvmQemu.md)*
