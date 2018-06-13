#!/bin/bash

elf_path="/data/local/tmp/inotify"
symbols_path="/Users/master/Downloads/obj/local/armeabi/inotify"
param_path="."

get_pid() {
    test=`adb shell "ps |grep $1"` 
    if [ -n "$test" ]; then
        if echo "$test" | grep -q "   "; then
            pid=`echo "$test" | awk '{print $2}'`
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
#fi

lldbserver_pid=$( get_pid "lldb-server" )
if [ -n "$lldbserver_pid" ]; then
#    adb shell 'kill -9 '$lldbserver_pid''
    echo "find lldb server"
else 
    echo "start new lldb server"
    adb shell /data/local/tmp/lldb-server platform --server --listen unix-abstract:///data/local/tmp/debug.sock &
fi
#

echo "enter lldb cli,please input 'process launch [param] & breakpoint set & run'"
lldb -x -o 'platform select remote-android' \
-o 'platform connect unix-abstract-connect:///data/local/tmp/debug.sock' \
-o "target create $elf_path" \
-o "target symbols add $symbols_path" 

 