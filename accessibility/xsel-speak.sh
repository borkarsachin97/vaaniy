xsel -p -o | sed -E ':a;N;$!ba;s/\n/ /g; s/([.?!])([^0-9a-zA-Z])/&\n/g; s/([.?!]$)/&\n/g; $!s/$/\n/' | sed -z '$a\\n' >> /tmp/vaaniy_input

