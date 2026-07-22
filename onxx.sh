#!/usr/bin/env bash
# Open GitHub
echo -e "\033[38;5;214m[$current_time]\033[0m \033[1;32m[INFO]:\033[0m Opening GitHub in Chrome..."
am start -a android.intent.action.VIEW -d "https://github.com/onxx-x143" com.android.chrome >/dev/null 2>&1 || {
    echo -e "\033[38;5;214m[$current_time]\033[0m \033[1;33m[WARNING]:\033[0m Could not open Chrome."
}

# onxx.sh
# ---------------------------------------------------------
# Ek command-line tool jo naya Java-based Android project
# generate karta hai (MainActivity.java, XML layouts, banner
# drawable ke saath) aur phir Gradle se APK build karta hai.
#
# USAGE:
#   onxx.sh init   <ProjectName> <com.company.app>
#   onxx.sh build  <ProjectName> [debug|release]
#   onxx.sh all    <ProjectName> <com.company.app> [debug|release]
#
# REQUIREMENTS (aapke system par pehle se installed hone chahiye):
#   - JDK 17+           (java -version)
#   - Android SDK        (ANDROID_HOME / ANDROID_SDK_ROOT set hona chahiye)
#   - Gradle (ya project ka apna gradle wrapper)
# ---------------------------------------------------------

set -euo pipefail

# ---------- Colors for pretty output ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color
'clear'


banner() {
echo -e "${RED}"
cat << "EOF"

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⡄⠀⠀⠀⢠⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⠝⡓⢫⣿⠀⠀⠀⣾⡻⠙⠫⣷⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⣡⣾⣷⡌⢻⡷⢦⣾⠟⢁⣽⣷⣌⢯⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⢣⣿⣿⣿⣿⡀⠘⠀⠀⣀⣼⣿⣿⣿⡜⡿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠇⣼⣿⣿⣿⣿⣿⣿⣶⣾⣿⣿⣿⣿⣿⣷⡸⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣤⣶⣦⣄⣠⣴⠿⠃⣼⣿⣿⣿⣿⣿⣟⣻⣿⣟⣻⣿⣿⣿⣿⣿⣷⡘⢿⣦⣄⣠⣴⣶⣤⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⣿⢋⡄⡙⠉⠙⠊⣀⣾⣿⣿⣿⣿⣿⢿⡟⣿⠻⣟⠿⣿⢿⣿⣿⣿⣿⣷⡠⡙⠋⠙⢊⢄⠹⣻⡄⠀⠀
                            BY ONXX⠀⠀⠀
⠀⠀⠀⠀⢸⡷⢾⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣶⣿⣾⣿⡿⠾⠷⣯⣿⣿⣿⣿⣿⣿⣷⣶⣾⣿⣿⣥⣻⡇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⢯⣽⣬⡉⠛⣿⣶⣶⣶⣯⣦⣽⡯⠍⣹⣿⣿⣿⣿⣿⣿⢷⡿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⢻⣟⣿⣿⣿⣿⣿⣿⣿⣿⠃⠼⣿⣤⣿⣿⠀⠙⣿⣿⣿⡿⠇⣯⣽⣿⣿⣿⣿⣿⣿⢿⡟⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠹⣾⣻⣿⣿⣿⣿⣿⣿⣆⣀⣈⠙⠋⣱⣿⣆⠈⢟⣩⣧⣿⣿⢿⣿⣿⣿⣿⣿⣽⠏⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣾⣿⣿⣿⡙⡿⣻⡟⠛⠃⠀⠻⠛⠟⠀⠟⢿⣿⣿⠿⢋⣿⣿⣟⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣀⣴⣾⣛⣩⣭⣝⣻⢿⣿⣿⣿⣤⣀⡒⡦⢦⢦⢶⣆⣤⣯⣿⣿⣿⣿⣿⣏⣁⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣟⣄⣟⣯⣟⣛⣿⡻⣾⣟⣑⣂⣓⣛⣛⣛⣓⣚⣒⣚⣛⡓⣂⣒⣐⣂⣐⣈⣀⣂⣉⣙⢦⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠙⢿⣹⣏⠉⠉⠉⠙⢿⡿⢿⠭⣽⡭⢯⣫⡽⠋⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⠙⠦⠤⠾⠶⠾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⢀⡤⡤⢤⢤⡀⠀⠤⡤⣤⠤⣤⣀⠀⢠⡤⡄⠀⣠⢤⠄⠀⠀⠀⠀⠀⠀⣠⣤⣤⣤⣤⡄⠀⣤⣤⣤⣤⣄⠀⣤⣤⣤⣤⣤⡀
⡿⣜⠉⠁⠮⣽⠀⡹⣼⠁⠉⢰⢫⠀⢸⡱⢇⡜⣮⠃⠀⠀⠀⠀⠀⠀⢸⣿⡏⠉⠉⠉⠁⠀⣿⣏⡉⣉⡉⠀⠉⠉⣿⡏⠉⠁
⣷⣭⡖⡖⢻⣼⠀⢱⠛⣶⠒⣮⢳⠀⢸⢹⡝⡞⣵⠂⠀⠀⣿⣽⣿⠀⢸⣿⡇⢸⢻⣿⡇⠀⣿⣿⠛⠛⠃⠀⠀⠀⣿⡇⠀⠀
⣗⡞⠐⠉⢧⣻⠀⡹⢾⠐⠉⠈⠁⠀⢸⣣⠏⠀⢧⣳⡀⠀⠀⠀⠀⠀⢸⣿⣧⣤⣼⣿⡇⠀⣿⣧⣤⣤⣤⠀⠀⠠⣿⡇⠀⠀
⠁⠉⠀⠀⠉⠉⠀⠁⠉⠀⠀⠀⠀⠀⠈⠁⠁⠀⠀⠁⠁⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠁⠀⠉⠉⠉⠉⠉⠀⠀⠀⠉⠁⠀⠀
EOF
echo -e "${NC}"
echo -e "${RED}${BOLD}   JAVA ANDROID APK BUILDER TOOL  v1.0${NC}"
echo -e "${RED}         Made for building simple Java APKs from CLI${NC}"
echo -e "${RED}              BY ONXX-X143 ${NC}"
echo ""
}

