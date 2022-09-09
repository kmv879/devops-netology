## Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами."

### Задача 1  
Опишите своими словами основные преимущества применения на практике IaaC паттернов.  

Непрерывная интеграция позволяет сократить стоимость исправленния дефекта за счет раннего выявления.  
Непрерывная доставка позволяет выпускать изменения небольшими партиями, которые легко изменить или устранить, путём отката на предыдущую версию.  
Непрерывное развертывание автоматически развертывает доставленное программное обеспечение.  

Какой из принципов IaaC является основополагающим?  

Основополагающим принципом IaaC является идемпотентность - свойство объекта или операции, при повторном выполнении которой получается результат идентичный предыдущему.   
 


### Задача 2  
Чем Ansible выгодно отличается от других систем управление конфигурациями?  

Ansible отличается от других систем управления конфигурациями тем, что использует существующую SSH инфраструктуру.  

Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?  

На мой взгляд более надежны метод pull, так как метод push  не гарантирует доставку конфигурации в случае недоступности хоста.  

### Задача 3  
Установить на личный компьютер:  

VirtualBox 

```
> vboxmanage --version
6.1.34_Ubuntur150636
```

Vagrant  

```
> vagrant --version
Vagrant 2.2.19
```

Ansible  

```
> ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/kmv/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.4 (main, Jun 29 2022, 12:14:53) [GCC 11.2.0]
```
 

### Задача 4(*)   
Воспроизвести практическую часть лекции самостоятельно.  

Создать виртуальную машину.  
Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды    
```docker ps```  

```
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

vagrant@server1:~$ systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-09-09 09:27:34 UTC; 1min 19s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 2902 (dockerd)
      Tasks: 7
     Memory: 41.0M
        CPU: 272ms
     CGroup: /system.slice/docker.service
             └─2902 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```