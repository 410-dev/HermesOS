#!/bin/bash
graphite_infobox "TouchDown UI 3.0 Beta 5"
export swap="$(<$CACHE/SIG/swap_address)"
if [[ -f "$CACHE/tmp/$swap/F0x11111111" ]]; then
    rm "$CACHE/tmp/$swap/F0x11111111"
fi
while [[ true ]]; do
    cd "$SYSTEM/libexec"
    export TOEXEC=$(graphite_fileselect "Command Selector" "./")
    if [[ -z $(echo "$TOEXEC" | grep "../") ]]; then
        export command=$(graphite_input "Arguments" "Argument field")
        args=($command)
        if [[ "$TOEXEC" == "./shutdown" ]]; then
            echo "1" > "$CACHE/tmp/$swap/F0x11111111"
        fi
        if [[ -f "$TOEXEC" ]]; then
            cd "$VFS"
            export OUTPUT=$("$SYSTEM/libexec/$TOEXEC" "${args[0]}" "${args[1]}" "${args[2]}" "${args[3]}" "${args[4]}" "${args[5]}" "${args[6]}" "${args[7]}" "${args[8]}" "${args[9]}" "${args[10]}" "${args[11]}" "${args[12]}")
            $graphitelib/TDGraphicalUIRenderer --title "Output from Command" --msgbox "$OUTPUT" 20 60
            cd "$SYSTEM/libexec"
        elif [[ -z "$command" ]]; then
            echo -n ""
        else
            graphite_msgbox "Error" "Command not found."
        fi
        if [[ -f "$CACHE/tmp/$swap/F0x11111111" ]]; then
            if [[ "$(<$CACHE/tmp/$swap/F0x11111111)" == "1" ]]; then
                graphite_msgbox "System Shutdown" "POSIX close signal detected.\
                The system will now shutdown."
                clear
                break
            fi
        fi
    else
        graphite_msgbox "Operation not permitted" "Operation not permitted: You may not execute command in ../ directories."
    fi
    if [[ -f "$CACHE/SIG/shell_close" ]] || [[ -f "$CACHE/SIG/shell_reload" ]]; then
        clear
        break
    fi
done