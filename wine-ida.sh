WINEPATH="/Applications/Wine Devel.app/Contents/Resources/wine/bin"

function bgwork()
{
    (exec "$@" 1>&2 2>/dev/null &) 1>&2 2>/dev/null &
}

function ida32()
{
	(
    PATH="$WINEPATH:$PATH"
	bgwork wine 'C:\Program Files\IDA 6.8\idaq.exe' "$@"
	)
}

function ida64()
{
	(
    PATH="$WINEPATH:$PATH"
    bgwork wine 'C:\Program Files\IDA 6.8\idaq64.exe' "$@"
	)
}

function ida()
{
    if [ "${1: -4}" = ".idb" ]; then
        echo "`tput setaf 2`[+] idb file detected, using idaq.exe`tput sgr0`"
        ida32 "$@"
    elif [ "${1: -4}" = ".i64" ]; then
        echo "`tput setaf 2`[+] i64 file detected, using idaq64.exe`tput sgr0`"
        ida64 "$@"
    else
        IS_64BIT=`(file "$1" | grep '64-bit' 2>&1 1>/dev/null) && echo 1 || echo 0`
        if [ $IS_64BIT -eq 1 ]; then
            echo "`tput setaf 2`[+] 64-bits file detected, using idaq64.exe`tput sgr0`"
            ida64 "$@"
        else
            echo "`tput setaf 3`[+] Guess that is 32-bits file, using idaq.exe`tput sgr0`"
            ida32 "$@"
        fi
    fi
}