log()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

# ---------------------------------------------------------
# check_requirements: verify JDK, ANDROID_HOME
# ---------------------------------------------------------
check_requirements() {
    log "Environment check kar raha hoon..."

    if ! command -v java &> /dev/null; then
        err "Java JDK nahi mila. Pehle JDK 17+ install karein."
        exit 1
    fi
    ok "Java mila: $(java -version 2>&1 | head -n1)"

    if [ -z "${ANDROID_HOME:-}" ] && [ -z "${ANDROID_SDK_ROOT:-}" ]; then
        warn "ANDROID_HOME / ANDROID_SDK_ROOT set nahi hai. Build fail ho sakta hai."
        warn "  export ANDROID_HOME=/path/to/Android/Sdk"
    else
        ok "Android SDK mila: ${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
    fi
}

# ---------------------------------------------------------
# init_project <ProjectName> <package.name>
# ---------------------------------------------------------
init_project() {
    local PROJECT_NAME="$1"
    local PACKAGE_NAME="$2"
    local PKG_PATH
    PKG_PATH=$(echo "$PACKAGE_NAME" | tr '.' '/')

    if [ -d "$PROJECT_NAME" ]; then
        err "Folder '$PROJECT_NAME' pehle se maujood hai. Dusra naam chunein ya use delete karein."
        exit 1
    fi

    log "Naya project '$PROJECT_NAME' generate kar raha hoon (package: $PACKAGE_NAME)..."

    local APP="$PROJECT_NAME/app"
    local JAVA_DIR="$APP/src/main/java/$PKG_PATH"
    local RES_DIR="$APP/src/main/res"

    mkdir -p "$JAVA_DIR"
    mkdir -p "$RES_DIR/layout"
    mkdir -p "$RES_DIR/values"
    mkdir -p "$RES_DIR/drawable"
    mkdir -p "$RES_DIR/mipmap-anydpi-v26"
    mkdir -p "$RES_DIR/mipmap-hdpi" "$RES_DIR/mipmap-mdpi" "$RES_DIR/mipmap-xhdpi" "$RES_DIR/mipmap-xxhdpi"
    mkdir -p "$PROJECT_NAME/gradle/wrapper"

    # ---------- settings.gradle ----------
    cat > "$PROJECT_NAME/settings.gradle" << EOF
rootProject.name = "$PROJECT_NAME"
include ':app'
EOF

    # ---------- root build.gradle ----------
    cat > "$PROJECT_NAME/build.gradle" << 'EOF'
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.2.0'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

    # ---------- app/build.gradle ----------
    cat > "$APP/build.gradle" << EOF
apply plugin: 'com.android.application'

android {
    namespace '$PACKAGE_NAME'
    compileSdk 34

    defaultConfig {
        applicationId "$PACKAGE_NAME"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            minifyEnabled false
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
}
EOF

    # ---------- gradle.properties ----------
    cat > "$PROJECT_NAME/gradle.properties" << 'EOF'
org.gradle.jvmargs=-Xmx2048m
android.useAndroidX=true
android.nonTransitiveRClass=true
EOF

    # ---------- AndroidManifest.xml ----------
    cat > "$APP/src/main/AndroidManifest.xml" << EOF
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:theme="@style/Theme.AppCompat.Light.DarkActionBar">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
EOF

    # ---------- strings.xml ----------
    cat > "$RES_DIR/values/strings.xml" << EOF
<resources>
    <string name="app_name">$PROJECT_NAME</string>
    <string name="welcome_text">Welcome to $PROJECT_NAME!</string>
</resources>
EOF

    # ---------- colors.xml ----------
    cat > "$RES_DIR/values/colors.xml" << 'EOF'
<resources>
    <color name="banner_start">#4A00E0</color>
    <color name="banner_end">#8E2DE2</color>
    <color name="white">#FFFFFF</color>
</resources>
EOF

    # ---------- banner drawable (gradient) ----------
    cat > "$RES_DIR/drawable/banner_background.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <gradient
        android:angle="45"
        android:startColor="@color/banner_start"
        android:endColor="@color/banner_end"
        android:type="linear" />
</shape>
EOF

    # ---------- activity_main.xml (with banner) ----------
    cat > "$RES_DIR/layout/activity_main.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <!-- Banner Section -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="160dp"
        android:background="@drawable/banner_background"
        android:orientation="vertical"
        android:gravity="center">

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="MY JAVA APP"
            android:textColor="@color/white"
            android:textSize="28sp"
            android:textStyle="bold"
            android:letterSpacing="0.1" />

        <TextView
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginTop="6dp"
            android:text="Built with onxx.sh"
            android:textColor="@color/white"
            android:textSize="14sp"
            android:alpha="0.85" />
    </LinearLayout>

    <!-- Body Section -->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical"
        android:gravity="center"
        android:padding="24dp">

        <TextView
            android:id="@+id/tvWelcome"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="@string/welcome_text"
            android:textSize="20sp" />

        <Button
            android:id="@+id/btnClick"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginTop="20dp"
            android:text="Tap Me" />

    </LinearLayout>

</LinearLayout>
EOF

    # ---------- MainActivity.java ----------
    cat > "$JAVA_DIR/MainActivity.java" << EOF
package $PACKAGE_NAME;

import android.os.Bundle;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private int clickCount = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView tvWelcome = findViewById(R.id.tvWelcome);
        Button btnClick = findViewById(R.id.btnClick);

        btnClick.setOnClickListener(v -> {
            clickCount++;
            tvWelcome.setText("Button clicked " + clickCount + " times!");
            Toast.makeText(MainActivity.this, "Hello from Java!", Toast.LENGTH_SHORT).show();
        });
    }
}
EOF

    # ---------- launcher icon (simple xml adaptive icon) ----------
    cat > "$RES_DIR/mipmap-anydpi-v26/ic_launcher.xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/banner_background"/>
    <foreground android:drawable="@drawable/banner_background"/>
