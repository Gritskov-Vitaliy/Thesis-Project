check_web () {
    curl http://127.0.0.1:1337 | grep Gritskov
}

until check_web
    do
    sleep 3
    done
exit 0
