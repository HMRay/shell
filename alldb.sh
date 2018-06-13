#!/bin/bash

package_name="dispatch.homebrew"
main_activity="ainSplashActivity"

get_pid() {
    test=`adb shell "ps |grep $1"` 
    if [ -n "$test" ]; then
        if echo "$test" | grep -q "   "; then
            pid=`echo "$test" | awk  '{print $2}'`
            echo "$pid"
        fi
    fi
}

#test=`adb shell 'ps |grep lldb-server'` 
#if [ -n "$test" ]; then
#    if echo "$test" | grep -q "      "; then
#        pid=`echo "$test" | awk  '{print $2}'`
#        adb shell "kill -9 $pid"
#        echo "kill lldb server"
#    fi
#f
lldbserver_pid=$( get_pid "lldb-server" )
if [ -n "$lldbserver_pid" ]; then
#    adb shell 'kill -9 '$lldbserver_pid''
    echo "find lldb server"
else 
    echo "start new lldb server"
    adb shell /data/local/tmp/lldb-server platform --server --listen unix-abstract:///data/local/tmp/debug.sock &
fi
#
if [ -n "$app_pid" ]; then
 #   adb shell "kill -9 $app_pid"
    adb shell am force-stop $package_name 
    echo "kill app"
fi
echo "start app in debug mode "
adb shell am start -n "$package_name/$main_activity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -D

app_pid=$( get_pid "$package_name" )

echo "enter lldb cli"
lldb -x -o 'platform select remote-android' \
-o 'platform connect unix-abstract-connect:///data/local/tmp/debug.sock' \
-o "process attach -p $app_pid" \
-o 'target symbols add /Users/master/work/reverse_work/anroidstudiopro/lldbtest/app/build/intermediates/cmake/debug/obj/armeabi/libnative-lib.so' 
