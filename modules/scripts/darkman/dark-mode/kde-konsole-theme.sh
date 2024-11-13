  #!/usr/bin/env bash
 PROFILE='Breath'
            for pid in $(pidof konsole); do
              qdbus "org.kde.konsole-$pid" "/Windows/1" setDefaultProfile "$PROFILE"
              for session in $(qdbus "org.kde.konsole-$pid" /Windows/1 sessionList); do
                qdbus "org.kde.konsole-$pid" "/Sessions/$session" setProfile "$PROFILE"
              done
            done