</adaptive-icon>
EOF
    cp "$RES_DIR/mipmap-anydpi-v26/ic_launcher.xml" "$RES_DIR/mipmap-anydpi-v26/ic_launcher_round.xml"

    # ---------- Gradle wrapper properties ----------
    cat > "$PROJECT_NAME/gradle/wrapper/gradle-wrapper.properties" << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

    ok "Project structure ban gaya: $PROJECT_NAME/"
    echo ""
    echo -e "${CYAN}Structure:${NC}"
    find "$PROJECT_NAME" -type f | sed 's/^/  /'
    echo ""
    ok "Ab build karne ke liye chalayein:  ./onxx.sh build $PROJECT_NAME debug"
}

# ---------------------------------------------------------
# build_project <ProjectName> <debug|release>
# ---------------------------------------------------------
build_project() {
    local PROJECT_NAME="$1"
    local BUILD_TYPE="${2:-debug}"

    if [ ! -d "$PROJECT_NAME" ]; then
        err "Project folder '$PROJECT_NAME' nahi mila. Pehle 'init' chalayein."
        exit 1
    fi

    cd "$PROJECT_NAME"

    log "APK build kar raha hoon ($BUILD_TYPE)..."

    if command -v gradle &> /dev/null; then
        GRADLE_CMD="gradle"
    elif [ -f "./gradlew" ]; then
        chmod +x ./gradlew
        GRADLE_CMD="./gradlew"
    else
        err "Gradle nahi mila (na system gradle, na gradlew). Gradle install karein."
        exit 1
    fi

    if [ "$BUILD_TYPE" == "release" ]; then
        $GRADLE_CMD assembleRelease
        OUT_APK=$(find app/build/outputs/apk/release -name "*.apk" | head -n1)
    else
        $GRADLE_CMD assembleDebug
        OUT_APK=$(find app/build/outputs/apk/debug -name "*.apk" | head -n1)
    fi

    if [ -n "${OUT_APK:-}" ] && [ -f "$OUT_APK" ]; then
        ok "APK ban gaya: $PROJECT_NAME/$OUT_APK"
    else
        err "Build hua lekin APK file nahi mili. Upar ke logs check karein."
        exit 1
    fi
}

# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------
banner

COMMAND="${1:-}"

case "$COMMAND" in
    init)
        [ $# -ge 3 ] || { err "Usage: $0 init <ProjectName> <com.company.app>"; exit 1; }
        check_requirements
        init_project "$2" "$3"
        ;;
    build)
        [ $# -ge 2 ] || { err "Usage: $0 build <ProjectName> [debug|release]"; exit 1; }
        check_requirements
        build_project "$2" "${3:-debug}"
        ;;
    all)
        [ $# -ge 3 ] || { err "Usage: $0 all <ProjectName> <com.company.app> [debug|release]"; exit 1; }
        check_requirements
        init_project "$2" "$3"
        build_project "$2" "${4:-debug}"
        ;;
    *)
        echo -e "${BOLD}Usage:${NC}"
        echo "  $0 init  <ProjectName> <com.company.app>            # Naya project generate karein"
        echo "  $0 build <ProjectName> [debug|release]               # APK build karein"
        echo "  $0 all   <ProjectName> <com.company.app> [debug|release]  # Dono ek saath"
        echo ""
        echo -e "${BOLD}Example:${NC}"
        echo "  $0 all MyFirstApp com.example.myfirstapp debug"
        exit 1
        ;;
esac

