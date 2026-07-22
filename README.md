onxx-x143

![install](https://raw.githubusercontent.com/onxx-x143/APK-GET/main/onxx.gif)

Java Android APK Builder Tool — Bash script jo naya Java Android project generate karta hai (MainActivity.java, layouts, banner ke saath) aur Gradle se APK build karta hai.

## Requirements

- JDK 17+
- Android SDK (`ANDROID_HOME` set hona chahiye)
- Gradle (ya project ka gradle wrapper)

## Installation

```bash
git clone https://github.com/APK-GET/onxx-x143.git
cd APK-GET
chmod +x main.sh
bash Main.sh
```

## Usage

### Naya project generate karna (bina build)
```bash
bash onxx.sh init MyFirstApp com.example.myfirstapp
```

### Sirf build karna
```bash
bash onxx.sh build MyFirstApp debug
```

### Dono ek saath (init + build)
```bash
bash onxx.sh all MyFirstApp com.example.myfirstapp debug
```

## Command Arguments

| Argument | Matlab |
|---|---|
| `all` / `init` / `build` | Command type |
| `MyFirstApp` | Project/app ka naam |
| `com.example.myfirstapp` | Package name (Android app ka unique ID) |
| `debug` / `release` | Build type |

## Android SDK Path Set Karna

```bash
export ANDROID_HOME=$HOME/android-sdk
echo 'export ANDROID_HOME=$HOME/android-sdk' >> ~/.bashrc
source ~/.bashrc
```

## APK Install Karna (Termux)

```bash
cd MyFirstApp
termux-open app/build/outputs/apk/debug/app-debug.apk
```

## Notes

- Script ko `bash onxx.sh ...` se hi chalayein — `python3` se nahi, kyunki yeh Bash script hai.
- Build fail ho to sabse pehle `ANDROID_HOME` set hai ya nahi check karein.

```bash
bash -x onxx.sh all MyFirstApp com.example.myfirstapp debug 2>&1 | tee error-log.txt
```
