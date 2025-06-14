#!/bin/bash
out=ingresses.temp

url=https://github.com/ai-robots-txt/ai.robots.txt/releases/latest/download/robots.txt

bots="$(curl -sL $url | grep User-agent | cut -f 2 -d : | tr -d ' ' | tr \\n \| | rev | cut -f 2- -d \| | rev)"

cat resources/ingresses.yaml | while IFS= read line; do
    if [[ "${line}" =~ "\$http_user_agent" ]]; then
        echo "      if (\$http_user_agent ~* \"(${bots})\"){" >> $out
    else
        echo "${line}" >> $out
    fi
done

mv $out resources/ingresses.yaml
git add resources/ingresses.yaml
git commit -m "chore: update robots"
git push
