## Using adb to grab a android package from a phone.

Build this container:

```sh
docker_build_container . adb
```

Plug your testing android phone into your computer and turn on debugging mode.


Run:

```s2e
docker run -it --device /dev/bus/usb  s2e/adb bash
```

Once the docker container loads run the following to get the list of packages on a device

```s2e
adb start-server
adb devices
adb help
adb shell pm list packages
```

Get package names
remove "Package:" from start of them

```sh
adb shell pm path com.PACKAGE.NAME
```

Pull from that path

```sh
adb pull /data/app/com.PACKAGE.NAME-fN7kj8WEM0YxO-1pw8d3Ew==/base.apk /tmp/com.PACKAGE.NAME.apk
```

Now you got the apk

```sh
ls /tmp/com.PACKAGE.NAME.apk
```
